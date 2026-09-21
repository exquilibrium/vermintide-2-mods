local mod = get_mod("AccessibilityOptions")

--[[

	Outline Colors (Accessibility)

	General-purpose, non-career-specific outline color overrides, ported from Tourney Balance's
	Accessibility section (scripts/mods/TourneyBalance/accessibility/outline_colors.lua and
	_color_presets.lua).

]]

-- {{{1 Color presets.
----------------------------------------------------------------------------------------------------
-- RGB values match Colors.color_definitions (scripts/utils/colors.lua) so presets match colors
-- already used elsewhere in the game rather than arbitrary picks.
local PRESETS_BY_ID = {
	white = { r = 255, g = 255, b = 255 },
	red   = { r = 227, g = 4,   b = 4   },
	green = { r = 118, g = 186, b = 0   },
	blue  = { r = 30,  g = 150, b = 255 },
	ghost = { r = 89,  g = 218, b = 158 },
	pink  = { r = 255, g = 70,  b = 130 },
	gold  = { r = 255, g = 215, b = 0   },
}

-- Ported from the "Mark" mod's rainbow ping/outline effect (scripts/mods/Mark/Mark.lua). Cycles
-- hue at full saturation/value through the color wheel; "outline_rainbow_pulse_rate" controls speed.
local function get_rainbow_pulse_rate()
	return math.clamp(mod:get("outline_rainbow_pulse_rate") or 1, 0.1, 10)
end

local function rainbow_rgb(t)
	-- Callers include mod:add_setting_changed_function's fan-out, which passes the changed
	-- setting_id (a string) through as this same argument - fall back to a fixed hue rather than
	-- erroring, since on_update's per-frame pass-through (a real elapsed-seconds number) is what
	-- actually drives the animation.
	t = type(t) == "number" and t or 0

	local hue = t * get_rainbow_pulse_rate() % 1
	local hue_sector = hue * 6
	local sector = math.floor(hue_sector)
	local fraction = hue_sector - sector
	local inverse_fraction = 1 - fraction
	local red, green, blue

	if sector == 0 then
		red, green, blue = 1, fraction, 0
	elseif sector == 1 then
		red, green, blue = inverse_fraction, 1, 0
	elseif sector == 2 then
		red, green, blue = 0, 1, fraction
	elseif sector == 3 then
		red, green, blue = 0, inverse_fraction, 1
	elseif sector == 4 then
		red, green, blue = fraction, 0, 1
	else
		red, green, blue = 1, 0, inverse_fraction
	end

	return math.floor(red * 255 + 0.5), math.floor(green * 255 + 0.5), math.floor(blue * 255 + 0.5)
end

-- Resolves a color group's final RGB: the selected preset's RGB, the entry's own stock RGB when
-- "default" is selected, a cycling hue when "rainbow" is selected (t = elapsed seconds), or the
-- custom R/G/B sliders when "custom" is selected.
local function resolve_color(dropdown_setting_id, r_setting_id, g_setting_id, b_setting_id, default_r, default_g, default_b, t)
	local selected = mod:get(dropdown_setting_id)

	if selected == "default" then
		return default_r, default_g, default_b
	end

	if selected == "rainbow" then
		return rainbow_rgb(t)
	end

	local preset = PRESETS_BY_ID[selected]
	if preset then
		return preset.r, preset.g, preset.b
	end

	return mod:get(r_setting_id), mod:get(g_setting_id), mod:get(b_setting_id)
end

-- {{{1 Dedicated accessibility colors.
----------------------------------------------------------------------------------------------------
-- Dangerous Enemy Marker: the auto-target-marking used by Sister of the Thorn's deepwood staff,
-- Necromancer's staff, Waystalker ultimate, Pyromancer ultimate, and the true-flight bow. Repointed
-- here to a dedicated color, decoupling it from knocked_down.
OutlineSettings.colors.accessibility_dangerous_enemy_marker = {
	pulsate = false,
	pulse_multiplier = 50,
	color = { 255, 0, 0, 0 }, -- alpha, r, g, b - populated below
}

OutlineSettings.templates.target_enemy.outline_color = OutlineSettings.colors.accessibility_dangerous_enemy_marker

-- Downed/Disabled Player Indicator: the downed/incapacitated ally indicator (templates.incapacitated,
-- used in generic_status_extension.lua) - also covers a hooked/grabbed (Packmaster) teammate, since
-- that status uses the same "incapacitated" template. Originally reused OutlineSettings.colors.
-- knocked_down too. templates.incapacitated is only ever referenced by that indicator, so it's
-- repointed here to a dedicated color, decoupling it from knocked_down and from the dangerous enemy
-- marker above. No outline is shown for the local player's own hooked/downed status (base game
-- behavior, not something this mod controls) - only visible on teammates.
OutlineSettings.colors.accessibility_downed_player_indicator = {
	pulsate = false,
	pulse_multiplier = 50,
	color = { 255, 0, 0, 0 }, -- alpha, r, g, b - populated below
}

OutlineSettings.templates.incapacitated.outline_color = OutlineSettings.colors.accessibility_downed_player_indicator

-- Per-category ping colors: a ping on a Monster (breed.boss), Elite (breed.elite) or Special
-- (breed.special) enemy gets its own color instead of the shared player_attention one. Everything
-- else (regular infantry, pickups, allies, ...) keeps using player_attention, which is the "Other"
-- ping group below. The swap happens in the add_outline hook further down - the base game's ping
-- template (templates.ping_unit) only has one color slot, so there's no way to pick per-category at
-- the settings level.
local function make_ping_color_table()
	return {
		pulsate = false,
		pulse_multiplier = OutlineSettings.colors.player_attention.pulse_multiplier,
		color = { 255, 30, 150, 255 }, -- alpha, r, g, b - populated below
	}
end

OutlineSettings.colors.accessibility_ping_monster = make_ping_color_table()
OutlineSettings.colors.accessibility_ping_elite = make_ping_color_table()
OutlineSettings.colors.accessibility_ping_special = make_ping_color_table()

local function get_ping_category_color_table(unit)
	if not unit or not Unit.alive(unit) then
		return nil
	end

	local breed = Unit.get_data(unit, "breed")

	if not breed then
		return nil
	end

	if breed.boss then
		return OutlineSettings.colors.accessibility_ping_monster
	elseif breed.special then
		return OutlineSettings.colors.accessibility_ping_special
	elseif breed.elite then
		return OutlineSettings.colors.accessibility_ping_elite
	end

	return nil
end

-- Sensed Special: RGB source for the Visual Aid > Sixth Sense > Sense Specials mark. Registered as a
-- color group below (presets / Custom / Rainbow), but no outline uses this table directly:
-- VisualAid.lua reads its RGB every frame and gives each outline its own table with the pulse and
-- distance strength applied (a shared table would let this group's updates overwrite that).
OutlineSettings.colors.accessibility_sensed_special = {
	pulsate = false,
	pulse_multiplier = 50,
	color = { 255, 0, 0, 0 }, -- alpha, r, g, b - populated below
}

-- Sensed Overhead: RGB source for the Visual Aid > Sixth Sense > Sense Overheads mark. Same
-- arrangement as Sensed Special above: a color group that only supplies RGB, read by VisualAid.lua,
-- which applies the 2 second fade itself on a per-outline table.
OutlineSettings.colors.accessibility_sensed_overhead = {
	pulsate = false,
	pulse_multiplier = 50,
	color = { 255, 0, 0, 0 }, -- alpha, r, g, b - populated below
}

-- {{{1 Color group registry.
----------------------------------------------------------------------------------------------------
-- Ping: the base game's ping-highlight color (colorblind-friendly ping visibility). Also covers
-- templates.target_ally, which shares the same color table. This entry is the "Other" ping category
-- (anything that isn't a Monster/Elite/Special enemy - see get_ping_category_color_table above); its
-- setting ids are unchanged from before the category split so existing saved choices carry over.
-- Interactable: the default outline used for nearly everything interactable - pickups, doors,
-- small doors, elevators, objectives (normal/light/large), generic interactables, conditional
-- interact/pickup outlines, and the tutorial-highlight / career-targeting reticle. By far the most
-- commonly seen outline color in the game.
-- Knocked Down: the base "knocked_down" color entry. In the base game this was shared by both
-- templates.target_enemy and templates.incapacitated; those are forked off above, decoupling them
-- from this one and from each other. What's left reading knocked_down directly:
-- EnemyOutlineExtension's baseline outline slot (outline_system.lua - its method is hardcoded
-- "never", so inert in normal play) and, in Versus mode, DarkPactPlayerHuskOutlineExtension's
-- fallback color for an enemy-team human player.
-- Player: ally/player body outline (PlayerOutlineExtension, PlayerHuskOutlineExtension). Also
-- shared with the "ready for assisted respawn" revive-prompt outline
-- (templates.ready_for_assisted_respawn_husk), left as-is since it's a minor, closely related highlight.
-- Skeleton: OutlineSettings.colors.necromancer_command, used for the Necromancer's summoned
-- skeleton pets (MinionOutlineExtension) as well as the Command ability's target-highlighting
-- while directing a pet/ally (career_ability_bw_necromancer_command.lua).
local COLOR_GROUPS = {
	{ dropdown_setting_id = "outline_ping_color_group", color_table = OutlineSettings.colors.player_attention,
	  r_setting_id = "outline_ping_color_r", g_setting_id = "outline_ping_color_g", b_setting_id = "outline_ping_color_b",
	  r_default = 30, g_default = 150, b_default = 255 },
	{ dropdown_setting_id = "outline_ping_monster_color_group", color_table = OutlineSettings.colors.accessibility_ping_monster,
	  r_setting_id = "outline_ping_monster_color_r", g_setting_id = "outline_ping_monster_color_g", b_setting_id = "outline_ping_monster_color_b",
	  r_default = 30, g_default = 150, b_default = 255 },
	{ dropdown_setting_id = "outline_ping_elite_color_group", color_table = OutlineSettings.colors.accessibility_ping_elite,
	  r_setting_id = "outline_ping_elite_color_r", g_setting_id = "outline_ping_elite_color_g", b_setting_id = "outline_ping_elite_color_b",
	  r_default = 30, g_default = 150, b_default = 255 },
	{ dropdown_setting_id = "outline_ping_special_color_group", color_table = OutlineSettings.colors.accessibility_ping_special,
	  r_setting_id = "outline_ping_special_color_r", g_setting_id = "outline_ping_special_color_g", b_setting_id = "outline_ping_special_color_b",
	  r_default = 30, g_default = 150, b_default = 255 },
	{ dropdown_setting_id = "outline_sensed_special_color_group", color_table = OutlineSettings.colors.accessibility_sensed_special,
	  r_setting_id = "outline_sensed_special_color_r", g_setting_id = "outline_sensed_special_color_g", b_setting_id = "outline_sensed_special_color_b",
	  r_default = 227, g_default = 4, b_default = 4 },
	{ dropdown_setting_id = "outline_sensed_overhead_color_group", color_table = OutlineSettings.colors.accessibility_sensed_overhead,
	  r_setting_id = "outline_sensed_overhead_color_r", g_setting_id = "outline_sensed_overhead_color_g", b_setting_id = "outline_sensed_overhead_color_b",
	  r_default = 227, g_default = 4, b_default = 4 },
	{ dropdown_setting_id = "outline_interactable_color_group", color_table = OutlineSettings.colors.interactable,
	  r_setting_id = "outline_interactable_color_r", g_setting_id = "outline_interactable_color_g", b_setting_id = "outline_interactable_color_b",
	  r_default = 255, g_default = 255, b_default = 255 },
	{ dropdown_setting_id = "outline_knocked_down_color_group", color_table = OutlineSettings.colors.knocked_down,
	  r_setting_id = "outline_knocked_down_color_r", g_setting_id = "outline_knocked_down_color_g", b_setting_id = "outline_knocked_down_color_b",
	  r_default = 227, g_default = 4, b_default = 4 },
	{ dropdown_setting_id = "outline_dangerous_color_group", color_table = OutlineSettings.colors.accessibility_dangerous_enemy_marker,
	  r_setting_id = "outline_dangerous_color_r", g_setting_id = "outline_dangerous_color_g", b_setting_id = "outline_dangerous_color_b",
	  r_default = 227, g_default = 4, b_default = 4 },
	{ dropdown_setting_id = "outline_downed_player_color_group", color_table = OutlineSettings.colors.accessibility_downed_player_indicator,
	  r_setting_id = "outline_downed_player_color_r", g_setting_id = "outline_downed_player_color_g", b_setting_id = "outline_downed_player_color_b",
	  r_default = 227, g_default = 4, b_default = 4 },
	{ dropdown_setting_id = "outline_player_color_group", color_table = OutlineSettings.colors.ally,
	  r_setting_id = "outline_player_color_r", g_setting_id = "outline_player_color_g", b_setting_id = "outline_player_color_b",
	  r_default = 118, g_default = 186, b_default = 0 },
	{ dropdown_setting_id = "outline_skeleton_color_group", color_table = OutlineSettings.colors.necromancer_command,
	  r_setting_id = "outline_skeleton_color_r", g_setting_id = "outline_skeleton_color_g", b_setting_id = "outline_skeleton_color_b",
	  r_default = 89, g_default = 218, b_default = 158 },
}

local color_group_by_table = {}
for _, group in ipairs(COLOR_GROUPS) do
	color_group_by_table[group.color_table] = group
end

-- {{{1 Live outline tracking.
----------------------------------------------------------------------------------------------------
-- OutlineExtension.add_outline clones its settings table internally (table.clone), and since our
-- color tables are plain tables (no metatable, so is_class_instance is false), that clone recurses
-- into outline_color too - an already-active outline holds its OWN independent copy of the color
-- from the moment it was created. Mutating OutlineSettings.colors.X.color in place therefore never
-- reaches a unit that was already outlined before the change - not for a static preset switch, and
-- especially not for Rainbow, which needs to keep changing every frame. So, mirroring the "Mark"
-- mod's own track_tourney_outline/update_tourney_outlines, we track every live (OutlineExtension,
-- outline_id) pair using one of our color tables and explicitly push a fresh outline_color to each
-- one whenever that group's color changes (see apply_color_group and on_update below).
local tracked_outlines = {}

local function track_outline(outline_extension, outline_id, group)
	local ids = tracked_outlines[outline_extension]

	if not ids then
		ids = {}
		tracked_outlines[outline_extension] = ids
	end

	ids[outline_id] = group
end

local function untrack_outline(outline_extension, outline_id)
	-- OutlineExtension.remove_outline itself treats a nil/negative id as a no-op (outline_extension.lua:
	-- `if not unique_id or unique_id < 0 then return end`) - the base game relies on this and does call
	-- it with no id in some paths (e.g. observed when a hooked player's/teammate's hook is removed).
	-- Our hook_safe callback runs regardless, so it needs the same guard or `ids[outline_id] = nil`
	-- below errors with "table index is nil".
	if not outline_id or outline_id < 0 then
		return
	end

	local ids = tracked_outlines[outline_extension]

	if not ids then
		return
	end

	ids[outline_id] = nil

	if not next(ids) then
		tracked_outlines[outline_extension] = nil
	end
end

mod:hook("OutlineExtension", "add_outline", function(func, self, settings)
	-- Ping category swap: only the shared player_attention color is redirected, and only for enemy
	-- units with a Monster/Elite/Special breed. Works on a copy, never the shared template itself
	-- (templates.target_ally shares this same color table and must not be changed for everyone).
	if settings.outline_color == OutlineSettings.colors.player_attention then
		local category_color = get_ping_category_color_table(self._unit)

		if category_color then
			settings = table.shallow_copy(settings, true)
			settings.outline_color = category_color
		end
	end

	local outline_id = func(self, settings)
	local group = color_group_by_table[settings.outline_color]

	if group then
		track_outline(self, outline_id, group)
	end

	return outline_id
end)

mod:hook_safe("OutlineExtension", "remove_outline", function(self, outline_id)
	untrack_outline(self, outline_id)
end)

-- {{{1 Static apply.
----------------------------------------------------------------------------------------------------
-- Updates the shared color table (covers outlines created from now on) and pushes the new color to
-- every already-tracked live outline of this group (covers ones that already exist - see the
-- live-tracking comment above for why that push is necessary). Only RGB is written: the alpha entry
-- (color[1]) stays at its initial 255, since OutlineSystem draws Color(255, r, g, b) and would ignore
-- any other alpha anyway.
local function apply_color_group(group, t)
	local color = group.color_table.color
	local r, g, b = resolve_color(group.dropdown_setting_id, group.r_setting_id, group.g_setting_id, group.b_setting_id, group.r_default, group.g_default, group.b_default, t)

	color[2], color[3], color[4] = r, g, b

	for outline_extension, ids in pairs(tracked_outlines) do
		if not Unit.alive(outline_extension._unit) then
			tracked_outlines[outline_extension] = nil
		else
			for outline_id, tracked_group in pairs(ids) do
				if tracked_group == group then
					outline_extension:update_outline({
						outline_color = table.clone(group.color_table),
					}, outline_id)
				end
			end
		end
	end
end

for _, group in ipairs(COLOR_GROUPS) do
	apply_color_group(group)
	mod:add_setting_changed_function(function(t)
		apply_color_group(group, t)
	end)
end

-- {{{1 Rainbow animation.
----------------------------------------------------------------------------------------------------
-- Ticks every group currently set to Rainbow once per frame - a single pass over tracked_outlines
-- regardless of how many groups are animating, rather than calling apply_color_group (and its own
-- full tracked_outlines scan) once per active group.
local function on_update(dt)
	local any_rainbow = false
	local t = Managers.time:time("main")

	for _, group in ipairs(COLOR_GROUPS) do
		if mod:get(group.dropdown_setting_id) == "rainbow" then
			any_rainbow = true

			local color = group.color_table.color

			color[2], color[3], color[4] = rainbow_rgb(t)
		end
	end

	if not any_rainbow then
		return
	end

	for outline_extension, ids in pairs(tracked_outlines) do
		if not Unit.alive(outline_extension._unit) then
			tracked_outlines[outline_extension] = nil
		else
			for outline_id, group in pairs(ids) do
				if mod:get(group.dropdown_setting_id) == "rainbow" then
					outline_extension:update_outline({
						outline_color = table.clone(group.color_table),
					}, outline_id)
				end
			end
		end
	end
end
mod:add_update_function(on_update)