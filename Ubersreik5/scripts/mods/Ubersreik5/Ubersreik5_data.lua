return {
	is_mutator = false,
	name = "Ubersreik5",
	is_togglable = true,
	description = get_mod("Ubersreik5"):localize("mod_description"),
	mutator_settings = {},
	options = {
		widgets = {
			{
				type = "group",
				setting_id = "last_build_group",
				sub_widgets = {},
			},
			{
				type = "numeric",
				setting_id = "extend",
				notify_mod = true,
				default_value = 15,
				decimals_number = 0,
				unit_text = "unit_text_empty",
				range = {
					11,
					25,
				},
			},
			{
				type = "numeric",
				setting_id = "numberofbots",
				notify_mod = true,
				default_value = 3,
				decimals_number = 0,
				unit_text = "unit_text_empty",
				range = {
					0,
					4,
				},
			},
		},
	},
}
