return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`DPSTools` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("DPSTools", {
			mod_script       = "scripts/mods/DPSTools/DPSTools",
			mod_data         = "scripts/mods/DPSTools/DPSTools_data",
			mod_localization = "scripts/mods/DPSTools/DPSTools_localization",
		})
	end,
	packages = {
		"resource_packages/DPSTools/DPSTools",
	},
}
