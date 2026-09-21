return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`GiveWeaponPlus` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("GiveWeaponPlus", {
			mod_script       = "scripts/mods/GiveWeaponPlus/GiveWeaponPlus",
			mod_data         = "scripts/mods/GiveWeaponPlus/GiveWeaponPlus_data",
			mod_localization = "scripts/mods/GiveWeaponPlus/GiveWeaponPlus_localization",
		})
	end,
	packages = {
		"resource_packages/GiveWeaponPlus/GiveWeaponPlus",
	},
}
