return {
	mod_description = {
		en = "Create inventory items, then save and auto-equip them between sessions."
	},

	MUC_fail = {
		en = "%s: Failed to check the Steam Workshop for updates.",
	},
	last_build = {
		en = "Last Build: 2026-08-30 02:45 UTC",
	},
	MUC_out_of_date = {
		en = "%s: A newer version is available on the Steam Workshop. Please update it.",
	},
	FORCE_WOODEN_HAMMER = {
		en = "Wooden 2h Hammer"
	},
	FORCE_WOODEN_HAMMER_T = {
		en = "Whenever you equip a 2h hammer, it will have the wooden skin, like in the tutorial."
			.."\nOther people will still see the normal skin, I cannot sync it."
	},
	REMOVE_CW_CONTENT = {
		en = "Remove Chaos Wastes Content"
	},
	REMOVE_CW_CONTENT_T = {
		en = "Hide traits and properties exclusive to the Chaos Wastes (Winds of Magic) DLC from their dropdowns."
			.."\nTakes effect next time you open the inventory screen."
	},
	FILTER_TRAITS_PROPERTIES = {
		en = "Only Show Valid Traits/Properties"
	},
	FILTER_TRAITS_PROPERTIES_T = {
		en = "Only list traits and properties that the game actually allows on the selected item type, instead of every trait/property in the game."
			.."\nUpdates when you change the selected item type."
	},

	auto_save = {
		en = "Auto-save created items",
	},
	auto_save_tooltip = {
		en = "When enabled, items created with the weapon creator will be saved automatically. \nIf this setting is disabled, the command \"/sw_save_*item_name*\" (auto-fill will help you) can be used instead to save an item.",
	},

	auto_equip_on_startup = {
		en = "Auto-equip items on game launch",
	},
	auto_equip_on_startup_tooltip = {
		en = "When enabled, your equipped modded items will be remembered between sessions and automatically equipped when you launch the game. \nWhen disabled, modded items are unequipped when you exit the game, resulting in the default Hero Power 5 items taking their place.",
	},

	displayed_rarity = {
		en = "Displayed items rarity",
	},
	displayed_rarity_tooltip = {
		en = "Select displayed rarity for created/loaded items in your inventory. \nThis can be helpful to differentiate modded items from normal ones, as the inventory will sort them accordingly.",
	},
	rarity_default = {
		en = "Default",
	},
	rarity_white = {
		en = "White",
	},
	rarity_green = {
		en = "Green",
	},
	rarity_blue = {
		en = "Blue",
	},
	rarity_orange = {
		en = "Orange",
	},
	rarity_red = {
		en = "Red",
	},

	keybinds_group = {
		en = "Keybinds",
	},
	delete_item_keybind = {
		en = "Delete item",
	},
	delete_item_keybind_tooltip = {
		en = "To use: hover over the (un)desired item in your inventory, then press the defined keybind to delete your item. \nUse chat command \"/sw_undo\" if you regret deleting the item and want it back.",
	},
	undo_delete_keybind = {
		en = "Undo delete",
	},
	undo_delete_keybind_tooltip = {
		en = "Only works while in the inventory screen! \nWhen pressed, this brings back the last deleted item. Can be used repeatedly.",
	},
}
