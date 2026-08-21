local mod = get_mod("GiveWeaponPlus")

local pl = require'pl.import_into'()
local tablex = require'pl.tablex'
local stringx = require'pl.stringx'

mod.simple_ui = get_mod("SimpleUI")
mod.more_items_library = get_mod("MoreItemsLibrary")

mod.properties = {}
mod.traits = {}

fassert(mod.simple_ui, "GiveWeaponPlus must be lower than SimpleUI in your launcher's load order.")
fassert(mod.more_items_library, "GiveWeaponPlus must be lower than MoreItemsLibrary in your launcher's load order.")

-- Old widescreen font bug: SimpleUI's default font ("hell_shark", used by every widget type
-- since no per-widget-type theme overrides it) computes its size purely from screen WIDTH
-- (screen_w / 100 in simple_ui.lua's font template), with no regard for height. On any display
-- wider than the 16:9 baseline that formula assumes -- ultrawide, or even just a wide 16:9 at
-- high resolution -- that inflates font size well past what the window's fixed reference layout
-- expects. This is a known upstream SimpleUI issue, not something in this file's own layout code:
-- https://github.com/Vermintide-Mod-Framework/Grasmann-Mods/issues/14
--
-- We can't patch SimpleUI itself without affecting every other mod that uses it, so instead we
-- register our own fixed-size (non-dynamic) font and hook SimpleUI's widget factory to swap it
-- in only for widgets belonging to our own window ("give_weapon"). SimpleUI clones its window
-- prototype per window instance, but functions are copied by reference, not value, so hooking
-- the shared prototype's create_widget still lets us key off of which window each call came from.
mod.simple_ui.fonts:create("give_weapon_plus_font", "hell_shark", 22, "materials/fonts/gw_body", false)
mod:hook(mod.simple_ui.widgets.window, "create_widget", function(func, window_self, name, position, size, _type, anchor, params)
	local widget = func(window_self, name, position, size, _type, anchor, params)
	if window_self.name == "give_weapon" and widget.theme then
		widget.theme.font = "give_weapon_plus_font"
	end
	return widget
end)

-- Shrink-to-fit for dropdown text: rather than widening the boxes (which throws off the whole
-- window's layout), measure the entry's text width at our font's normal size and, if it would
-- overflow the box, temporarily shrink that one draw call's font size so it fits. render_text is
-- SimpleUI's shared base text-draw function (used by every widget type), so this only applies
-- when the widget belongs to our own window and is a dropdown/dropdown option row.
local basic_ui = get_mod("BasicUI")
local give_weapon_plus_font = mod.simple_ui.fonts.fonts["give_weapon_plus_font"]
local GWP_MIN_FONT_SIZE = 11
give_weapon_plus_font.font_size = function(self)
	return self.override_size or self.size
end
if basic_ui then
	mod:hook(mod.simple_ui.widgets.widget, "render_text", function(func, self)
		if self.window and self.window.name == "give_weapon"
		and (self._type == "dropdown" or self._type == "dropdown_item")
		and self.text and self.text ~= ""
		then
			-- Mirrors render_text's own size[2]*0.2 left padding, doubled for a symmetric right margin.
			local available_width = math.max(self.size[1] - self.size[2]*0.4, 10)
			local text_width = basic_ui:text_width(self.text, give_weapon_plus_font.material, give_weapon_plus_font.size)
			if text_width > available_width then
				give_weapon_plus_font.override_size = math.max(give_weapon_plus_font.size * (available_width / text_width), GWP_MIN_FONT_SIZE)
			end
		end
		func(self)
		give_weapon_plus_font.override_size = nil
	end)
end

mod.pos_y = -35

mod.create_skins_dropdown = function(item_type, window_size)
	mod:pcall(function()
		local all_skins = pl.List(mod.get_skins(item_type))
		mod.skin_names = tablex.pairmap(function(_, skin) return skin, Localize(WeaponSkins.skins[skin].display_name) end, all_skins)
		mod.sorted_skin_names = all_skins:map(function(skin) return Localize(WeaponSkins.skins[skin].display_name) end)

		-- it used to be each skin had an unique localized name, but not anymore
		-- so we have to do something about duplicates
		for localized_skin_name, skin_data in pairs(mod.skin_names) do
			if type(skin_data) == "table" then
				mod.skin_names[localized_skin_name] = skin_data[1]
			end
		end

		mod.sorted_skin_names = pl.Map.keys(pl.Set(mod.sorted_skin_names))

		-- Non-runed skins first, then runed, then runed_02 last -- alphabetical within each group.
		table.sort(mod.sorted_skin_names,
			function(skin_name_first, skin_name_second)
				local skin_key_first = mod.skin_names[skin_name_first]
				local skin_key_second = mod.skin_names[skin_name_second]

				if pl.stringx.lfind(skin_key_first, "_runed")
				and pl.stringx.lfind(skin_key_second, "_runed")
				then
					if pl.stringx.lfind(skin_key_first, "_runed_02")
					and pl.stringx.lfind(skin_key_second, "_runed_02")
					then
						return skin_name_first < skin_name_second
					end

					if pl.stringx.lfind(skin_key_first, "_runed_02") then
						return true
					end

					if pl.stringx.lfind(skin_key_second, "_runed_02") then
						return false
					end

					return skin_name_first < skin_name_second
				end

				if pl.stringx.lfind(skin_key_first, "_runed") then
					return true
				elseif pl.stringx.lfind(skin_key_second, "_runed") then
					return false
				else
					return skin_name_first < skin_name_second
				end
			end)
		table.insert(mod.sorted_skin_names, 1, "<no skin>")
		local skin_options = tablex.index_map(mod.sorted_skin_names)

		if mod.skins_dropdown then
			mod.skins_dropdown.visible = false
		end

		mod.skins_dropdown = mod.main_window:create_dropdown("skins_dropdown", {5+180+180+5+5+260+5+260+5+20, mod.pos_y+window_size[2]-35},  {260, 30}, nil, skin_options, "skins_dropdown", 1)
		mod.skins_dropdown:select_index(1)
	end)
end

mod.create_properties_dropdown = function(item_type, window_size)
	mod:pcall(function()
		local property_list = WeaponProperties.properties
		if mod:get(mod.SETTING_NAMES.REMOVE_CW_CONTENT) then
			property_list = {}
			for property_key, property in pairs(WeaponProperties.properties) do
				if not mod.cw_property_keys[property_key] then
					property_list[property_key] = property
				end
			end
		end
		if mod:get(mod.SETTING_NAMES.FILTER_TRAITS_PROPERTIES) then
			local valid_keys = mod:get_valid_property_keys(item_type)
			if valid_keys then
				local filtered = {}
				for property_key, property in pairs(property_list) do
					if valid_keys[property_key] then
						filtered[property_key] = property
					end
				end
				property_list = filtered
			end
		end

		mod.property_names = tablex.pairmap(
			function(property_key, _)
				local full_prop_description = UIUtils.get_property_description(property_key, 0)
				local _, _, prop_description = stringx.partition(full_prop_description, " ")
				prop_description = stringx.replace(prop_description, "Damage", "Dmg")
				if property_key == "deus_power_vs_chaos" then
					prop_description = prop_description.." (CW)"
				end
				return property_key, prop_description
			end,
			property_list
		)
		mod.sorted_property_names = tablex.pairmap(
			function(property_key, _)
				local full_prop_description = UIUtils.get_property_description(property_key, 0)
				local _, _, prop_description = stringx.partition(full_prop_description, " ")
				prop_description = stringx.replace(prop_description, "Damage", "Dmg")
				if property_key == "deus_power_vs_chaos" then
					prop_description = prop_description.." (CW)"
				end
				return prop_description
			end,
			property_list
		)
		table.sort(mod.sorted_property_names)
		table.insert(mod.sorted_property_names, 1, "<no property>")
		local properties_options = tablex.index_map(mod.sorted_property_names)

		if mod.properties_dropdown then
			mod.properties_dropdown.visible = false
		end

		mod.properties_dropdown = mod.main_window:create_dropdown("properties_dropdown", {5+180+180+5+5+260+5+20, mod.pos_y+window_size[2]-35},  {260, 30}, nil, properties_options, nil, 1)
		mod.properties_dropdown:select_index(1)
	end)
end

mod.create_traits_dropdown = function(item_type, window_size)
	mod:pcall(function()
		local trait_list = WeaponTraits.traits
		if mod:get(mod.SETTING_NAMES.REMOVE_CW_CONTENT) then
			trait_list = {}
			for trait_key, trait in pairs(WeaponTraits.traits) do
				if not mod:is_chaos_wastes_trait(trait) then
					trait_list[trait_key] = trait
				end
			end
		end
		if mod:get(mod.SETTING_NAMES.FILTER_TRAITS_PROPERTIES) then
			local valid_keys = mod:get_valid_trait_keys(item_type)
			if valid_keys then
				local filtered = {}
				for trait_key, trait in pairs(trait_list) do
					if valid_keys[trait_key] then
						filtered[trait_key] = trait
					end
				end
				trait_list = filtered
			end
		end

		mod.trait_names = tablex.pairmap(function(trait_key, trait) return trait_key, Localize(trait.display_name) end, trait_list)
		mod.sorted_trait_names = tablex.pairmap(function(trait_key, trait) -- luacheck: ignore trait_key
				return Localize(trait.display_name)
			end, trait_list)
		table.sort(mod.sorted_trait_names)
		table.insert(mod.sorted_trait_names, 1, "<no trait>")
		local traits_options = tablex.index_map(mod.sorted_trait_names)

		if mod.traits_dropdown then
			mod.traits_dropdown.visible = false
		end

		mod.traits_dropdown = mod.main_window:create_dropdown("traits_dropdown", {5+180+180+5+5+20, mod.pos_y+window_size[2]-35}, {260, 30}, nil, traits_options, nil, 1)
		mod.traits_dropdown:select_index(1)
	end)
end

mod.get_skins = function(item_type)
	local current_career_names = mod.current_careers:map(function(career) return career.name end)
	for _, item in pairs( ItemMasterList ) do
		if item.item_type == item_type
		and item.template
		and item.can_wield
		and pl.List(item.can_wield) -- check if the item is valid career-wise
			:map(function(career_name) return current_career_names:contains(career_name) end)
			:reduce('or')
		then
			if item.skin_combination_table or pl.List{"necklace", "ring", "trinket"}:contains(item_type) then
				if item.skin_combination_table then
					local all_skins = pl.List()
					tablex.foreach(WeaponSkins.skin_combinations[item.skin_combination_table], function(value)
						all_skins:extend(pl.List(value))
					end)
					return pl.Map.keys(pl.Set(all_skins))
				end
			end
		end
	end
end

-- Finds a representative ItemMasterList entry for an item_type, the same way create_weapon
-- picks which entry to build from. Used to read that item's trait_table_name/property_table_name,
-- which is what the base game itself uses to know which traits/properties are actually valid on it.
mod.find_item_for_type = function(self, item_type)
	local current_career_names = mod.current_careers:map(function(career) return career.name end)
	for _, item in pairs( ItemMasterList ) do
		if item.item_type == item_type
		and item.template
		and item.can_wield
		and pl.List(item.can_wield) -- check if the item is valid career-wise
			:map(function(career_name) return current_career_names:contains(career_name) end)
			:reduce('or')
		then
			return item
		end
	end
	return nil
end

-- Returns the set (map of key -> true) of trait keys that are actually craftable onto the
-- given item_type, per WeaponTraits.combinations[item.trait_table_name]. Returns nil if that
-- can't be determined (e.g. unknown item_type), in which case callers should show everything.
mod.get_valid_trait_keys = function(self, item_type)
	local item = mod:find_item_for_type(item_type)
	local combos = item and item.trait_table_name and WeaponTraits.combinations[item.trait_table_name]
	if not combos then
		return nil
	end

	local valid_keys = {}
	for _, combo in ipairs(combos) do
		for _, trait_key in ipairs(combo) do
			valid_keys[trait_key] = true
		end
	end
	return valid_keys
end

-- Same idea as get_valid_trait_keys, but for properties. Property combinations are bucketed
-- per rarity (common/rare/exotic/unique) rather than being one flat list like traits, so this
-- unions every rarity bucket together -- we want everything ever possible on this item, since
-- the weapon creator isn't limited to one rarity's crafting pool like normal in-game rerolling is.
mod.get_valid_property_keys = function(self, item_type)
	local item = mod:find_item_for_type(item_type)
	local combo_table = item and item.property_table_name and WeaponProperties.combinations[item.property_table_name]
	if not combo_table then
		return nil
	end

	local valid_keys = {}
	for _, rarity_combos in pairs(combo_table) do
		for _, combo in ipairs(rarity_combos) do
			for _, property_key in ipairs(combo) do
				valid_keys[property_key] = true
			end
		end
	end
	return valid_keys
end

-- Chaos Wastes (Winds of Magic DLC, internal codename "morris") traits are merged directly
-- into WeaponTraits.traits at load time, so there's no separate table to check against.
-- Every trait added by that DLC uses a "deus_"-prefixed icon though (the CW item codename),
-- while no base-game trait does, so that's what we key off of to filter them out.
mod.is_chaos_wastes_trait = function(self, trait)
	return trait.icon ~= nil and stringx.startswith(trait.icon, "deus_")
end

-- Chaos Wastes-exclusive properties don't share a consistent icon/key naming convention like
-- traits do, so they're excluded by name instead.
mod.cw_property_keys = {
	deus_power_vs_chaos = true,
	stockpile = true,
	deus_coins_greed = true,
}

mod:hook(table, "clone", function(func, t, skip_metatable)
	return func(t, true)
end)

mod.create_weapon = function(item_type, give_random_skin)
	local rarity = mod:get("displayed_rarity")

	if not mod.current_careers then
		local player = Managers.player:local_player()
		local profile_index = player:profile_index()
		mod.current_careers = pl.List(SPProfiles[profile_index].careers)
	end
	local current_career_names = mod.current_careers:map(function(career) return career.name end)
	for item_key, item in pairs( ItemMasterList ) do
		if item.item_type == item_type
		and item.template
		and item.can_wield
		and string.sub(tostring(item_key), 1, 2) ~= "vs" -- exclude versus-mode counterparts (GiveWeaponFix)
		and pl.List(item.can_wield) -- check if the item is valid career-wise
			:map(function(career_name) return current_career_names:contains(career_name) end)
			:reduce('or')
		then
			if item.skin_combination_table or pl.List{"necklace", "ring", "trinket"}:contains(item_type) then
				local skin
				if item.skin_combination_table and mod.skin_names then
					skin = mod.skin_names[mod.sorted_skin_names[mod.skins_dropdown.index]]
				end
				if give_random_skin then
					local skins = mod.get_skins(item_type)
					skin = skins[math.random(#skins)]
				end

				local custom_properties = "{"
				for _, prop_name in ipairs( mod.properties ) do
					custom_properties = custom_properties..'\"'..prop_name..'\":1,'
				end
				custom_properties = custom_properties.."}"

				local properties = {}
				for _, prop_name in ipairs( mod.properties ) do
					properties[prop_name] = 1
				end

				local custom_traits = "["
				for _, trait_name in ipairs( mod.traits ) do
					custom_traits = custom_traits..'\"'..trait_name..'\",'
				end
				custom_traits = custom_traits.."]"

				local rnd = math.random(1000000) -- uhh yeah
				local new_backend_id =  tostring(item_key) .. "_" .. rnd .. "_from_GiveWeapon"
				local entry = table.clone(ItemMasterList[item_key], true)
				entry.mod_data = {
				    backend_id = new_backend_id,
				    ItemInstanceId = new_backend_id,
				    CustomData = {
						-- traits = "[\"melee_attack_speed_on_crit\", \"melee_timed_block_cost\"]",
						traits = custom_traits,
						power_level = "300",
						properties = custom_properties,
						rarity = "exotic",
					},
					rarity = "exotic",
				    -- traits = { "melee_timed_block_cost", "melee_attack_speed_on_crit" },
				    traits = table.clone(mod.traits, true),
				    power_level = 300,
				    properties = properties,
				}
				if skin then
					entry.mod_data.CustomData.skin = skin
					entry.mod_data.skin = skin
					entry.mod_data.inventory_icon = WeaponSkins.skins[skin].inventory_icon
				end

				entry.rarity = "exotic"

				entry.rarity = "default"
				entry.mod_data.rarity = "default"
				entry.mod_data.CustomData.rarity = "default"

				mod.more_items_library:add_mod_items_to_local_backend({entry}, "GiveWeapon")

				mod:echo("Spawned "..item_key)

				Managers.backend:get_interface("items"):_refresh()

				ItemHelper.mark_backend_id_as_new(new_backend_id)

				local backend_items = Managers.backend:get_interface("items")
				local new_item = backend_items:get_item_from_id(new_backend_id)

				if rarity then
					new_item.rarity = rarity
					new_item.data.rarity = rarity
					new_item.CustomData.rarity = rarity
				end

				mod.properties = {}
				mod.traits = {}
				return new_backend_id
			end
		end
	end
end

-- Fixed hero dropdown order (Markus, Bardin, Kerillian, Victor, Sienna), independent of
-- SPProfiles' own native ordering (Witch Hunter, Bright Wizard, Dwarf Ranger, Wood Elf, Empire
-- Soldier). Matched by career-name prefix rather than a hardcoded SPProfiles index, since that's
-- the same stable per-hero identifier already used throughout this file.
local HERO_DISPLAY_ORDER = {"es_", "dr_", "we_", "wh_", "bw_"}

mod.hero_options = {}
mod.hero_profile_index_by_display_index = {}
mod.hero_display_index_by_profile_index = {}
for display_index, career_prefix in ipairs(HERO_DISPLAY_ORDER) do
	for profile_index, profile in ipairs(pl.List(SPProfiles):slice(1, 5)) do
		if stringx.startswith(profile.careers[1].name, career_prefix) then
			mod.hero_options[Localize(profile.ingame_display_name)] = display_index
			mod.hero_profile_index_by_display_index[display_index] = profile_index
			mod.hero_display_index_by_profile_index[profile_index] = display_index
			break
		end
	end
end

mod.create_item_types_dropdown = function(profile_index, window_size)
	mod.current_careers = pl.List(SPProfiles[profile_index].careers)

	local item_master_list = ItemMasterList
	local any_weapon = get_mod("AnyWeapon")
	if any_weapon then
		local cached_item_master_list = any_weapon:persistent_table("cache").ItemMasterList
		if cached_item_master_list then
			item_master_list = cached_item_master_list
		end
	end

	local melee_item_types_set = {}
	local ranged_item_types_set = {}
	for _, item in pairs( item_master_list ) do
		for _, career in ipairs( mod.current_careers ) do
			if table.contains(item.can_wield, career.name) then
				if item.slot_type == "melee" then
					melee_item_types_set[item.item_type] = true
				elseif item.slot_type == "ranged" then
					ranged_item_types_set[item.item_type] = true
				end
				break
			end
		end
	end

	-- Sort each group alphabetically by its localized (displayed) name, not the internal item_type key.
	local sort_by_localized_name = function(item_type_a, item_type_b)
		return Localize(item_type_a) < Localize(item_type_b)
	end
	local melee_item_types = tablex.keys(melee_item_types_set)
	local ranged_item_types = tablex.keys(ranged_item_types_set)
	table.sort(melee_item_types, sort_by_localized_name)
	table.sort(ranged_item_types, sort_by_localized_name)

	mod.career_item_types = pl.List(melee_item_types)
	mod.career_item_types:extend(ranged_item_types)
	mod.career_item_types:extend({"necklace", "ring", "trinket"})

	local career_item_types = mod.career_item_types:map(Localize)

	local item_types_options = tablex.index_map(career_item_types)

	if mod.item_types_dropdown then
		mod.item_types_dropdown.visible = false
	end

	mod.item_types_dropdown = mod.main_window:create_dropdown("item_types_dropdown", {5+180+5, mod.pos_y+window_size[2]-35},  {200, 30}, nil, item_types_options, "item_types_dropdown", 1)
	mod.item_types_dropdown.on_index_changed = function(dropdown)
		local item_type = mod.career_item_types[dropdown.index]
		mod.create_skins_dropdown(item_type, window_size)
		mod.create_properties_dropdown(item_type, window_size)
		mod.create_traits_dropdown(item_type, window_size)
	end
	mod.item_types_dropdown:select_index(1)
end

mod.on_create_weapon_click = function(button) -- luacheck: ignore button
	mod:pcall(function()
		local item_type = mod.career_item_types[mod.item_types_dropdown.index]
		if not item_type then return end

		local trait_name = mod.trait_names[mod.sorted_trait_names[mod.traits_dropdown.index]]
		if trait_name then
			table.insert(mod.traits, trait_name)
		end

		local backend_id = mod.create_weapon(item_type, false)
		local backend_items = Managers.backend:get_interface("items")

		if mod.loadout_inv_view then
			backend_items:_refresh()
			local inv_item_grid = mod.loadout_inv_view._item_grid
			inv_item_grid:change_item_filter(mod.item_filter, false)
			inv_item_grid:repopulate_current_inventory_page()
		end
	end)
end

mod.create_window = function(self, profile_index, loadout_inv_view)
	mod.loadout_inv_view = loadout_inv_view
	local window_size = {905+190+15+20+60, 80+32}

	-- SimpleUI's create_window already centres its 1920x1080 reference canvas within the actual
	-- screen and scales everything from there (see adjust_to_fit_position_and_scale in
	-- simple_ui.lua) -- the position we pass in is an offset from that canvas's own top-left, not
	-- from the real screen. Computing our position against the real screen_width/screen_height
	-- (like this used to) double-counts that and only happened to line up at exactly 1920x1080;
	-- expressing it as an offset from the window's own centre instead keeps it correctly placed
	-- on any resolution or aspect ratio.
	local REFERENCE_WIDTH, REFERENCE_HEIGHT = 1920, 1080
	local window_center_offset = {295, 479} -- how far right/down of screen centre the window's centre sits
	local window_position = {
		REFERENCE_WIDTH/2 + window_center_offset[1] - window_size[1]/2,
		REFERENCE_HEIGHT/2 + window_center_offset[2] - window_size[2]/2,
	}

	self.main_window = mod.simple_ui:create_window("give_weapon", window_position, window_size)
	mod.main_window:create_title("give_weapon_title", "Give Weapon Plus", 35)

	local pos_x = 5
	local pos_y = mod.pos_y

	mod.create_weapon_button = self.main_window:create_button("create_weapon_button", {pos_x+90, pos_y+window_size[2]-35-35}, {200, 30}, nil, ">Create Weapon<", nil)
	mod.create_weapon_button.on_click = mod.on_create_weapon_click

	mod.heroes_dropdown = self.main_window:create_dropdown("heroes_dropdown", {pos_x, pos_y+window_size[2]-35},  {180, 30}, nil, mod.hero_options, nil, 1)
	mod.heroes_dropdown.on_index_changed = function(dropdown)
		mod.create_item_types_dropdown(mod.hero_profile_index_by_display_index[dropdown.index], window_size)
	end
	if profile_index then
		mod.heroes_dropdown:select_index(mod.hero_display_index_by_profile_index[profile_index])
	end

	mod.add_property_button = self.main_window:create_button("add_property_button", {pos_x+180+180+5+5+260+5+40+20, pos_y+window_size[2]-70}, {180, 30}, nil, "Add Property", nil)
	mod.add_property_button.on_click = function(button) -- luacheck: ignore button
			local property_name = mod.property_names[mod.sorted_property_names[mod.properties_dropdown.index]]
			if property_name then
				table.insert(mod.properties, property_name)
			end
		end

	-- mod.add_trait_button = self.main_window:create_button("add_trait_button", {pos_x+180+180+50+5, pos_y+window_size[2]-70}, {180, 30}, nil, "Add Trait", nil)
	-- mod.add_trait_button.on_click = function(button)
	-- 		local trait_name = mod.trait_names[mod.traits_dropdown.index]
	-- 		if trait_name then
	-- 			table.insert(mod.traits, trait_name)
	-- 		end
	-- 	end

	-- Properties/traits dropdowns are (re)built per selected item type by
	-- create_properties_dropdown/create_traits_dropdown, wired into item_types_dropdown's
	-- on_index_changed above -- which also runs once here via the heroes_dropdown selection cascade.

	self.main_window.on_hover_enter = function(window)
		window:focus()
	end

	self.main_window:init()
end

-- # Track item_grid's last used item_filter
mod:hook_safe(ItemGridUI, "change_item_filter", function(self, item_filter, change_page)
    mod.item_filter = item_filter
end)

--- Create window when opening hero view.
-- Also tracks item_grid here (rather than as a separate hook_safe in SaveWeapon.lua) because VMF
-- only allows one hook per (mod, target function) pair -- now that GiveWeapon and SaveWeapon are
-- the same mod object, a second hook_safe on the same HeroWindowLoadoutInventory.on_enter from
-- SaveWeapon.lua gets silently dropped instead of stacking, like it did back when they were
-- separate mods.
mod:hook_safe(HeroWindowLoadoutInventory, "on_enter", function(self)
	local player = Managers.player:local_player()
	local profile_index = player:profile_index()
	mod:reload_windows(profile_index, self)

	mod.item_grid = self._item_grid
end)

mod.reload_windows = function(self, profile_index, loadout_inv_view)
	self:destroy_windows()
	self:create_window(profile_index, loadout_inv_view)
end

mod.destroy_windows = function(self)
	if self.main_window then
		self.main_window:destroy()
		self.main_window = nil
	end
end

mod:hook(HeroWindowLoadoutInventory, "on_exit", function(func, self)
	func(self)

	mod:destroy_windows()

	mod.item_grid = nil
end)

mod:dofile("scripts/mods/"..mod:get_name().."/wooden_2h_hammer")
mod:dofile("scripts/mods/"..mod:get_name().."/SaveWeapon")
mod:dofile("scripts/mods/"..mod:get_name().."/RanaldsImport")
