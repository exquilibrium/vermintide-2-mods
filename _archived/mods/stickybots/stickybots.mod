return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`stickybots` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("stickybots", {
			mod_script       = "scripts/mods/stickybots/stickybots",
			mod_data         = "scripts/mods/stickybots/stickybots_data",
			mod_localization = "scripts/mods/stickybots/stickybots_localization",
		})
	end,
	packages = {
		"resource_packages/stickybots/stickybots",
	},
}
