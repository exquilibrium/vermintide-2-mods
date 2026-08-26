return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`SkipEndOfLevelLoot` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("SkipEndOfLevelLoot", {
			mod_script       = "scripts/mods/SkipEndOfLevelLoot/SkipEndOfLevelLoot",
			mod_data         = "scripts/mods/SkipEndOfLevelLoot/SkipEndOfLevelLoot_data",
			mod_localization = "scripts/mods/SkipEndOfLevelLoot/SkipEndOfLevelLoot_localization",
		})
	end,
	packages = {
		"resource_packages/SkipEndOfLevelLoot/SkipEndOfLevelLoot",
	},
}
