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
mod:hook_safe(IngameUI, "post_update", function(self, dt, t)
    if meterHud:is_visible() and self.ui_renderer then
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

mod.on_meter_keypressed = function()
    if meterHud:is_visible() then
        mod.close_meter_ui()
    else
        mod.open_meter_ui()
    end
end

mod.on_meter_reset_keypressed = function()
    if mod:get("meter_disable_reset_keybind") then
        return
    end

    mod.SaveDefaultSettings()
end

mod.open_meter_ui = function()
    meterHud:set_visible(true)
end

mod.close_meter_ui = function()
    meterHud:set_visible(false)
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
end

mod:command("dpsgui", " Open the DPS Meter", function()
    mod.open_meter_ui()
end)

mod:command("forcedpsclose", " Force the DPS Meter to close", function()
    mod.close_meter_ui()
end)

mod:command("dpsstart", " Start the DPS Meter timer", function()
    scoreController:start()
end)

mod:command("dpsend", " Stop the DPS Meter timer", function()
    scoreController:finish()
end)

mod:command("dpsclear", " Clear the DPS Meter's recorded scores", function()
    scoreController:clear()
end)

mod:command("dpsdefault", " Reset the DPS Meter's size/position/appearance to default", function()
    mod.SaveDefaultSettings()
end)

mod:command("dpsmode", " Switch the DPS Meter's display mode. Usage: /dpsmode <dps|hps>", function(requested_mode)
    if requested_mode ~= "dps" and requested_mode ~= "hps" then
        mod:echo("Usage: /dpsmode <dps|hps>")

        return
    end

    meterHud:set_mode(requested_mode)
    scoreController:set_mode(requested_mode)
end)
