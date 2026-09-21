local mod = get_mod("AccessibilityOptions")

-- Lifecycle-hook dispatchers.
-- VMF calls each of these as a single field on the mod, so only one file could assign it
-- directly - whichever dofile ran last would silently win over any earlier submodule. Submodules
-- register through `mod:add_<hook>_function(fn)` instead of assigning the field themselves, so
-- multiple submodules can all react to the same lifecycle event independently.
local function make_dispatcher(hook_name, adder_name)
	local functions = {}
	mod[adder_name] = function(self, func)
		functions[#functions + 1] = func
	end
	mod[hook_name] = function(...)
		for i = 1, #functions do
			functions[i](...)
		end
	end
end

make_dispatcher("update", "add_update_function")
make_dispatcher("on_all_mods_loaded", "add_all_mods_loaded_function")
make_dispatcher("on_setting_changed", "add_setting_changed_function")
make_dispatcher("on_game_state_changed", "add_game_state_changed_function")

-- Engine-hook dispatcher.
-- Same single-registration problem as the VMF lifecycle hooks above, but for a shared engine class
-- method instead of a mod field: hooking the exact same (class, method) via mod:hook/mod:hook_safe
-- from more than one file in this mod silently drops all but one registration (confirmed the hard
-- way porting Tourney-Balance-Open-Beta's mod:hook_safe(IngameHud, "update", ...) duplication).
-- AccessibilityCaptions and SoundCues both need to observe AudioSystem._play_event, so it's hooked
-- once here; submodules register through mod:add_play_event_function(fn) instead of hooking it
-- directly themselves.
local _play_event_functions = {}
function mod.add_play_event_function(self, func)
	_play_event_functions[#_play_event_functions + 1] = func
end
mod:hook_safe(AudioSystem, "_play_event", function(self, event, unit, object_id)
	for i = 1, #_play_event_functions do
		_play_event_functions[i](self, event, unit, object_id)
	end
end)

-- Same again for AI extension init (fires once per spawned enemy unit) - AccessibilityCaptions and
-- SoundCues both need it too. Both AISimpleExtension and AiHuskBaseExtension route through this one
-- shared fan-out, matching how AccessibilityCaptions itself already treated the two identically.
local _ai_extension_init_functions = {}
function mod.add_ai_extension_init_function(self, func)
	_ai_extension_init_functions[#_ai_extension_init_functions + 1] = func
end
local function dispatch_ai_extension_init(self, extension_init_context, unit, extension_init_data)
	for i = 1, #_ai_extension_init_functions do
		_ai_extension_init_functions[i](self, extension_init_context, unit, extension_init_data)
	end
end
mod:hook_safe(AISimpleExtension, "init", dispatch_ai_extension_init)
mod:hook_safe(AiHuskBaseExtension, "init", dispatch_ai_extension_init)

mod:dofile("scripts/mods/AccessibilityOptions/AccessibilityCaptions")
mod:dofile("scripts/mods/AccessibilityOptions/OutlineOptions")
mod:dofile("scripts/mods/AccessibilityOptions/SoundControl")
mod:dofile("scripts/mods/AccessibilityOptions/VisualAid")
