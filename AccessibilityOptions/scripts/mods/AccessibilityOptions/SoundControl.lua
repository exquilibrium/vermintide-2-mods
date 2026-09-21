local mod = get_mod("AccessibilityOptions")

--[[

	Sound Cues (Accessibility)

	Ported from "Specials Sound Cues Fix", but instead of that mod's approach (a custom replacement
	Wwise bank + RTPC volume sliders), each cue here just reuses the vanilla sound event itself: when
	it fires, play the SAME event a second time from a position closer to the player. Wwise's normal
	distance attenuation then makes that second copy louder/clearer on its own, with no custom
	soundbank or RTPC needed.

]]

-- {{{1 Shared: tracked duplicate-sound instances.
----------------------------------------------------------------------------------------------------
-- Common machinery reused by every cue below: spawn one or more independent manual-source copies of
-- a vanilla sound event at a position, track them, reposition them every frame to follow both their
-- source unit and the player as they move, and stop + destroy each one the moment its source unit
-- dies or Wwise reports it has finished playing on its own.
--
-- Uses a MANUAL Wwise source (WwiseWorld.make_manual_source), not the auto-source
-- WwiseUtils.trigger_position_event creates - a manual source is the pattern the base game itself
-- uses whenever it needs to keep repositioning a sound and end it on its own terms (e.g.
-- scripts/entity_system/systems/projectile/projectile_system.lua:1043,1659,1932 for a flying
-- projectile's sound: make_manual_source -> per-frame set_source_position -> explicit
-- destroy_manual_source), as opposed to an auto-source's fire-and-forget lifecycle.
local tracked_instances = {} -- flat list of { unit, wwise_world, source, playing_id }

local function compute_midpoint(unit)
	local local_player = Managers.player:local_player()
	local player_unit = local_player and local_player.player_unit

	-- HEALTH_ALIVE[unit], not Unit.alive(unit) or ALIVE[unit], for the enemy: Unit.alive only checks
	-- whether the unit object still exists, which stays true for a corpse until it's eventually
	-- despawned. ALIVE looked like the right fix for that (and is what AccessibilityCaptions.lua
	-- still uses), but ALIVE is actually just a global alias for POSITION_LOOKUP (confirmed by
	-- reading scripts/utils/global_utils.lua: `ALIVE = POSITION_LOOKUP`) - a per-frame spatial index
	-- of units that currently have a position in the world, refreshed for corpses too and only
	-- cleared on actual despawn/destruction, i.e. it has the exact same "stays true past death" flaw
	-- as Unit.alive for this purpose. HEALTH_ALIVE is the real "is this character currently alive"
	-- table - confirmed via scripts/unit_extensions/generic/generic_health_extension.lua's
	-- GenericHealthExtension.set_dead, which sets `HEALTH_ALIVE[self.unit] = nil` in the same place
	-- it sets `self.dead = true`, independent of when the corpse itself despawns.
	if not player_unit or not Unit.alive(player_unit) or not unit or not HEALTH_ALIVE[unit] then
		return nil
	end

	return Vector3.lerp(Unit.world_position(player_unit, 0), Unit.world_position(unit, 0), 0.5)
end

local function get_level_wwise_world()
	local world = Managers.world:has_world("level_world") and Managers.world:world("level_world")

	return world and Managers.world:wwise_world(world)
end

-- Spawns instance_count independent copies of event_name at position, tracked against unit. Each
-- copy is its own Wwise source/game object (not the same one retriggered), which also sidesteps a
-- per-game-object "limit instances" setting some events are authored with, if a single extra copy
-- alone isn't audibly making a difference. Returns how many actually triggered (can be less than
-- instance_count if e.g. Sound Cues Debug's "Disable All Sounds" is suppressing new triggers), the
-- last entry created (nil if none, for callers that only want to keep watching one instance), and
-- the full list of entries created this call (for callers - like the Packmaster beacon below - that
-- want to treat everything spawned in one call as a single synchronized batch).
local function spawn_tracked_instances(wwise_world, event_name, position, unit, instance_count)
	local triggered_count = 0
	local last_entry
	local entries = {}

	for i = 1, instance_count do
		local source = WwiseWorld.make_manual_source(wwise_world, position)
		local playing_id = WwiseWorld.trigger_event(wwise_world, event_name, source)

		if playing_id then
			triggered_count = triggered_count + 1
			last_entry = {
				unit = unit,
				wwise_world = wwise_world,
				source = source,
				playing_id = playing_id,
			}
			entries[#entries + 1] = last_entry
			tracked_instances[#tracked_instances + 1] = last_entry
		else
			WwiseWorld.destroy_manual_source(wwise_world, source)
		end
	end

	return triggered_count, last_entry, entries
end

mod:add_update_function(function(dt)
	for i = #tracked_instances, 1, -1 do
		local entry = tracked_instances[i]
		local still_playing = WwiseWorld.is_playing(entry.wwise_world, entry.playing_id)

		-- HEALTH_ALIVE[entry.unit], not Unit.alive or ALIVE - see compute_midpoint's comment above.
		-- Without this, a dead enemy's corpse (still tracked by ALIVE/POSITION_LOOKUP until it
		-- despawns) would keep this instance playing/tracked until then instead of being stopped
		-- the moment it actually died.
		if not HEALTH_ALIVE[entry.unit] or not still_playing then
			if still_playing then
				WwiseWorld.stop_event(entry.wwise_world, entry.playing_id)
			end

			WwiseWorld.destroy_manual_source(entry.wwise_world, entry.source)
			table.remove(tracked_instances, i)
		else
			local midpoint = compute_midpoint(entry.unit)

			if midpoint then
				WwiseWorld.set_source_position(entry.wwise_world, entry.source, midpoint)
			end
		end
	end
end)

-- {{{1 Cue: Packmaster Foley beacon.
----------------------------------------------------------------------------------------------------
-- The vanilla enemy_packmaster_foley Wwise event never actually fires through
-- AudioSystem._play_event/play_audio_unit_event in practice - confirmed via the Log Boosted Sounds
-- debug echo never printing even standing right next to an active, moving Packmaster - despite
-- captions' own caption_data listing that exact event name as the trigger for its "Packmaster
-- clattering" caption. So hooking the sound trigger isn't a usable signal for this cue. Instead,
-- this drives its own beacon: the moment a Packmaster spawns (AISimpleExtension/AiHuskBaseExtension
-- init, breed "skaven_pack_master" - same breed name check as the original "Specials Sound Cues Fix"
-- mod used), start triggering the vanilla event ourselves for as long as it's alive.
--
-- The vanilla clip itself is short (a single clank, not a loop), so re-triggering on a fixed
-- interval left an audible silent gap between each one. Instead, this chains a fresh BATCH the
-- MOMENT the previous one finishes (checked via WwiseWorld.is_playing) rather than waiting out a
-- cooldown, so it reads as one continuous, ongoing sound - each link is still tracked via the shared
-- tracked_instances update loop above, so its position keeps following the Packmaster while it plays.
-- MIN_RETRIGGER_GAP is a small safety debounce, not the intended pacing: if is_playing takes a frame
-- to start reporting true right after a trigger, this stops that lag from being misread as "already
-- finished" and spamming an extra re-trigger before the last batch is actually done.
--
-- sound_cues_packmaster_foley_boost is a 0-5 slider (0 = off) for how many copies play at once per
-- Packmaster. All desired_count copies of a "generation" are triggered together in a single
-- spawn_tracked_instances call (like the Leech burst below), instead of each one independently
-- self-sustaining its own chain - an earlier per-slot version let each copy re-trigger the moment
-- IT personally finished, which let them drift out of sync with each other over time (since Wwise
-- doesn't guarantee two independently-triggered instances of the same clip end on the exact same
-- tick). Using entries[1] of the just-spawned batch as a single reference for "has this generation
-- ended yet" keeps every copy in the same generation starting and ending together.
local PACKMASTER_BOOST_EVENT = "enemy_packmaster_foley"
local PACKMASTER_MIN_RETRIGGER_GAP = 0.1
local packmaster_units = {} -- unit -> true, tracked while alive
local packmaster_boost_batch = {} -- unit -> array of entries from the current, still-playing generation
local packmaster_next_allowed_t = {} -- unit -> earliest time the next generation may start

mod:add_ai_extension_init_function(function(self, extension_init_context, unit, extension_init_data)
	local breed = self._breed

	if breed and breed.name == "skaven_pack_master" then
		packmaster_units[unit] = true
	end
end)

mod:add_update_function(function(dt)
	if not next(packmaster_units) then
		return
	end

	-- type(...) == "number" guard: this setting used to be a checkbox before it became a slider (see
	-- the "Both boost toggles converted..." step in this file's history) - anyone with an old saved
	-- boolean value here would otherwise crash math.clamp comparing a boolean to a number. A stale
	-- non-numeric value is treated as 0 (off), matching the old checkbox's unchecked default.
	local raw_packmaster_boost = mod:get("sound_cues_packmaster_foley_boost")
	local desired_count = math.clamp(type(raw_packmaster_boost) == "number" and raw_packmaster_boost or 0, 0, 5)
	local t = Managers.time:time("game")
	local wwise_world

	for unit in pairs(packmaster_units) do
		-- HEALTH_ALIVE[unit], not Unit.alive or ALIVE - see compute_midpoint's comment above. Stop
		-- chaining the instant the Packmaster actually dies, not whenever its corpse despawns.
		if not HEALTH_ALIVE[unit] then
			packmaster_units[unit] = nil
			packmaster_boost_batch[unit] = nil
			packmaster_next_allowed_t[unit] = nil
		elseif desired_count <= 0 then
			-- Whatever's already playing just finishes naturally via the shared tracked_instances
			-- loop above - simply stop tracking it as "our" generation so it isn't re-chained.
			packmaster_boost_batch[unit] = nil
			packmaster_next_allowed_t[unit] = nil
		else
			local batch = packmaster_boost_batch[unit]
			local reference = batch and batch[1]
			local still_playing = reference and WwiseWorld.is_playing(reference.wwise_world, reference.playing_id)
			local next_allowed_t = packmaster_next_allowed_t[unit]

			if not still_playing and (not next_allowed_t or t >= next_allowed_t) then
				local midpoint = compute_midpoint(unit)

				if midpoint then
					wwise_world = wwise_world or get_level_wwise_world()

					if wwise_world then
						local triggered_count, _, entries = spawn_tracked_instances(wwise_world, PACKMASTER_BOOST_EVENT, midpoint, unit, desired_count)

						packmaster_boost_batch[unit] = entries
						packmaster_next_allowed_t[unit] = t + PACKMASTER_MIN_RETRIGGER_GAP

						if triggered_count > 0 and mod:get("sound_cues_debug_log_boosts") then
							mod:echo(string.format("Sound Control: packmaster beacon re-chained %d/%d '%s'", triggered_count, desired_count, PACKMASTER_BOOST_EVENT))
						end
					end
				end
			end
		end
	end
end)

-- {{{1 Cue: Chaos Sorcerer ("Leech") Teleport boost.
----------------------------------------------------------------------------------------------------
-- Same reliability problem as Packmaster Foley above - the Log Boosted Sounds debug echo never
-- printed for a teleporting Leech either, despite captions' caption_data also listing
-- "enemy_chaos_sorcerer_magic_teleport" as a trigger for its "Blight / Leech teleporting" caption.
-- Hooks the actual teleport action directly instead: BTQuickTeleportAction.play_teleport_effect
-- fires exactly once per teleport (scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/
-- bt_quick_teleport_action.lua:90,154), giving a reliable, explicit trigger point plus the unit
-- itself to read a live position from (compute_midpoint re-reads Unit.world_position, which by this
-- point already reflects the post-teleport position, since teleport_to ran before this).
--
-- sound_cues_chaos_sorcerer_teleport_boost is a 0-5 slider (0 = off) for how many simultaneous extra
-- copies to play per teleport - unlike the Packmaster beacon this is a single one-shot burst, not an
-- ongoing chain, so the slider value maps directly onto spawn_tracked_instances' instance_count.
local LEECH_BOOST_EVENT = "enemy_chaos_sorcerer_magic_teleport"

mod:hook_safe(BTQuickTeleportAction, "play_teleport_effect", function(self, unit, blackboard, start_position, end_position)
	-- type(...) == "number" guard: same stale-saved-boolean risk as the Packmaster slider above (this
	-- setting was a checkbox before it became a slider) - treat a non-numeric saved value as 0 (off).
	local raw_teleport_boost = mod:get("sound_cues_chaos_sorcerer_teleport_boost")
	local instance_count = type(raw_teleport_boost) == "number" and raw_teleport_boost or 0

	if instance_count <= 0 then
		return
	end

	if not unit or not Unit.alive(unit) then
		return
	end

	local breed = Unit.get_data(unit, "breed")

	if not breed or breed.name ~= "chaos_corruptor_sorcerer" then
		return
	end

	local midpoint = compute_midpoint(unit)

	if not midpoint then
		return
	end

	local wwise_world = get_level_wwise_world()

	if not wwise_world then
		return
	end

	local triggered_count = spawn_tracked_instances(wwise_world, LEECH_BOOST_EVENT, midpoint, unit, instance_count)

	if mod:get("sound_cues_debug_log_boosts") then
		mod:echo(string.format("Sound Control: playing %d/%d extra '%s' (breed=%s)", triggered_count, instance_count, LEECH_BOOST_EVENT, breed.name))
	end
end)

-- {{{1 Concurrent sound limiter: cap simultaneous Infantry/Elite sounds.
----------------------------------------------------------------------------------------------------
-- Modded high-intensity difficulties can throw far more enemies on screen (and making noise) at once
-- than the vanilla game was tuned for, burying the specials/monster cues this mod exists to make
-- audible under a wall of trash/elite foley, weapon, and vocalization sounds. This caps how many
-- copies of EACH listed sound event are allowed to be concurrently playing at once (the category's
-- slider value applies to every event name in that category's list, counted separately per name),
-- and silently drops any additional trigger past that cap - rather than letting Wwise's own
-- (unconfigurable from Lua) per-event "limit instances" authoring decide which copies survive.
--
-- Classification is a hand-curated list of Wwise event NAMES per category, the same approach
-- AccessibilityCaptions_definitions.lua uses for its caption_data table - NOT breed-based. A
-- unit/breed-based version (hooking WwiseUtils.trigger_unit_event, keyed off Unit.get_data(unit,
-- "breed")) was tried first, but many enemy sounds turn out not to go through that helper at all in
-- practice (same kind of bypass already seen with AudioSystem._play_event back in Step 27 for
-- Packmaster/Leech) - so there's no unit to classify by breed for those calls in the first place.
-- Filled in by hand using the "Log Triggered Sounds" debug keybind below, which echoes every event
-- name actually seen at the one point every sound in the game funnels through regardless of source
-- (WwiseWorld.trigger_event, same choke point the mute-all-sounds hook further below uses).
local INFANTRY_SOUND_EVENT_NAMES = {
	-- Idle
	"Play_clan_rat_alerted",
	"enemy_breathing_vce",
	"Play_clan_rat_breathing_vce",

	"ecm_gameplay_passive_idle_sick",
	"ecm_gameplay_passive_idle_itchy",
	"Play_enemy_marauder_foley_light",
	"Play_enemy_marauder_foley_medium",
	"Play_enemy_marauder_foley_heavy",
	"Play_enemy_marauder_breath_vce",
	"enemy_marauder_breathing_fast",

	"play_beastmen_breath_in_short",
	"play_beastmen_breath_out_short",
	"play_beastmen_breath_out_normal",
	"play_beastmen_short_puff_hard",
	"play_enemy_beastmen_puff_hard",
	"Play_enemy_gor_breath_heavy_short",
	"play_enemy_gor_short_bark_vce",
	"play_enemy_gor_snort_short_vce",
	"play_enemy_gor_growl_medium_vce",
	"Play_enemy_gor_foley_armour_left_legplate",
	"play_foley_armour_ungor",

	-- Movement
	"enemy_run",
	"enemy_foley_cloth_run",

	"enemy_marauder_footstep_walk",
	"enemy_marauder_footstep_slide",
	"enemy_marauder_footstep_run",
	"Play_foley_metal_shield_run_marauder",

	"Play_beastmen_small_walk_scuffs",
	"Play_beastmen_medium_walk_scuffs",
	"play_enemy_gor_walk",
	"play_enemy_gor_slide",
	"play_enemy_gor_run",
	"Play_enemy_gor_foley_run",
	"play_enemy_ungor_run",

	-- Attack
	"Play_enemy_swing_mace",
	"Play_slave_rat_attack_player_vce",
	"Play_clan_rat_attack_player_vce",
	"Play_clan_rat_charge_attack_vce",

	"Play_enemy_marauder_attack_player_vce",

	"play_enemy_gor_combat_idle_roar_1_vce",
	"play_enemy_gor_combat_idle_roar_2_vce",
	"play_enemy_gor_pre_attack_short_growl_vce",
	"play_enemy_gor_attack_short_vce",
	"play_enemy_gor_attack_vce",
	"play_enemy_gor_war_cry_long_vce",
	"play_enemy_gor_combat_charge_long_vce",
	"play_enemy_gor_aggressive_long_call_vce",
	"stop_enemy_gor_long_vce",
	"Play_enemy_ungor_attack_vce",

	-- Hurt
	"Play_clan_rat_hurt_vce",

	"enemy_marauder_land_body",
	"Play_enemy_marauder_hurt_vce",

	"Play_enemy_gor_hurt_short_vce",
	"Play_enemy_ungor_hurt_vce",

	-- Die
	"Play_slave_rat_die_vce",
	"Play_clan_rat_die_vce",

	"Play_enemy_marauder_death_vce",

	"play_enemy_gor_die_vce",
	"Play_enemy_ungor_die_vce",

	-- Enemy weapons
	"Play_enemy_combat_swing_dagger",
	"Play_enemy_weapon_flail_1h_swing",
	"Play_enemy_swing_spear",
	"Play_enemy_swing_torch",
	"Play_enemy_combat_sword_1h_swing",
	"Play_enemy_combat_sword_1h_heavy_swing",
	"Play_enemy_combat_axe_1h_swing",

	"Play_foley_metal_shield_bash",
	"Play_foley_metal_shield_down",
	"Play_enemy_metal_weapon_med_drop",

	"play_enemy_gor_pawing_short",
	"play_enemy_ungor_walk",

	-- Backstabs
	--"Play_hud_enemy_attack_back_hit",
	--"Play_clan_rat_attack_player_back_vce",
	--"Play_enemy_marauder_attack_player_back_vce",
	--"Play_enemy_ungor_attack_player_back_vce",
	--"play_enemy_gor_attack_player_back_vce",

	-- Unsorted
	"Play_enemy_ragdoll_limb_hit_ground",
	"Play_enemy_combat_block_stun",
}

local ELITE_SOUND_EVENT_NAMES = {
}

local function build_event_set(event_names)
	local set = {}

	for _, event_name in ipairs(event_names) do
		set[event_name] = true
	end

	return set
end

local infantry_sound_events = build_event_set(INFANTRY_SOUND_EVENT_NAMES)
local elite_sound_events = build_event_set(ELITE_SOUND_EVENT_NAMES)

-- category -> event name -> list of { wwise_world, playing_id } currently playing, pruned every frame
-- - same shape and cleanup approach as tracked_instances above, just counting instead of
-- repositioning. The cap is applied PER EVENT NAME: each name in a category's list gets its own
-- independent allowance (the category's slider value), so one noisy event (e.g. footsteps) can't
-- use up the slots that a rarer event in the same list needs.
local limiter_active = {
	infantry = {},
	elite = {},
}

mod:add_update_function(function(dt)
	for _, active_by_event in pairs(limiter_active) do
		for event_name, active in pairs(active_by_event) do
			for i = #active, 1, -1 do
				local entry = active[i]

				if not WwiseWorld.is_playing(entry.wwise_world, entry.playing_id) then
					table.remove(active, i)
				end
			end

			if #active == 0 then
				active_by_event[event_name] = nil
			end
		end
	end
end)

-- Toggled by the "Log Triggered Sounds" debug keybind below, not persisted as a setting - resets to
-- off each session, same as the other debug tools' transient state (current_sound_index, etc).
local logging_triggered_sound_events = false

-- event name -> how many times it was triggered since logging was last started. Reset on every
-- start, dumped to the console log (not chat) on stop.
local triggered_sound_event_counts = {}

local function dump_triggered_sound_event_counts()
	local names = {}
	local total = 0

	for event_name, count in pairs(triggered_sound_event_counts) do
		names[#names + 1] = event_name
		total = total + count
	end

	-- Most frequent first, ties broken alphabetically, so the noisiest events (the ones most worth
	-- capping) are at the top and the output is stable between runs.
	table.sort(names, function (a, b)
		local count_a, count_b = triggered_sound_event_counts[a], triggered_sound_event_counts[b]

		if count_a ~= count_b then
			return count_a > count_b
		end

		return a < b
	end)

	mod:info("Sound Control Debug: triggered sound event counts (%d distinct, %d total):", #names, total)

	for i = 1, #names do
		mod:info("%s = %d", names[i], triggered_sound_event_counts[names[i]])
	end

	return #names, total
end

mod.sound_control_debug_toggle_log_events = function ()
	logging_triggered_sound_events = not logging_triggered_sound_events

	if logging_triggered_sound_events then
		triggered_sound_event_counts = {}

		mod:echo("Sound Control Debug: logging triggered sound event names ON - counting occurrences, press again to write the totals to the console log.")
	else
		local distinct, total = dump_triggered_sound_event_counts()

		mod:echo(string.format("Sound Control Debug: logging OFF - wrote %d distinct sound events (%d triggers total) to the console log.", distinct, total))
	end
end

-- {{{1 Debug: browse & play every known Wwise sound event.
----------------------------------------------------------------------------------------------------
-- NetworkLookup.sound_events (scripts/network_lookup/network_lookup.lua) is the base game's own
-- flat list of every Wwise SFX event name registered for network sync. Reused here purely as a
-- ready-made catalogue of event names to cycle through and audition - not for any networking
-- purpose. Two reasons a given name can still produce no audible sound when played, neither fixable
-- generically: (1) it only lists names, not banks - an event whose SoundBank isn't currently loaded
-- (e.g. an enemy-specific cue with no such enemy having appeared this level) does nothing when
-- triggered; (2) many combat/enemy SFX are authored as attenuated 3D sounds - triggering them with
-- a registered emitter near the player (below) makes those audible, but one attenuated far past its
-- max distance from wherever it actually is (out of our control - it's an unpositioned name lookup)
-- could still be inaudible.
local sound_event_names = NetworkLookup.sound_events
local current_sound_index = 1

local function get_level_world()
	return Managers.world:has_world("level_world") and Managers.world:world("level_world")
end

local function echo_current_sound(prefix)
	mod:echo(string.format("%s[%d/%d] %s", prefix, current_sound_index, #sound_event_names, sound_event_names[current_sound_index]))
end

mod.sound_cues_debug_previous = function ()
	current_sound_index = current_sound_index - 1

	if current_sound_index < 1 then
		current_sound_index = #sound_event_names
	end

	echo_current_sound("Sound Control Debug ")
end

mod.sound_cues_debug_next = function ()
	current_sound_index = current_sound_index + 1

	if current_sound_index > #sound_event_names then
		current_sound_index = 1
	end

	echo_current_sound("Sound Control Debug ")
end

-- Set to true only for the duration of our own trigger_event call below, so the mute hook (right
-- after) can tell "the test sound itself" apart from "everything else" and let only this one through.
local playing_test_sound = false

mod.sound_cues_debug_play = function ()
	local world = get_level_world()

	if not world then
		mod:echo("Sound Control Debug: not in a level, can't play sounds.")
		return
	end

	local event_name = sound_event_names[current_sound_index]
	local local_player = Managers.player:local_player()
	local player_unit = local_player and local_player.player_unit

	playing_test_sound = true

	local ok = pcall(function()
		if player_unit and Unit.alive(player_unit) then
			-- Trigger with a source positioned at the player rather than a bare 2-arg
			-- trigger_event: the base game always creates an explicit Wwise "source" (game
			-- object) via WwiseUtils.make_*_auto_source before triggering any positional/3D sound
			-- (see AudioSystem._play_position_event in
			-- scripts/entity_system/systems/audio/audio_system.lua and
			-- scripts/helpers/wwise_utils.lua) - without one, an attenuated 3D event may play
			-- inaudibly or not at all, regardless of whether its bank is loaded. A bare
			-- trigger_event only reliably works for genuinely 2D/non-positional events.
			WwiseUtils.trigger_position_event(world, event_name, Unit.world_position(player_unit, 0))
		else
			WwiseWorld.trigger_event(Managers.world:wwise_world(world), event_name)
		end
	end)

	playing_test_sound = false

	if not ok then
		mod:echo("Sound Control Debug: failed to trigger " .. tostring(event_name))
		return
	end

	echo_current_sound("Sound Control Debug playing ")
end

-- Stops everything currently playing (as opposed to the mute toggle below, which only prevents NEW
-- sounds from starting going forward). wwise_world:stop_all() is the same call MusicManager.
-- stop_all_sounds itself uses internally (scripts/managers/music/music_manager.lua:115-117:
-- `self._wwise_world:stop_all()`) - music runs on its own separate wwise_world from gameplay, so
-- both need stopping separately to actually silence everything.
mod.sound_cues_debug_stop_all = function ()
	local world = get_level_world()

	if world then
		Managers.world:wwise_world(world):stop_all()
	end

	if Managers.music then
		Managers.music:stop_all_sounds()
	end

	mod:echo("Sound Control Debug: stopped all sounds.")
end

-- {{{1 Debug: mute every other sound while testing, log triggered names, and cap Infantry/Elite sounds.
----------------------------------------------------------------------------------------------------
-- No generic per-event or bus-volume mute API exists in this engine (confirmed by reading the
-- options menu's own volume sliders - they're all RTPC global parameters, and there's no
-- WwiseWorld.set_bus_volume exposed to Lua at all). The only real lever is to intercept the actual
-- trigger call. WwiseWorld.trigger_event is the one point every sound in the game funnels through
-- regardless of source - AudioSystem, MusicManager (its own separate wwise_world), WwiseFlowCallbacks
-- foley, and DialogueSystem VO all end up calling this same global function - so hooking it once here
-- mutes everything, without needing separate hooks per system. The same reasoning is why the
-- Infantry/Elite concurrent-sound limiter above and the "Log Triggered Sounds" debug tool are both
-- implemented right here too, instead of as separate hooks - every event name eventually passes
-- through this exact point regardless of which higher-level helper (or bypass of one) triggered it.
mod:hook(WwiseWorld, "trigger_event", function (func, wwise_world, event_name, ...)
	-- Limiter decision comes first, so a trigger the limiter drops is skipped entirely - it is not
	-- logged/counted by "Log Triggered Sounds" either (only sounds that actually get to play are).
	local category, active_by_event, active

	if mod:get("sound_control_limiter_enabled") then
		category = infantry_sound_events[event_name] and "infantry" or elite_sound_events[event_name] and "elite"

		if category then
			active_by_event = limiter_active[category]
			active = active_by_event[event_name]

			local max_count = mod:get(category == "elite" and "sound_control_limiter_elite_max" or "sound_control_limiter_infantry_max") or 0

			if (active and #active or 0) >= max_count then
				return
			end
		end
	end

	if logging_triggered_sound_events then
		local event_key = tostring(event_name)

		triggered_sound_event_counts[event_key] = (triggered_sound_event_counts[event_key] or 0) + 1

		mod:echo("Sound Control Debug: " .. event_key)
	end

	if mod:get("sound_cues_debug_disable_all_sounds") and not playing_test_sound then
		return
	end

	if category then
		local playing_id = func(wwise_world, event_name, ...)

		if playing_id then
			if not active then
				active = {}
				active_by_event[event_name] = active
			end

			active[#active + 1] = { wwise_world = wwise_world, playing_id = playing_id }
		end

		return playing_id
	end

	return func(wwise_world, event_name, ...)
end)
