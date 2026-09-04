local mod = get_mod("DPSTools")
local Application = Application

mod:dofile("scripts/mods/DPS Meter/ScoreController")
mod:dofile("scripts/mods/DPS Meter/MeterImgui")
mod:dofile("scripts/mods/DPS Meter/ScoreCollectors")

mod.cached_settings = {}
mod.scoreController = ScoreController:new(mod)
mod.meterImgui = MeterImgui:new(mod)

local mod_widgets = mod.data.options.widgets
local cached_settings = mod.cached_settings
local scoreController = mod.scoreController
local meterImgui = mod.meterImgui

mod.update = function(dt)
    scoreController:update(dt)
    meterImgui:update(dt)
end

mod.on_enabled = function()
    for i = 1, #mod_widgets do
        local widget = mod_widgets[i]
        local setting_id = widget.setting_id
        cached_settings[setting_id] = mod:get(setting_id)
    end
end

mod.on_disabled = function()
    scoreController:clear()
end

mod.on_unload = function()
    mod.on_disabled()
end

mod.on_setting_changed = function(setting_id)
    cached_settings[setting_id] = mod:get(setting_id)

    meterImgui:refresh_size_and_position()
end

mod.on_game_state_changed = function(status, state_name)
    if status == "enter" and state_name == "StateLoading" then
        scoreController:finish()
    end
end

mod.on_meter_keypressed = function()
    if meterImgui:is_visible() then
        mod.close_meter_ui()
    else
        mod.open_meter_ui()
    end
end

mod.on_meter_reset_keypressed = function()
    if cached_settings.meter_disable_reset_keybind then
        return
    end

    mod.SaveDefaultSettings()
    meterImgui:refresh_size_and_position()
end

mod.open_meter_ui = function()
    if Application.user_setting("fullscreen") then
        mod:echo("You can't use this mod for fullscreen.")
        return
    end

    meterImgui:set_visible(true)
    meterImgui:unlock_input()
end

mod.close_meter_ui = function()
    if Application.user_setting("fullscreen") then
        mod:echo("You can't use this mod for fullscreen.")
        return
    end

    meterImgui:set_visible(false)
    meterImgui:lock_input()
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

mod:command("dpsgui", " DPS Meter ImGui", function()
    mod.open_meter_ui()
end)

mod:command("forcedpsclose", " Force the ImGui to close", function()
    mod.close_meter_ui()
end)
