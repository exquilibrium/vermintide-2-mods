# ThirdPerson — Design Notes

Toggles a persistent third-person camera via keybind, with configurable
position and "turn" (look around without changing where you actually aim)
offsets. This document is the living design log for the non-obvious
decisions in `scripts/mods/ThirdPerson/ThirdPerson.lua` — what was tried,
why it failed, and why the current approach works. Code comments stay
short; update this file whenever the reasoning behind a fix changes.

## Core approach: faking `third_person_mode`

The game has a built-in, developer-only third person mode gated behind
`Development.parameter("third_person_mode")`. Both the camera state
machine (`CharacterStateHelper.change_camera_state`, which redirects the
normal "follow" state to "follow_third_person_over_shoulder") and the
weapon zoom/aim logic (`GenericStatusExtension`, which picks
`over_shoulder`/`..._third_person` camera nodes instead of
`first_person_node`/`zoom_in`) already check this same flag. We hook
`Development.parameter` to fake it `true` while active.

An earlier version tried forcing the camera into the `follow_third_person`
state used by the character-inspect feature instead. That looked right
until any zoom-state change (e.g. an attack cancelling aim) ran
`GenericStatusExtension`'s zoom logic, which hardcodes the camera back to
`first_person_node` unless the dev flag is set — snapping the view back to
first person. Faking the flag itself routes through the same code paths
the game already uses for a persistent third person camera, so it survives
attacking, aiming, blocking, etc.

Several vanilla character states (e.g. self-inspect) call
`PlayerUnitFirstPerson.set_first_person_mode(false)` on their own
`on_enter` assuming they start from first person, but never re-assert it
while active and can flip it back to `true` in ways nothing above catches.
We pin `set_first_person_mode` to `false` for as long as third person is
active, except for genuine overrides (cutscenes, benchmark mode).

Repeating crossbows set `default_zoom = "first_person_node"`, which
`set_zooming`'s "zooming" branch unconditionally suffixes to
`"first_person_node_third_person"` once our fake flag is on — a node that
doesn't exist, crashing `CameraManager.set_camera_node`. We redirect to
`"over_shoulder"` (what the "not zooming" branch already maps it to) and
briefly suppress our own flag fake so `set_zooming` doesn't double-suffix it.

## Persisting across new maps/characters

`mod.third_person_active` is a mod-level flag that lives for the whole
session (only reset false on mod disable) — but it's only ever *applied*
to a specific unit from the toggle keybind handler
(`set_third_person_active`/`apply_third_person_to_unit`). A brand new
`player_unit` (loading into a new map, switching character/career, or
respawning mid-level) always starts back in first person by default, and
nothing re-asserted third person onto it — the camera silently fell back
to first person even though the flag itself never changed. Fixed by
hooking `EventManager.trigger` (the **class**, not a specific
`Managers.state.event` instance — `Managers.state.event` is actually a
brand new `EventManager` per level, so a one-time `:register()` call
wouldn't survive the next level transition; hooking the class method
means it keeps working across every future level regardless) and
reapplying third person via `apply_third_person_to_unit` whenever
`"level_start_local_player_spawned"` fires and `mod.third_person_active`
is still true. That event is the same one several vanilla systems already
use for "reapply my per-run state to the fresh local unit" (e.g. passive
ability setup for some careers), and — unlike the more generic
`"new_player_unit"` event, which also fires for bots and remote players —
it only fires for the local player, so no extra filtering is needed.
`apply_third_person_to_unit` was factored out of `set_third_person_active`
so both the keybind path and this automatic reapply path share the exact
same unit-specific logic.

## Camera position (`TransformCamera.update` hook)

The camera's shoulder offset (`over_shoulder`) is a `TransformCamera` node
whose offset is normally baked once from `CameraSettings` at level load
(`TransformCamera.parse_parameters`), so editing `CameraSettings` at
runtime has no effect. We hook `TransformCamera.update` instead, which runs
every frame with the live node instance, and overwrite `_offset_position`
there — this makes the sliders apply live.

`get_camera_offset` returns a **plain table**, not a `Vector3()`: a real
engine `Vector3` is a transient object, and holding one in this field
indefinitely (overwritten every frame) eventually corrupts to a mismatched
userdata type and crashes `TransformCamera.update`. `TransformCamera` only
ever reads `.x/.y/.z` as plain numbers anyway.

**Zoom is entirely mod-owned - it no longer uses vanilla's own zoom-tier
camera nodes at all.** This replaced a long, unsuccessful attempt to mirror
vanilla's own multi-tier zoom system (`zoom_in_third_person`,
`increased_zoom_in_third_person`, `zoom_in_trueflight_third_person`) in
third person. That approach accumulated three separate, increasingly
severe problems before being abandoned:

1. **Crosshair drift.** Zooming with a turn dialed in drifted the
   crosshair off target - confirmed to be strictly a nonzero-turn issue
   (zero turn = correct), and confirmed via `TransformCamera.update`'s own
   decompiled source (`scripts/managers/camera/cameras/transform_camera.lua`)
   that the offset is baked into position using the character's raw,
   untouched facing (`rotation`, traced to
   `Unit.world_rotation(root_unit, root_object)`) - structurally before the
   turned direction exists anywhere in the pipeline, since
   `CameraManager.post_update` runs the entire node tree (`_update_nodes`)
   to completion before ever calling `_update_camera_properties` (where
   the turn is applied). Five attempts to make the offset "chase" the
   turned direction, and one attempt to suppress the turn while aiming
   instead (which made the drift *worse*), all failed to resolve it.
   Verified three independent ways along the way (a round-trip diagnostic,
   the decompiled source above, a clean algebraic re-derivation) that the
   math itself wasn't the problem - the true root cause was never found.
2. **Weapon-specific zoom-tier mismatches.** Some weapons only have a "no
   zoom" and "extra zoom" stage (no real middle tier); others default
   straight to the middle "zoomed" tier. Trying to mirror each weapon's
   exact tier progression in third person kept getting individual weapons
   wrong in different ways, and the user was playing on a custom balance
   mod (Tourney Balance) that may reconfigure these tiers per weapon
   anyway, making vanilla source an unreliable reference for what any
   given weapon *should* do.
3. **A partial fix regressed further.** Substituting the confirmed-safe
   `increased_zoom_in_third_person` node for the buggy
   `zoom_in_third_person` node (keeping `self.zoom_mode` untouched so
   weapon special's cycling still worked) did fix the drift, but then
   caused weapons that shouldn't zoom at all to start zooming on regular
   aim - never fully explained, though likely another balance-mod
   interaction.

**The first fix**: stop trying to represent "which vanilla zoom tier" via a
different camera node at all. The mod defined its own zoom behavior
entirely instead, via four settings (`camera_zoom_enabled`,
`camera_zoom_amount`, `camera_weapon_special_zoom_enabled`,
`camera_weapon_special_zoom_amount`) that moved the camera physically
closer/forward on `"over_shoulder"` while aiming - still using
`mod._is_aiming`/`mod._weapon_special_zoom_active` (state that's still
current, see "Weapon zoom, entirely mod-owned" below) to pick which amount
applied. This resolved problems 2 and 3 above (no more vanilla zoom tier to
mismatch, nothing left for a balance mod's reconfigured thresholds to
interfere with), but **did NOT resolve problem 1** - crosshair drift while
aiming with a turn dialed in persisted, because this design still moved the
camera's position per zoom state, just via a different mechanism (a mod-owned
offset instead of a vanilla node switch) that turned out to have the exact
same class of bug.

**The real fix, found much later**: the crosshair drift was never actually
about which camera NODE was active - it was caused by moving the camera's
POSITION per zoom state at all, regardless of mechanism. Once that was
identified, the four distance-zoom settings above were removed entirely and
zoom was rebuilt as FOV-only, with the camera's position now fixed across
every zoom state. See "Weapon zoom, entirely mod-owned" below for the full
story and the current, final design - this section is kept for the
history of *why* the position-based approaches (vanilla node switching,
then a mod-owned position offset) were both eventually abandoned, not as a
description of current behavior.

## Turn getting permanently baked into aim (`apply_recoil` hook)

`PlayerUnitFirstPerson.apply_recoil(factor)` fires on the weapon-fire
animation event for nearly all ranged weapons. With no factor (the normal
case) it does a full lerp toward `ScriptCamera.rotation(camera)` and stores
the result into `self.look_rotation` — the character's persistent aim
accumulator. In first person the camera *is* the aim, so this is a no-op.
In third person with a turn configured, the rendered camera is
deliberately offset from the real aim, so this permanently bakes the
cosmetic turn into the character's actual aim on every shot.

Two wrong fixes before the right one:
1. Letting `apply_recoil` run untouched and subtracting the turn from its
   result afterward. `apply_recoil` has a second branch (used while a
   recoil kick from an earlier shot is still playing — the normal case for
   rapid-fire weapons) that computes its rotation from `self.look_rotation`
   directly, never touching the camera — which was already clean.
   Subtracting the turn from an already-clean result nudged the aim by the
   turn amount in the wrong direction every shot: a visible per-shot drift
   on rapid-fire weapons.
2. The eventual fix: prevent the contamination instead of correcting it
   after the fact. Temporarily strip the turn from the live camera before
   calling through (via `strip_turn_from_rotation`), so both branches see a
   clean value, then restore the turned rotation immediately after so
   anything reading it later in the same shot (aim origin, below) still
   sees it turned.

## Aiming origin (`get_projectile_start_position_rotation` hook)

Almost every ranged weapon fires from/along the character's first-person
head bone regardless of perspective, not the camera — so with any camera
offset or turn dialed in, the crosshair and the actual shot diverge. We
return the camera's own position/rotation instead while third person is
active, mirroring what the vanilla first-person branch already does.

## Weapon zoom, entirely mod-owned (`set_zooming` / `switch_variable_zoom` hooks)

Three earlier approaches to mirroring vanilla's own zoom-tier system in
third person are documented in "Camera position" above - a crosshair-drift
bug on one specific node, weapon-specific zoom-tier mismatches (worsened
by playing on a custom balance mod that may reconfigure them), and a
partial fix that itself regressed further. All abandoned. The current
design sidesteps the whole vanilla zoom-tier system instead of trying to
track it.

**`set_zooming`** fires whenever a ranged weapon starts or stops aiming,
with vanilla's own `camera_name` for whichever tier that weapon would
normally zoom to (`"zoom_in"`, `"first_person_node"`, etc., always
suffixed to `"..._third_person"` once our fake flag is on). Regardless of
what that value is, while `zooming == true` we redirect it to
`"over_shoulder"` and suppress the flag fake for that one call (so vanilla
doesn't also suffix `"over_shoulder"` into the nonexistent
`"over_shoulder_third_person"` - the same crash this redirect originally
existed to prevent, for repeating crossbows specifically, before being
generalized to every weapon). `mod._is_aiming` is set from `zooming`
directly and `mod._weapon_special_zoom_active` resets to `false` - a fresh
aim session always starts at the regular zoom amount, not wherever weapon
special left off last time. Un-aiming (`zooming == false`) is NOT
redirected: vanilla's own logic there already correctly picks
`"over_shoulder"` for third person on its own.

**`switch_variable_zoom`** fires when weapon special is pressed while
aiming (only for weapons with the `increased_zoom` talent and a real
extra-zoom tier - vanilla-gated, unchanged). `mod._weapon_special_zoom_active`
just toggles on each call: this hook only ever fires on a fresh
weapon-special press, and the vanilla cycle it used to drive is a
two-entry table, so a plain toggle mirrors that alternation without
needing to track vanilla's own cycle position. Still calls through to
vanilla afterward (`self.zoom_mode`/`self.zooming` stay updated for
whatever else might read them), but re-asserts `"over_shoulder"`
immediately after in case vanilla's own cycling changed the active node -
`self.zoom_mode` no longer reliably matches vanilla's zoom table once
redirected by `set_zooming`, so vanilla's own lookup can land anywhere;
the camera node it might pick doesn't matter, since we override it back
regardless.

**ROOT CAUSE OF THE CROSSHAIR-DRIFT BUG FOUND: moving the camera per zoom
state.** After 7+ failed attempts across the whole session (documented
under "Camera position" above - chasing the turned direction, suppressing
the turn, substituting camera nodes, redesigning zoom as mod-owned distance
+ FOV), the user identified the actual cause through their own testing: it
was the per-frame camera-position offset this mod itself applied while
zoomed (`camera_zoom_amount`/`camera_weapon_special_zoom_amount`, subtracted
from `offset.y` in `TransformCamera.update`, moving the camera physically
closer/forward while aiming). Every earlier attempt treated the drift as a
bug in how the TURN interacted with zoom - it was actually the zoom's own
POSITION change interacting badly with the turn, which is why "suppress the
turn while aiming" and "chase the turned direction" both failed: neither
touched the actual cause.

**Fix: zoom is now FOV-only. The camera's position never changes with zoom
state at all.** `get_camera_offset` (`TransformCamera.update`) no longer
varies by zoom state in any way - the `camera_zoom_amount`/
`camera_zoom_speed`/`camera_weapon_special_zoom_amount`/
`camera_zoom_enabled`/`camera_weapon_special_zoom_enabled` settings, and
`get_zoom_distance_reduction_target`/`get_smoothed_zoom_distance_reduction`,
are all removed entirely - not disabled, not defaulted to zero, deleted -
so there's no distance-changing code path left to regress back into this
bug by accident. The camera sits at exactly the same position and distance
whether unzoomed, zoomed, or weapon-special zoomed; only the FOV changes.

**FOV per zoom state** (`get_fov_radians_target`/`get_smoothed_fov_radians`,
`_update_camera_properties` hook) is now the ONLY zoom effect this mod
applies (moved into `zoom_settings_group` from its own former
`fov_settings_group` - now the only group left, since it's the only real
"zoom" setting). Three independent settings -
`camera_fov_unzoomed`/`camera_fov_zoomed`/`camera_fov_extra_zoomed`
(degrees, defaulting to 65/32/16 to roughly match vanilla's own
third-person `over_shoulder`/`zoom_in_third_person`/
`increased_zoom_in_third_person` node FOVs, even though those nodes are no
longer used for zoom) - selected by the same three-way `mod._is_aiming`/
`mod._weapon_special_zoom_active` state used throughout this file, eased
toward the target via `ease_toward` over the user-configured
`camera_zoom_speed` setting (seconds - lower is faster). Applied by
directly setting `camera_data.vertical_fov` before calling through to
vanilla `_update_camera_properties` - the same field vanilla's own
transition system would have set from the current node's `vertical_fov()`,
just overridden with our own value. Only applied while
`current_node:name() == "over_shoulder"` - the only node whose zoom state
this mod actually drives; any other node (`heal_self`, or a vanilla
mechanic activating one of the other `OFFSET_NODE_NAMES` directly) keeps
whatever FOV vanilla's own transition system computed for it.

**`ease_toward` helper kept from the distance-zoom era, now FOV's only
caller.** The generic keyed easing helper (`self._ease_state[key]`),
introduced when there were two things to smooth (distance-zoom reduction
and FOV), is still worth keeping as its own function even with only FOV
using it now - it's a real, separable piece of behavior ("ease toward a
target over a duration, keyed, safe to call more than once per frame") and
the next per-zoom-state value this mod smooths (if any) can reuse it
without duplicating the start-value/start-time tracking again.
`camera_zoom_speed` itself was briefly removed alongside the distance-zoom
settings it used to also govern (FOV fell back to the fixed vanilla
`CameraTransitionSettings.perspective_transition_time` duration for one
round), then re-added at the user's request as FOV's own speed control -
it now exists purely for FOV, unrelated to its original distance-zoom
purpose.

**Known tradeoff, not yet reported as an issue but worth flagging:**
`self.zoom_mode`'s exact string value may no longer reliably reflect
which zoom tier vanilla itself thinks is active, since it's now driven by
a redirected `camera_name` and a cycling table that rarely matches. Any
gameplay mechanic that reads `self.zoom_mode` directly (rather than
`self.zooming`, or a buff/perk check) - e.g. a talent granting bonus
critical chance specifically while genuinely in the deepest zoom tier -
could behave differently in third person than in first person as a
result. Camera behavior is unaffected either way, since it's driven by
`mod._is_aiming`/`mod._weapon_special_zoom_active` instead, but this is
worth keeping in mind if a talent-specific bug surfaces later.

## TourneyBalance compatibility: Beam Staff never zoomed at all (`ActionBeam` hook)

The user reported the Beam Staff never zoomed in third person - not a
misbehaving tier, no zoom effect whatsoever. Diagnostic logging (three
rounds: a `set_zooming` echo, an `ActionBeam` do_zoom/is_zooming echo, then
a before/after-`func()` comparison per call) showed `GenericStatusExtension.is_zooming()`
staying `false` for the entire duration of firing, every single frame,
even immediately after calling through to `func(...)` - meaning
`set_zooming(true)` was never actually being invoked, despite
`self.do_zoom` reading `true` the whole time (which per vanilla's own
source, `scripts/unit_extensions/weapons/actions/action_beam.lua`, should
unconditionally trigger it every frame while not already zooming).

**Root cause, confirmed by reading the user's TourneyBalance install**
(`Tourney-Balance-Open-Beta/scripts/mods/TourneyBalance/changes/weapon_changes/ranged/bw_beam.lua`):
TourneyBalance replaces `ActionBeam.client_owner_post_update` **entirely**
via its own `mod:hook_origin` (VMF's "replace the original function" hook
type, as opposed to the wrap-around `mod:hook` this mod uses everywhere).
Its replacement rewrote the beam's damage/zoom logic and, in doing so,
simply dropped vanilla's `if self.do_zoom then if not
status_extension:is_zooming() then status_extension:set_zooming(true) end
... end` block - the replacement only ever calls `switch_variable_zoom`
(gated on weapon special), never the entry call. Since `hook_origin`
replaces the function at the bottom of the hook chain, `func(...)` inside
*our own* `ActionBeam` hook resolves to TourneyBalance's version, not
vanilla's - so the Beam Staff never enters a "zooming" state for our
`set_zooming` hook to ever see, regardless of third person. The exit side
(`ActionBeam.finish` calling `set_zooming(false)`) is untouched by
TourneyBalance, which is why `set_zooming(false)` was the only call our
diagnostics ever caught.

**Fix**: a new hook on `ActionBeam.client_owner_post_update` calls through
first, then - only if `mod.third_person_active`, `self.do_zoom` is true,
and `is_zooming()` is *still* false afterward - calls
`self.status_extension:set_zooming(true)` itself, restoring the call
TourneyBalance's replacement dropped. Checking the RESULT after calling
through (rather than unconditionally before) makes this self-healing and
safe regardless of cause: with plain vanilla (no TourneyBalance, or a
future TourneyBalance version that restores the call), `is_zooming()`
would already be `true` by this point and the extra call is a harmless
no-op. Deliberately scoped to `mod.third_person_active` only - Beam Staff
zoom while playing in plain first person is unaffected by this mod either
way, and it's not this mod's place to silently patch a third-party
balance mod's own first-person behavior.

**Only Beam Staff is covered.** Other weapons TourneyBalance modifies
could have the same class of gap (any weapon whose action class is
replaced via `hook_origin` and drops a `set_zooming` call) - not audited,
since this fix was scoped to the one weapon actually reported broken. If
another weapon's zoom turns out to be similarly silent in third person,
the diagnosis technique here (log `is_zooming()` before/after calling
through the hooked function, check whether the user's balance mod
replaces that weapon's update function via `hook_origin`) is the template
to reuse, not something to re-derive from scratch.

## Turn composition math (`apply_turn_to_rotation` / `strip_turn_from_rotation`)

The turn is applied in `CameraManager._update_camera_properties` — the
last Lua-level function to see `camera_data` before it becomes the
rendered camera orientation (nothing else touches rotation after this
point). It couldn't be applied earlier (`TransformCamera.update` or
`CameraManager._apply_offset`, both tried first) because most ranged
weapons switch `settings_node` while aiming (`over_shoulder` →
`zoom_in_third_person`, a real node change), which reset any
node-local turn state.

Two rounds of warping bugs, both from composing the turn in the wrong
reference frame relative to the player's own current look direction:

1. **Roll that grows with pitch.** The first working version combined
   yaw and pitch into one local (right-multiplied) offset:
   `camera_data.rotation * (yaw * pitch)`. Since `camera_data.rotation`
   already encodes the player's own current pitch, and local composition
   reinterprets the offset's axes through that base orientation, the
   algebra produces a net roll term ∝ `sin(yaw)·sin(player_pitch)` — the
   turn visibly skewed more the further you looked up/down.
2. **The real fix**: split yaw and pitch into different reference frames
   instead of one local offset:
   ```lua
   local yawed = Quaternion.multiply(yaw_rotation, rotation)  -- world-space, pre-multiplied
   return Quaternion.multiply(yawed, pitch_rotation)          -- local-space, post-multiplied
   ```
   Yaw pre-multiplied = applied in world space around true world-up, as the
   outermost op — rotates the whole camera direction around vertical like
   re-aiming a compass heading, independent of current pitch. Pitch
   post-multiplied = local space, around the now-yawed camera's own local
   right axis — provably roll-free on its own, the same way vanilla's own
   FPS camera (`PlayerUnitFirstPerson.calculate_look_rotation`, yaw outer /
   pitch inner) never rolls from mouse input alone.

`strip_turn_from_rotation` (used by `apply_recoil`) is the exact algebraic
inverse: `clean = yaw⁻¹ * turned * pitch⁻¹` — inverse yaw on the **left**,
inverse pitch on the **right**. It must always match whatever
`apply_turn_to_rotation` does forward, or it strips the wrong rotation and
silently reopens the aim-contamination bug `apply_recoil` exists to
prevent. This is why both live in one place instead of being duplicated
per call site — that duplication is exactly how bug #1 above slipped
through unnoticed in one copy after being fixed in the other.

**Excluded on the `"heal_self"` node.** Self-inspect, revive, self-heal,
and emote camera views all route through `CameraStateFollowThirdPerson`
using the shared `"heal_self"` `TransformCamera` node (as opposed to the
mod's own third-person mode, which uses `"over_shoulder"`/its zoom
variants via `CameraStateFollowThirdPersonOverShoulder`). None of those
views should be skewed by a turn or offset meant for normal
over-the-shoulder gameplay. `"heal_self"` itself was never in
`OFFSET_NODE_NAMES`, so `TransformCamera.update` never touches its offset
directly - but the position offset still needs to fade out on entering
inspect and back in on leaving it, since the node the camera *returns to*
(`over_shoulder`) is otherwise pushed to the full configured offset the
instant it becomes active again, with nothing else interpolating it.

**Faded, not snapped - both position and rotation, in lockstep.** The
first version of the `"heal_self"` exclusion was a hard on/off check on
rotation only, which made the turn snap instantly to/from zero the moment
the camera node changed - visually jarring, and the user then noticed the
*position* offset had the exact same snap (rotation eased, position
popped), since nothing had fixed that half yet. `get_camera_blend` tracks a
single 0–1 blend factor (0 = fully suppressed, 1 = fully applied) and eases
it toward whichever target the current node implies over
`CameraTransitionSettings.perspective_transition_time` seconds (the same
duration the game already uses for its own first/third-person visibility
transition, reused here for a consistent feel). It records the blend's
current value and a start time whenever the target changes, so
interrupting a transition partway through (e.g. entering and exiting
inspect quickly) continues smoothly from wherever it actually was rather
than jumping.

This one blend value is shared by both hooks so they fade in lockstep
rather than at independently-drifting rates:
- `_update_camera_properties` calls `apply_turn_to_rotation` with
  `yaw * blend` and `pitch * blend` — scaling the angle passed into a
  single-axis `Quaternion(axis, angle)` construction is itself a smooth,
  monotonic sweep from identity to the full rotation, so no separate
  quaternion slerp is needed.
- `TransformCamera.update` scales the computed offset vector
  (`x/y/z * blend`) before assigning it to `_offset_position` - a plain
  linear interpolation from `(0,0,0)` to the full offset.

`_update_camera_properties` is the only hook that receives `current_node`
(and therefore knows whether `"heal_self"` is the currently active node),
so it's the one that calls `get_camera_blend` to update the shared value
each frame; `TransformCamera.update` (which only sees whichever specific
node it's updating, e.g. `"over_shoulder"`) just reads the already-computed
`mod._camera_blend_value` directly.

## WASD movement following the turned camera (`move_on_ground` hook)

`CharacterStateHelper.move_on_ground` (the shared ground-movement function
for every normal player state) derives world-space move direction from
`first_person_extension:current_rotation()` — the character's clean aim,
untouched by the turn by default. With a yaw turn dialed in, "forward"
walked toward the real aim, not the turned camera, so holding W visibly
drifted off to the side of the crosshair. The user asked for movement to
follow the turned camera instead.

Fixed with the same poke-and-restore approach used elsewhere: temporarily
rotate `first_person_unit` to the turned rotation for the exact synchronous
duration of the call, then restore. No `World.update_unit` needed here —
unlike the flamethrower/charged-projectile pokes below —
because `current_rotation()` reads `Unit.local_rotation` directly, which
updates immediately (no propagation delay). Only yaw matters:
`move_on_ground` already flattens to the horizontal plane, so pitch has no
effect on ground movement either way.

The initial version passed yaw through the same local (post-multiply)
route as the original camera bug (composing it onto the character's own
already-pitched rotation) — same root cause, same fix: pre-multiply
(world-space) instead, via `apply_turn_to_rotation(original_rotation, yaw, 0)`.

**Known gap, explicitly out of scope (versus-mode-related, user request)**:
`CharacterStateHelper.packmaster_move_on_ground` (movement while being
dragged by a Packmaster) has the identical clean-aim-instead-of-camera gap,
not fixed.

## Flamethrower (`ActionFlamethrower` hooks)

Flamethrower-kind weapons (Drakegun, Flamestorm/"Wizard" Staff) don't go
through `get_projectile_start_position_rotation` and have two separate
camera-dependent problems, discovered and fixed across several rounds:

**1. Damage cone.** `_select_targets` reads
`first_person_extension:current_position()` and
`Unit.world_rotation(first_person_unit, 0)` directly — both based on the
character's facing, not the camera. Fixed by wrapping the whole
`client_owner_post_update` call and temporarily poking `first_person_unit`
to the camera's position/rotation for the exact synchronous duration of
the call (restored immediately after) — this is the *only* place in the
file confirmed to need `World.update_unit` for a *position* read too, since
`_select_targets` reads `Unit.world_position`, not just rotation.
`Unit.set_local_position/set_local_rotation` do **not** immediately
propagate to `Unit.world_position/world_rotation` — the engine needs an
explicit `World.update_unit(world, unit)` call. Without it, this read
silently saw the stale pre-poke rotation the whole time. This mirrors a
documented vanilla pattern (`projectile_linker_extension.lua` does the
identical set-position/set-rotation/update_unit sequence).

**2. The visible flame.** `client_owner_post_update` creates the flame
particle once (on the "waiting_to_shoot" → "shooting" transition) and
`World.link_particles` keeps it following a bone's live rotation
thereafter. Three sequential discoveries were needed to actually fix this:

- **Restore timing.** The damage-cone poke-then-restore-within-one-call
  was correct for damage (read synchronously, inside the same call), but
  `World.link_particles` samples the bone at *render* time, which happens
  after that frame's Lua logic — including our restore — had already run.
  The poke never survived long enough for rendering to see it. Fixed by no
  longer restoring `weapon_unit`'s rotation every frame: poke it to the
  live camera rotation and leave it there for the whole spray (re-poking
  each frame so it stays live), restoring only when firing actually stops
  (`_stop_fx`, which covers both natural completion and
  interruption/cancellation/weapon switch — not gated on
  `mod.third_person_active`, so a poke started while active still gets
  cleaned up if the player toggles third person off mid-spray).
  `first_person_unit` keeps strict poke-and-restore-per-call — its
  rotation is read by many other systems between frames (the same
  contamination risk `apply_recoil`'s fix prevents) — whereas nothing else
  reads `weapon_unit`'s rotation while a flamethrower fires.

- **Transient-object crash.** Holding the captured original rotation
  across frames as the raw `Unit.local_rotation(...)` return value crashed
  (`Vector4 expected, got userdata`): engine rotation/vector values from
  calls like `Unit.local_rotation` come from a short-lived per-frame temp
  pool, valid only briefly — not safe to store across the many frames a
  spray lasts. Fixed with `QuaternionBox` (the engine's own API for this;
  see `scripts/managers/debug/debug_manager.lua`'s `QuaternionBox(rot)` /
  `:unbox()` for vanilla precedent) — box on capture, `:unbox()` on
  restore. **Any value that needs to survive past the single synchronous
  call it was obtained in must be boxed** — holding the raw value is only
  safe for the strictly-transient, single-call poke/restore pattern used
  everywhere else in this file.

- **Wrong node, twice.** Setting `weapon_unit`'s node 0 directly to
  `camera_rotation` produced first a vertical inversion, then (after a
  wrong "mirror the pitch" guess) a roll-like pitch-to-yaw coupling —
  diagnostic logging (`mod:echo`, temporarily) revealed node 0's local
  rotation is *always exactly identity* regardless of camera pitch: the
  weapon is rigidly attached to a parent bone (hand/weapon-attach,
  animation/IK-driven) that does all the aiming, and node 0 carries no
  local rotation of its own — so setting it to an absolute value stacks
  the camera's rotation on top of the hand bone's own orientation instead
  of replacing it. The **actual** bug, though: the flame particle is
  linked to the **muzzle node** (`self.muzzle_node_name`, e.g. `fx_muzzle`)
  — a different bone with its own fixed offset relative to node 0. Forcing
  node 0 doesn't make the muzzle point at the camera; it's off by that
  fixed offset, which is why the error was a constant, direction-
  independent skew (always straight up) instead of one that varied with
  aim. Fixed by targeting the muzzle node directly, solving for the local
  rotation that actually produces `camera_rotation` in world space:
  read the muzzle's own current world and local rotation (undisturbed),
  derive its effective cumulative parent as `world * inverse(local)`, then
  `needed_local = inverse(effective_parent) * camera_rotation`. This
  generalizes to any node depth without needing to know the exact bone
  hierarchy. Confirmed working in-game (damage and visible flame both).

## `ActionChargedProjectile` (`_shoot` hook)

The class behind the Bolt Staff, Fireball/Conflagration Staff, Necromancy
Staff, and Drakefire Pistols — none of which go through
`get_projectile_start_position_rotation`. `_shoot` computes its own fire
position (`Unit.world_position(first_person_unit, 0)`) and rotation
(`Unit.local_rotation(first_person_unit, 0)`) directly. Some weapons define
a custom `action_data.fire_pos_rot` for auto-targeting melee-ish attacks —
those still read `first_person_unit`'s node-0 position/rotation for their
aim-direction raycast, so they benefit too, just not perfectly for the
exact origin point if they use a different attach node.

Same poke-and-restore approach as the flamethrower damage-cone fix,
including `World.update_unit` after each poke/restore — `_shoot` reads
`Unit.world_position`, so it needs this exactly as much as
`_select_targets` did. `_shoot` is called both from
`client_owner_post_update` and from `finish()` (multi-shot buffs), so
hooking `_shoot` itself covers both call sites in one place.

User confirmed (`staff_death.lua`'s custom-origin approximation included)
this is fine as-is — no further work planned here.

## Known gaps

- **Melee** (`action_sweep.lua`, `action_shield_slam.lua`): deliberately
  left using the character's real position/rotation, not the camera —
  redirecting hit origin to the camera could make attacks miss things right
  next to the character or hit things behind them.
- **"First person while aiming" - tried and removed.** A
  `camera_first_person_when_aiming` setting attempted to switch to a
  genuine vanilla first-person camera/state while aiming, instead of the
  mod-owned third-person zoom - by suppressing the third-person flag fake
  for the aim duration and re-triggering
  `CharacterStateHelper.change_camera_state(player, "follow")` so the
  camera STATE itself (not just the node name) actually swapped. The first
  version (missing the `change_camera_state` call) was confirmed not
  working; a second, source-grounded fix was implemented but never
  confirmed working before the user asked to remove the feature entirely
  rather than keep iterating on it. Removed cleanly - no leftover
  `mod._first_person_aim_active` state or special-casing remains in any
  hook. If revisited, the `change_camera_state` fix from this history is
  still the right lead (see git history / prior conversation for the exact
  reasoning), not something to re-derive from scratch.
- **Explicitly out of scope per the user, versus-mode-related, do not
  revisit unless asked**: `ActionWarpfireThrower` (separate class from
  `ActionFlamethrower`, not audited) and
  `CharacterStateHelper.packmaster_move_on_ground` (see above).
- **Player opacity - tried and removed, confirmed NOT to work in-game.** A
  `player_opacity` setting attempted to fade the third-person body mesh via
  `Unit.set_scalar_for_materials_in_unit_and_childs(mesh_unit, "opacity",
  value)` on `PlayerUnitCosmeticExtension`'s dedicated third-person mesh
  unit. The engine call itself was confirmed real (same API vanilla uses
  elsewhere for other per-material scalars), but the `"opacity"` variable
  name was a best-effort guess - shaders are compiled binary assets, not
  visible from the decompiled Lua source, so it couldn't be verified ahead
  of time. User confirmed it had no visible effect, consistent with the
  character material likely being opaque-rendered with no alpha-blend path
  at all (no vanilla system was found that fades a live player's own body
  continuously - only hard on/off visibility or AI-perception-only
  "invisible" flags). Removed entirely rather than left as a dead/no-op
  setting. If revisited, a different variable name would need to come from
  someone who can inspect the actual compiled material/shader - not
  something inferable from this Lua source tree.

## Refactor notes

Shared helpers consolidate logic that was previously duplicated across
multiple hooks (and, in the turn-composition case, is exactly what let two
of the bugs above happen — one copy got fixed while a duplicate elsewhere
didn't):

- `mod.get_owner_camera(self, owner_unit, world)` — the
  `Managers.player:owner` / `ScriptWorld.viewport` / `ScriptViewport.camera`
  lookup, previously duplicated in 4 hooks.
- `mod.apply_turn_to_rotation` / `mod.strip_turn_from_rotation` — the turn
  composition and its exact inverse, previously duplicated between the
  camera hook and `move_on_ground`.
- `mod.ease_toward(self, key, target, duration)` — a generic, keyed
  "ease this value toward a target over a duration" helper (see "Weapon
  zoom, entirely mod-owned"), introduced when there were two per-zoom-state
  values to smooth (a distance-zoom reduction, since removed, and FOV) and
  kept as FOV's sole caller after the first was removed — still worth
  keeping as its own function rather than inlining into `get_smoothed_fov_radians`,
  since it's a real, separable, reusable piece of behavior.
