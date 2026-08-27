local mod = get_mod("ThirdPerson")

local mod_data = {
	name = "ThirdPerson",
	description = mod:localize("mod_description"),
	is_togglable = true,
}

mod_data.options = {
	widgets = {
		{
			setting_id = "toggle_third_person_keybind",
			type = "keybind",
			tooltip = "toggle_third_person_keybind_tooltip",
			default_value = {},
			keybind_global = true,
			keybind_trigger = "pressed",
			keybind_type = "function_call",
			function_name = "toggle_third_person_pressed",
		},
		{
			setting_id = "camera_settings_group",
			type = "group",
			sub_widgets = {
				{
					setting_id = "camera_shoulder_side",
					type = "dropdown",
					tooltip = "camera_shoulder_side_tooltip",
					default_value = "right",
					options = {
						{text = "camera_shoulder_side_left", value = "left"},
						{text = "camera_shoulder_side_right", value = "right"},
						{text = "camera_shoulder_side_center", value = "center"},
					},
				},
				{
					setting_id = "camera_x_position",
					type = "numeric",
					tooltip = "camera_x_position_tooltip",
					default_value = 0.75,
					decimals_number = 2,
					range = {-3, 3},
				},
				{
					setting_id = "camera_y_position",
					type = "numeric",
					tooltip = "camera_y_position_tooltip",
					default_value = 0.5,
					decimals_number = 2,
					range = {-3, 3},
				},
				{
					setting_id = "camera_turn_horizontal",
					type = "numeric",
					tooltip = "camera_turn_horizontal_tooltip",
					default_value = 12,
					decimals_number = 2,
					range = {-45, 45},
				},
				{
					setting_id = "camera_turn_vertical",
					type = "numeric",
					tooltip = "camera_turn_vertical_tooltip",
					default_value = -7,
					decimals_number = 2,
					range = {-45, 45},
				},
				{
					setting_id = "camera_distance",
					type = "numeric",
					tooltip = "camera_distance_tooltip",
					default_value = 0.65,
					decimals_number = 2,
					range = {-3, 3},
				},
			},
		},
		{
			setting_id = "zoom_settings_group",
			type = "group",
			sub_widgets = {
				{
					setting_id = "camera_zoom_speed",
					type = "numeric",
					tooltip = "camera_zoom_speed_tooltip",
					default_value = 0.2,
					decimals_number = 3,
					range = {0.005, 2},
				},
				{
					setting_id = "camera_fov_unzoomed",
					type = "numeric",
					tooltip = "camera_fov_unzoomed_tooltip",
					default_value = 65,
					decimals_number = 1,
					range = {10, 120},
				},
				{
					setting_id = "camera_fov_zoomed",
					type = "numeric",
					tooltip = "camera_fov_zoomed_tooltip",
					default_value = 30,
					decimals_number = 1,
					range = {10, 120},
				},
				{
					setting_id = "camera_fov_extra_zoomed",
					type = "numeric",
					tooltip = "camera_fov_extra_zoomed_tooltip",
					default_value = 15,
					decimals_number = 1,
					range = {10, 120},
				},
			},
		},
	},
}

return mod_data
