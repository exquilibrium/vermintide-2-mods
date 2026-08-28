local mod = get_mod("Ubersreik5")

-- Party size for adventure mode. Must be set before the settings overrides
-- below run (mod-load time, not inside a hook). See README.md.
MAX_PLAYERS = 5

-- Removed MorePlayers 2 check

-- Reset the mod's own scoreboard-tracking state on (re)entering the inn or
-- an adventure mission. See README.md.
mod:hook_safe(StateIngame, "on_enter", function (self)
	local game_mode_key = Managers.state.game_mode:game_mode_key()

	if PlayerScores ~= nil and (game_mode_key == "inn" or game_mode_key == "inn_deus" or game_mode_key == "adventure") then
		PlayerScores = {}
	end
end)

-- Every restart path (vote/esc-menu/checkpoint retry, auto-reload on a party
-- wipe) funnels through reload_level, unlike on_enter above. Also resets
-- vanilla's own native stats and the stale cached-scoreboard field a
-- reconnect catch-up clears for the same reason. See README.md.
mod:hook_safe(LevelTransitionHandler, "reload_level", function (self, ...)
	if PlayerScores ~= nil then
		PlayerScores = {}
	end

	local statistics_db = Managers.venture and Managers.venture.statistics

	if statistics_db then
		statistics_db:reset_session_stats()
	end

	if Managers.mechanism then
		Managers.mechanism.synced_players_session_score = nil
	end
end)

-- Party/lobby/matchmaking capacity. Runs at mod-load time, so MAX_PLAYERS
-- must already be set above.
MechanismSettings.adventure.party_data.heroes.num_slots = MAX_PLAYERS
MatchmakingSettings.MAX_NUMBER_OF_PLAYERS = MAX_PLAYERS
PlayerManager.MAX_PLAYERS = MAX_PLAYERS

-- 4 -> MAX_PLAYERS spawn slots for event light spirits (e.g. Halescourge).
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
-- (Same idea as the light-spirit hook above.)
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

-- Other-party-member HUD frames: vanilla's NUM_PARTY_MEMBERS excludes self,
-- so MAX_PLAYERS - 1, not MAX_PLAYERS.
mod:hook(UnitFramesHandler, "_create_party_members_unit_frames", function (func, self)
	local unit_frames = self._unit_frames

	for i = 1, MAX_PLAYERS - 1 do
		unit_frames[#unit_frames + 1] = self:_create_unit_frame_by_type("team", i)
	end

	return true
end)

-- Duplicate hero/career selection: stub the low-level primitives every
-- higher-level UI/flow function queries, rather than patching each one.
-- See README.md.
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

-- Stubbing is_profile_in_use above also blinds vanilla's bot-hero-picker to
-- real usage, so it'd pick the same hero for every bot. Check real usage
-- directly instead and pick randomly among what's free. See README.md.
mod:hook(GameModeAdventure, "_get_first_available_bot_profile", function (func, self)
	local available_profiles = self._available_profiles
	local used_profile_indices = {}

	for _, player in pairs(Managers.player:players()) do
		local profile_index = player:profile_index()

		if profile_index then
			used_profile_indices[profile_index] = true
		end
	end

	-- Belt-and-suspenders against a within-batch timing gap; see README.md.
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

-- Bot-fill count: replaces vanilla's "always fill every slot" with the
-- user-configured "numberofbots" setting (read into fillwithbots below).
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
-- player exists; silence exactly that assert. See README.md.
mod:hook(_G, "ferror", function (func, message, ...)
	if message == "Sanity check, how did we get above 4 here?" then
		return
	end

	return func(message, ...)
end)

-- Defensive: vanilla's text-draw pass crashes indexing FontHeights with a
-- nil font_type on some widget style shapes. See README.md.
mod:hook(_G, "UIGetFontHeight", function (func, gui, font_name, font_size)
	return func(gui, font_name or "hell_shark", font_size)
end)

-- AI clustering math used by the conflict director. cluster_positions needs
-- no changes for 5 players - copied only to point at vanilla's real
-- implementation. See README.md and ConflictDirectorClustering.lua.
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

-- Stubbed to a constant rather than generalized to 5 (error-prone; only
-- affects AI horde-pacing tuning, not correctness). See README.md.
mod:hook_origin(ConflictUtils, "cluster_weight_and_loneliness", function ()
	return 1, 1, 100
end)

-- Nil-guard a slot's game_mode_data against a player disconnect/leave
-- timing race (not player-count-specific, just cheap insurance).
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

-- Deus/Chaos Wastes board only has 4 authored token poses (baked into
-- level data); don't place a token for slot 5. See README.md.
mod:hook(DeusMapScene, "_place_token", function (func, self, profile_index, slot, node_key)
	if slot > 4 then
		return
	end

	return func(self, profile_index, slot, node_key)
end)

-- Defensive: safe defaults for health fields instead of erroring on an
-- unsynced game object (more likely with more simultaneous peers).
mod:hook(GameSession, "game_object_field", function (func, game, go_id, key)
	if not GameSession.game_object_exists(game, go_id) then
		if key == "current_health" or key == "temporary_health" or key == "current_temporary_health" or key == "max_health" then
			return 0
		end

		return nil
	end

	return func(game, go_id, key)
end)

-- See README.md for what each of these does and why.
mod:dofile("scripts/mods/Ubersreik5/CustomScoreboard")
mod:dofile("scripts/mods/Ubersreik5/CustomScoreboardScoresFunctions")
mod:dofile("scripts/mods/Ubersreik5/MatchmakingPartySlot5")
mod:dofile("scripts/mods/Ubersreik5/ConflictDirectorClustering")
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
