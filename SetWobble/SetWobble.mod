return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`SetWobble` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("SetWobble", {
			mod_script       = "scripts/mods/SetWobble/SetWobble",
			mod_data         = "scripts/mods/SetWobble/SetWobble_data",
			mod_localization = "scripts/mods/SetWobble/SetWobble_localization",
		})
	end,
	packages = {
		"resource_packages/SetWobble/SetWobble",
	},
}
