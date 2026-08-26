local mod = get_mod("Ubersreik5")

-- Extra per-player stat columns for the end-of-level scoreboard, on top of
-- vanilla's own (kills/damage/revives/etc, already read straight out of the
-- vanilla StatisticsDB by CustomScoreboard.lua). Everything here is
-- hook_safe (side-effect only, after vanilla's real logic runs) and keyed by
-- PlayerScores[stats_id][stat_name], reset each time we (re)enter the
-- inn/adventure (see the on_enter hook in Ubersreik5.lua).

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

	-- Clamp overkill the same way vanilla's own StatisticsUtil.register_damage
	-- does for "damage_dealt" (called before health is actually reduced, so
	-- current_health here is still the pre-hit value) - otherwise a lethal hit
	-- with damage far beyond the target's remaining health inflates our totals.
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

-- Host-authoritative catch-up sync, modeled on a proven pattern found in
-- MorePlayers2 (scripts/mods/MorePlayers2/src/ui/custom_scoreboard.lua) - a
-- more mature, higher-player-count mod solving the exact same problem: a
-- player who relaunches the game to reconnect gets a fresh, empty
-- statistics_db and PlayerScores, with no way to recover values for events
-- it wasn't present for. Two things make this more robust than what this
-- file tried before (a version that broadcast PlayerScores - and briefly,
-- vanilla's own huge players_session_scores structure - at scoreboard-open
-- time, and silently failed to deliver anything):
--
-- 1. This triggers on mod.on_user_joined, which fires the moment a player
--    (re)joins the party, mid-mission - not at scoreboard-open time. That
--    sidesteps vanilla's own native-stat sync (GameMechanismManager.
--    sync_players_session_score / rpc_sync_players_session_score) and its
--    one-shot-no-retry limitation entirely, since this fires because the
--    join itself just happened, and it means the fix is already in place
--    long before any scoreboard ever gets built for this mission - no need
--    to force a re-render afterward.
-- 2. For native stats, it writes straight into the receiving client's own
--    statistics_db via StatisticsDatabase:modify_stat_by_amount(stats_id,
--    stat_name, value) rather than fighting vanilla's players_session_scores/
--    _setup_player_scores pipeline - vanilla's own scoreboard already reads
--    from that same statistics_db, so nothing else needs to change. Compound
--    topics (kills_elites, kills_specials, damage_dealt_bosses - each a SUM
--    across several kills_per_breed/damage_dealt_per_breed sub-stats, not a
--    single stored value) get the whole delta dumped into just their first
--    sub-stat-type, same as MorePlayers2 does it - the scoreboard only ever
--    shows the summed total, never a per-breed breakdown, so which specific
--    sub-stat absorbs it doesn't matter.
--
-- modify_stat_by_amount ADDS the given amount to whatever's already stored,
-- it doesn't set an absolute value - this only stays correct because
-- on_user_joined fires essentially immediately after joining, before the
-- rejoining player has generated any stats of their own yet, so their local
-- value is still at its fresh baseline (same assumption MorePlayers2 makes).
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

-- StatisticsDatabase:unregister(stats_id) / :register(stats_id, ...)
-- (scripts/managers/player/player_manager.lua) run on EVERY connected
-- machine's own local statistics_db, not just the disconnecting/joining
-- player's own client - whenever ANY player leaves, everyone else's
-- (including the HOST's) local copy of their native stats gets unregistered,
-- and a fresh, zeroed entry gets created when they rejoin. This is the real
-- root cause behind every native-stat symptom seen so far: by the time a
-- disconnected player reconnects, even the HOST's own statistics_db entry
-- for them may already be gone - so reading statistics_db at on_user_joined
-- time (what this file did before) can itself already be reading the
-- wiped/reset value, regardless of any sync mechanism, and there is no way
-- to recover a value that's already gone from the only place being read.
--
-- The fix: snapshot a player's native stats into our OWN table, independent
-- of statistics_db, right BEFORE unregister() wipes them - this needs a full
-- mod:hook (not hook_safe) so the snapshot happens before the underlying
-- data is actually removed. That snapshot then becomes the source of truth
-- for the catch-up sync below, instead of a live (possibly already-reset)
-- statistics_db read.
local NativeStatsSnapshot = {}

mod:hook(StatisticsDatabase, "unregister", function (func, self, stats_id, ...)
	local snapshot = {}

	for _, topic in ipairs(ScoreboardHelper.scoreboard_topic_stats) do
		snapshot[topic.name] = get_native_stat(self, stats_id, topic)
	end

	NativeStatsSnapshot[stats_id] = snapshot

	return func(self, stats_id, ...)
end)

-- One network_send call per TEAMMATE, not one covering the whole party:
-- mod:network_send ultimately goes through ModManager.network_send ->
-- RPC.rpc_mod_user_data (scripts/managers/mod/mod_manager.lua) - a real
-- engine RPC, which typically has a strict size limit on its parameters.
-- MorePlayers2's own version of this (the pattern this is modeled on) sends
-- one small message per teammate in a loop, each carrying only 3 numbers -
-- not one message covering every player and stat at once. An earlier version
-- of this combined everything (every teammate, every stat) into a single
-- message and it silently delivered nothing, twice, even after trimming the
-- payload shape - matching an RPC size limit being exceeded rather than a
-- shape/type problem.
local CATCHUP_PACKAGE_ID = "ubersreik5_catchup"

local function apply_native_catchup(statistics_db, stats_id, native)
	for _, topic in ipairs(ScoreboardHelper.scoreboard_topic_stats) do
		local value = native[topic.name]

		if value then
			apply_native_stat_delta(statistics_db, stats_id, topic, value)
		end
	end
end

mod:network_register(CATCHUP_PACKAGE_ID, function (sender_peer_id, stats_id, data)
	local statistics_db = Managers.player:statistics_db()

	if statistics_db and data.native then
		apply_native_catchup(statistics_db, stats_id, data.native)

		-- GameMechanismManager.get_players_session_score
		-- (scripts/managers/game_mode/game_mechanism_manager.lua) caches
		-- vanilla's own native-stat sync the first time it arrives (`if
		-- self.synced_players_session_score then return
		-- self.synced_players_session_score end`) and never re-reads
		-- statistics_db live again for the rest of the mission once that's
		-- set. Clear it so a later scoreboard build re-reads statistics_db
		-- live (picking up what we just wrote) instead of an earlier,
		-- possibly stale, frozen snapshot. Vanilla's own sync (fires once,
		-- at mission end) will re-cache a fresh one later regardless, and by
		-- then the host's own copy should also be correct (see
		-- mod.on_user_joined below), so that later re-cache stays correct too.
		if Managers.mechanism then
			Managers.mechanism.synced_players_session_score = nil
		end
	end

	if data.custom then
		PlayerScores[stats_id] = data.custom
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
			-- Prefer the pre-disconnect snapshot over a live statistics_db
			-- read: if this teammate (which may be the rejoining player
			-- themselves, or anyone else who dis/reconnected earlier this
			-- mission) was ever unregistered, statistics_db may already be
			-- sitting at a freshly-reset baseline by now.
			local native = NativeStatsSnapshot[stats_id]

			if native then
				-- The host's own copy needs the same restoration as the
				-- joining client's - it went through the same unregister/
				-- register reset. Without this, vanilla's own native-stat
				-- sync (fires once, at mission end) would just re-propagate
				-- the host's still-wiped value to everyone later anyway.
				apply_native_catchup(statistics_db, stats_id, native)
				NativeStatsSnapshot[stats_id] = nil
			else
				native = {}

				for _, topic in ipairs(ScoreboardHelper.scoreboard_topic_stats) do
					native[topic.name] = get_native_stat(statistics_db, stats_id, topic)
				end
			end

			mod:network_send(CATCHUP_PACKAGE_ID, player.peer_id, stats_id, {
				native = native,
				custom = PlayerScores[stats_id],
			})
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
