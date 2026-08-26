return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`movespeed` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("movespeed", {
			mod_script       = "scripts/mods/movespeed/movespeed",
			mod_data         = "scripts/mods/movespeed/movespeed_data",
			mod_localization = "scripts/mods/movespeed/movespeed_localization",
		})
	end,
	packages = {
		"resource_packages/movespeed/movespeed",
	},
}
