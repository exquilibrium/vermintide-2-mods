local mod = get_mod("SetWobble")

local mod_data = {
	name = "SetWobble",
	description = mod:localize("mod_description"),
	is_togglable = true,
}

mod_data.options = {
	widgets = {
		{
			setting_id = "camera_sway",
			type = "numeric",
			tooltip = "camera_sway_option_tooltip",
			default_value = 100,
			decimals_number = 0,
			range = {0, 100},
		},
	},
}

return mod_data
