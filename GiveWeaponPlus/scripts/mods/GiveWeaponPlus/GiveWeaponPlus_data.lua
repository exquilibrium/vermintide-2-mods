local mod = get_mod("GiveWeaponPlus")

mod.SETTING_NAMES = {
	FORCE_WOODEN_HAMMER = "FORCE_WOODEN_HAMMER",
	REMOVE_CW_CONTENT = "REMOVE_CW_CONTENT",
	FILTER_TRAITS_PROPERTIES = "FILTER_TRAITS_PROPERTIES",
}

local mod_data = {
	name = "Give Weapon Plus",
	description = mod:localize("mod_description"),
	is_togglable = false, -- must always run to load/equip saved items on startup
}

-- All options live in this one schema (options.widgets, setting_id/type) -- the older flat
-- options_widgets/widget_type format some mods use is not recognized by every VMF version and
-- silently produces no menu entry (and thus no default gets applied, so mod:get() reads nil).
mod_data.options = {
	widgets = {
		{
			setting_id = mod.SETTING_NAMES.REMOVE_CW_CONTENT,
			type = "checkbox",
			tooltip = "REMOVE_CW_CONTENT_T",
			default_value = true,
		},
		{
			setting_id = mod.SETTING_NAMES.FILTER_TRAITS_PROPERTIES,
			type = "checkbox",
			tooltip = "FILTER_TRAITS_PROPERTIES_T",
			default_value = true,
		},
		-- {
		-- 	setting_id = mod.SETTING_NAMES.FORCE_WOODEN_HAMMER,
		-- 	type = "checkbox",
		-- 	tooltip = "FORCE_WOODEN_HAMMER_T",
		-- 	default_value = false,
		-- },
		{
			setting_id = "auto_save",
			type = "checkbox",
			tooltip = "auto_save_tooltip",
			default_value = true,
		},
		{
			setting_id = "auto_equip_on_startup",
			type = "checkbox",
			tooltip = "auto_equip_on_startup_tooltip",
			default_value = true,
		},
		{
			setting_id = "displayed_rarity",
			type = "dropdown",
			tooltip = "displayed_rarity_tooltip",
			default_value = "plentiful",
			options = {
				{text = "rarity_default",	value = "default"},
				{text = "rarity_white",		value = "plentiful"},
				{text = "rarity_green",		value = "common"},
				{text = "rarity_blue",		value = "rare"},
				{text = "rarity_orange",	value = "exotic"},
				{text = "rarity_red",		value = "unique"},
			},
		},
		{
			setting_id = "keybinds_group",
			type = "group",
			sub_widgets = {
				{
					setting_id = "delete_item_keybind",
					type = "keybind",
					tooltip = "delete_item_keybind_tooltip",
					default_value = {},
					keybind_global = true,
					keybind_trigger = "pressed",
					keybind_type = "function_call",
					function_name = "delete_item_keybind_pressed",
				},
				{
					setting_id = "undo_delete_keybind",
					type = "keybind",
					tooltip = "undo_delete_keybind_tooltip",
					default_value = {},
					keybind_global = true,
					keybind_trigger = "pressed",
					keybind_type = "function_call",
					function_name = "undo_delete_keybind_pressed",
				},
			},
		},
	},
}

return mod_data
