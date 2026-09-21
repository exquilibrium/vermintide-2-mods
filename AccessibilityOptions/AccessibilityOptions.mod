return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`AccessibilityOptions` mod must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("AccessibilityOptions", {
			mod_script       = "scripts/mods/AccessibilityOptions/AccessibilityOptions",
			mod_data         = "scripts/mods/AccessibilityOptions/AccessibilityOptions_data",
			mod_localization = "scripts/mods/AccessibilityOptions/AccessibilityOptions_localization",
		})
	end,
	packages = {
		"resource_packages/AccessibilityOptions/AccessibilityOptions",
	},
}
