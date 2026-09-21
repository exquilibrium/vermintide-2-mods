local mod = get_mod("AccessibilityOptions")

-- Builds a "preset dropdown + custom R/G/B sliders" widget. Every color group in the OutlineOptions
-- section shares the same Default + presets + Custom; selecting Default or a preset hides the R/G/B
-- sliders, selecting Custom reveals them (show_widgets = {1, 2, 3}). Default resolves to that
-- entry's own stock in-game RGB (r_default/g_default/b_default), passed to OutlineOptions.lua's
-- resolve_color at the call site. There is deliberately no alpha slider: OutlineSystem ignores an
-- outline color's alpha (it draws Color(255, r, g, b)), so it could not change anything on screen.
local function color_picker_widget(setting_id, r_setting_id, g_setting_id, b_setting_id, r_default, g_default, b_default)
	return {
		setting_id = setting_id,
		type = "dropdown",
		title = setting_id,
		default_value = "default",
		options = {
			{ text = "outline_color_preset_default_title", value = "default" },
			{ text = "outline_color_preset_white_title", value = "white" },
			{ text = "outline_color_preset_red_title", value = "red" },
			{ text = "outline_color_preset_green_title", value = "green" },
			{ text = "outline_color_preset_blue_title", value = "blue" },
			{ text = "outline_color_preset_ghost_title", value = "ghost" },
			{ text = "outline_color_preset_pink_title", value = "pink" },
			{ text = "outline_color_preset_gold_title", value = "gold" },
			{ text = "outline_color_preset_rainbow_title", value = "rainbow" },
			{ text = "outline_color_preset_custom_title", value = "custom", show_widgets = {1, 2, 3} },
		},
		sub_widgets = {
			{
				type = "numeric",
				setting_id = r_setting_id,
				default_value = r_default,
				range = {0, 255},
				decimals_number = 0,
				title = r_setting_id .. "_title",
				tooltip = r_setting_id .. "_description",
			},
			{
				type = "numeric",
				setting_id = g_setting_id,
				default_value = g_default,
				range = {0, 255},
				decimals_number = 0,
				title = g_setting_id .. "_title",
				tooltip = g_setting_id .. "_description",
			},
			{
				type = "numeric",
				setting_id = b_setting_id,
				default_value = b_default,
				range = {0, 255},
				decimals_number = 0,
				title = b_setting_id .. "_title",
				tooltip = b_setting_id .. "_description",
			},
		},
	}
end

local outline_options_widgets = {
	{
		setting_id = "outline_ping_group",
		type = "group",
		sub_widgets = {
			color_picker_widget("outline_ping_monster_color_group", "outline_ping_monster_color_r", "outline_ping_monster_color_g", "outline_ping_monster_color_b", 30, 150, 255),
			color_picker_widget("outline_ping_elite_color_group", "outline_ping_elite_color_r", "outline_ping_elite_color_g", "outline_ping_elite_color_b", 30, 150, 255),
			color_picker_widget("outline_ping_special_color_group", "outline_ping_special_color_r", "outline_ping_special_color_g", "outline_ping_special_color_b", 30, 150, 255),
			color_picker_widget("outline_ping_color_group", "outline_ping_color_r", "outline_ping_color_g", "outline_ping_color_b", 30, 150, 255),
		},
	},
	color_picker_widget("outline_interactable_color_group", "outline_interactable_color_r", "outline_interactable_color_g", "outline_interactable_color_b", 255, 255, 255),
	color_picker_widget("outline_knocked_down_color_group", "outline_knocked_down_color_r", "outline_knocked_down_color_g", "outline_knocked_down_color_b", 227, 4, 4),
	color_picker_widget("outline_dangerous_color_group", "outline_dangerous_color_r", "outline_dangerous_color_g", "outline_dangerous_color_b", 227, 4, 4),
	color_picker_widget("outline_downed_player_color_group", "outline_downed_player_color_r", "outline_downed_player_color_g", "outline_downed_player_color_b", 227, 4, 4),
	color_picker_widget("outline_player_color_group", "outline_player_color_r", "outline_player_color_g", "outline_player_color_b", 118, 186, 0),
	color_picker_widget("outline_skeleton_color_group", "outline_skeleton_color_r", "outline_skeleton_color_g", "outline_skeleton_color_b", 89, 218, 158),
	{
		type = "numeric",
		setting_id = "outline_rainbow_pulse_rate",
		tooltip = "outline_rainbow_pulse_rate_description",
		range = {0.1, 10},
		decimals_number = 1,
		default_value = 1,
	},
}

mod:dofile("scripts/mods/AccessibilityOptions/AccessibilityCaptions_definitions")

-- Generate a checkbox option for each caption.
local sound_widgets = {}
for i, data in ipairs(mod.caption_data) do
	if not data.no_option then
		local label = data.label
		sound_widgets[i] = {
			type = "checkbox",
			setting_id = label,
			title = label,
			default_value = false,
			localize = false,
		}
		data.enabled = mod:get(label)
	end
end

local SCREEN_W, SCREEN_H = Gui.resolution()

local accessibility_captions_widgets = {
	{
		setting_id = "sound_widgets",
		type = "group",
		sub_widgets = sound_widgets,
	},
	{
		type = "numeric",
		setting_id = "max_hearing_distance",
		range = { 1, 50 },
		default_value = 50,
	},
	{
		type = "dropdown",
		setting_id = "widget_direction",
		default_value = 0,
		options = {
			{ text = "north_east", value = 0x3 },
			{ text = "north_west", value = 0x2 },
			{ text = "south_east", value = 0x1 },
			{ text = "south_west", value = 0x0 },
		},
	},
	{
		type = "numeric",
		setting_id = "font_size",
		unit_text = "pixels",
		range = { 8, 52 },
		default_value = 14,
	},
	{
		type = "numeric",
		setting_id = "widget_x",
		unit_text = "pixels",
		range = { -SCREEN_W * 0.5, SCREEN_W * 0.5 },
		default_value = 0,
	},
	{
		type = "numeric",
		setting_id = "widget_y",
		unit_text = "pixels",
		range = { -SCREEN_H * 0.5, SCREEN_H * 0.5 },
		default_value = 0,
	},
}

table.insert(accessibility_captions_widgets, {
	setting_id = "debug",
	type = "group",
	sub_widgets = {
		{
			type = "checkbox",
			setting_id = "show_all_sounds",
			default_value = false,
		},
		{
			type = "checkbox",
			setting_id = "debug_mode",
			default_value = false,
			tooltip = "debug_mode_description",
		},
	},
})

local sound_cues_widgets = {
	{
		setting_id = "sound_cues_packmaster_foley",
		type = "group",
		sub_widgets = {
			{
				setting_id = "sound_cues_packmaster_foley_boost",
				type = "numeric",
				tooltip = "sound_cues_packmaster_foley_boost_description",
				range = {0, 5},
				decimals_number = 0,
				default_value = 0,
			},
		},
	},
	{
		setting_id = "sound_cues_chaos_sorcerer_teleport",
		type = "group",
		sub_widgets = {
			{
				setting_id = "sound_cues_chaos_sorcerer_teleport_boost",
				type = "numeric",
				tooltip = "sound_cues_chaos_sorcerer_teleport_boost_description",
				range = {0, 5},
				decimals_number = 0,
				default_value = 0,
			},
		},
	},

	{
		setting_id = "sound_control_limiter",
		type = "group",
		sub_widgets = {
			{
				setting_id = "sound_control_limiter_enabled",
				type = "checkbox",
				tooltip = "sound_control_limiter_enabled_description",
				default_value = true,
			},
			{
				setting_id = "sound_control_limiter_infantry_max",
				type = "numeric",
				tooltip = "sound_control_limiter_infantry_max_description",
				range = {0, 30},
				decimals_number = 0,
				default_value = 3,
			},
			{
				setting_id = "sound_control_limiter_elite_max",
				type = "numeric",
				tooltip = "sound_control_limiter_elite_max_description",
				range = {0, 20},
				decimals_number = 0,
				default_value = 3,
			},
		},
	},

	-- Lets the user cycle through and play every known Wwise sound event by name, to audition
	-- candidates before building real Sound Cues entries for them.
	{
		setting_id = "sound_cues_debug",
		type = "group",
		sub_widgets = {
			{
				setting_id = "sound_cues_debug_previous_keybind",
				type = "keybind",
				tooltip = "sound_cues_debug_previous_keybind_description",
				default_value = {},
				keybind_global = true,
				keybind_trigger = "pressed",
				keybind_type = "function_call",
				function_name = "sound_cues_debug_previous",
			},
			{
				setting_id = "sound_cues_debug_next_keybind",
				type = "keybind",
				tooltip = "sound_cues_debug_next_keybind_description",
				default_value = {},
				keybind_global = true,
				keybind_trigger = "pressed",
				keybind_type = "function_call",
				function_name = "sound_cues_debug_next",
			},
			{
				setting_id = "sound_cues_debug_play_keybind",
				type = "keybind",
				tooltip = "sound_cues_debug_play_keybind_description",
				default_value = {},
				keybind_global = true,
				keybind_trigger = "pressed",
				keybind_type = "function_call",
				function_name = "sound_cues_debug_play",
			},
			{
				setting_id = "sound_cues_debug_stop_all_keybind",
				type = "keybind",
				tooltip = "sound_cues_debug_stop_all_keybind_description",
				default_value = {},
				keybind_global = true,
				keybind_trigger = "pressed",
				keybind_type = "function_call",
				function_name = "sound_cues_debug_stop_all",
			},
			{
				setting_id = "sound_control_debug_log_events_keybind",
				type = "keybind",
				tooltip = "sound_control_debug_log_events_keybind_description",
				default_value = {},
				keybind_global = true,
				keybind_trigger = "pressed",
				keybind_type = "function_call",
				function_name = "sound_control_debug_toggle_log_events",
			},
			{
				setting_id = "sound_cues_debug_disable_all_sounds",
				type = "checkbox",
				tooltip = "sound_cues_debug_disable_all_sounds_description",
				default_value = false,
			},
			{
				setting_id = "sound_cues_debug_log_boosts",
				type = "checkbox",
				tooltip = "sound_cues_debug_log_boosts_description",
				default_value = false,
			},
		},
	},
}

-- Shown as one group titled "Visual Aid - Sixth Sense" (the "VisualAid" localization entry).
local visual_aid_widgets = {
	{
		setting_id = "sense_specials",
		type = "checkbox",
		tooltip = "sense_specials_description",
		default_value = false,
	},
	color_picker_widget("outline_sensed_special_color_group", "outline_sensed_special_color_r", "outline_sensed_special_color_g", "outline_sensed_special_color_b", 227, 4, 4),
	{
		setting_id = "sense_overheads",
		type = "checkbox",
		tooltip = "sense_overheads_description",
		default_value = false,
	},
	color_picker_widget("outline_sensed_overhead_color_group", "outline_sensed_overhead_color_r", "outline_sensed_overhead_color_g", "outline_sensed_overhead_color_b", 227, 4, 4),
}

return {
	name = "AccessibilityOptions",
	description = mod:localize("mod_description"),
	is_togglable = false,
	options = {
		widgets = {
			{
				setting_id = "AccessibilityCaptions",
				type = "group",
				sub_widgets = accessibility_captions_widgets,
			},
			{
				setting_id = "OutlineOptions",
				type = "group",
				sub_widgets = outline_options_widgets,
			},
			{
				setting_id = "SoundCues",
				type = "group",
				sub_widgets = sound_cues_widgets,
			},
			{
				setting_id = "VisualAid",
				type = "group",
				sub_widgets = visual_aid_widgets,
			},
		},
		collapsed_widgets = {
			"sound_widgets",
		},
	},
}
