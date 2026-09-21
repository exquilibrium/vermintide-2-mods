return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`MMONames` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("MMONames", {
			mod_script       = "scripts/mods/MMONames/MMONames",
			mod_data         = "scripts/mods/MMONames/MMONames_data",
			mod_localization = "scripts/mods/MMONames/MMONames_localization",
		})
	end,
	packages = {
		"resource_packages/MMONames/MMONames",
	},
}
