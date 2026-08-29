local mod = get_mod("ThirdPerson")
mod:dofile("scripts/mods/"..mod:get_name().."/version")

-- Toggles a persistent third-person camera with configurable position and
-- "turn" (look around without changing where you actually aim) offsets.
-- See README.md at the mod root for the full design log: why each fix
-- exists, what was tried and failed first, and how the pieces interact.

mod.third_person_active = false

-- TransformCamera nodes whose position we override to match our camera
-- settings. Only "over_shoulder" is ever actually activated by this mod
-- now (see the set_zooming/switch_variable_zoom hooks below - zoom is
-- entirely mod-owned, not vanilla's own zoom-tier nodes) - the other three
-- are kept here only in case some other, untouched mechanic still
-- activates them directly. See README.md ("Camera position").
mod.OFFSET_NODE_NAMES = {
	over_shoulder = true,
	zoom_in_third_person = true,
	increased_zoom_in_third_person = true,
	zoom_in_trueflight_third_person = true,
}

mod.get_camera_offset = function (self)
	local side = self:get("camera_shoulder_side")
	local sign = (side == "left" and -1) or (side == "right" and 1) or 0
	local x = sign * self:get("camera_x_position")
	local y = self:get("camera_distance")
	local z = self:get("camera_y_position")

	-- Plain table, not Vector3() - see README.md ("Camera position") for why
	-- holding a real engine Vector3 here indefinitely crashes TransformCamera.
	return {x = x, y = y, z = z}
end

-- Eases self._ease_state[key]'s value toward `target` over `duration`
-- seconds instead of snapping instantly - shared by every per-zoom-state
-- value this mod smooths (FOV below). Same start-value/start-time tracking
-- as the original
-- get_camera_blend pattern, generalized to an arbitrary numeric target and
-- keyed so multiple independent values can each track their own transition
-- without stepping on each other. Safe to call more than once per frame for
-- the same key (e.g. from both apply_recoil and _update_camera_properties)
-- since it's a pure recompute from stored state, not an accumulator - it
-- returns the same value every time within the same frame. See README.md
-- ("Camera position").
mod.ease_toward = function (self, key, target, duration)
	local state = self._ease_state

	if not state then
		state = {}
		self._ease_state = state
	end

	local entry = state[key]
	local now = Managers.time:time("main")

	if not entry then
		entry = {value = target, target = target, start_value = target, start_time = now}
		state[key] = entry
	elseif entry.target ~= target then
		entry.target = target
		entry.start_value = entry.value
		entry.start_time = now
	end

	local t = duration > 0 and math.clamp((now - entry.start_time) / duration, 0, 1) or 1

	entry.value = entry.start_value + (target - entry.start_value) * t

	return entry.value
end

-- Destination vertical FOV (radians) for the current zoom state - the
-- ONLY zoom effect this mod applies now (see README.md "Weapon zoom,
-- entirely mod-owned" for why the camera-movement/distance-zoom mechanism
-- that used to sit alongside this was removed - it was the actual cause of
-- the long-standing crosshair-drift bug). Three independent settings the
-- user configures directly (unzoomed, zoomed, weapon special "extra
-- zoomed"). See README.md ("Camera position").
mod.get_fov_radians_target = function (self)
	local degrees

	if not self._is_aiming then
		degrees = self:get("camera_fov_unzoomed")
	elseif self._weapon_special_zoom_active then
		degrees = self:get("camera_fov_extra_zoomed")
	else
		degrees = self:get("camera_fov_zoomed")
	end

	return degrees * math.pi / 180
end

-- Eases toward get_fov_radians_target over the user-configured
-- camera_zoom_speed (seconds - lower is faster) instead of snapping
-- instantly.
mod.get_smoothed_fov_radians = function (self)
	return self:ease_toward("fov_radians", self:get_fov_radians_target(), self:get("camera_zoom_speed"))
end

mod.get_camera_yaw_radians = function (self)
	local side = self:get("camera_shoulder_side")
	local sign = (side == "left" and -1) or (side == "right" and 1) or 0
	local degrees_to_radians = math.pi / 180

	return sign * self:get("camera_turn_horizontal") * degrees_to_radians
end

mod.get_camera_pitch_radians = function (self)
	local degrees_to_radians = math.pi / 180

	return self:get("camera_turn_vertical") * degrees_to_radians
end

-- Shared camera lookup - see README.md ("Refactor notes").
mod.get_owner_camera = function (self, owner_unit, world)
	local player = Managers.player:owner(owner_unit)
	local viewport = ScriptWorld.viewport(world, player.viewport_name)

	return ScriptViewport.camera(viewport)
end

-- Temporarily extends the shared vanilla INTERACT_RAY_DISTANCE global
-- (2.5m by default - a real bare global, not a table field, also read by
-- bot AI positioning in player_bot_base.lua, so NOT safe to change
-- permanently) by `extra_distance`, for the exact synchronous duration of
-- one interaction/pickup raycast. Returns the original value so the
-- caller can restore it immediately after, the same "poke and restore"
-- pattern used elsewhere in this file for Unit position/rotation, just
-- applied to a global instead.
--
-- `extra_distance` must be the ACTUAL real-world gap between the
-- third-person camera and the true first-person head position
-- (Vector3.distance between the two, measured fresh by the caller before
-- poking) - NOT just the camera_distance setting. Even at
-- camera_distance = 0 the camera doesn't sit at the head/eye position:
-- the shoulder x-offset, the height offset, and the third-person node's
-- own baseline anchor point (not the head bone) all still contribute a
-- real gap. See README.md ("Item pickup / interaction raycast").
mod.extend_interact_ray_distance = function (self, extra_distance)
	local original = INTERACT_RAY_DISTANCE

	INTERACT_RAY_DISTANCE = original + extra_distance

	return original
end

-- Applies the turn to a rotation: yaw pre-multiplied (world-space, immune to
-- current pitch), pitch post-multiplied (local-space, roll-free on its own).
-- See README.md ("Turn composition math") for the full derivation of why
-- this specific split is necessary. Pass pitch = 0 for yaw-only callers.
mod.apply_turn_to_rotation = function (self, rotation, yaw, pitch)
	if yaw == 0 and pitch == 0 then
		return rotation
	end

	local yaw_rotation = Quaternion(Vector3.up(), yaw)
	local pitch_rotation = Quaternion(Vector3.right(), pitch)
	local yawed_rotation = Quaternion.multiply(yaw_rotation, rotation)

	return Quaternion.multiply(yawed_rotation, pitch_rotation)
end

-- Exact algebraic inverse of apply_turn_to_rotation above - must always
-- match it or this reopens the aim-contamination bug apply_recoil prevents.
mod.strip_turn_from_rotation = function (self, rotation, yaw, pitch)
	if yaw == 0 and pitch == 0 then
		return rotation
	end

	local inverse_yaw_rotation = Quaternion.inverse(Quaternion(Vector3.up(), yaw))
	local inverse_pitch_rotation = Quaternion.inverse(Quaternion(Vector3.right(), pitch))

	return Quaternion.multiply(Quaternion.multiply(inverse_yaw_rotation, rotation), inverse_pitch_rotation)
end

-- Blend factor (0 = fully suppressed, 1 = fully applied) for fading BOTH
-- the position offset and the turn in/out around the "heal_self"
-- exclusion, instead of snapping them on/off the instant the camera node
-- changes. Shared by TransformCamera.update (position) and
-- _update_camera_properties (rotation) so the two fade in lockstep rather
-- than at different rates. See README.md ("Turn composition math").
mod.get_camera_blend = function (self, suppressed)
	local target = suppressed and 0 or 1
	local now = Managers.time:time("main")

	if self._camera_blend_target ~= target then
		self._camera_blend_target = target
		self._camera_blend_start_value = self._camera_blend_value or target
		self._camera_blend_start_time = now
	end

	local duration = CameraTransitionSettings.perspective_transition_time
	local t = duration > 0 and math.clamp((now - self._camera_blend_start_time) / duration, 0, 1) or 1
	local blend = self._camera_blend_start_value + (target - self._camera_blend_start_value) * t

	self._camera_blend_value = blend

	return blend
end

-- Applies third person to a specific unit/player - shared by the toggle
-- handler below and the level-start reapply hook further down, since a
-- fresh player_unit (new map, character switch, mid-level respawn) always
-- starts back in first person and needs this re-asserted explicitly.
mod.apply_third_person_to_unit = function (self, player, unit)
	local first_person_extension = ScriptUnit.extension(unit, "first_person_system")

	-- Re-trigger the camera state so the Development.parameter hook below
	-- can redirect it immediately instead of waiting for the next transition.
	CharacterStateHelper.change_camera_state(player, "follow")
	first_person_extension:set_first_person_mode(false)
end

mod.set_third_person_active = function (self, active)
	if self.third_person_active == active then
		return
	end

	local player = Managers.player and Managers.player:local_player()
	local unit = player and player.player_unit

	if not unit or not ScriptUnit.has_extension(unit, "first_person_system") then
		return
	end

	self.third_person_active = active

	if active then
		self:apply_third_person_to_unit(player, unit)
	else
		CharacterStateHelper.change_camera_state(player, "follow")
		ScriptUnit.extension(unit, "first_person_system"):toggle_visibility(CameraTransitionSettings.perspective_transition_time)

		-- Don't carry a stale "was aiming"/"was in weapon special zoom" state
		-- into the next time third person is turned back on.
		self._is_aiming = false
		self._weapon_special_zoom_active = false
	end
end

-- Blocks the toggle third person keybind
local function is_in_toggle_blocked_state(status_extension)
	return status_extension:is_dead()
		or status_extension:is_ready_for_assisted_respawn()
		or status_extension:is_knocked_down()
		or status_extension:is_pounced_down()
		or status_extension:is_grabbed_by_pack_master()
		or status_extension:get_is_ledge_hanging()
		or status_extension:is_hanging_from_hook()
end

mod.toggle_third_person_pressed = function ()
	local player = Managers.player and Managers.player:local_player()
	local unit = player and player.player_unit
	local status_extension = unit and ScriptUnit.has_extension(unit, "status_system")

	if status_extension and is_in_toggle_blocked_state(status_extension) then
		return
	end

	mod:set_third_person_active(not mod.third_person_active)
end

-- Flips camera_shoulder_side between "left" and "right" - "center" is
-- treated the same as "right" (i.e. pressed while centered goes to
-- "right"), since a plain left/right toggle has no natural third state to
-- cycle through. mod:set persists it exactly like changing the dropdown in
-- the options menu would, and get_camera_offset (read every frame while
-- third_person_active) picks it up immediately - no extra refresh needed.
mod.toggle_shoulder_side_pressed = function ()
	local current_side = mod:get("camera_shoulder_side")
	local next_side = (current_side == "left") and "right" or "left"

	mod:set("camera_shoulder_side", next_side)
end

-- Fakes the game's dev-only third-person flag so vanilla camera/zoom code
-- routes through its own persistent third-person paths. See README.md
-- ("Core approach") for why this beats forcing a specific camera state.
mod:hook(Development, "parameter", function (func, param)
	if param == "third_person_mode" and mod.third_person_active and not mod._suppress_third_person_mode_flag then
		return true
	end

	return func(param)
end)

-- third_person_active persists for the whole session, but a brand new
-- player_unit (new map, character switch, mid-level respawn) always starts
-- back in first person - nothing re-asserts third person onto it unless we
-- do so here. "level_start_local_player_spawned" is the vanilla event other
-- systems already use for "reapply my state to the fresh local unit".
-- Hooked on EventManager.trigger (the class, not a specific instance)
-- because Managers.state.event is a brand new EventManager per level - a
-- one-time :register() call wouldn't survive the next level transition.
-- See README.md ("Persisting across new maps/characters").
mod:hook(EventManager, "trigger", function (func, self, event_name, ...)
	local result = func(self, event_name, ...)

	if event_name == "level_start_local_player_spawned" and mod.third_person_active then
		local is_initial_spawn, unit = ...
		local player = unit and Managers.player:owner(unit)

		if player then
			mod:apply_third_person_to_unit(player, unit)
		end
	end

	return result
end)

-- Some vanilla states flip first-person mode back on without going through
-- anything else we hook - pin it off for as long as we're active.
mod:hook(PlayerUnitFirstPerson, "set_first_person_mode", function (func, self, active, override, unarmed)
	if mod.third_person_active and not override then
		active = false
	end

	return func(self, active, override, unarmed)
end)

-- CameraSettings offsets are baked once at level load, so we overwrite the
-- live node's offset every frame instead. See README.md ("Camera position").
-- Scaled by the shared blend (see get_camera_blend above) so the offset
-- fades in/out around "heal_self" (self-inspect etc.) in lockstep with the
-- turn, instead of snapping - this node isn't in OFFSET_NODE_NAMES so it
-- never gets scaled itself, only whatever node the camera returns to.
--
-- Deliberately does NOT vary this offset by zoom state anymore - "zooming"
-- while aiming used to move the camera closer/forward here, but the user
-- identified this exact per-frame position offset as the actual cause of
-- the long-standing crosshair-drift bug (see README.md "Weapon zoom,
-- entirely mod-owned"). Zoom is now expressed ONLY via FOV
-- (get_smoothed_fov_radians, in _update_camera_properties below) - the
-- camera's position/distance stays fixed at all zoom states.
mod:hook(TransformCamera, "update", function (func, self, dt, position, rotation, data)
	if not mod.third_person_active then
		return func(self, dt, position, rotation, data)
	end

	local name = self._name

	if mod.OFFSET_NODE_NAMES[name] then
		local blend = mod._camera_blend_value or 1
		local offset = mod:get_camera_offset()

		self._offset_position = {x = offset.x * blend, y = offset.y * blend, z = offset.z * blend}
	end

	return func(self, dt, position, rotation, data)
end)

-- Last Lua-level function to see camera_data before it becomes the actual
-- rendered orientation - the only place downstream enough for the turn to
-- survive zoom-node switches while aiming. Faded out on the "heal_self"
-- node (self-inspect/revive/self-heal/emote camera views) rather than cut
-- instantly. See README.md ("Turn composition math") for why it can't be
-- applied earlier and why that node is excluded.
--
-- Position (the "camera movement when aiming" offset) is deliberately NOT
-- touched here, even though this is where the turn's rotation is applied -
-- camera_data.position here is downstream of per-frame smoothing, so an
-- absolute delta added to it every frame compounds instead of staying
-- fixed. See the TransformCamera.update hook instead, which sets a fresh,
-- non-accumulating local offset every frame - the correct and only safe
-- place for any position adjustment. See README.md ("Camera position").
mod:hook(CameraManager, "_update_camera_properties", function (func, self, camera, shadow_cull_camera, current_node, camera_data, viewport_name)
	if mod.third_person_active and camera_data.rotation then
		local blend = mod:get_camera_blend(current_node:name() == "heal_self")

		if blend > 0 then
			local yaw = mod:get_camera_yaw_radians() * blend
			local pitch = mod:get_camera_pitch_radians() * blend

			camera_data.rotation = mod:apply_turn_to_rotation(camera_data.rotation, yaw, pitch)
		end
	end

	-- FOV per zoom state (mod.get_smoothed_fov_radians) only makes sense on
	-- "over_shoulder" - the only node whose zoom state (mod._is_aiming /
	-- mod._weapon_special_zoom_active) this mod actually drives. Any other
	-- node (heal_self, or a vanilla mechanic activating one of the other
	-- OFFSET_NODE_NAMES directly) keeps whatever FOV vanilla's own transition
	-- system already computed for it.
	if mod.third_person_active and current_node:name() == "over_shoulder" then
		camera_data.vertical_fov = mod:get_smoothed_fov_radians()
	end

	return func(self, camera, shadow_cull_camera, current_node, camera_data, viewport_name)
end)

-- apply_recoil reads the rendered camera and bakes it into the character's
-- real aim (a no-op in first person, but permanently bakes our cosmetic
-- turn into the aim in third person). Strip the turn before calling
-- through, restore it after. See README.md ("Turn getting permanently
-- baked into aim") for the rapid-fire-weapon bug this replaced.
mod:hook(PlayerUnitFirstPerson, "apply_recoil", function (func, self, factor)
	if not mod.third_person_active then
		return func(self, factor)
	end

	local yaw = mod:get_camera_yaw_radians()
	local pitch = mod:get_camera_pitch_radians()

	if yaw == 0 and pitch == 0 then
		return func(self, factor)
	end

	local camera = mod:get_owner_camera(self.unit, self.world)
	local turned_rotation = ScriptCamera.rotation(camera)
	local clean_rotation = mod:strip_turn_from_rotation(turned_rotation, yaw, pitch)

	ScriptCamera.set_local_rotation(camera, clean_rotation)

	local result = func(self, factor)

	ScriptCamera.set_local_rotation(camera, turned_rotation)

	return result
end)

-- WASD movement follows the turned camera, not the character's clean aim
-- (user request). Poke-and-restore first_person_unit for the synchronous
-- duration of the call; no World.update_unit needed since current_rotation()
-- reads local_rotation directly. See README.md ("WASD movement...").
mod:hook(CharacterStateHelper, "move_on_ground", function (func, first_person_extension, input_extension, locomotion_extension, local_move_direction, speed, unit, strafe_speed_mult)
	if not mod.third_person_active then
		return func(first_person_extension, input_extension, locomotion_extension, local_move_direction, speed, unit, strafe_speed_mult)
	end

	local yaw = mod:get_camera_yaw_radians()

	if yaw == 0 then
		return func(first_person_extension, input_extension, locomotion_extension, local_move_direction, speed, unit, strafe_speed_mult)
	end

	local first_person_unit = first_person_extension.first_person_unit
	local original_rotation = Unit.local_rotation(first_person_unit, 0)
	local turned_rotation = mod:apply_turn_to_rotation(original_rotation, yaw, 0)

	Unit.set_local_rotation(first_person_unit, 0, turned_rotation)

	local result = func(first_person_extension, input_extension, locomotion_extension, local_move_direction, speed, unit, strafe_speed_mult)

	Unit.set_local_rotation(first_person_unit, 0, original_rotation)

	return result
end)

-- Almost every ranged weapon fires along the character's head bone
-- regardless of perspective - fire from the camera instead so the shot
-- matches the crosshair. See README.md ("Aiming origin").
mod:hook(PlayerUnitFirstPerson, "get_projectile_start_position_rotation", function (func, self)
	if not mod.third_person_active then
		return func(self)
	end

	local camera = mod:get_owner_camera(self.unit, self.world)

	return ScriptCamera.position(camera), ScriptCamera.rotation(camera)
end)

-- The tag/ping raycast (the dedicated "Tag" key AND the regular
-- ping/social-wheel targeting share this same function) has the identical
-- head-bone-instead-of-camera problem as weapon fire above:
-- ContextAwarePingExtension._check_raycast reads
-- first_person_extension:current_position()/current_rotation(), which trace
-- to Unit.local_position/local_rotation(first_person_unit, 0) - the
-- character's own facing, not the camera - so pressing Tag in third person
-- marks whatever the character's head is pointed at, not what's under the
-- crosshair. Poke-and-restore first_person_unit for the exact synchronous
-- duration of the call, same pattern as ActionChargedProjectile's _shoot
-- hook below. No World.update_unit needed - like move_on_ground,
-- current_position/current_rotation read Unit.local_position/local_rotation
-- directly, which update immediately with no propagation delay.
-- _is_camera_looking_at_position (the separate dark-pact/versus enemy-mark
-- fallback) already uses first_person_extension:camera() - the real
-- rendered camera - so it needs no fix. See README.md ("Tag/ping raycast").
mod:hook(ContextAwarePingExtension, "_check_raycast", function (func, self, unit)
	if not mod.third_person_active then
		return func(self, unit)
	end

	local first_person_unit = self._first_person_extension.first_person_unit
	local camera = mod:get_owner_camera(unit, self._world)
	local camera_position = ScriptCamera.position(camera)
	local camera_rotation = ScriptCamera.rotation(camera)
	local original_position = Unit.local_position(first_person_unit, 0)
	local original_rotation = Unit.local_rotation(first_person_unit, 0)
	local original_interact_ray_distance = mod:extend_interact_ray_distance(Vector3.distance(camera_position, original_position))

	Unit.set_local_position(first_person_unit, 0, camera_position)
	Unit.set_local_rotation(first_person_unit, 0, camera_rotation)

	local ping_unit, social_wheel_unit, ping_unit_distance, social_wheel_unit_distance, position = func(self, unit)

	Unit.set_local_position(first_person_unit, 0, original_position)
	Unit.set_local_rotation(first_person_unit, 0, original_rotation)
	INTERACT_RAY_DISTANCE = original_interact_ray_distance

	return ping_unit, social_wheel_unit, ping_unit_distance, social_wheel_unit_distance, position
end)

-- Item pickup / interaction detection (ammo crates, potions, levers,
-- revive, etc.) has the same head-bone-instead-of-camera raycast origin
-- problem as the tag/ping and weapon-fire hooks above -
-- GenericUnitInteractorExtension.update's local-player branch also reads
-- first_person_extension:current_position()/current_rotation() for its
-- raycast. Same poke-and-restore fix, wrapping the WHOLE update() call
-- rather than trying to intercept the raycast individually - the raycast
-- is inlined directly in this large function rather than split into its
-- own hookable method, and everything camera-relevant inside it runs
-- synchronously within this one call, so bracketing the whole thing is
-- both simpler and safer than reimplementing any of its logic.
--
-- Also extends INTERACT_RAY_DISTANCE for the same synchronous duration
-- (see extend_interact_ray_distance) by the ACTUAL measured gap between
-- the camera and the head, not just the camera_distance setting - even at
-- camera_distance = 0 the camera doesn't sit at the head/eye position
-- (shoulder x-offset, height offset, and the node's own baseline anchor
-- point all still contribute), so a fixed-length raycast from the camera
-- would otherwise fall short of items reachable in first person.
-- User-reported: "it should raycast [from the camera], the distance needs
-- to be longer, since the camera is further away."
mod:hook(GenericUnitInteractorExtension, "update", function (func, self, unit, input, dt, context, t)
	if not mod.third_person_active then
		return func(self, unit, input, dt, context, t)
	end

	local first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	local first_person_unit = first_person_extension.first_person_unit
	local camera = mod:get_owner_camera(unit, self.world)
	local camera_position = ScriptCamera.position(camera)
	local camera_rotation = ScriptCamera.rotation(camera)
	local original_position = Unit.local_position(first_person_unit, 0)
	local original_rotation = Unit.local_rotation(first_person_unit, 0)
	local original_interact_ray_distance = mod:extend_interact_ray_distance(Vector3.distance(camera_position, original_position))

	Unit.set_local_position(first_person_unit, 0, camera_position)
	Unit.set_local_rotation(first_person_unit, 0, camera_rotation)

	local result = func(self, unit, input, dt, context, t)

	Unit.set_local_position(first_person_unit, 0, original_position)
	Unit.set_local_rotation(first_person_unit, 0, original_rotation)
	INTERACT_RAY_DISTANCE = original_interact_ray_distance

	return result
end)

-- Beam Staff-specific compatibility fix. TourneyBalance (see
-- Tourney-Balance-Open-Beta/scripts/mods/TourneyBalance/changes/weapon_changes/ranged/bw_beam.lua)
-- replaces ActionBeam.client_owner_post_update entirely via its own
-- mod:hook_origin, and that replacement never calls
-- GenericStatusExtension.set_zooming(true) at all (confirmed by reading its
-- source and by diagnostic logging: is_zooming() stayed false for the
-- entire duration of firing). Since `func` here resolves to TourneyBalance's
-- replacement, not vanilla, the Beam Staff never entered a "zooming" state
-- for our set_zooming hook to see - so it never zoomed in third person at
-- all. This restores the missing call ourselves, using self.do_zoom (still
-- set correctly by TourneyBalance's replacement) as the trigger, checked
-- AFTER calling through so it's a harmless no-op if vanilla (or some other
-- mod) already handled it correctly. See README.md ("Weapon zoom, entirely
-- mod-owned"). Scoped to third_person_active only - not our place to "fix"
-- this for first person, which is unaffected by this mod either way.
mod:hook(ActionBeam, "client_owner_post_update", function (func, self, dt, t, world, can_damage)
	local result_a, result_b, result_c = func(self, dt, t, world, can_damage)

	if mod.third_person_active and self.do_zoom and self.status_extension and not self.status_extension:is_zooming() then
		self.status_extension:set_zooming(true)
	end

	return result_a, result_b, result_c
end)

-- Flamethrower-kind weapons (Drakegun, Flamestorm Staff) don't go through
-- get_projectile_start_position_rotation and need both their damage cone
-- and visible flame redirected to the camera - two different fixes, see
-- README.md ("Flamethrower") for the full multi-round history (render
-- timing, a transient-object crash, and targeting the wrong bone).
mod:hook(ActionFlamethrower, "client_owner_post_update", function (func, self, dt, t, world, can_damage)
	if not mod.third_person_active then
		return func(self, dt, t, world, can_damage)
	end

	local first_person_unit = self.first_person_unit
	local weapon_unit = self.weapon_unit
	local camera = mod:get_owner_camera(self.owner_unit, world)
	local camera_position = ScriptCamera.position(camera)
	local camera_rotation = ScriptCamera.rotation(camera)
	local fp_original_position = Unit.local_position(first_person_unit, 0)
	local fp_original_rotation = Unit.local_rotation(first_person_unit, 0)

	-- The flame particle follows the MUZZLE node, not node 0 - node 0 is
	-- always identity locally (rigidly attached to a hand bone that does
	-- the real aiming), so we solve for the local rotation that makes the
	-- muzzle's WORLD rotation equal camera_rotation instead of setting an
	-- absolute value. See README.md for the derivation and the two wrong
	-- attempts (vertical inversion, then a pitch/yaw coupling) before this.
	local muzzle_node_name = self.muzzle_node_name or "fx_muzzle"
	local muzzle_node = Unit.node(weapon_unit, muzzle_node_name)

	-- Only valid while local is truly identity - restore-then-recompute
	-- each frame after the first, since we deliberately leave the muzzle
	-- poked between frames (see below) rather than restoring it every frame.
	if self._tp_original_weapon_rotation == nil then
		-- QuaternionBox: Unit.local_rotation returns a transient per-frame
		-- value that doesn't survive being stored across frames raw.
		self._tp_original_weapon_rotation = QuaternionBox(Unit.local_rotation(weapon_unit, muzzle_node))
	else
		Unit.set_local_rotation(weapon_unit, muzzle_node, self._tp_original_weapon_rotation:unbox())
		World.update_unit(world, weapon_unit)
	end

	local muzzle_original_local_rotation = self._tp_original_weapon_rotation:unbox()
	local muzzle_original_world_rotation = Unit.world_rotation(weapon_unit, muzzle_node)
	local muzzle_effective_parent_world_rotation = Quaternion.multiply(muzzle_original_world_rotation, Quaternion.inverse(muzzle_original_local_rotation))
	local weapon_rotation = Quaternion.multiply(Quaternion.inverse(muzzle_effective_parent_world_rotation), camera_rotation)

	Unit.set_local_position(first_person_unit, 0, camera_position)
	Unit.set_local_rotation(first_person_unit, 0, camera_rotation)
	Unit.set_local_rotation(weapon_unit, muzzle_node, weapon_rotation)
	World.update_unit(world, first_person_unit)
	World.update_unit(world, weapon_unit)

	local result_a, result_b, result_c = func(self, dt, t, world, can_damage)

	-- first_person_unit restores every call (its rotation is read by many
	-- other systems between frames); weapon_unit is deliberately left
	-- poked - see _stop_fx below and README.md for why.
	Unit.set_local_position(first_person_unit, 0, fp_original_position)
	Unit.set_local_rotation(first_person_unit, 0, fp_original_rotation)
	World.update_unit(world, first_person_unit)

	return result_a, result_b, result_c
end)

-- Restores weapon_unit's rotation once firing actually stops (covers both
-- natural completion and interruption/cancellation) - see the hook above.
mod:hook(ActionFlamethrower, "_stop_fx", function (func, self)
	if self._tp_original_weapon_rotation then
		local weapon_unit = self.weapon_unit
		local muzzle_node_name = self.muzzle_node_name or "fx_muzzle"
		local muzzle_node = Unit.node(weapon_unit, muzzle_node_name)

		Unit.set_local_rotation(weapon_unit, muzzle_node, self._tp_original_weapon_rotation:unbox())
		World.update_unit(self.world, weapon_unit)

		self._tp_original_weapon_rotation = nil
	end

	return func(self)
end)

-- Bolt/Fireball/Conflagration/Necromancy staves and Drakefire Pistols
-- compute their own fire position/rotation from first_person_unit directly,
-- bypassing get_projectile_start_position_rotation entirely. Same
-- poke-and-restore as the flamethrower damage cone. See README.md
-- ("ActionChargedProjectile").
mod:hook(ActionChargedProjectile, "_shoot", function (func, self, t)
	if not mod.third_person_active then
		return func(self, t)
	end

	local first_person_unit = self.first_person_unit
	local camera = mod:get_owner_camera(self.owner_unit, self.world)
	local original_position = Unit.local_position(first_person_unit, 0)
	local original_rotation = Unit.local_rotation(first_person_unit, 0)

	Unit.set_local_position(first_person_unit, 0, ScriptCamera.position(camera))
	Unit.set_local_rotation(first_person_unit, 0, ScriptCamera.rotation(camera))
	World.update_unit(self.world, first_person_unit)

	local result = func(self, t)

	Unit.set_local_position(first_person_unit, 0, original_position)
	Unit.set_local_rotation(first_person_unit, 0, original_rotation)
	World.update_unit(self.world, first_person_unit)

	return result
end)

-- Zoom is entirely mod-owned now (see README.md "Camera position" for the
-- long history of trying to mirror vanilla's own multi-tier zoom system in
-- third person - crosshair drift on one specific node, then weapon-specific
-- mismatches with a custom balance mod, then a still-unexplained regression
-- where weapons with no real zoom tier started showing one). Regardless of
-- which vanilla camera_name a weapon would normally zoom to
-- ("zoom_in"/"increased_zoom_in"/etc, always suffixed to "..._third_person"
-- once our fake flag is on), we always force the camera to stay on
-- "over_shoulder" while zooming - the ONE node this mod fully controls the
-- position of - and represent "zoomed in" purely via FOV
-- (get_smoothed_fov_radians, in _update_camera_properties below) instead of
-- switching nodes OR moving the camera at all - moving the camera per zoom
-- state turned out to be the actual cause of the drift bug (see README.md),
-- so position is now identical across every zoom state. Suppressing our
-- flag fake for this call (like the original crossbow crash fix) stops
-- vanilla from ALSO suffixing "over_shoulder" into the nonexistent
-- "over_shoulder_third_person".
--
-- mod._is_aiming (read by get_fov_radians_target) mirrors `zooming`
-- directly - true for every ranged weapon's aim input, regardless of
-- whether that weapon has a real zoom tier in vanilla. Un-aiming
-- (zooming == false) is NOT redirected: letting vanilla run normally there
-- already correctly picks "over_shoulder" for third person on its own.
mod:hook(GenericStatusExtension, "set_zooming", function (func, self, zooming, camera_name)
	if not mod.third_person_active then
		return func(self, zooming, camera_name)
	end

	mod._is_aiming = zooming

	if not zooming then
		return func(self, zooming, camera_name)
	end

	mod._weapon_special_zoom_active = false
	mod._suppress_third_person_mode_flag = true

	local result = func(self, zooming, "over_shoulder")

	mod._suppress_third_person_mode_flag = false

	return result
end)

-- Weapon special zoom (variable-zoom weapons: beam staves, trueflight bow)
-- is now also entirely mod-owned - see the set_zooming hook above.
-- mod._weapon_special_zoom_active just toggles on each call (this hook
-- only ever fires on a weapon-special press while aiming, and the
-- underlying vanilla cycle it used to drive is a two-entry table, so a
-- plain toggle mirrors that alternation without needing to track vanilla's
-- own cycle position at all). Still call through to vanilla so
-- self.zoom_mode/self.zooming stay updated for whatever else might read
-- them, but re-assert "over_shoulder" afterward in case vanilla's own
-- (now-meaningless, since self.zoom_mode never matches its zoom_table
-- once redirected) cycling changed the active node. See README.md
-- ("Weapon zoom, entirely mod-owned").
mod:hook(GenericStatusExtension, "switch_variable_zoom", function (func, self, zoom_table)
	if not mod.third_person_active then
		return func(self, zoom_table)
	end

	mod._weapon_special_zoom_active = not mod._weapon_special_zoom_active

	local result = func(self, zoom_table)
	local camera_follow_unit = self.player.camera_follow_unit

	if Unit.alive(camera_follow_unit) then
		Unit.set_data(camera_follow_unit, "camera", "settings_node", "over_shoulder")
	end

	return result
end)


mod.on_disabled = function ()
	mod:set_third_person_active(false)
end
