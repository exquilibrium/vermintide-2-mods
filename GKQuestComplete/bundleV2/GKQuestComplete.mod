return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`GKQuestComplete` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("GKQuestComplete", {
			mod_script       = "scripts/mods/GKQuestComplete/GKQuestComplete",
			mod_data         = "scripts/mods/GKQuestComplete/GKQuestComplete_data",
			mod_localization = "scripts/mods/GKQuestComplete/GKQuestComplete_localization",
		})
	end,
	packages = {
		"resource_packages/GKQuestComplete/GKQuestComplete",
	},
}
