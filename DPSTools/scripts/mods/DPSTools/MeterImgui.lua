local Imgui = Imgui
local Application = Application
local MathfLerp = math.lerp
local MathfMin = math.min
local MathfFloor = math.floor
local StringFormat = string.format

local function FormatTime(seconds)
    seconds = MathfFloor(seconds)

    return StringFormat("%03d:%02d", seconds / 60, seconds % 60)
end

local function FormatScore(score_element, score)
    local text
    if score_element.use_float then
        text = StringFormat("%.2f", score)
    else
        text = tostring(score)
    end
    return text
end

MeterImgui = class(MeterImgui)

MeterImgui.init = function(self, mod)
    self._mod = mod
    self._scoreController = mod.scoreController
    self._mod_setttings = mod.cached_settings

    self._meters_template = mod.meter_templates
    self._option_template = mod.meter_option_template

    self._restriction_ratio = mod.restriction_ratio
    self._max_restriction = mod.max_restriction

    self._mode = ""
    self._current_meter_template = {}

    self._visible = false
    self._should_refresh = false

    self:set_mode("dps")
end

MeterImgui.update = function(self, dt)
    if not self._visible then
        return
    end

    local settings = self._mod_setttings

    if self._should_refresh then
        local restriction_ratio = self._restriction_ratio
        local max_restriction = self._max_restriction

        local x_ratio, y_ratio = settings.meter_window_x_ratio, settings.meter_window_y_ratio
        local w_ratio, h_ratio = settings.meter_width_ratio, settings.meter_height_ratio

        local w, h = Application.resolution()
        local half_w, half_h = w / 2, h / 2
        local margin_w, margin_h = half_w * restriction_ratio, half_h * restriction_ratio

        margin_w = MathfMin(max_restriction, margin_w)
        margin_h = MathfMin(max_restriction, margin_h)

        local start_x, end_x = margin_w, w - margin_w
        local start_y, end_y = margin_h, h - margin_h

        local calculated_w = MathfLerp(0, w - margin_w * 2, w_ratio)
        local calculated_h = MathfLerp(0, h - margin_h * 2, h_ratio)

        local calculated_x = MathfLerp(start_x, end_x - calculated_w, x_ratio)
        local calculated_y = MathfLerp(start_y, end_y - calculated_h, y_ratio)

        Imgui.set_next_window_pos(calculated_x, calculated_y)
        Imgui.set_next_window_size(calculated_w, calculated_h)

        self._should_refresh = false
    end

    local background_alpha = tonumber(settings.meter_background_alpha)

    Imgui.push_style_color(2, 0, 0, 0, background_alpha) -- channel 2 is background
    Imgui.begin_window("DPS Meter", "no_title_bar", "no_resize", "no_nav_focus", "no_move")
    Imgui.pop_style_color()

    Imgui.set_window_font_scale(settings.meter_font_scale)

    self:_draw_options()
    self:_draw_meter()

    Imgui.end_window()
end

MeterImgui._draw_options = function(self)
    local options = self._option_template
    local columns = options.columns
    local elements = options.elements
    local scoreController = self._scoreController

    Imgui.columns(columns)

    for i = 1, #elements do
        local option = elements[i]

        if Imgui.button(option.display_text) then
            option.on_pressed(self, scoreController)
        end

        if option.next_column then
            Imgui.next_column()
        else
            Imgui.same_line()
        end
    end

    Imgui.columns(1)
    Imgui.separator()
end

MeterImgui._draw_meter = function(self)
    local scoreController = self._scoreController
    local meter_template = self._current_meter_template

    local column_size = meter_template.column_size
    Imgui.columns(column_size)

    for _, element in ipairs(meter_template.elements) do
        if element.category == "time" then
            Imgui.text(FormatTime(scoreController.elapsed_time))
        else
            Imgui.text(element.display_text)
        end

        Imgui.next_column()
    end

    Imgui.columns(1)
    Imgui.separator()

    Imgui.channel_split(2)

    local rect_alpha = tonumber(self._mod_setttings.meter_rect_alpha)
    local window_width = Imgui.get_window_size()
    local window_x = Imgui.get_window_pos()
    local _, TallestCharHeight = Imgui.calculate_text_size("gjqQP")

    local scores = scoreController:GetScores()

    for i = 1, #scores do
        local playerScores = scores[i].data
        local meterScores = playerScores[self._mode]
        Imgui.channel_set_current(0)

        local window_cur_pos_x, window_cur_pos_y = Imgui.get_cursor_screen_pos()
        local right_offset_x = (window_cur_pos_x - window_x) * 2

        local rect_percent = meterScores.percent
        local percent_bar_width

        if rect_percent < 0.1 or rect_percent ~= rect_percent then
            percent_bar_width = window_width * 0.001
        elseif rect_percent >= 97 then
            percent_bar_width = window_width * rect_percent * 0.01 - right_offset_x
        else
            percent_bar_width = window_width * rect_percent * 0.01
        end

        local rect_color = playerScores.meterColor
        local colorVector4 = Color(rect_alpha, rect_color[2], rect_color[3], rect_color[4])

        Imgui.add_rect_filled(
            window_cur_pos_x,
            window_cur_pos_y,
            window_cur_pos_x + percent_bar_width,
            window_cur_pos_y + TallestCharHeight,
            colorVector4,
            3)

        Imgui.channel_set_current(1)
        Imgui.columns(column_size)

        for _, element in ipairs(meter_template.elements) do
            local text

            if element.category == "time" then
                text = playerScores.shortCareerName
            elseif element.category == "name" then
                text = playerScores.name
            elseif element.category == "dps" then
                text = FormatScore(element, playerScores.dps.scorePerSeconds)
            elseif element.category == "hps" then
                text = FormatScore(element, playerScores.hps.scorePerSeconds)
            elseif element.category == "damage_score" then
                text = FormatScore(element, playerScores.dps.scores)
            elseif element.category == "heal_score" then
                text = FormatScore(element, playerScores.hps.scores)
            else
                local score = playerScores[element.category] or 0

                text = FormatScore(element, score)
            end

            Imgui.text(text)

            Imgui.next_column()
        end

        Imgui.columns(1)
        Imgui.separator()
    end

    Imgui.channels_merge()
end

MeterImgui.refresh_size_and_position = function(self)
    self._should_refresh = true
end

MeterImgui.is_visible = function(self)
    return self._visible
end

MeterImgui.set_visible = function(self, state)
    self._visible = state

    if state then
        self:refresh_size_and_position()
        Imgui.open_imgui()
    else
        Imgui.close_imgui()
    end
end

MeterImgui.set_mode = function(self, mode)
    local meter_template = self._meters_template[mode]

    if not meter_template then
        self._mod:error(mode .. " is not supported meter_type")
        return
    end

    self._mode = mode
    self._current_meter_template = meter_template
end

MeterImgui.lock_input = function(self)
    Imgui.disable_imgui_input_system(Imgui.KEYBOARD)
    Imgui.disable_imgui_input_system(Imgui.GAMEPAD)
    Imgui.disable_imgui_input_system(Imgui.MOUSE)
end

MeterImgui.unlock_input = function(self)
    Imgui.enable_imgui_input_system(Imgui.KEYBOARD)
    Imgui.enable_imgui_input_system(Imgui.GAMEPAD)
    Imgui.enable_imgui_input_system(Imgui.MOUSE)
end
