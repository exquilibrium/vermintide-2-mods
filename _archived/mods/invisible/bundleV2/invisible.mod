return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`invisible` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("invisible", {
			mod_script       = "scripts/mods/invisible/invisible",
			mod_data         = "scripts/mods/invisible/invisible_data",
			mod_localization = "scripts/mods/invisible/invisible_localization",
		})
	end,
	packages = {
		"resource_packages/invisible/invisible",
	},
}
