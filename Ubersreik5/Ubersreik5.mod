return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`Ubersreik5` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("Ubersreik5", {
			mod_script       = "scripts/mods/Ubersreik5/Ubersreik5",
			mod_data         = "scripts/mods/Ubersreik5/Ubersreik5_data",
			mod_localization = "scripts/mods/Ubersreik5/Ubersreik5_localization",
		})
	end,
	packages = {
		"resource_packages/Ubersreik5/Ubersreik5",
	},
}
