--[[

	=====================================
	= RANALDS.GIFT BUILD LINK IMPORTER  =
	=====================================

	Adds "/gwp_import <link>" -- given a ranalds.gift build-share link, crafts (or reuses
	already-saved) items matching the linked weapons/necklace/charm/trinket and their
	properties/trait, equips them on the linked career, and sets that career's talents to
	match (clearing any tier the build didn't pick a talent for).

	Link format: https://www.ranalds.gift/heroes/{careerId}/{talents}/{primary}/{secondary}/{necklace}/{charm}/{trinket}
		careerId            : numeric id -> VT2 career codename (RANALDS_CAREERS below)
		talents             : 6 digits, one per talent tier, each 0-3 (0 = no talent picked
		                      that tier, 1-3 = which option column). This is literally the same
		                      format the game's own talent backend expects (see
		                      HeroWindowTalents._selected_talents[row] = column in the base
		                      game source), so it's used as-is with zero transformation.
		primary/secondary   : "{weaponId}-{property1Id}-{property2Id}-{traitId}"
		necklace/charm/trinket : "{property1Id}-{property2Id}-{traitId}" (no weapon selection
		                      for these slots -- ranalds.gift calls the ring slot "charm")

	The live ranalds.gift site (the one that actually serves these links) turned out to be an
	older, separately-deployed build rather than the SvelteKit source under ranalds.gift2-main
	-- but that repo's src/lib/data/legacy/* files are a faithful port of that older site's
	static id tables (verified empirically: weapon id 14 in an example link renders as "Mace",
	i.e. es_1h_mace, matching WeaponsDataMap.ts exactly), so those are the tables baked in below.
	Skins are never part of any ranalds.gift link format, so newly-crafted weapons instead get a
	random skin from their own skin_combination_table (same pool as GiveWeaponPlus's own "random
	skin" option); items reused from your inventory or from an already-saved craft keep whatever
	skin they already have.

]]--

local mod = get_mod("GiveWeaponPlus")

-- careerId -> VT2 career codename (ranalds.gift2-main: src/lib/data/legacy/HeroesDataMap.ts)
mod.ranalds_careers = {
	[1] = "es_mercenary", [2] = "es_huntsman", [3] = "es_knight", [16] = "es_questingknight",
	[4] = "dr_ranger", [5] = "dr_ironbreaker", [6] = "dr_slayer", [17] = "dr_engineer",
	[7] = "we_waywatcher", [8] = "we_maidenguard", [9] = "we_shade", [18] = "we_thornsister",
	[10] = "wh_captain", [11] = "wh_bountyhunter", [12] = "wh_zealot", [19] = "wh_priest",
	[13] = "bw_adept", [14] = "bw_scholar", [15] = "bw_unchained", [20] = "bw_necromancer",
}

-- weaponId -> VT2 item_type (ranalds.gift2-main: src/lib/data/legacy/WeaponsDataMap.ts)
-- NOTE: values are the ItemMasterList *item_type* field, which for several weapons differs from
-- the ItemMasterList *key* the game happens to store that entry under (e.g. key "dr_shield_axe"
-- has item_type "dr_1h_axe_shield") -- verified entry-by-entry against item_master_list_exported.lua
-- and the DLC item_master_list_*.lua files, since find_item_key_for_career (below) matches on
-- item.item_type, not on the ItemMasterList key.
mod.ranalds_weapons = {
	[1] = "bw_morningstar", [2] = "bw_1h_dagger", [3] = "bw_flame_sword", [4] = "bw_1h_sword",
	[5] = "dr_1h_axes", [6] = "dr_1h_hammer", [7] = "dr_2h_axes", [8] = "dr_2h_hammer", [9] = "dr_2h_picks",
	[10] = "dr_dual_axes", [11] = "dr_1h_axe_shield", [12] = "dr_1h_hammer_shield",
	[13] = "es_flail", [14] = "es_1h_mace", [15] = "es_1h_sword", [16] = "es_2h_war_hammer", [17] = "es_2h_sword",
	[18] = "es_2h_sword_executioner", [19] = "es_2h_halberd", [20] = "es_1h_mace_shield", [21] = "es_1h_sword_shield",
	[22] = "ww_1h_sword", [23] = "ww_2h_axe", [24] = "ww_2h_sword", [25] = "ww_dual_daggers",
	[26] = "ww_sword_and_dagger", [27] = "ww_dual_swords", [28] = "we_2h_spear",
	[29] = "wh_1h_axes", [30] = "wh_1h_falchions", [31] = "wh_2h_sword", [32] = "wh_fencing_sword",
	[33] = "es_dual_wield_hammer_sword", [34] = "es_2h_heavy_spear", [35] = "we_1h_axe", [36] = "we_1h_spears_shield",
	[37] = "dr_dual_wield_hammers", [38] = "wh_dual_wield_axe_falchion", [39] = "wh_2h_billhook",
	[40] = "bw_1h_crowbill", [41] = "bw_1h_flail_flaming", [42] = "es_1h_sword_shield_breton", [43] = "es_bastard_sword",
	[44] = "dr_cog_hammer", [45] = "bw_staff_beam", [46] = "bw_staff_firball",
	[47] = "bw_staff_flamethrower", [48] = "bw_staff_geiser", [49] = "bw_staff_spear",
	[50] = "dr_crossbow", [51] = "dr_drakefire_pistols", [52] = "dr_drakegun", [53] = "dr_handgun", [54] = "dr_grudgeraker",
	[55] = "es_blunderbuss", [56] = "es_handgun", [57] = "ww_longbow", [58] = "es_repeating_handgun",
	[59] = "wh_repeating_crossbow", [60] = "ww_longbow", [61] = "ww_shortbow", [62] = "ww_hagbane",
	[63] = "wh_brace_of_pisols", [64] = "wh_crossbow", [65] = "wh_repeating_crossbow", [66] = "wh_repeating_pistol",
	[67] = "dr_1h_throwing_axes", [68] = "dr_steam_pistol", [69] = "es_deus_01", [70] = "dr_deus_01",
	[71] = "we_deus_01", [72] = "wh_deus_01", [73] = "bw_deus_01", [74] = "we_life_staff", [75] = "we_javelin",
	[76] = "wh_1h_hammer", [77] = "wh_2h_hammer", [78] = "wh_hammer_shield", [79] = "wh_dual_hammer",
	[80] = "wh_hammer_book", [81] = "wh_flail_shield", [82] = "bw_ghost_scythe", [83] = "bw_necromancy_staff",
}

-- property category (ranalds.gift2-main: src/lib/data/legacy/Properties.ts) -> {id -> VT2 property key}.
-- "melee"/"range" cover weapons (picked below by the resolved weapon's own slot_type);
-- necklace/charm/trinket are fixed categories for those slots (VT2 calls the "charm" slot
-- "ring" internally).
mod.ranalds_properties = {
	melee = {
		[1] = "attack_speed", [2] = "stamina", [3] = "block_cost", [4] = "crit_chance",
		[5] = "crit_boost", [6] = "push_block_arc", [7] = "power_vs_skaven", [8] = "power_vs_chaos",
	},
	range = {
		[1] = "crit_chance", [2] = "crit_boost", [3] = "power_vs_skaven", [4] = "power_vs_chaos",
		[5] = "power_vs_unarmoured", [6] = "power_vs_armoured", [7] = "power_vs_frenzy", [8] = "power_vs_large",
	},
	necklace = {
		[1] = "stamina", [2] = "block_cost", [3] = "health", [4] = "push_block_arc",
		[5] = "protection_skaven", [6] = "protection_chaos", [7] = "protection_aoe",
	},
	charm = {
		[1] = "attack_speed", [2] = "crit_boost", [3] = "power_vs_skaven", [4] = "power_vs_chaos",
		[5] = "power_vs_unarmoured", [6] = "power_vs_armoured", [7] = "power_vs_frenzy", [8] = "power_vs_large",
	},
	trinket = {
		[1] = "ability_cooldown_reduction", [2] = "crit_chance", [3] = "curse_resistance",
		[4] = "movespeed", [5] = "respawn_speed", [6] = "revive_speed", [7] = "fatigue_regen",
	},
}

-- trait category (matches VT2's own trait_table_name values exactly) -> {id -> VT2 trait key}.
-- Source: ranalds.gift2-main: src/lib/data/legacy/TraitsDataMap.ts, cross-checked against
-- mod.trait_name_table in SaveWeapon_utilities.lua for exact key spelling.
mod.ranalds_traits = {
	melee = {
		[1] = "melee_shield_on_assist", [2] = "melee_increase_damage_on_block", [3] = "melee_counter_push_power",
		[4] = "melee_timed_block_cost", [5] = "melee_reduce_cooldown_on_crit", [6] = "melee_attack_speed_on_crit",
	},
	ranged_ammo = {
		[1] = "ranged_consecutive_hits_increase_power", [2] = "ranged_replenish_ammo_headshot",
		[3] = "ranged_increase_power_level_vs_armour_crit", [4] = "ranged_restore_stamina_headshot",
		[5] = "ranged_reduce_cooldown_on_crit", [6] = "ranged_replenish_ammo_on_crit",
	},
	ranged_heat = {
		[1] = "ranged_consecutive_hits_increase_power", [2] = "ranged_remove_overcharge_on_crit",
		[3] = "ranged_increase_power_level_vs_armour_crit", [4] = "ranged_restore_stamina_headshot",
		[5] = "ranged_reduce_cooldown_on_crit", [6] = "ranged_reduced_overcharge",
	},
	ranged_energy = {
		[1] = "ranged_consecutive_hits_increase_power",
		[3] = "ranged_increase_power_level_vs_armour_crit", [4] = "ranged_restore_stamina_headshot",
		[5] = "ranged_reduce_cooldown_on_crit",
	},
	defence_accessory = {
		[1] = "necklace_damage_taken_reduction_on_heal", [2] = "necklace_heal_self_on_heal_other",
		[3] = "necklace_not_consume_healing", [4] = "necklace_no_healing_health_regen",
		[5] = "necklace_increased_healing_received",
	},
	offence_accessory = {
		[1] = "ring_all_potions", [2] = "ring_potion_duration", [3] = "ring_not_consume_potion",
		[4] = "ring_potion_spread",
	},
	utility_accessory = {
		[1] = "trinket_increase_grenade_radius", [2] = "trinket_not_consume_grenade",
		[3] = "trinket_grenade_damage_taken",
	},
}


--	___________________
--	# LINK PARSING #
--	¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

-- Splits a dash-separated segment (e.g. "14-1-2-1") into numbers.
mod.split_dashes = function(self, str)
	local parts = {}
	for part in string.gmatch(str, "[^-]+") do
		table.insert(parts, tonumber(part))
	end
	return parts
end

-- Parses a ranalds.gift build link's 7 path segments.
-- Returns career_id, talents_str, primary_str, secondary_str, necklace_str, charm_str, trinket_str
-- on success, or nil plus an error message on failure.
mod.parse_ranalds_link = function(self, link)
	local path = string.match(link, "ranalds%.gift/heroes/([^%?%s]+)")
	if not path then
		return nil, nil, nil, nil, nil, nil, nil, "not a ranalds.gift build link"
	end
	path = string.gsub(path, "/+$", "")

	local segments = {}
	for segment in string.gmatch(path, "[^/]+") do
		table.insert(segments, segment)
	end
	if #segments ~= 7 then
		return nil, nil, nil, nil, nil, nil, nil,
			"unrecognized link format (expected 7 path segments, got " .. #segments .. ")"
	end

	local career_id = tonumber(segments[1])
	if not career_id then
		return nil, nil, nil, nil, nil, nil, nil, "invalid career id"
	end

	return career_id, segments[2], segments[3], segments[4], segments[5], segments[6], segments[7]
end


--	___________________
--	# ITEM RESOLUTION #
--	¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

-- Finds the specific ItemMasterList key for an item_type that the given career can wield.
-- Unlike mod.find_item_for_type (used by the UI, scoped to mod.current_careers), this takes
-- an explicit career_name so importing a build works regardless of which hero is currently
-- being played/viewed in the GiveWeaponPlus UI.
mod.find_item_key_for_career = function(self, item_type, career_name)
	for item_key, item in pairs(ItemMasterList) do
		if item.item_type == item_type
		and item.template
		and item.can_wield
		and string.sub(tostring(item_key), 1, 2) ~= "vs" -- exclude versus-mode counterparts (GiveWeaponFix)
		and table.contains(item.can_wield, career_name)
		then
			return item_key, item
		end
	end
	return nil, nil
end

-- Resolves one build slot (a weapon, or necklace/charm/trinket) into a concrete item_key plus
-- VT2 property/trait keys. property_category/trait_category are fixed for accessory slots;
-- for weapon slots (left nil by the caller) they're derived from the resolved weapon's own
-- slot_type/trait_table_name, since "primary"/"secondary" don't always mean melee/ranged
-- (e.g. Slayer and Grail Knight can have a melee weapon in the secondary slot).
mod.resolve_slot_item = function(self, item_type, career_name, property_ids, trait_id, property_category, trait_category)
	local item_key, item = mod:find_item_key_for_career(item_type, career_name)
	if not item_key then
		return nil, "no \"" .. item_type .. "\" item found for " .. career_name
	end

	if not property_category then
		property_category = (item.slot_type == "melee") and "melee" or "range"
	end
	if not trait_category then
		trait_category = item.trait_table_name
	end

	local property_keys = {}
	local property_table = mod.ranalds_properties[property_category]
	for _, prop_id in ipairs(property_ids) do
		local key = property_table and property_table[prop_id]
		if key then
			table.insert(property_keys, key)
		end
	end
	-- A weapon can only have each property once, so property1/property2 are really an unordered
	-- set -- sort them so "atk_speed,bcr" and "bcr,atk_speed" produce the identical savestring
	-- and correctly dedup against each other instead of crafting two "different" items.
	table.sort(property_keys)

	local trait_table = trait_category and mod.ranalds_traits[trait_category]
	local trait_key = trait_table and trait_table[trait_id]

	return {
		item_key = item_key,
		item = item,
		property_keys = property_keys,
		trait_key = trait_key,
	}
end

-- Picks a random skin key from an item's own skin_combination_table, the same pool
-- mod.create_weapon's "random skin" option draws from (see GiveWeaponPlus.lua). Necklace/ring/
-- trinket entries have no skin_combination_table (each cosmetic variant is its own ItemMasterList
-- key instead, already baked into item_key), so this returns nil for those -- same as picking
-- "no skin" -- rather than crafting fails.
mod.get_random_skin_for_item = function(self, item)
	if not item.skin_combination_table then
		return nil
	end

	local all_skins = {}
	for _, combo in pairs(WeaponSkins.skin_combinations[item.skin_combination_table]) do
		for _, skin_key in ipairs(combo) do
			table.insert(all_skins, skin_key)
		end
	end
	if #all_skins == 0 then
		return nil
	end

	return all_skins[math.random(#all_skins)]
end


--	___________________________
--	# OWNED ITEM MATCHING #
--	¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

-- Looks for an already-owned, non-modded ("official realm") item matching item_key/trait/
-- properties exactly, so importing a build prefers gear the player actually earned over crafting
-- a new GiveWeapon one. backend_items._items is the same "every owned item" table find_base_item
-- (SaveWeapon_utilities.lua) already iterates, and item.traits/item.properties are populated the
-- same way for real and modded items alike (see BackendInterfaceItemPlayfab.get_traits in the
-- base game source).
mod.find_owned_item = function(self, item_key, trait_key, property_keys)
	local backend_items = Managers.backend:get_interface("items")
	local wants_no_trait = (trait_key == nil or trait_key == "")

	-- Necklace/ring/trinket aren't one canonical key with a swappable skin like weapons are --
	-- ItemMasterList has a genuinely separate entry per cosmetic variant ("ring", "ring_02", ...,
	-- "ring_10"), all sharing item_type "ring". find_item_key_for_career just returns whichever
	-- ItemMasterList happens to iterate to first for that item_type, so the item_key we're asked
	-- to match can itself already be a numbered variant like "ring_07", not just plain "ring".
	-- So detect the category by prefix on BOTH sides (target item_key and each owned item's key),
	-- the same reduction find_base_item (SaveWeapon_utilities.lua) already does.
	local accessory_category = nil
	for _, category in ipairs({"necklace", "ring", "trinket"}) do
		if string.sub(item_key, 1, #category) == category then
			accessory_category = category
			break
		end
	end

	for backend_id, item in pairs(backend_items._items) do
		local item_matches_key
		if accessory_category then
			item_matches_key = (string.sub(item.key, 1, #accessory_category) == accessory_category)
		else
			item_matches_key = (item.key == item_key)
		end

		if item_matches_key and not mod:is_backend_id_from_mod(backend_id) then
			local item_traits = item.traits or {}
			local trait_matches
			if wants_no_trait then
				trait_matches = (#item_traits == 0)
			else
				trait_matches = (#item_traits == 1 and item_traits[1] == trait_key)
			end

			if trait_matches then
				local item_properties = item.properties or {}
				local item_property_count = 0
				for _ in pairs(item_properties) do
					item_property_count = item_property_count + 1
				end

				if item_property_count == #property_keys then
					local properties_match = true
					for _, key in ipairs(property_keys) do
						if not item_properties[key] then
							properties_match = false
							break
						end
					end
					if properties_match then
						return backend_id
					end
				end
			end
		end
	end
	return nil
end


--	_________________________
--	# CRAFTING WITH DEDUP #
--	¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

-- Crafts an item with the given trait/properties/skin, reusing an already-saved one if an
-- identical item (same item_key, same trait+properties+skin) has already been crafted and saved.
-- Returns the item's backend_id and whether it was newly crafted (false if reused).
mod.craft_or_reuse_item = function(self, item_key, trait_key, property_keys, skin)
	-- generate_item_string concatenates the (shortened) trait name directly, which errors on a
	-- nil trait -- pass "" instead, which round-trips safely (just resolves to "no trait" on load).
	local savestring = mod:generate_item_string(skin, trait_key or "", property_keys)

	for save_id, existing_savestring in pairs(mod.saved_items) do
		if existing_savestring == savestring then
			local backend_id = save_id .. "_from_GiveWeapon"
			if mod:get_item_name_from_save_id(backend_id) == item_key then
				if not mod:verify_backend_id(backend_id) then
					mod:create_saved_item(backend_id, existing_savestring)
				end
				return backend_id, false
			end
		end
	end

	local rnd = math.random(1000000)
	local new_backend_id = tostring(item_key) .. "_" .. rnd .. "_from_GiveWeapon"
	local created = mod:create_saved_item(new_backend_id, savestring)
	if not created then
		return nil, false
	end
	mod:save_item(new_backend_id, savestring)
	return new_backend_id, true
end


--	_________________
--	# EQUIPPING #
--	¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

-- Equips an item into a career/slot, syncing the live in-world unit if that career is the one
-- currently being played -- the same three-way branching mod.unequip_item already uses (hero
-- view open on that exact career / actively playing that career / a background career).
mod.equip_item = function(self, backend_id, career_name, slot_name)
	local player = Managers.player:local_player()
	local player_unit = player.player_unit
	local career_extension = ScriptUnit.extension(player_unit, "career_system")
	local current_career = career_extension:career_name()
	local backend_items = Managers.backend:get_interface("items")

	if mod.hero_view and mod.hero_view.career_name == career_name then
		local item = backend_items:get_item_from_id(backend_id)
		mod.hero_view:_set_loadout_item(item, slot_name)
	elseif (not mod.hero_view and career_name == current_career)
	or (mod.hero_view and career_name == current_career and mod.hero_view.career_name ~= current_career)
	then
		backend_items:set_loadout_item(backend_id, career_name, slot_name)
		if slot_name == "slot_ranged" or slot_name == "slot_melee" then
			local inventory_extension = ScriptUnit.extension(player_unit, "inventory_system")
			inventory_extension:create_equipment_in_slot(slot_name, backend_id)
		else
			local attachment_extension = ScriptUnit.extension(player_unit, "attachment_system")
			attachment_extension:create_attachment_in_slot(slot_name, backend_id)
		end
	else
		backend_items:set_loadout_item(backend_id, career_name, slot_name)
	end
end

-- Sets a career's talents to exactly the given 6-tier array (each 0-3; 0 clears that tier),
-- syncing the live unit if that career is the one currently being played.
mod.equip_talents = function(self, career_name, talents)
	Managers.backend:get_interface("talents"):set_talents(career_name, talents)

	local player = Managers.player:local_player()
	local player_unit = player and player.player_unit
	local career_extension = player_unit and ScriptUnit.extension(player_unit, "career_system")
	local current_career = career_extension and career_extension:career_name()

	if player_unit and Unit.alive(player_unit) and current_career == career_name then
		ScriptUnit.extension(player_unit, "talent_system"):talents_changed()
		ScriptUnit.extension(player_unit, "inventory_system"):apply_buffs_to_ammo()
	end
end


--	___________________
--	# IMPORT COMMAND #
--	¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

mod.import_ranalds_build = function(self, link)
	local career_id, talents_str, primary_str, secondary_str, necklace_str, charm_str, trinket_str, parse_err
		= mod:parse_ranalds_link(link)
	if not career_id then
		mod:echo("[GiveWeaponPlus] Import failed: " .. tostring(parse_err))
		return
	end

	local career_name = mod.ranalds_careers[career_id]
	if not career_name then
		mod:echo("[GiveWeaponPlus] Import failed: unrecognized career id " .. tostring(career_id))
		return
	end

	if string.len(talents_str) ~= 6 then
		mod:echo("[GiveWeaponPlus] Import failed: talent string should be 6 digits.")
		return
	end
	local talents = {}
	for i = 1, 6 do
		local digit = tonumber(string.sub(talents_str, i, i))
		if not digit or digit < 0 or digit > 3 then
			mod:echo("[GiveWeaponPlus] Import failed: invalid talent value at tier " .. i .. ".")
			return
		end
		talents[i] = digit
	end

	local primary_parts = mod:split_dashes(primary_str)
	local secondary_parts = mod:split_dashes(secondary_str)
	local necklace_parts = mod:split_dashes(necklace_str)
	local charm_parts = mod:split_dashes(charm_str)
	local trinket_parts = mod:split_dashes(trinket_str)
	if #primary_parts ~= 4 or #secondary_parts ~= 4
	or #necklace_parts ~= 3 or #charm_parts ~= 3 or #trinket_parts ~= 3
	then
		mod:echo("[GiveWeaponPlus] Import failed: malformed item segment in link.")
		return
	end

	local primary_item_type = mod.ranalds_weapons[primary_parts[1]]
	local secondary_item_type = mod.ranalds_weapons[secondary_parts[1]]
	if not primary_item_type or not secondary_item_type then
		mod:echo("[GiveWeaponPlus] Import failed: unrecognized weapon id in link.")
		return
	end

	-- "primary"/"secondary" map positionally to slot_melee/slot_ranged (matching how
	-- ranalds.gift itself models them) regardless of which slot_type the weapon actually is --
	-- the game itself allows a melee weapon in slot_ranged for Slayer/Grail Knight.
	local slot_specs = {
		{ slot_name = "slot_melee", item_type = primary_item_type,
			property_ids = {primary_parts[2], primary_parts[3]}, trait_id = primary_parts[4] },
		{ slot_name = "slot_ranged", item_type = secondary_item_type,
			property_ids = {secondary_parts[2], secondary_parts[3]}, trait_id = secondary_parts[4] },
		{ slot_name = "slot_necklace", item_type = "necklace",
			property_ids = {necklace_parts[1], necklace_parts[2]}, trait_id = necklace_parts[3],
			property_category = "necklace", trait_category = "defence_accessory" },
		{ slot_name = "slot_ring", item_type = "ring",
			property_ids = {charm_parts[1], charm_parts[2]}, trait_id = charm_parts[3],
			property_category = "charm", trait_category = "offence_accessory" },
		{ slot_name = "slot_trinket_1", item_type = "trinket",
			property_ids = {trinket_parts[1], trinket_parts[2]}, trait_id = trinket_parts[3],
			property_category = "trinket", trait_category = "utility_accessory" },
	}

	local resolved_slots = {}
	for _, spec in ipairs(slot_specs) do
		local resolved, err = mod:resolve_slot_item(spec.item_type, career_name, spec.property_ids, spec.trait_id,
			spec.property_category, spec.trait_category)
		if not resolved then
			mod:echo("[GiveWeaponPlus] Import failed: " .. tostring(err))
			return
		end
		resolved.slot_name = spec.slot_name
		table.insert(resolved_slots, resolved)
	end

	local owned_count = 0
	local crafted_count = 0
	local reused_count = 0
	for _, slot in ipairs(resolved_slots) do
		local owned_backend_id = mod:find_owned_item(slot.item_key, slot.trait_key, slot.property_keys)
		if owned_backend_id then
			slot.backend_id = owned_backend_id
			owned_count = owned_count + 1
		else
			local skin = mod:get_random_skin_for_item(slot.item)
			local backend_id, was_new = mod:craft_or_reuse_item(slot.item_key, slot.trait_key, slot.property_keys, skin)
			if not backend_id then
				mod:echo("[GiveWeaponPlus] Import failed: couldn't craft \"" .. slot.item_key .. "\".")
				return
			end
			slot.backend_id = backend_id
			if was_new then
				crafted_count = crafted_count + 1
			else
				reused_count = reused_count + 1
			end
		end
	end

	for _, slot in ipairs(resolved_slots) do
		mod:equip_item(slot.backend_id, career_name, slot.slot_name)
	end

	mod:equip_talents(career_name, talents)

	Managers.backend:get_interface("items"):_refresh()

	mod:echo("[GiveWeaponPlus] Imported build for " .. career_name .. " (" .. owned_count .. " from your inventory, " .. crafted_count .. " crafted, " .. reused_count .. " reused).")
end

mod:command("gwp_import", "Import and equip a build from a ranalds.gift link", function(link)
	mod:pcall(function()
		if not link or link == "" then
			mod:echo("[GiveWeaponPlus] Usage: /gwp_import <ranalds.gift link>")
			return
		end
		mod:import_ranalds_build(link)
	end)
end)
