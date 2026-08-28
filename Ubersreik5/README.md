# Ubersreik5

A Vermintide 2 mod enabling 5-player adventure-mode co-op, ported/rebuilt from the decompiled original "UbersreikFive" mod, with reference to two other mods for patterns: **MorePlayers2** (a more mature 32-player mod) and **Grasmann's scoreboard_extension** (credited in `itemV2.cfg`). Most features are ports validated against decompiled original source or a working sibling mod's pattern, not invented from scratch.

This file exists so the in-code comments can stay short (1-2 lines). Whenever a comment says "see README", the full reasoning - the specific bug it fixes, the vanilla function it's reacting to, why the obvious simpler approach doesn't work - lives here instead.

## File layout

- `Ubersreik5.lua` - main file: party size, scoreboard-reset hooks, 4->5 loop-bound fixes, duplicate hero/career selection, bot handling, crash guards, dofile list.
- `CustomScoreboard.lua` - 5-player end-of-level scoreboard UI: real 5th panel, scrollbar for extra stat columns.
- `CustomScoreboardScoresFunctions.lua` - custom stat tracking (kill combos, burst dmg, healing, pings, overkill, etc.) + host-authoritative catch-up sync for mid-mission reconnects.
- `ConflictDirectorClustering.lua` - extends AI Director player-clustering math from 4 to 5 players.
- `MatchmakingPartySlot5.lua` - 5th-player readiness dot on the matchmaking overlay.
- `SkipEndOfLevelLoot.lua` - skips a vanilla backend call not built for a 5th player.

## Framework limitation: hook chaining

This modding framework does not chain multiple `mod:hook`/`mod:hook_safe` registrations from the **same mod** on the **same** `(table, method)` pair - only the first one to register actually takes effect, later ones silently never fire. This shows up twice in this codebase:

- `UISceneGraph.init_scenegraph` is patched exactly once, in `CustomScoreboard.lua`, with two independent shape-checked branches inside it (one for the scoreboard's `player_panel_5`/`player_frame_5`/`scrollbar`, one for the matchmaking overlay's `party_slot_5`) - `MatchmakingPartySlot5.lua` needs the second branch's node but can't register its own hook for it.
- Every restart-reset concern in `Ubersreik5.lua`'s `reload_level` hook lives in one hook body for the same reason (not a hook-chaining case here, just noted since it's the same pattern of "one hook, multiple independent concerns behind separate checks").

## Ubersreik5.lua

### MAX_PLAYERS and party size
`MAX_PLAYERS = 5` is set at the very top, before `MechanismSettings`/`MatchmakingSettings`/`PlayerManager` overrides run, because those execute immediately at mod-load time (not inside a hook) and read it directly.

### Scoreboard reset: on_enter
Resets the mod's own `PlayerScores` table whenever `StateIngame.on_enter` fires for the inn or an adventure mission.

### Scoreboard reset: reload_level
Restarting a map (vote retry, esc-menu retry, checkpoint retry, and the automatic reload on a party wipe) all funnel through `LevelTransitionHandler.reload_level` - but doesn't reliably re-trigger the `on_enter` reset above in time. Resetting directly off `reload_level` itself sidesteps that timing question by hooking the one point every restart path shares, instead of depending on `on_enter` firing correctly.

This hook does three things:
1. **`PlayerScores = {}`** - the mod's own custom stat table.
2. **`statistics_db:reset_session_stats()`** - vanilla's own native stats (kills/damage/etc). The `StatisticsDatabase` backing these (`Managers.venture.statistics`) is created once per "venture" (`GameMechanismManager._on_venture_start`) and only swapped for a fresh one when the venture ends (returning to inn) - a same-venture restart never touches it, so without this it accumulates across restarts instead of resetting. Vanilla itself defines `StatisticsDatabase:reset_session_stats()` for exactly this purpose (zeroes every registered player's session stat back to its default/persistent value in place, no unregister/re-register needed) but never calls it anywhere in real gameplay - only from its own unit test.
3. **Clear `Managers.mechanism.synced_players_session_score`** - `GameMechanismManager.get_players_session_score` caches vanilla's own native-stat sync the first time it arrives and never re-reads `statistics_db` live again for the rest of the mission (see the matching comment on the `CATCHUP_PACKAGE_ID` handler in `CustomScoreboardScoresFunctions.lua`, which clears this same field after a reconnect catch-up for the identical reason). Concretely: a party wipe with a checkpoint available shows the "continue from checkpoint?" screen before reloading, and setting up that screen calls `sync_players_session_score`, which populates this cache with the *failed* attempt's final stats on every client. If left in place, every non-host client would keep showing those stale pre-reset numbers for the entire next attempt, because a client's `get_players_session_score` returns this cached snapshot without ever touching `statistics_db` again once it's set - only the host always reads live. Clearing it here forces the next read back onto a live (correctly-reset) `statistics_db` read.

### Party/lobby/matchmaking capacity
`MechanismSettings`/`MatchmakingSettings`/`PlayerManager` overrides run immediately at mod-load time (not inside a hook), so `MAX_PLAYERS` must already be set above them.

### EventLightSpawnerExtension / BeastmenStandardExtension
Both hardcode a 4-slot spawn/astar-check pool (event light spirits e.g. Halescourge; beastmen banner/standard aura). Extended to `MAX_PLAYERS` slots.

### UnitFramesHandler._create_party_members_unit_frames
Vanilla's `NUM_PARTY_MEMBERS` excludes self (party size 4 -> 3 other frames), so the fix uses `MAX_PLAYERS - 1`, not `MAX_PLAYERS`.

### Duplicate hero/career selection
Stubs the low-level primitives every higher-level UI/flow function ultimately queries (`try_reserve_profile_for_peer`, `profile_available_for_peer`, `is_free_in_lobby`, `is_profile_in_use`) rather than patching each higher-level function individually. This allows fully identical duplicate hero+career picks (no "exact combo still blocked" restriction) - matches a proven, more general 32-player mod ("MorePlayers2") rather than the original Ubersreik Five's own narrower approach.

### Bot hero picker (`_get_first_available_bot_profile`)
Stubbing `is_profile_in_use`/`is_free_in_lobby` above (needed so humans can freely duplicate heroes) also blinds vanilla's own bot-hero-picker priority sort to real usage, so it would otherwise deterministically pick the same hero for every bot. This hook checks real usage directly via `Managers.player:players()` instead, so bots still default to one of each hero and only duplicate when every hero is taken, then picks randomly among what's actually free.

Deliberately **not** using `Managers.party._player_statuses` for "used" tracking: vanilla's own bot/profile removal (`ProfileSynchronizer._unassign_profiles_of_peer`) only clears the `ProfileSynchronizer`'s own state - it never clears `status.profile_index` on the party status entry, and nothing else ever deletes a status entry either. So once a bot has ever held a hero, that entry keeps reporting it as "used" forever, even long after the bot is removed - which is exactly what was still causing duplicates after removing and re-adding bots (party state, unlike a single mission, survives map<->keep transitions). `Managers.player:players()` is properly pruned on disconnect/removal instead.

`mod._bots_assigned_this_batch` is belt-and-suspenders against a within-batch timing gap: `_handle_bots` below calls `_add_bot` in a tight loop to fill several slots at once, and this table is this function's own immediate record of what it has already handed out *this batch*, in case one bot's pick hasn't landed on its player object yet by the time the next bot's check runs.

### Bot fill count (`_handle_bots`)
Vanilla always fills every open party slot with bots (`max_bots = party.num_slots`). Replaced with a user-configured count (mod option "numberofbots", read into the `fillwithbots` global by `on_all_mods_loaded`/`on_setting_changed`) so players can run with fewer than a full 5-player party of bots.

### `ferror` guard
Boss-kill achievement tracking hard-crashes the instant a 5th local player exists (`death_reactions.lua`'s `"while player_manager:local_player(local_player_id) ~= nil do if local_player_id > 4 then ferror(...)"`). This silences exactly that one assert message rather than patching the underlying loop bound (deep engine-adjacent achievement code) - the only cost is the 5th player's boss-kill achievement progress not being tracked for that instance.

### `UIGetFontHeight` guard
`scripts/ui/ui_passes.lua`'s text-draw pass unconditionally reads `ui_style.font_type` to look up cached font height metrics, even on the code path meant for widgets whose style provides a raw `font` table instead of a named `font_type` string - if `font_type` is nil, that read indexes `FontHeights` with a nil key and crashes ("table index is nil"). Hit while starting to host with this mod's new matchmaking/scoreboard widgets; the exact widget wasn't pinned down from static review of ~1000 lines of style tables, so this guards the general case instead of guessing further - falls back to a real, common font whenever `font_type` is missing.

### `cluster_positions` / `cluster_weight_and_loneliness`
The actual 5-player rewrite lives in `ConflictDirectorClustering.lua` - see that section below. The copy of `cluster_positions` here exists only to point at vanilla's real implementation (it's fully dynamic and needs no player-count changes); `cluster_weight_and_loneliness` is stubbed to a constant here because correctly generalizing vanilla's fixed 4-position algorithm is error-prone (an earlier attempt had a confirmed under-counting bug) - matches a proven, more general 32-player mod. This only affects how "clustered vs spread out" the AI *thinks* the party is, not any crash/correctness path.

### AdventureSpawning nil-guards
`_assign_data_to_slot`/`_unassign_data_from_slot` dereference `data.health_state`/`table.is_empty(data)` without a nil-guard on a slot's `game_mode_data` - a timing race around player disconnect/leave that isn't specific to player count but is cheap insurance to add. `table.is_empty` itself is also patched globally to treat `nil` as empty.

### DeusMapScene._place_token
The Deus/Chaos Wastes map board only has 4 authored token-placement poses (`referenced_token_poses` is baked into level data, not something a mod can resize) - a 5th player's board token would index a nil pose. Simplest correct fix: don't place a token for player slots beyond 4.

### GameSession.game_object_field guard
Returns safe defaults for health-related fields instead of erroring when a game object hasn't finished syncing yet - a timing race that becomes more likely with more simultaneous peers, not something tied to a specific player count.

### dofile list
Loads `CustomScoreboard`, `CustomScoreboardScoresFunctions`, `MatchmakingPartySlot5`, `ConflictDirectorClustering`, and `SkipEndOfLevelLoot` - see their own sections below. `SkipEndOfLevelLoot` exists because `generate_end_of_level_loot` sends the full player roster to a remote Playfab CloudScript call this mod doesn't control, and that backend logic isn't built for a 5th player.

## CustomScoreboard.lua

### Why a real 5th panel, not a resize
Vanilla's own row widgets (`UIWidgets.create_score_entry`/`create_score_topics`) bake in their row count and *size* at widget-creation time (a `size` constructor parameter, not something read live from the scenegraph node) - so getting players 1-4 to actually render thinner/taller requires fully recreating those widgets with the new size, not just resizing their scenegraph nodes. `create_ui_elements` below does exactly that: calls vanilla's own version first, then rebuilds `scores_topics` and all 5 score widgets at this mod's size/row-capacity.

### Row layout math (`BOTTOM_PADDING_ROWS`, panel sizing)
Mirrors vanilla's own `UIWidgets.create_score_entry`/`create_score_topics`: both lay out row `k` at `y = size[2] - 80 - k * row_bg_settings.size[2]`, where `row_bg_settings` comes from the `"scoreboard_topic_bg"` atlas entry - 39px tall, not the round 40 you'd guess. Sizing the panel for anything but exactly `header + rows_default * 39` leaves dead space below the last row that grows by the same amount at every "extend" setting value (extension adds height 1:1 per row, so the mismatch never gets absorbed). `BOTTOM_PADDING_ROWS` adds exactly that much dead space back deliberately - it's added to the base size (not run through `extension()`), so it stays a constant 1 empty row of padding at every "extend" value, without shifting the scrollbar's `visible_rows` count (which only counts real content rows).

### Scrollbar
Index space is into `self._scoreboard_rows`: row 1 (player names) is fixed and never part of it; the scrollbar covers rows `2..(1 + total scrollable rows)`. Manual (mouse wheel / gamepad) scrolling only - the original mod's idle auto-scroll animation had the heaviest decompiler corruption of anything in that source (unclear timing constants, several undefined locals) and is skipped here as a deliberate simplification rather than guessed at.

### `init_scenegraph` hook
Only needs to add `player_panel_5`/`player_frame_5` - the widgets consuming panels 1-4 get fully recreated in `create_ui_elements` regardless, but the scenegraph *nodes* for 1-4 still need their size/position updated since `UISceneGraph` resolves world positions from these. Only patches `EndViewStateScore`'s scenegraph (checked via the `player_panel_4` + `scores_topics` shape, unique to the end-of-level score screen) - `init_scenegraph` itself is shared by dozens of unrelated UI screens.

This is also the one hook handling the matchmaking overlay's `party_slot_5` node (see the hook-chaining limitation above) - checked via its own independent `party_slot_4` + `party_slot_root` shape.

`TOP_OFFSET`: `UIRenderer.begin_pass` calls `UISceneGraph.update_scenegraph` every frame, which *does* apply `vertical_alignment` via `align()` against the engine's real per-resolution screen height, not a hardcoded 1080. With `vertical_alignment = "top"`, a child's top edge resolves to `position[2] + screen_height` regardless of the child's own size - so pinning `TOP_OFFSET` needs no compensation for `mod.scoreboard:extension()` at all (unlike `"center"`, which would need half the size delta subtracted to hold an edge fixed), and stays correct across resolutions/aspect ratios since `screen_height` comes from the engine instead of an assumed 1080. `player_frame_i` (portraits) and the level icon attach `"top"` further down this same parent chain, so they inherit this fixed position automatically.

`scenegraph_def` is vanilla's own module-level table, shared/reused for every scoreboard built for the rest of the game session (not recreated per build). So `player_panel_5`/`player_frame_5`/`scrollbar` must only be added once (guarded by `if not scenegraph_def.player_panel_5`), while everything that depends on the *current* "extend" setting (size, position, alignment) must run on every call - otherwise a setting change made after the first scoreboard of the session never takes effect (`create_ui_elements` still rebuilds widgets fresh every time against the stale, frozen anchor - this is what made the panel look bottom-anchored again after changing "extend" more than once without reloading).

### `move_inner_panels` / `move_outer_panels`
Vanilla's own entrance animation directly overwrites `player_panel_1-4`'s `local_position[1]` every frame, sliding them to vanilla's hardcoded 4-player rest spots (`-700, -375, 375, 700`) - overriding whatever `init_scenegraph` set as their base position. Since `player_panel_5` has no animation entry of its own, it would just sit at its `init_scenegraph` position (650), landing on top of panels 3/4's vanilla rest spots. Re-registering both callbacks with new rest spots (evenly spaced alongside the topics column at -700 and panel 5 at 650) is how the original mod fixed this; same fix, same rest-spot values.

### `_setup_player_scores` hook
Vanilla's own `_setup_player_scores`/`_setup_score_panel` already handle a 5th player correctly once `_score_widgets[5]` exists (they iterate however many players are actually in `players_session_scores`, not a hardcoded 4) - no need to replace that logic. This hook just captures the per-player `stats_id` list, in the *same order* vanilla assigns widget indices, for the custom-entry callbacks in `_setup_score_panel` below. It must run *before* calling through to vanilla (a full `mod:hook`, not `hook_safe`), since vanilla's own `_setup_player_scores` calls `_setup_score_panel` internally near its own end, and that hook depends on `_stats_id_by_widget_index` already being set.

Deliberately **not** `table.sort()`-ed: vanilla's own widget_index assignment (further down in this same function) is a plain incrementing counter over its own `pairs(players_session_scores)` loop - unsorted. An earlier version of this sorted stats_ids alphabetically for (mistaken) determinism, which put this list in a different order than vanilla's, so `_stats_id_by_widget_index[i]` and vanilla's own player at widget index `i` were often two different players - misattributing every custom stat column to the wrong player. Plain `pairs()` with no sort lands in the exact same order vanilla's own subsequent `pairs()` call over this same, unmodified table does (Lua's `pairs()`/`next()` iteration order is deterministic for an unchanged table).

After calling through to vanilla: both `_hero_widgets` (vanilla's own, pre-created at a fixed 4 slots in `create_ui_elements`) and `_score_widgets` (this mod's, pre-created at a fixed 5 slots) are built before the real player count is known. Vanilla's loop only overwrites slots `1..num_players` with a real player's widget, so any slot beyond that still holds its original empty placeholder - an extra panel/frame with no player in it. This hook nils those trailing slots out so vanilla's own `draw()` (which walks both arrays with `ipairs`, stopping at the first nil) simply skips them - this is what makes a solo/duo/trio game show only as many panels as there are real players, instead of always 4-5.

### `_setup_score_panel` hook (`hook_safe`)
After vanilla writes its own native rows (1 name row + 1 per stat topic) into `_score_widgets[1..N].content`, this appends the mod's custom entries as additional scrollable rows.

### `draw`/`begin_pass`/`end_pass`
Vanilla's real `draw()` already ends its own pass by the time a `hook_safe` body runs, so drawing the scrollbar needs a separate pass, not a bare `draw_widget` call after the fact (that crashes - `self.ui_renderer.ui_scenegraph` is nil once a pass has ended).

### `_update_entry_hover` hook
While actively scrolling, don't let vanilla's own hover-highlight logic react to rows sliding under a stationary mouse cursor.

## CustomScoreboardScoresFunctions.lua

Extra per-player stat columns for the end-of-level scoreboard, on top of vanilla's own (kills/damage/revives/etc, already read straight out of the vanilla `StatisticsDB` by `CustomScoreboard.lua`). Everything here is `hook_safe` (side-effect only, after vanilla's real logic runs) and keyed by `PlayerScores[stats_id][stat_name]`, reset each time the mod's scoreboard-reset hooks in `Ubersreik5.lua` fire.

### Overkill damage clamp (`register_damage` hook)
Vanilla's own `StatisticsUtil.register_damage` clamps `damage_amount` to the victim's remaining health before accumulating its own `"damage_dealt"` stat (`math.clamp(damage_amount, 0, current_health)`, called before health is actually reduced, so `current_health` here is still the pre-hit value) - otherwise a lethal hit for far more damage than the target had left would inflate the total. This hook mirrors that same clamp before using `damage_amount` for every stat below (self-damage, friendly fire, burst, elite/special/lord damage, DoT types) - without it, one overkill hit could inflate all of them. The clamped-off difference (`raw_damage_amount - damage_amount`) is itself tracked as the `overkill_damage` stat, scoped to enemy damage only (same branch as `elite_dmg`/`lord_dmg`/`special_dmg`) so self-damage and friendly fire don't pollute it.

### Reconnect catch-up sync
Modeled on a proven pattern found in MorePlayers2 (`src/ui/custom_scoreboard.lua`) - a more mature, higher-player-count mod solving the exact same problem: a player who relaunches the game to reconnect gets a fresh, empty `statistics_db` and `PlayerScores`, with no way to recover values for events it wasn't present for.

**The root cause:** `StatisticsDatabase:unregister(stats_id)`/`:register(stats_id, ...)` (`player_manager.lua`) run on **every connected machine's own local `statistics_db`**, not just the disconnecting/joining player's own client - whenever *any* player leaves, everyone else's (including the **host's**) local copy of their native stats gets unregistered too, and a fresh, zeroed entry gets created when they rejoin. By the time a disconnected player reconnects, even the host's own `statistics_db` entry for them may already be gone - so a live read at reconnect time can itself already be reading the wiped/reset value, regardless of any sync mechanism, and there is no way to recover a value that's already gone from the only place being read.

**The fix, in two parts:**
1. **Snapshot before wipe.** `mod:hook(StatisticsDatabase, "unregister", ...)` (a full hook, not `hook_safe`, so it runs *before* the underlying data is removed) captures a player's native stats into `NativeStatsSnapshot[stats_id]`, independent of `statistics_db`, right before `unregister()` wipes them. That snapshot becomes the source of truth for catch-up, instead of a live (possibly already-reset) `statistics_db` read.
2. **Restore on (re)join.** `mod.on_user_joined` fires the moment a player (re)joins the party, mid-mission - not at scoreboard-open time, which sidesteps vanilla's own native-stat sync (`GameMechanismManager.sync_players_session_score`/`rpc_sync_players_session_score`) and its one-shot-no-retry limitation entirely. For every teammate (which may be the rejoining player themselves, or anyone else who dis/reconnected earlier this mission): prefer the snapshot over a live read (since `statistics_db` may already be at a freshly-reset baseline); restore the **host's own** copy too via `apply_native_catchup`/`modify_stat_by_amount` (the host needs this exact same restoration, or vanilla's own later sync would just re-propagate its still-wiped value to everyone); then send the value to the rejoining client via `CATCHUP_PACKAGE_ID`, which applies it the same way and clears `Managers.mechanism.synced_players_session_score` (see the matching comment in `Ubersreik5.lua`'s `reload_level` hook for why).

For native stats specifically, catch-up writes straight into the receiving client's own `statistics_db` via `modify_stat_by_amount(stats_id, stat_name, value)` rather than fighting vanilla's `players_session_scores`/`_setup_player_scores` pipeline - vanilla's own scoreboard already reads from that same `statistics_db`, so nothing else needs to change. Compound topics (`kills_elites`, `kills_specials`, `damage_dealt_bosses` - each a sum across several `kills_per_breed`/`damage_dealt_per_breed` sub-stats, not a single stored value) get the whole delta dumped into just their first sub-stat-type, same as MorePlayers2 does it - the scoreboard only ever shows the summed total, never a per-breed breakdown, so which specific sub-stat absorbs it doesn't matter. `modify_stat_by_amount` *adds* to whatever's already stored rather than setting an absolute value - this only stays correct because `on_user_joined` fires essentially immediately after joining, before the rejoining player has generated any stats of their own yet.

**Why one `network_send` per teammate, not one covering the whole party:** `mod:network_send` ultimately goes through `ModManager.network_send -> RPC.rpc_mod_user_data` - a real engine RPC, which typically has a strict size limit on its parameters. MorePlayers2's own version of this sends one small message per teammate in a loop, each carrying only 3 numbers - not one message covering every player and stat at once. An earlier version of this file combined everything (every teammate, every stat) into a single message and it silently delivered nothing, twice, even after trimming the payload shape - matching an RPC size limit being exceeded rather than a shape/type problem.

**Debugging note:** this took multiple wrong theories to nail down (payload-too-complex for `mod:network_send`, `register()` firing after the snapshot fix, RPC size limits) before reaching the real cause above. `mod:echo` diagnostics placed at every step of the chain (unregister fired? snapshot found? catchup received? readback after apply?) were what actually resolved it - if a similar sync bug shows up again, that's the fastest path to ground truth, faster than re-deriving from source reading alone.

## ConflictDirectorClustering.lua

AI Director player-position clustering (`conflict_director/conflict_utils.lua`), hardcoded to at most 4 players/bots. Called constantly throughout a mission: `horde_spawner.lua` uses `cluster_positions` to decide *where* to spawn hordes relative to the party, `conflict_director.lua` uses both for pacing, and `perception_utils.lua` uses `cluster_weight_and_loneliness` to pick which player is most "lonely" (e.g. who an isolated-player-seeking special like a Gutter Runner should target). Without patching these, a 5th player's position is silently invisible to all of that - not a visual bug, a whole-mission gameplay-pacing one.

**Full replace rather than wrapping vanilla's function**, for both: vanilla's originals close over module-level scratch tables reused across calls as a performance optimization (avoids a table allocation per call) - those locals aren't reachable from a hook, and reusing them at a different size would need reimplementing anyway. Using a fresh table per call instead is simpler, and avoids a real correctness bug that optimization has in `cluster_positions`: vanilla's scratch queue only gets reset up to its *old* fixed size, so a call with fewer positions right after a call with more would see stale leftover entries and miscount how many are actually queued.

`cluster_weight_and_loneliness`'s 5-position math uses the same hand-unrolled pairwise-distance shape vanilla uses for 1-4 positions (kept identical, including index 5's max score following the same `C(n,2)` pattern index 3 (3) and 4 (6) already use), extended with a 5th position `e`. Processed highest-index-down so each block's cross-terms (e.g. `cd`, `ce`) are already computed by the time a lower block needs them, exactly mirroring vanilla's own d-then-c-then-b-then-a ordering.

## MatchmakingPartySlot5.lua

The 5th-player readiness dot on the matchmaking overlay (the small light next to the party portraits that goes green when a player is standing in the "ready to proceed" zone, blue otherwise). All of the actual readiness logic is 100% vanilla and already player-count-agnostic: `MatchmakingUI._sync_players_ready_state` checks each human player's `status_extension:is_in_end_zone()` and calls `_set_player_ready_state`, which swaps `player_status_N`'s texture between ready/not-ready - and every loop involved is bounded by `self._max_number_of_players`, not a hardcoded 4. So the only thing actually missing for a 5th player is the widget/scenegraph entries themselves - matches the original Ubersreik Five mod's own scope here.

`party_slot_5`'s actual scenegraph node is added in `CustomScoreboard.lua`'s `init_scenegraph` hook, not here - see the hook-chaining limitation at the top of this document. `PARTY_SLOT_5_SIZE` just needs to match the size used there.

`create_status_widget` mirrors the private `create_status_widget()` local in vanilla's `matchmaking_ui_definitions.lua` (not exposed via `UIWidgets`, so it can't be called directly) - every `player_status_N` widget is built from this same shape, differing only by offset into the shared `"window"` scenegraph node. `PLAYER_STATUS_5_OFFSET` uses the same Y as `player_status_1` (43), further left (-171 vs -89) so it sits its own gap to the left of the 1-4 row - same values the original mod used.

`_update_status` spins each `party_slot`'s "connecting..." icon while its player is still loading in - unlike every other per-slot loop in that vanilla function, it hardcodes `"for i = 1, 4"` instead of `self._max_number_of_players`, so `party_slot_5`'s connecting icon would silently never spin. This hook duplicates just that one calculation for slot 5 rather than touching vanilla's own loop for 1-4.

## SkipEndOfLevelLoot.lua

`BackendInterfaceLootPlayfab.generate_end_of_level_loot` sends the full player roster (`remote_player_ids_and_characters`) to a remote Playfab CloudScript function (`"generateEndOfLevelLoot"`) this mod has no control over, and that backend logic isn't built for a 5th player. This hook skips the real request entirely and returns an empty, immediately-resolved loot entry instead.
