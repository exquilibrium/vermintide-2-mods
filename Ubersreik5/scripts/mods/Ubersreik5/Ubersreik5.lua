local mod = get_mod("Ubersreik5")

-- Party size for adventure mode. Read by settings overrides below and by
-- every hook that needs to generalize a vanilla 4-player loop bound to 5.
-- Must be set before the MechanismSettings/MatchmakingSettings/PlayerManager
-- overrides run, since those execute immediately at mod-load time, not inside
-- a hook.
MAX_PLAYERS = 5

-- Removed MorePlayers 2 check

-- Reset the mod's own scoreboard-tracking state whenever we (re)enter the
-- inn or an adventure mission.
mod:hook_safe(StateIngame, "on_enter", function (self)
	local game_mode_key = Managers.state.game_mode:game_mode_key()

	if PlayerScores ~= nil and (game_mode_key == "inn" or game_mode_key == "inn_deus" or game_mode_key == "adventure") then
		PlayerScores = {}
	end
end)

-- Party/lobby/matchmaking capacity. These run immediately at mod-load
-- time (not inside a hook), so MAX_PLAYERS must already be set above.
MechanismSettings.adventure.party_data.heroes.num_slots = MAX_PLAYERS
MatchmakingSettings.MAX_NUMBER_OF_PLAYERS = MAX_PLAYERS
PlayerManager.MAX_PLAYERS = MAX_PLAYERS

-- 4 -> MAX_PLAYERS spawn slots for the event light spirits (e.g. Halescourge).
mod:hook(EventLightSpawnerExtension, "init", function (func, self, extension_init_context, unit, extension_init_data)
	local world = extension_init_context.world

	self.world = world
	self.unit = unit
	self.is_server = Managers.player.is_server
	self.unit_spawner = Managers.state.unit_spawner
	self._units = {}
	self._spawn_pool = {}
	self._spawn_pool_timer = 0
	self._spawn_pool_spawn_index = 1
	self._spawn_pool_add_index = 1
	self._num_raycasts = 0
	self._speed = extension_init_data.speed or Unit.get_data(unit, "speed") or 1
	self._respawn_timer = extension_init_data.respawn_timer or Unit.get_data(unit, "respawn_timer") or 10
	self._first_spawn_delay = extension_init_data.first_spawn_delay or Unit.get_data(unit, "first_spawn_delay") or 0
	self._unit_to_spawn = extension_init_data.unit_to_spawn or Unit.get_data(unit, "unit_to_spawn")
	self._light_intensity = Unit.get_data(unit, "light_intensity") or 1
	self._active = false

	Unit.set_unit_visibility(self.unit, false)

	if self.is_server then
		for i = 1, MAX_PLAYERS do
			self._units[i] = {
				speed = self._speed,
				id = i,
				respawn_time = self._respawn_timer - self._first_spawn_delay,
			}
		end
	end
end)

-- 4 -> MAX_PLAYERS astar-check slots for the beastmen banner/standard aura.
mod:hook(BeastmenStandardExtension, "init", function (func, self, extension_init_context, unit, extension_init_data)
	local world = extension_init_context.world

	self.world = world
	self.unit = unit
	self.is_server = Managers.player.is_server

	local self_pos = Unit.local_position(unit, 0)

	self.self_position_boxed = Vector3Box(self_pos)

	local standard_template_name = extension_init_data.standard_template_name
	local standard_template = BeastmenStandardTemplates[standard_template_name]

	self.standard_template = standard_template
	self.standard_template_name = standard_template_name
	self.standard_template_buff_name = standard_template.buff_template_name
	self.standard_bearer_unit = extension_init_data.standard_bearer_unit
	self.side = Managers.state.side.side_by_unit[self.standard_bearer_unit]
	self.apply_buff_frequency = 0.5

	local t = Managers.time:time("game")

	self.next_apply_buff_t = t
	self.affected_units_effects = {}
	self.ai_units_broadphase_result = {}
	self.ai_units_inside = {}
	self.standard_data = {}
	self.standard_data.challenge_time = t + QuestSettings.standard_bearer_alive_seconds
	self.standard_data.is_server = self.is_server
	self.standard_data.standard_bearer_unit = self.standard_bearer_unit

	local side_manager = Managers.state.side
	local side = side_manager.side_by_unit[self.standard_bearer_unit] or side_manager:get_side_from_name("dark_pact")

	side_manager:add_unit_to_side(self.unit, side.side_id)

	if self.is_server then
		self.astar_check_frequency = standard_template.astar_check_frequency or 15
		self.nav_world = Managers.state.entity:system("ai_system"):nav_world()

		local astar_to_players_allowed_layers = {
			bot_poison_wind = 1,
			bot_ratling_gun_fire = 1,
			doors = 1,
			fire_grenade = 1,
			ledges = 1,
			ledges_with_fence = 1,
			planks = 1,
		}
		local player_astar_navtag_layer_cost_table = GwNavTagLayerCostTable.create()

		table.merge(astar_to_players_allowed_layers, NAV_TAG_VOLUME_LAYER_COST_AI)
		AiUtils.initialize_cost_table(player_astar_navtag_layer_cost_table, astar_to_players_allowed_layers)

		local player_astar_traverse_logic = GwNavTraverseLogic.create(self.nav_world, player_astar_navtag_layer_cost_table)

		self.player_astar_navtag_layer_cost_table = player_astar_navtag_layer_cost_table
		self.player_astar_traverse_logic = player_astar_traverse_logic
		self.player_astar_data = {}

		for i = 1, MAX_PLAYERS do
			self.player_astar_data[i] = {
				next_astar_check_t = t + self.astar_check_frequency,
			}
		end

		Managers.state.conflict:add_unit_to_standards(unit)

		self.next_vo_trigger_event_t = t + 15

		LevelHelper:flow_event(self.world, "standard_placed")
	end

	local sfx_placed = standard_template.sfx_placed

	if sfx_placed then
		WwiseUtils.trigger_unit_event(world, sfx_placed, unit, 0)
	end

	local sfx_loop = standard_template.sfx_loop

	if sfx_loop then
		WwiseUtils.trigger_unit_event(world, sfx_loop, unit, 0)
	end
end)

-- Other-party-member HUD frames: NUM_PARTY_MEMBERS in vanilla excludes
-- self (party size 4 -> 3 other frames), so use MAX_PLAYERS - 1, not
-- MAX_PLAYERS.
mod:hook(UnitFramesHandler, "_create_party_members_unit_frames", function (func, self)
	local unit_frames = self._unit_frames

	for i = 1, MAX_PLAYERS - 1 do
		unit_frames[#unit_frames + 1] = self:_create_unit_frame_by_type("team", i)
	end

	return true
end)

-- Duplicate hero/career selection: stub the low-level primitives every
-- higher-level UI/flow function ultimately queries, rather than patching
-- each of those higher-level functions individually. This allows fully
-- identical duplicate hero+career picks (no "exact combo still blocked"
-- restriction) - simpler and matches a proven, more general 32-player mod
-- ("MorePlayers2") rather than the original Ubersreik Five's approach.
mod:hook_origin(ProfileSynchronizer, "try_reserve_profile_for_peer", function (self, party_id, peer_id, profile_index, career_index)
	self:_clear_profile_index_reservation(peer_id)
	self._state:set_profile_index_reservation(party_id, profile_index, career_index, peer_id)

	return true
end)
mod:hook_origin(GameMechanismManager, "profile_available_for_peer", function ()
	return true
end)
mod:hook_origin(ProfileSynchronizer, "is_free_in_lobby", function ()
	return true
end)
mod:hook_origin(ProfileSynchronizer, "is_profile_in_use", function ()
	return false
end)

mod._bots_assigned_this_batch = {}

-- Vanilla's bot-hero-picker filters candidates by
-- profile_synchronizer:is_profile_in_use(profile_index), which we just
-- stubbed to always false above - so its priority sort would otherwise
-- deterministically pick the same hero for every bot. Replace it with a
-- random pick so bots don't all spawn as clones of each other.
mod:hook(GameModeAdventure, "_get_first_available_bot_profile", function (func, self)
	local available_profiles = self._available_profiles

	-- profile_available_for_peer/is_profile_in_use are stubbed to always
	-- report "free" (needed so humans can freely duplicate heroes), which
	-- also blinded this vanilla function to real usage, so it picked
	-- randomly with no preference at all. Check real usage directly
	-- instead, so bots still default to one of each hero and only
	-- duplicate when every hero is already taken.
	--
	-- Deliberately NOT Managers.party._player_statuses here: vanilla's own
	-- bot/profile removal (ProfileSynchronizer._unassign_profiles_of_peer)
	-- only clears the ProfileSynchronizer's own state - it never clears
	-- status.profile_index on the party status entry, and nothing else
	-- in party_manager.lua ever deletes a status entry either. So once a
	-- bot has ever held a hero, that entry keeps reporting it as "used"
	-- forever, even long after the bot is removed - which is exactly what
	-- was still causing duplicates after removing and re-adding bots
	-- (party state, unlike a single mission, survives map<->keep
	-- transitions). Managers.player:players() is properly pruned on
	-- disconnect/removal, and every player object (bot or human) has a
	-- live :profile_index(), so this can't accumulate stale entries.
	local used_profile_indices = {}

	for _, player in pairs(Managers.player:players()) do
		local profile_index = player:profile_index()

		if profile_index then
			used_profile_indices[profile_index] = true
		end
	end

	-- _handle_bots below calls _add_bot in a tight loop to fill several
	-- slots at once. Belt-and-suspenders against any within-batch timing
	-- gap between one bot's pick landing on its player object and the
	-- next bot's check seeing it: mod._bots_assigned_this_batch (reset
	-- per fill cycle in _handle_bots below) is this function's own
	-- immediate record of what it has already handed out this batch.
	for profile_index in pairs(mod._bots_assigned_this_batch) do
		used_profile_indices[profile_index] = true
	end

	local free_profile_indices = {}

	for i = 1, #available_profiles do
		local profile_index = FindProfileIndex(available_profiles[i])

		if not used_profile_indices[profile_index] then
			free_profile_indices[#free_profile_indices + 1] = profile_index
		end
	end

	local profile_index

	if #free_profile_indices > 0 then
		profile_index = free_profile_indices[math.random(#free_profile_indices)]
	else
		profile_index = FindProfileIndex(available_profiles[math.random(#available_profiles)])
	end

	mod._bots_assigned_this_batch[profile_index] = true

	local profile = SPProfiles[profile_index]
	local display_name = profile.display_name
	local hero_attributes = Managers.backend:get_interface("hero_attributes")
	local career_index = hero_attributes:get(display_name, "career") or 1
	local bot_career_index = hero_attributes:get(display_name, "bot_career") or career_index or 1

	return profile_index, bot_career_index
end)

-- Bot-fill count: vanilla always fills every open party slot with bots
-- (max_bots = party.num_slots). Replace that target with a user-configured
-- count (mod option "numberofbots", read into the fillwithbots global by
-- on_all_mods_loaded/on_setting_changed below) so players can run with
-- fewer than a full 5-player party of bots.
mod:hook(GameModeAdventure, "_handle_bots", function (func, self, t, dt)
	local in_session = Managers.state.network ~= nil and not Managers.state.network.game_session_shutdown

	if not in_session then
		return
	end

	if script_data.ai_bots_disabled then
		if #self._bot_players > 0 then
			local update_safe = true

			self:_clear_bots(update_safe)
		end

		return
	end

	local party = Managers.party:get_party(1)
	local num_slots = party.num_slots
	local max_bots = fillwithbots or num_slots
	local bot_players = self._bot_players
	local num_bot_players = #bot_players
	local delta = max_bots - num_bot_players

	if delta > 0 then
		local num_used_slots = party.num_used_slots
		local open_slots = num_slots - num_used_slots
		local num_bots_to_add = math.min(delta, open_slots)

		mod._bots_assigned_this_batch = {}

		for i = 1, num_bots_to_add do
			self:_add_bot()
		end
	elseif delta < 0 then
		local num_bots_to_remove = math.abs(delta)

		for i = 1, num_bots_to_remove do
			local update_safe = true

			self:_remove_bot(bot_players[#bot_players], update_safe)
		end
	end
end)

-- Boss-kill achievement tracking hard-crashes the instant a 5th local
-- player exists (scripts/unit_extensions/generic/death_reactions.lua:
-- "while player_manager:local_player(local_player_id) ~= nil do if
-- local_player_id > 4 then ferror(...)"). Silence exactly that assert
-- rather than patching the underlying loop bound (deep engine-adjacent
-- achievement code); the only cost is the 5th player's boss-kill
-- achievement progress not being tracked for that instance.
mod:hook(_G, "ferror", function (func, message, ...)
	if message == "Sanity check, how did we get above 4 here?" then
		return
	end

	return func(message, ...)
end)

-- Defensive: scripts/ui/ui_passes.lua's text-draw pass unconditionally
-- reads ui_style.font_type to look up cached font height metrics, even on
-- the code path meant for widgets whose style provides a raw `font` table
-- instead of a named `font_type` string - if font_type is nil, that read
-- indexes FontHeights with a nil key and crashes ("table index is nil").
-- Hit this while starting to host with the new matchmaking/scoreboard
-- widgets added this session; couldn't pin down the exact widget from
-- static review of ~1000 lines of style tables, so guard the general
-- case instead of guessing further - fall back to a real, common font
-- whenever font_type is missing.
mod:hook(_G, "UIGetFontHeight", function (func, gui, font_name, font_size)
	return func(gui, font_name or "hell_shark", font_size)
end)

-- AI clustering math used by the conflict director. cluster_positions:
-- fully dynamic (grows/shrinks its work queue, no fixed player-count
-- array), needs no changes for 5 players - copied here only to point at
-- vanilla's real implementation. These three caches are reused across
-- calls (mirrors vanilla's own module-level caches) rather than
-- reallocated every call.
local conflict_utils_clusters_sizes = {}
local conflict_utils_cluster_index_lookup = {}
local conflict_utils_work_queue = {}

mod:hook(ConflictUtils, "cluster_positions", function (func, positions, min_dist)
	if #positions == 0 then
		return {}, {}, {}
	end

	local clusters = {
		positions[1],
	}
	local clusters_sizes = conflict_utils_clusters_sizes
	local cluster_index_lookup = conflict_utils_cluster_index_lookup
	local work_queue = conflict_utils_work_queue

	for i = 1, #clusters_sizes do
		clusters_sizes[i] = nil
	end

	for i = 1, #cluster_index_lookup do
		cluster_index_lookup[i] = nil
	end

	for i = 1, #work_queue do
		work_queue[i] = nil
	end

	clusters_sizes[1] = 1
	cluster_index_lookup[1] = 1

	local min_dist_sq = min_dist * min_dist

	for i = 2, #positions do
		work_queue[#work_queue + 1] = i
	end

	while #work_queue > 0 do
		local clustered = false
		local work_size = #work_queue

		for cluster_idx = 1, #clusters do
			local i = 1

			while work_size >= i do
				local pos_idx = work_queue[i]
				local dist_sq = Vector3.distance_squared(clusters[cluster_idx], positions[pos_idx])

				if dist_sq < min_dist_sq then
					cluster_index_lookup[pos_idx] = cluster_idx
					clusters_sizes[cluster_idx] = clusters_sizes[cluster_idx] + 1
					work_queue[i] = work_queue[work_size]
					work_queue[work_size] = nil
					work_size = work_size - 1
					clustered = true
				else
					i = i + 1
				end
			end

			if clustered then
				break
			end
		end

		if not clustered and #work_queue > 0 then
			local new_cluster_idx = #clusters + 1
			local pos_idx = work_queue[1]

			clusters[new_cluster_idx] = positions[pos_idx]
			cluster_index_lookup[pos_idx] = new_cluster_idx
			clusters_sizes[new_cluster_idx] = 1
			work_queue[1] = work_queue[#work_queue]
			work_queue[#work_queue] = nil
		end
	end

	return clusters, clusters_sizes, cluster_index_lookup
end)

-- cluster_weight_and_loneliness feeds AI horde-director tuning only, not
-- correctness. Vanilla's real algorithm only handles up to 4 fixed
-- positions (a/b/c/d locals, a 4-entry max_cluster_score table) and
-- correctly generalizing it to 5 positions is error-prone (our own first
-- attempt at this had a confirmed under-counting bug). Stub it to a
-- constant instead, matching a proven, more general 32-player mod - this
-- only affects how "clustered vs spread out" the AI thinks the party is,
-- not any crash/correctness path.
mod:hook_origin(ConflictUtils, "cluster_weight_and_loneliness", function ()
	return 1, 1, 100
end)

-- AdventureSpawning: data.health_state/table.is_empty(data) get
-- dereferenced without a nil-guard on a slot's game_mode_data - a timing
-- race around player disconnect/leave that isn't specific to player count
-- but is cheap insurance to add.
mod:hook(AdventureSpawning, "_assign_data_to_slot", function (func, self, slot, data)
	if not data then
		return
	end

	return func(self, slot, data)
end)
mod:hook(AdventureSpawning, "_unassign_data_from_slot", function (func, self, slot, data)
	if not data then
		slot.game_mode_data = {}

		return
	end

	return func(self, slot, data)
end)

local original_table_is_empty = table.is_empty

table.is_empty = function (t)
	if t == nil then
		return true
	end

	return original_table_is_empty(t)
end

-- Deus/Chaos Wastes map board only has 4 authored token-placement poses
-- (referenced_token_poses is baked into level data, not something a mod
-- can resize) - a 5th player's board token would index a nil pose.
-- Simplest correct fix: just don't place a token for player slots beyond 4.
mod:hook(DeusMapScene, "_place_token", function (func, self, profile_index, slot, node_key)
	if slot > 4 then
		return
	end

	return func(self, profile_index, slot, node_key)
end)

-- Defensive: return safe defaults for health-related fields instead of
-- erroring when a game object hasn't finished syncing yet - a timing race
-- that becomes more likely with more simultaneous peers, not something
-- tied to a specific player count.
mod:hook(GameSession, "game_object_field", function (func, game, go_id, key)
	if not GameSession.game_object_exists(game, go_id) then
		if key == "current_health" or key == "temporary_health" or key == "current_temporary_health" or key == "max_health" then
			return 0
		end

		return nil
	end

	return func(game, go_id, key)
end)

-- Full end-of-level scoreboard (real 5th panel + scrollbar + extra stat
-- columns), matching the original Ubersreik Five mod's design.
mod:dofile("scripts/mods/Ubersreik5/CustomScoreboard")
mod:dofile("scripts/mods/Ubersreik5/CustomScoreboardScoresFunctions")

-- 5th-player readiness dot on the matchmaking overlay, matching the
-- original Ubersreik Five mod's design.
mod:dofile("scripts/mods/Ubersreik5/MatchmakingPartySlot5")

-- AI Director player-clustering (horde spawn positioning, pacing,
-- loneliest-player targeting) extended to see a 5th player, matching the
-- original Ubersreik Five mod's design.
mod:dofile("scripts/mods/Ubersreik5/ConflictDirectorClustering")

-- Skips the real end-of-level loot request: generate_end_of_level_loot
-- sends the full player roster to a remote Playfab CloudScript call we
-- don't control, and that backend logic isn't built for a 5th player.
mod:dofile("scripts/mods/Ubersreik5/SkipEndOfLevelLoot")

mod.on_all_mods_loaded = function ()
	fillwithbots = mod:get("numberofbots")

	if mod.scoreboard then
		mod.scoreboard.rows = mod:get("extend")
	end
end

mod.on_setting_changed = function ()
	fillwithbots = mod:get("numberofbots")

	if mod.scoreboard then
		mod.scoreboard.rows = mod:get("extend")
	end
end
