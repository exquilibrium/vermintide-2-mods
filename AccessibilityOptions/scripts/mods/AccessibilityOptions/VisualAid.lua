local mod = get_mod("AccessibilityOptions")

--[[

	Visual Aid - Sixth Sense

	Sense Specials: every live special is outlined until it dies. The outline fades linearly with the
	distance to the local player, exactly like the Sense Overheads fade: full color at NEAR_DISTANCE or
	closer, FADE_END_BRIGHTNESS of it (35% black) at FAR_DISTANCE or further. Modelled on the WHC ISJYA
	special mark in Tourney Balance (13_wh_captain.lua: a dedicated outline added per special, removed
	on death) but purely visual - it does not ping the unit, so it triggers no ping procs or buffs.

	The base RGB comes from the "Sensed Special" color group in OutlineOptions.lua (presets / custom /
	Rainbow), read every frame from that group's color table. The fade is not a setting: it is
	computed here per unit and applied by scaling the RGB, so each outline gets its own color table (a
	table shared with a color group would make OutlineOptions overwrite it whenever that group
	updates).

	Why RGB scaling and not the color's alpha: OutlineSystem builds the outline color as
	Color(255, r, g, b) (outline_system.lua, the non-pulsing path), so the alpha entry of an outline
	color table is never used - only RGB can change what is drawn.

	Sense Overheads (second half of this file): a Stormvermin / Chaos Warrior / Raider / Bestigor that starts
	its overhead attack is outlined for 2 seconds, fading linearly. Both features use outline
	priority 7, below a player tag (ping, priority 8), so a tag takes over the color while it lasts.

]]

local FAR_DISTANCE = 20
local NEAR_DISTANCE = 5
-- Shared by both features: the fade only goes 35% of the way to black, i.e. it bottoms out at 65% of
-- the color's brightness (Sense Specials at FAR_DISTANCE, Sense Overheads at the end of its 2 seconds).
local FADE_END_BRIGHTNESS = 0.2
-- OutlineExtension shows the highest-priority outline, and templates.ping_unit (a player tag) is 8:
-- staying below it means a tagged special shows the tag's color instead of this one.
local SENSE_OUTLINE_PRIORITY = 7

local color_source = OutlineSettings.colors.accessibility_sensed_special

local sense_enabled = mod:get("sense_specials") and true or false
-- unit -> false while not yet seen alive (an AI extension's init can run before the health
-- extension exists), true once HEALTH_ALIVE has confirmed it; every live special is tracked, even
-- while the toggle is off.
local special_units = {}
local sensed_units = {} -- unit -> { outline_id, r, g, b } (the last applied, already scaled, RGB)

-- Alpha is fixed at 255 because OutlineSystem ignores it (see the header comment).
local function make_outline_color(r, g, b)
	return {
		pulsate = false,
		pulse_multiplier = 50,
		color = { 255, r, g, b },
	}
end

-- Brightness strength from the distance to the player: FADE_END_BRIGHTNESS at FAR_DISTANCE or
-- further, linearly up to 1 at NEAR_DISTANCE or closer (also the far value when there is no player
-- unit to measure from).
local function distance_strength(distance)
	if not distance or distance >= FAR_DISTANCE then
		return FADE_END_BRIGHTNESS
	end

	if distance <= NEAR_DISTANCE then
		return 1
	end

	local fraction = (FAR_DISTANCE - distance) / (FAR_DISTANCE - NEAR_DISTANCE)

	return FADE_END_BRIGHTNESS + fraction * (1 - FADE_END_BRIGHTNESS)
end

local function scale_channel(value, strength)
	return math.floor(value * strength + 0.5)
end

local function get_local_player_position()
	local local_player = Managers.player and Managers.player:local_player()
	local player_unit = local_player and local_player.player_unit

	if player_unit and Unit.alive(player_unit) then
		return Unit.world_position(player_unit, 0)
	end

	return nil
end

local function unsense_unit(unit, data)
	if Unit.alive(unit) then
		local outline_extension = ScriptUnit.has_extension(unit, "outline_system")

		if outline_extension then
			outline_extension:remove_outline(data.outline_id)
		end
	end

	sensed_units[unit] = nil
end

local function clear_sensed_units()
	for unit, data in pairs(sensed_units) do
		unsense_unit(unit, data)
	end
end

local function sense_unit(unit, r, g, b)
	local outline_extension = ScriptUnit.has_extension(unit, "outline_system")

	if not outline_extension then
		return
	end

	local outline_id = outline_extension:add_outline({
		method = "ai_alive",
		priority = SENSE_OUTLINE_PRIORITY,
		outline_color = make_outline_color(r, g, b),
		flag = OutlineSettings.flags.non_wall_occluded,
	})

	sensed_units[unit] = {
		outline_id = outline_id,
		r = r,
		g = g,
		b = b,
	}
end

-- {{{1 Tracking specials.
----------------------------------------------------------------------------------------------------
mod:add_ai_extension_init_function(function (self, extension_init_context, unit, extension_init_data)
	local breed = self._breed

	if breed and breed.special then
		special_units[unit] = false
	end
end)

-- {{{1 Per-frame update.
----------------------------------------------------------------------------------------------------
mod:add_update_function(function (dt)
	if not next(special_units) then
		return
	end

	for unit, confirmed_alive in pairs(special_units) do
		if HEALTH_ALIVE[unit] then
			special_units[unit] = true
		elseif confirmed_alive or not Unit.alive(unit) then
			special_units[unit] = nil

			local data = sensed_units[unit]

			if data then
				unsense_unit(unit, data)
			end
		end
	end

	if not sense_enabled then
		return
	end

	local player_position = get_local_player_position()
	local source_color = color_source.color

	for unit, confirmed_alive in pairs(special_units) do
		if confirmed_alive then
			local distance = player_position and Vector3.distance(player_position, Unit.world_position(unit, 0))
			local strength = distance_strength(distance)
			local r = scale_channel(source_color[2], strength)
			local g = scale_channel(source_color[3], strength)
			local b = scale_channel(source_color[4], strength)
			local data = sensed_units[unit]

			if not data then
				sense_unit(unit, r, g, b)
			elseif data.r ~= r or data.g ~= g or data.b ~= b then
				local outline_extension = ScriptUnit.has_extension(unit, "outline_system")

				if outline_extension then
					-- A fresh table every time: OutlineExtension only recolors when the table
					-- identity changes (see _refresh_current_outline).
					outline_extension:update_outline({
						outline_color = make_outline_color(r, g, b),
					}, data.outline_id)
				end

				data.r, data.g, data.b = r, g, b
			end
		end
	end
end)

mod:add_setting_changed_function(function ()
	sense_enabled = mod:get("sense_specials") and true or false

	if not sense_enabled then
		clear_sensed_units()
	end
end)

-- Units from the previous level are gone; drop every reference to them.
mod:add_game_state_changed_function(function (status, state_name)
	if status == "enter" and state_name == "StateIngame" then
		table.clear(special_units)
		table.clear(sensed_units)
	end
end)

-- {{{1 Sense Overheads.
----------------------------------------------------------------------------------------------------
-- When a Stormvermin, Chaos Warrior or Bestigor starts its overhead attack it is outlined for
-- OVERHEAD_MARK_DURATION seconds, fading linearly toward black (RGB scaled from full at the start
-- down to FADE_END_BRIGHTNESS at the end of the 2 seconds, then the outline is removed; see the
-- header comment for why RGB and not alpha). The color is the "Sensed Overhead" group in
-- OutlineOptions.lua.
--
-- Detection: all three breeds attack through BTStormVerminAttackAction, whose _init_attack picks an
-- animation from the action's attack_anim / step_attack_anim and plays it with
-- Managers.state.network:anim_event. Their overhead is the "special_attack_cleave" action (narrow,
-- tall, heavy; the sweep/push/quick attacks are other actions). The single place where that animation
-- is applied to the unit on BOTH the host (BT-driven) and clients (rpc_anim_event) is
-- AnimationSystem.anim_event, so that is what is hooked - a hook on the BT node would never run on a
-- client. The event names are read from BreedActions rather than hardcoded (attack_special for the
-- Stormvermin and the Bestigor; attack_cleave_01/02 and attack_cleave_moving_01 for the Chaos
-- Warrior; attack_cleave, attack_cleave_02 and attack_cleave_moving_01 for the Raider) and the unit's
-- breed is checked as well, since other breeds reuse event names (the shielded Stormvermin shares
-- attack_special with the Stormvermin, which is exactly why the breed check matters).
local OVERHEAD_MARK_DURATION = 2
-- The shielded Stormvermin is deliberately not included.
local OVERHEAD_BREEDS = {
	"skaven_storm_vermin",
	"chaos_warrior",
	"chaos_raider",
	"beastmen_bestigor",
}

local overhead_color_source = OutlineSettings.colors.accessibility_sensed_overhead
local sense_overheads_enabled = mod:get("sense_overheads") and true or false
local overhead_marks = {} -- unit -> { outline_id, expire_t, r, g, b } (r,g,b = last applied, already faded)
local overhead_index -- anim event name -> { breed name -> true }, built on first use

-- TimeManager:time returns nil (not an error) when the "game" timer doesn't exist, i.e. outside a level.
local function get_game_time()
	return Managers.time and Managers.time:time("game")
end

local function add_overhead_events(index, breed_name, events)
	if type(events) == "string" then
		events = { events }
	end

	for _, event_name in ipairs(events or {}) do
		index[event_name] = index[event_name] or {}
		index[event_name][breed_name] = true
	end
end

local function build_overhead_index()
	local index = {}

	for _, breed_name in ipairs(OVERHEAD_BREEDS) do
		local actions = BreedActions[breed_name]
		local cleave = actions and actions.special_attack_cleave

		if cleave then
			add_overhead_events(index, breed_name, cleave.attack_anim)
			add_overhead_events(index, breed_name, cleave.step_attack_anim)
		end
	end

	return index
end

local function remove_overhead_mark(unit, data)
	if Unit.alive(unit) then
		local outline_extension = ScriptUnit.has_extension(unit, "outline_system")

		if outline_extension then
			outline_extension:remove_outline(data.outline_id)
		end
	end

	overhead_marks[unit] = nil
end

local function clear_overhead_marks()
	for unit, data in pairs(overhead_marks) do
		remove_overhead_mark(unit, data)
	end
end

local function mark_overhead(unit)
	local t = get_game_time()

	if not t then
		return
	end

	local data = overhead_marks[unit]

	if data then
		-- Another overhead while still marked: restart the fade.
		data.expire_t = t + OVERHEAD_MARK_DURATION

		return
	end

	if not HEALTH_ALIVE[unit] then
		return
	end

	local outline_extension = ScriptUnit.has_extension(unit, "outline_system")

	if not outline_extension then
		return
	end

	local color = overhead_color_source.color
	local r, g, b = color[2], color[3], color[4]

	overhead_marks[unit] = {
		outline_id = outline_extension:add_outline({
			method = "ai_alive",
			priority = SENSE_OUTLINE_PRIORITY,
			outline_color = make_outline_color(r, g, b),
			flag = OutlineSettings.flags.non_wall_occluded,
		}),
		expire_t = t + OVERHEAD_MARK_DURATION,
		r = r,
		g = g,
		b = b,
	}
end

mod:hook_safe(AnimationSystem, "anim_event", function (self, unit, event_name)
	if not sense_overheads_enabled then
		return
	end

	overhead_index = overhead_index or build_overhead_index()

	local breeds = overhead_index[event_name]

	if not breeds then
		return
	end

	local breed = Unit.get_data(unit, "breed")

	if breed and breeds[breed.name] then
		mark_overhead(unit)
	end
end)

mod:add_update_function(function (dt)
	if not next(overhead_marks) then
		return
	end

	local t = get_game_time()

	if not t then
		return
	end

	local source_color = overhead_color_source.color

	for unit, data in pairs(overhead_marks) do
		local remaining = data.expire_t - t

		if remaining <= 0 or not HEALTH_ALIVE[unit] then
			remove_overhead_mark(unit, data)
		else
			local strength = FADE_END_BRIGHTNESS + (1 - FADE_END_BRIGHTNESS) * (remaining / OVERHEAD_MARK_DURATION)
			local r = scale_channel(source_color[2], strength)
			local g = scale_channel(source_color[3], strength)
			local b = scale_channel(source_color[4], strength)

			if data.r ~= r or data.g ~= g or data.b ~= b then
				local outline_extension = ScriptUnit.has_extension(unit, "outline_system")

				if outline_extension then
					-- A fresh table every time: OutlineExtension only recolors when the table
					-- identity changes (see _refresh_current_outline).
					outline_extension:update_outline({
						outline_color = make_outline_color(r, g, b),
					}, data.outline_id)
				end

				data.r, data.g, data.b = r, g, b
			end
		end
	end
end)

mod:add_setting_changed_function(function ()
	sense_overheads_enabled = mod:get("sense_overheads") and true or false

	if not sense_overheads_enabled then
		clear_overhead_marks()
	end
end)

mod:add_game_state_changed_function(function (status, state_name)
	if status == "enter" and state_name == "StateIngame" then
		table.clear(overhead_marks)
	end
end)
