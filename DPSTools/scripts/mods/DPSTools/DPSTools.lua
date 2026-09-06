local mod = get_mod("DPSTools")

mod:dofile("scripts/mods/DPSTools/ScoreController")
mod:dofile("scripts/mods/DPSTools/MeterHud")
mod:dofile("scripts/mods/DPSTools/ScoreCollectors")

mod.scoreController = ScoreController:new(mod)
mod.meterHud = MeterHud:new(mod)

local scoreController = mod.scoreController
local meterHud = mod.meterHud

mod.update = function(dt)
    scoreController:update(dt)
end

-- Draws alongside the game's own HUD (health bars, chat, etc.) using its ui_renderer,
-- instead of a separate Imgui overlay window. See MeterHud.lua for why.
--
-- Visibility is driven off the game's own tab/player-list screen (IngamePlayerListUI
-- in PvE, VersusTabUI in Versus) rather than a manual open/close toggle - the meter
-- shows whenever that screen is up, or all the time once pinned (see
-- MeterHud.update_auto_visibility).
mod:hook_safe(IngameUI, "post_update", function(self, dt, t)
    if not self.ui_renderer then
        return
    end

    local ingame_hud = self.ingame_hud
    local tab_screen_ui = ingame_hud and (ingame_hud:component("IngamePlayerListUI") or ingame_hud:component("VersusTabUI"))
    local tab_screen_active = tab_screen_ui ~= nil and tab_screen_ui:is_active()

    meterHud:update_auto_visibility(tab_screen_active)

    if meterHud:is_visible() then
        meterHud:draw(self.ui_renderer)
    end
end)

mod.on_disabled = function()
    scoreController:clear()
end

mod.on_unload = function()
    mod.on_disabled()
end

mod.on_game_state_changed = function(status, state_name)
    if status == "enter" and state_name == "StateLoading" then
        scoreController:finish()
    end
end

mod.SaveDefaultSettings = function ()
    local widgets = mod.data.options.widgets

    local default_settings = {}

    for i = 1, #widgets do
        local widget = widgets[i]
        local setting_id = widget.setting_id
        default_settings[setting_id] = widget.default_value
    end

    mod:set("meter_width_ratio", default_settings.meter_width_ratio, true)
    mod:set("meter_height_ratio", default_settings.meter_height_ratio, true)
    mod:set("meter_window_x_ratio", default_settings.meter_window_x_ratio, true)
    mod:set("meter_window_y_ratio", default_settings.meter_window_y_ratio, true)
    mod:set("meter_background_alpha", default_settings.meter_background_alpha, true)
    mod:set("meter_rect_alpha", default_settings.meter_rect_alpha, true)
    mod:set("meter_font_scale", default_settings.meter_font_scale, true)
    mod:set("meter_tab_screen_only", default_settings.meter_tab_screen_only, true)
end
