local mod = get_mod("Ubersreik5")

-- Extra per-player stat columns for the end-of-level scoreboard, on top of
-- vanilla's own. Keyed by PlayerScores[stats_id][stat_name]; reset by
-- Ubersreik5.lua. See README.md.

PlayerScores = {}

local function get_player_scores(stats_id)
	local scores = PlayerScores[stats_id]

	if not scores then
		scores = {}
		PlayerScores[stats_id] = scores
	end

	return scores
end

mod.returnstat = function (self, stats_id, stat_name)
	local scores = PlayerScores[stats_id]
	local value = scores and scores[stat_name] or 0

	return math.floor(value * 100 + 0.5) / 100
end

-- Healing: real sig (self, healer_unit, heal_amount, heal_source_name, heal_type).
mod:hook_safe(PlayerUnitHealthExtension, "add_heal", function (self, healer_unit, heal_amount, heal_source_name, heal_type)
	local healer_player = Managers.player:owner(healer_unit)

	if not healer_player then
		return
	end

	local scores = get_player_scores(healer_player:stats_id())
	local status_extension = self.status_extension

	if status_extension and status_extension:is_permanent_heal(heal_type) and not status_extension:is_knocked_down() then
		scores.greenhealed = (scores.greenhealed or 0) + heal_amount
	else
		scores.whitehealed = (scores.whitehealed or 0) + heal_amount
	end

	if heal_type == "healing_draught" or heal_type == "bandage" then
		scores.timeshealed = (scores.timeshealed or 0) + 1
	end
end)

-- Knockdowns received: real sig (victim_unit, damage_data, statistics_db, is_server), static.
mod:hook_safe(StatisticsUtil, "register_knockdown", function (victim_unit, damage_data, statistics_db, is_server)
	local victim_player = Managers.player:owner(victim_unit)

	if not victim_player then
		return
	end

	local scores = get_player_scores(victim_player:stats_id())

	scores.muertes = (scores.muertes or 0) + 1
end)

-- Elite/special/boss kill combo (rolling 4s window): real sig
-- (victim_unit, damage_data, statistics_db, is_server), static.
local POISON_DAMAGE_TYPES = {
	aoe_poison_dot = true,
	arrow_poison_dot = true,
	arrow_poison = true,
	poison = true,
}
local IGNORED_FRIENDLY_FIRE_DAMAGE_TYPES = {
	wounded_dot = true,
	knockdown_bleed = true,
	temporary_health_degen = true,
	kinetic = true,
	life_tap = true,
	overcharge = true,
}

mod:hook_safe(StatisticsUtil, "register_kill", function (victim_unit, damage_data, statistics_db, is_server)
	local victim_health_extension = ScriptUnit.has_extension(victim_unit, "health_system")
	local victim_damage_data = victim_health_extension and victim_health_extension.last_damage_data

	if not victim_damage_data then
		return
	end

	local attacker_unique_id = victim_damage_data.attacker_unique_id
	local attacker_player = attacker_unique_id and Managers.player:player_from_unique_id(attacker_unique_id)

	if not attacker_player then
		return
	end

	local breed_killed = Unit.get_data(victim_unit, "breed")

	if not breed_killed or not (breed_killed.elite or breed_killed.special or breed_killed.boss) then
		return
	end

	local stats_id = attacker_player:stats_id()
	local scores = get_player_scores(stats_id)
	local t = Managers.time:time("game")
	local combo_window = 4

	if not scores.combo_end_t or scores.combo_end_t < t then
		scores.actualcombo = 0
	end

	scores.actualcombo = (scores.actualcombo or 0) + 1
	scores.combo_end_t = t + combo_window
	scores.bestcombo = math.max(scores.bestcombo or 0, scores.actualcombo)
end)

-- Damage-based stats: real sig (victim_unit, damage_data, statistics_db), static.
mod:hook_safe(StatisticsUtil, "register_damage", function (victim_unit, damage_data, statistics_db)
	local damage_data_attacker_unit = damage_data[DamageDataIndex.ATTACKER]
	local damage_source_name = damage_data[DamageDataIndex.DAMAGE_SOURCE_NAME]
	local attacker_unit = damage_data_attacker_unit
	local attacker_player = AiUtils.get_actual_attacker_player(attacker_unit, victim_unit, damage_source_name)

	if not attacker_player then
		attacker_unit = damage_data[DamageDataIndex.SOURCE_ATTACKER_UNIT] or attacker_unit
		attacker_unit = AiUtils.get_actual_attacker_unit(attacker_unit)
		attacker_player = Managers.player:owner(attacker_unit)
	end

	if not attacker_player then
		return
	end

	local victim_player = Managers.player:owner(victim_unit)
	local raw_damage_amount = damage_data[DamageDataIndex.DAMAGE_AMOUNT]
	local damage_amount = raw_damage_amount
	local damage_type = damage_data[DamageDataIndex.DAMAGE_TYPE]
	local stats_id = attacker_player:stats_id()
	local scores = get_player_scores(stats_id)

	-- Clamp overkill the same way vanilla's own register_damage does for
	-- "damage_dealt", so a lethal hit doesn't inflate our totals. See README.md.
	local victim_health_extension = ScriptUnit.has_extension(victim_unit, "health_system")

	if victim_health_extension then
		damage_amount = math.clamp(raw_damage_amount, 0, victim_health_extension:current_health())
	end

	local overkill_amount = raw_damage_amount - damage_amount

	-- Self-damage.
	if victim_player == attacker_player then
		scores.self_dmg = (scores.self_dmg or 0) + damage_amount

		return
	end

	-- Friendly fire dealt/received (both players, excludes DoT-ish damage
	-- types that would otherwise spam this every tick).
	if victim_player and not IGNORED_FRIENDLY_FIRE_DAMAGE_TYPES[damage_type] then
		local side_manager = Managers.state.side
		local attacker_side = side_manager:get_side_from_player_unique_id(attacker_player:unique_id())
		local victim_side = side_manager.side_by_unit[victim_unit]

		if attacker_side and victim_side and not side_manager:is_enemy_by_side(attacker_side, victim_side) then
			scores.ff = (scores.ff or 0) + damage_amount

			local victim_scores = get_player_scores(victim_player:stats_id())

			victim_scores.receivedff = (victim_scores.receivedff or 0) + damage_amount
		end
	end

	-- Everything below is damage dealt TO an enemy (skip further friendly fire).
	if victim_player then
		return
	end

	local victim_breed = Unit.alive(victim_unit) and Unit.get_data(victim_unit, "breed")

	if not victim_breed then
		return
	end

	scores.overkill_damage = (scores.overkill_damage or 0) + overkill_amount

	-- 2s rolling burst-damage window.
	local t = Managers.time:time("game")
	local burst_window = 2

	if not scores.burst_end_t or scores.burst_end_t < t then
		scores.actualburst = 0
	end

	scores.actualburst = (scores.actualburst or 0) + damage_amount
	scores.burst_end_t = t + burst_window
	scores.bestburst = math.max(scores.bestburst or 0, scores.actualburst)

	if victim_breed.boss then
		scores.lord_dmg = (scores.lord_dmg or 0) + damage_amount
	elseif victim_breed.elite then
		scores.elite_dmg = (scores.elite_dmg or 0) + damage_amount
	elseif victim_breed.special then
		scores.special_dmg = (scores.special_dmg or 0) + damage_amount
	end

	if POISON_DAMAGE_TYPES[damage_type] then
		scores.poison = (scores.poison or 0) + damage_amount
	elseif damage_type == "burning" or damage_type == "fire_dot" then
		scores.burninating = (scores.burninating or 0) + damage_amount
	elseif damage_type == "bleeding" or damage_type == "bleed_dot" then
		scores.bleed = (scores.bleed or 0) + damage_amount
	elseif damage_type == "overcharge" then
		scores.overcharge = (scores.overcharge or 0) + damage_amount
	elseif damage_type == "push" or damage_type == "blunt_push" then
		scores.pushes = (scores.pushes or 0) + 1
	end

	local hit_zone = damage_data[DamageDataIndex.HIT_ZONE]

	if hit_zone == "head" then
		local attack_type = damage_data[DamageDataIndex.ATTACK_TYPE]
		local is_ranged = attack_type ~= "heavy_attack" and attack_type ~= "light_attack"

		if is_ranged then
			scores.hs_ranged = (scores.hs_ranged or 0) + 1
		end
	end
end)

-- Pings.
mod:hook_safe(PingSystem, "_handle_ping", function (self, ping_type, social_wheel_event_id, sender_player, pinger_unit, pinged_unit, position, flash)
	if not pinged_unit or not ScriptUnit.has_extension(pinged_unit, "buff_system") then
		return
	end

	local scores = get_player_scores(sender_player:stats_id())

	scores.pings = (scores.pings or 0) + 1
end)

-- Host-authoritative catch-up sync for a player who relaunches mid-mission
-- to reconnect (modeled on MorePlayers2's pattern). See README.md.
local function get_native_stat(statistics_db, stats_id, topic)
	if topic.stat_types then
		local total = 0

		for _, stat_type in ipairs(topic.stat_types) do
			total = total + (statistics_db:get_stat(stats_id, unpack(stat_type)) or 0)
		end

		return total
	else
		return statistics_db:get_stat(stats_id, topic.stat_type) or 0
	end
end

local function apply_native_stat_delta(statistics_db, stats_id, topic, delta)
	if not delta or delta == 0 then
		return
	end

	if topic.stat_types then
		local category, breed = unpack(topic.stat_types[1])

		statistics_db:modify_stat_by_amount(stats_id, category, breed, delta)
	else
		statistics_db:modify_stat_by_amount(stats_id, topic.stat_type, delta)
	end
end

-- unregister()/register() run on EVERY connected machine's own local
-- statistics_db, not just the leaving/joining player's - so a value can be
-- gone before we ever get to read it. Snapshot before the wipe instead.
-- See README.md.
local NativeStatsSnapshot = {}

-- A restart/win/fail with clients connected produces the exact same
-- unregister -> rejoin sequence as a genuine mid-mission reconnect (the
-- level_session_id changes and clients rejoin the reloaded level), so a
-- snapshot taken just before our own intentional reset would otherwise
-- survive it and get resurrected by on_user_joined below once the client
-- rejoins. Ubersreik5.lua's on_enter reset hook calls this to drop any
-- snapshot that predates the reset.
mod.clear_native_stats_snapshot = function (self)
	table.clear(NativeStatsSnapshot)
end

mod:hook(StatisticsDatabase, "unregister", function (func, self, stats_id, ...)
	local snapshot = {}

	for _, topic in ipairs(ScoreboardHelper.scoreboard_topic_stats) do
		snapshot[topic.name] = get_native_stat(self, stats_id, topic)
	end

	NativeStatsSnapshot[stats_id] = snapshot

	return func(self, stats_id, ...)
end)

-- One network_send call per STAT, not one per teammate covering all their
-- stats in a single table - VMF caps a network_send string parameter at
-- 500 characters (fails with "Failed to pack parameter 3, too many
-- characters"), and the combined native+custom payload for one teammate
-- can exceed that once a mission has run long enough to rack up values
-- across ~30 native+custom stats. See README.md.
local CATCHUP_PACKAGE_ID = "ubersreik5_catchup"

local NATIVE_TOPIC_BY_NAME = {}

for _, topic in ipairs(ScoreboardHelper.scoreboard_topic_stats) do
	NATIVE_TOPIC_BY_NAME[topic.name] = topic
end

local function apply_native_catchup(statistics_db, stats_id, native)
	for _, topic in ipairs(ScoreboardHelper.scoreboard_topic_stats) do
		local value = native[topic.name]

		if value then
			apply_native_stat_delta(statistics_db, stats_id, topic, value)
		end
	end
end

mod:network_register(CATCHUP_PACKAGE_ID, function (sender_peer_id, stats_id, kind, stat_name, value)
	if kind == "native" then
		local statistics_db = Managers.player:statistics_db()
		local topic = NATIVE_TOPIC_BY_NAME[stat_name]

		if statistics_db and topic then
			apply_native_stat_delta(statistics_db, stats_id, topic, value)

			-- Clear vanilla's cached scoreboard snapshot so it re-reads live.
			-- Same reasoning as Ubersreik5.lua's on_enter reset hook; see README.md.
			if Managers.mechanism then
				Managers.mechanism.synced_players_session_score = nil
			end
		end
	elseif kind == "custom" then
		-- Merged onto whatever's already there rather than replacing the
		-- whole table outright - by the time a catch-up like this can fire,
		-- the receiver's own copy for this stats_id is fresh/nil anyway (see
		-- README.md), so this is equivalent in practice and simpler to send
		-- one stat at a time.
		local scores = PlayerScores[stats_id]

		if not scores then
			scores = {}
			PlayerScores[stats_id] = scores
		end

		scores[stat_name] = value
	end
end)

mod.on_user_joined = function (player)
	if not Managers.player.is_server or not player or not player.peer_id then
		return
	end

	local statistics_db = Managers.player:statistics_db()

	if not statistics_db then
		return
	end

	for _, teammate in pairs(Managers.player:players()) do
		local stats_id = teammate:stats_id()

		if stats_id then
			-- Prefer the pre-disconnect snapshot over a live read, which may
			-- already be reset. See README.md.
			local native = NativeStatsSnapshot[stats_id]

			if native then
				-- The host's own copy needs this restoration too. See README.md.
				apply_native_catchup(statistics_db, stats_id, native)
				NativeStatsSnapshot[stats_id] = nil
			else
				native = {}

				for _, topic in ipairs(ScoreboardHelper.scoreboard_topic_stats) do
					native[topic.name] = get_native_stat(statistics_db, stats_id, topic)
				end
			end

			for stat_name, value in pairs(native) do
				if value ~= 0 then
					mod:network_send(CATCHUP_PACKAGE_ID, player.peer_id, stats_id, "native", stat_name, value)
				end
			end

			local custom = PlayerScores[stats_id]

			if custom then
				for stat_name, value in pairs(custom) do
					if value ~= 0 then
						mod:network_send(CATCHUP_PACKAGE_ID, player.peer_id, stats_id, "custom", stat_name, value)
					end
				end
			end
		end
	end
end

mod.create_test_entries = function (self)
	self:register_entry("overkill_damage", "Overkill damage", "lowest", self.returnstat)
	self:register_entry("bestcombo", "Elites & specials in 4 seconds", "highest", self.returnstat)
	self:register_entry("bestburst", "Burst dmg in 2 seconds", "highest", self.returnstat)
	self:register_entry("elite_dmg", "Damage to elites", "highest", self.returnstat)
	self:register_entry("special_dmg", "Damage to specials", "highest", self.returnstat)
	self:register_entry("lord_dmg", "Damage to lords", "highest", self.returnstat)
	self:register_entry("burninating", "Burning damage", "highest", self.returnstat)
	self:register_entry("bleed", "Bleed damage", "highest", self.returnstat)
	self:register_entry("poison", "Poison damage", "highest", self.returnstat)
	self:register_entry("ff", "Friendly fire dealt", "lowest", self.returnstat)
	self:register_entry("receivedff", "Friendly fire received", "highest", self.returnstat)
	self:register_entry("self_dmg", "Self-harm", "lowest", self.returnstat)
	self:register_entry("overcharge", "Overcharge damage", "highest", self.returnstat)
	self:register_entry("muertes", "Knockdowns", "lowest", self.returnstat)
	self:register_entry("whitehealed", "Temporary hitpoints gained", "highest", self.returnstat)
	self:register_entry("greenhealed", "Hitpoints gained", "highest", self.returnstat)
	self:register_entry("timeshealed", "Times healed", "lowest", self.returnstat)
	self:register_entry("hs_ranged", "Ranged headshots", "highest", self.returnstat)
	self:register_entry("pushes", "Total effective pushes", "highest", self.returnstat)
	self:register_entry("pings", "Pings", "highest", self.returnstat)
end

mod:create_test_entries()
