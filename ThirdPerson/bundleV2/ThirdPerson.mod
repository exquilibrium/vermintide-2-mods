return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`ThirdPerson` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("ThirdPerson", {
			mod_script       = "scripts/mods/ThirdPerson/ThirdPerson",
			mod_data         = "scripts/mods/ThirdPerson/ThirdPerson_data",
			mod_localization = "scripts/mods/ThirdPerson/ThirdPerson_localization",
		})
	end,
	packages = {
		"resource_packages/ThirdPerson/ThirdPerson",
	},
}
