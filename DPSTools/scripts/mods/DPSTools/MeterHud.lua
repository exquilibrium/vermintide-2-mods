local MathfMin = math.min
local MathfMax = math.max
local MathfClamp = math.clamp
local MathfAbs = math.abs
local MathfFloor = math.floor
local StringFormat = string.format

-- Every native HUD element in this game is authored against this fixed 1920x1080
-- reference canvas; UIRenderer maps it to real screen pixels every frame via
-- RESOLUTION_LOOKUP, in Windowed, Windowed Fullscreen and Fullscreen alike, without
-- us ever reading the actual window/screen size ourselves.
local REFERENCE_WIDTH = 1920
local REFERENCE_HEIGHT = 1080

local FONT_NAME = "gw_body"
local FONT_MATERIAL = "materials/fonts/" .. FONT_NAME
-- UIGetFontHeight's font_name argument isn't the raw font family above - it's a key
-- into the Fonts table in scripts/ui/ui_fonts.lua, which maps style aliases to
-- {material, size, family} triples. "hell_shark" is the alias for the gw_body family.
local FONT_HEIGHT_KEY = "hell_shark"
local BASE_FONT_SIZE = 16
local ROW_HEIGHT = 26
local TEXT_COLOR = { 255, 255, 255, 255 }
local SEPARATOR_COLOR = { 130, 255, 255, 255 }
local SEPARATOR_DRAGGING_COLOR = { 255, 255, 220, 60 }
local SEPARATOR_THICKNESS = 1
local MIN_COLUMN_WIDTH = 5
local SEPARATOR_HIT_BAND = 6
local CELL_PADDING = 6
local PANEL_CORNER_RADIUS = 8
local BAR_CORNER_RADIUS = 3
local BAR_PADDING = 3
local TOOLBAR_BUTTON_COLOR = { 140, 60, 130, 220 }
local TOOLBAR_BUTTON_HOVER_COLOR = { 190, 90, 160, 240 }
local TOOLBAR_BUTTON_ACTIVE_COLOR = { 255, 60, 130, 220 }
local TOOLBAR_BUTTON_CORNER_RADIUS = 4
local TOOLBAR_BUTTON_PADDING_Y = 4
local TOOLBAR_BUTTON_TEXT_PADDING_X = 8
local TOOLBAR_BUTTON_GAP = 4
local TOOLBAR_ROW_HEIGHT_SCALE = 1
-- Insets the whole table (rows, separators, everything) within the background box,
-- rather than padding individual elements against the box edge one at a time.
local BOX_PADDING = 5

-- Drawn late in the frame (see DPSTools.lua's IngameUI.post_update hook) and given a
-- z well above typical HUD element depths, so this panel stacks on top of other UI
-- rather than getting buried under it.
local BASE_LAYER = 500

local function FormatTime(seconds)
    seconds = MathfFloor(seconds)

    return StringFormat("%03d:%02d", seconds / 60, seconds % 60)
end

local function FormatScore(score_element, score)
    if score_element.use_float then
        return StringFormat("%.2f", score)
    end

    return tostring(score)
end

-- Longest prefix of text that renders within max_width, measured via
-- UIRenderer.text_size (exact pixel width, no engine-side ellipsis appended - unlike
-- UIRenderer.crop_text_width, which always adds one). Binary search over byte length
-- since text_size is the only way to know how wide a given prefix actually is.
local function crop_text_to_width(ui_renderer, text, font_size, max_width)
    if UIRenderer.text_size(ui_renderer, text, FONT_MATERIAL, font_size) <= max_width then
        return text
    end

    local low, high = 0, #text

    while low < high do
        local mid = MathfFloor((low + high + 1) / 2)

        if UIRenderer.text_size(ui_renderer, string.sub(text, 1, mid), FONT_MATERIAL, font_size) <= max_width then
            low = mid
        else
            high = mid - 1
        end
    end

    return string.sub(text, 1, low)
end

-- Left-aligned within its column, vertically centered within a row_height row whose
-- far/top edge is row_y (see MeterHud.draw). font_center_offset is
-- (font_min + font_max) / 2 from UIGetFontHeight - the vertical distance from the
-- text's draw-position baseline to the middle of its glyph box - so the vertical
-- centering works regardless of which way this renderer's Y axis points. Cropped to
-- max_width first so text that's too long for its column gets cut off instead of
-- overflowing into - and overlapping - the next one.
local function draw_row_text(ui_renderer, text, font_size, column_x, max_width, row_y, row_height, font_center_offset, layer)
    local cropped_text = crop_text_to_width(ui_renderer, text, font_size, max_width)
    local text_y = row_y - row_height / 2 - font_center_offset

    UIRenderer.draw_text(ui_renderer, cropped_text, FONT_MATERIAL, font_size, FONT_NAME, Vector3(column_x, text_y, layer), TEXT_COLOR)
end

-- Draws this one row's own bottom border plus its own column dividers (positioned via
-- column_x_offsets, cumulative offsets from content_x - see MeterHud.draw),
-- entirely self-contained to [row_y - row_height, row_y]. Called once per row (header
-- included) instead of one loop spanning the whole table, so the header always gets
-- its separators regardless of how many (if any) score rows exist below it.
local function draw_row_separators(ui_renderer, content_x, content_w, row_y, row_height, column_x_offsets, column_size, separator_thickness, layer, dragging_separator)
    local row_bottom = row_y - row_height

    UIRenderer.draw_rect(ui_renderer, { content_x, row_bottom, layer }, { content_w, separator_thickness }, SEPARATOR_COLOR)

    for i = 1, column_size - 1 do
        local separator_x = content_x + column_x_offsets[i + 1]
        local color = i == dragging_separator and SEPARATOR_DRAGGING_COLOR or SEPARATOR_COLOR

        UIRenderer.draw_rect(ui_renderer, { separator_x, row_bottom, layer }, { separator_thickness, row_height }, color)
    end
end

-- Toolbar buttons drawn left to right in the row above the header (see
-- MeterHud.draw). These replace the old dpsstart/dpsend/dpsclear/dpsdefault/dpsmode
-- text commands - every one of those actions now has an on-panel button instead.
local TOOLBAR_ITEMS = {
    { id = "start", label = "Start" },
    { id = "end", label = "End" },
    { id = "clear", label = "Clear" },
    { separator = true },
    { id = "default", label = "Default" },
    { separator = true },
    { id = "dps", label = "DPS" },
    { id = "hps", label = "HPS" },
    { separator = true },
    { id = "pin", label = "Pin" },
    { id = "close", label = "Close" },
}

-- Counted once here rather than every frame: how many of the small fixed
-- (TOOLBAR_BUTTON_GAP) gaps sit between two buttons with no separator between
-- them, and how many separator slots exist. See MeterHud.draw for how these feed
-- into the separator gap width.
local TOOLBAR_SEPARATOR_COUNT = 0
local TOOLBAR_SMALL_GAP_COUNT = 0

for index, item in ipairs(TOOLBAR_ITEMS) do
    if item.separator then
        TOOLBAR_SEPARATOR_COUNT = TOOLBAR_SEPARATOR_COUNT + 1
    end

    local next_item = TOOLBAR_ITEMS[index + 1]

    if next_item and not item.separator and not next_item.separator then
        TOOLBAR_SMALL_GAP_COUNT = TOOLBAR_SMALL_GAP_COUNT + 1
    end
end

MeterHud = class(MeterHud)

MeterHud.init = function(self, mod)
    self._mod = mod
    self._scoreController = mod.scoreController

    self._meters_template = mod.meter_templates

    self._mode = ""
    self._current_meter_template = {}

    self._visible = false
    self._dragging_separator = nil
    self._column_ratios_by_mode = {}
    self._toolbar_mouse_was_down = false

    self:set_mode("dps")
end

-- w_ratio/h_ratio are a direct fraction of the full reference canvas (1 = the whole
-- screen, no margin held back). Only size is computed here - position is computed in
-- draw() directly against the real screen bounds (not this reference canvas), so
-- x_ratio/y_ratio reach the screen's true edges/corners on any aspect ratio, not just
-- whatever sub-region the 1920x1080 canvas happens to occupy on non-16:9 displays.
MeterHud._calculate_rect = function(self)
    local mod = self._mod

    local w_ratio, h_ratio = mod:get("meter_width_ratio"), mod:get("meter_height_ratio")

    local calculated_w = REFERENCE_WIDTH * w_ratio
    local calculated_h = REFERENCE_HEIGHT * h_ratio

    return calculated_w, calculated_h
end

-- Per-column widths as ratios of the panel width (summing to 1), evenly split by
-- default, adjustable by dragging separators in edit mode and persisted per mode
-- (dps/hps have different columns) via mod:set - the same arbitrary-keyed storage
-- pattern GiveWeaponPlus uses for its own saved_items table.
MeterHud._get_column_ratios = function(self, column_size)
    local ratios = self._column_ratios_by_mode[self._mode]

    if ratios and #ratios == column_size then
        return ratios
    end

    local saved = self._mod:get("meter_column_widths_" .. self._mode)

    if saved and #saved == column_size then
        ratios = saved
    else
        ratios = {}

        local even_ratio = 1 / column_size

        for i = 1, column_size do
            ratios[i] = even_ratio
        end
    end

    self._column_ratios_by_mode[self._mode] = ratios

    return ratios
end

MeterHud._save_column_ratios = function(self, ratios)
    self._mod:set("meter_column_widths_" .. self._mode, ratios, true)
end

-- Resets every mode's columns to an even split, both the in-memory cache
-- MeterHud._get_column_ratios reads from and the persisted settings underneath it -
-- called by the toolbar's "Default" button (see MeterHud._handle_toolbar_click),
-- since dragging column separators is otherwise a one-way trip with no way back to
-- even widths.
MeterHud.reset_column_ratios = function(self)
    for mode, meter_template in pairs(self._meters_template) do
        local column_size = meter_template.column_size
        local even_ratio = 1 / column_size
        local ratios = {}

        for i = 1, column_size do
            ratios[i] = even_ratio
        end

        self._column_ratios_by_mode[mode] = ratios
        self._mod:set("meter_column_widths_" .. mode, ratios, true)
    end
end

-- "pin" is the only toolbar button whose label depends on state (Pin/Unpin) -
-- every other item just shows its static TOOLBAR_ITEMS label.
MeterHud._toolbar_label = function(self, item)
    if item.id == "pin" then
        return self:is_pinned() and "Unpin" or "Pin"
    end

    return item.label
end

-- Dispatches a toolbar button click (see TOOLBAR_ITEMS and MeterHud.draw) straight
-- into the score controller / mod, the same calls the removed dpsstart/dpsend/
-- dpsclear/dpsdefault/dpsmode text commands used to make.
--
-- "pin"/"close" don't set self._visible directly - visibility is recomputed every
-- frame from the pinned setting and whether the tab screen is up (see
-- MeterHud.update_auto_visibility), so these just drive that setting: pin forces
-- the meter visible all the time, close (like unpin) drops it back to
-- tab-screen-only.
MeterHud._handle_toolbar_click = function(self, id)
    local scoreController = self._scoreController

    if id == "start" then
        scoreController:start()
    elseif id == "end" then
        scoreController:finish()
    elseif id == "clear" then
        scoreController:clear()
    elseif id == "default" then
        self._mod.SaveDefaultSettings()
        self:reset_column_ratios()
    elseif id == "dps" then
        self:set_mode("dps")
        scoreController:set_mode("dps")
    elseif id == "hps" then
        self:set_mode("hps")
        scoreController:set_mode("hps")
    elseif id == "pin" then
        self:toggle_pin()
    elseif id == "close" then
        self._mod:set("meter_tab_screen_only", true, true)
    end
end

-- Called from IngameUI.post_update (see DPSTools.lua) with the game's own ongoing
-- HUD renderer - the same one drawing health bars and chat, already correct in
-- every window mode. No Imgui, no raw input capture, nothing that can touch the
-- game window itself.
MeterHud.draw = function(self, ui_renderer)
    if not self._visible then
        return
    end

    local mod = self._mod
    local calculated_w, calculated_h = self:_calculate_rect()

    -- UIRenderer's raw draw_rect/draw_text calls expect actual screen pixels, not
    -- auto-scaled reference units - every other piece of native/mod HUD code
    -- (e.g. MMONames.lua's font sizing) converts its own reference-space values via
    -- RESOLUTION_LOOKUP.scale before handing them over. We do the same here, which
    -- is what makes this correct at resolutions other than exactly 1920x1080.
    --
    -- We compute our own scale here instead of reading RESOLUTION_LOOKUP.scale
    -- directly, because that value gets capped at 1 by the game's own
    -- "hud_clamp_ui_scaling" accessibility setting (see global_utils.lua) - meant to
    -- stop the rest of the game's HUD from ballooning at high resolutions. That cap
    -- would silently stop this panel from ever exceeding 1920x1080 real pixels, i.e.
    -- never reaching the true edges of a 1440p/4K screen, which defeats the point of
    -- letting it fill or corner-anchor on those screens.
    local scale = MathfMin(RESOLUTION_LOOKUP.res_w / REFERENCE_WIDTH, RESOLUTION_LOOKUP.res_h / REFERENCE_HEIGHT)

    calculated_w = calculated_w * scale
    calculated_h = calculated_h * scale

    -- Position is computed directly against the real screen bounds (not the
    -- reference canvas), so x_ratio=0/1 and y_ratio=0/1 reach the screen's actual
    -- edges/corners on any aspect ratio - ultrawide included - rather than only the
    -- edges of whatever centered 16:9 sub-region the canvas would otherwise occupy.
    local x_ratio, y_ratio = mod:get("meter_window_x_ratio"), mod:get("meter_window_y_ratio")

    local calculated_x = (RESOLUTION_LOOKUP.res_w - calculated_w) * x_ratio
    local calculated_y = (RESOLUTION_LOOKUP.res_h - calculated_h) * y_ratio

    local background_alpha = tonumber(mod:get("meter_background_alpha"))

    UIRenderer.draw_rounded_rect(ui_renderer, { calculated_x, calculated_y, BASE_LAYER }, { calculated_w, calculated_h }, PANEL_CORNER_RADIUS * scale, { background_alpha, 0, 0, 0 })

    -- The table (rows, separators, everything below) is laid out within this inset
    -- content rect rather than the background box's own bounds, so nothing in it
    -- touches the box edge.
    local box_padding = BOX_PADDING * scale
    local content_x = calculated_x + box_padding
    local content_y = calculated_y + box_padding
    local content_w = calculated_w - box_padding * 2
    local content_h = calculated_h - box_padding * 2

    local font_scale = tonumber(mod:get("meter_font_scale")) or 1
    local font_size = BASE_FONT_SIZE * font_scale * scale
    local row_height = ROW_HEIGHT * font_scale * scale
    local separator_thickness = SEPARATOR_THICKNESS * scale
    local cell_padding = CELL_PADDING * scale

    local _, font_min, font_max = UIGetFontHeight(ui_renderer.gui, FONT_HEIGHT_KEY, font_size)
    local font_center_offset = (font_min + font_max) / 2

    local meter_template = self._current_meter_template
    local column_size = meter_template.column_size
    local column_ratios = self:_get_column_ratios(column_size)

    -- Cumulative offsets from content_x: column_x_offsets[i] is column i's left
    -- edge, column_x_offsets[i+1] its right edge (= separator i's position).
    local column_x_offsets = { 0 }

    for i = 1, column_size do
        column_x_offsets[i + 1] = column_x_offsets[i] + column_ratios[i] * content_w
    end

    -- The toolbar row sits above the header at [toolbar_band_bottom, toolbar_band_top]
    -- (see toolbar_row_y/toolbar_row_height further down, which use this same
    -- formula) - column dragging is excluded from that band so clicking a toolbar
    -- button can never be mistaken for grabbing a column separator underneath it.
    local toolbar_band_top = content_y + content_h
    local toolbar_band_bottom = toolbar_band_top - row_height * TOOLBAR_ROW_HEIGHT_SCALE

    -- Columns are only draggable while something else already has the cursor visible
    -- (chat, a menu, etc. via ShowCursorStack) - never captured/shown by us. Reading
    -- raw Mouse state rather than going through an input service means this can't be
    -- blocked by whichever service currently has priority (e.g. chat's own), and it's
    -- exactly why this is safe: we never touch input capture or cursor visibility
    -- ourselves, so there's nothing here that can conflict with anything else,
    -- Imgui included.
    if ShowCursorStack.cursor_active() then
        local cursor = Mouse.axis(Mouse.axis_index("cursor"))
        local held = Mouse.button(Mouse.button_index("left")) == 1
        local outside_toolbar = not cursor or cursor[2] < toolbar_band_bottom or cursor[2] > toolbar_band_top

        if cursor and held and outside_toolbar then
            local cursor_local_x = cursor[1] - content_x

            if not self._dragging_separator then
                local hit_band = SEPARATOR_HIT_BAND * scale

                for i = 1, column_size - 1 do
                    if MathfAbs(cursor_local_x - column_x_offsets[i + 1]) <= hit_band then
                        self._dragging_separator = i

                        break
                    end
                end
            end

            local dragging = self._dragging_separator

            if dragging then
                local min_width = MIN_COLUMN_WIDTH
                local left_bound = column_x_offsets[dragging] + min_width
                local right_bound = column_x_offsets[dragging + 2] - min_width
                local new_boundary = MathfClamp(cursor_local_x, left_bound, right_bound)

                column_x_offsets[dragging + 1] = new_boundary
                column_ratios[dragging] = (new_boundary - column_x_offsets[dragging]) / content_w
                column_ratios[dragging + 1] = (column_x_offsets[dragging + 2] - new_boundary) / content_w

                self:_save_column_ratios(column_ratios)
            end
        else
            self._dragging_separator = nil
        end
    end

    local scoreController = self._scoreController
    local rect_alpha = tonumber(mod:get("meter_rect_alpha"))
    local scores = scoreController:GetScores()

    -- Rows are stacked from the content rect's far edge down to its near edge (rather
    -- than the other way around) so the header lands first and the sorted-descending
    -- score list reads highest-to-lowest going down, top to bottom.
    --
    -- The very first row is a toolbar strip (not part of the scored table) holding
    -- the action buttons, laid out left to right the same way column text is.
    local toolbar_row_y = toolbar_band_top
    local toolbar_row_height = toolbar_row_y - toolbar_band_bottom
    local toolbar_button_padding = TOOLBAR_BUTTON_PADDING_Y * scale
    local toolbar_button_y = toolbar_row_y - toolbar_row_height + toolbar_button_padding
    local toolbar_button_height = toolbar_row_height - toolbar_button_padding * 2
    local toolbar_text_padding = TOOLBAR_BUTTON_TEXT_PADDING_X * scale
    local toolbar_gap = TOOLBAR_BUTTON_GAP * scale

    -- Button widths are measured up front so the separator gaps can be sized to
    -- soak up whatever's left of content_w - the fixed bits (buttons + the small
    -- gaps between buttons within a group) are known, so each separator gets an
    -- equal share of the remainder, stretching the row so the last button's right
    -- edge lands exactly on the content rect's right border.
    local toolbar_button_widths = {}
    local toolbar_button_labels = {}
    local toolbar_fixed_width = 0

    for index, item in ipairs(TOOLBAR_ITEMS) do
        if not item.separator then
            local label = self:_toolbar_label(item)
            local label_width = UIRenderer.text_size(ui_renderer, label, FONT_MATERIAL, font_size)
            local button_width = label_width + toolbar_text_padding * 2

            toolbar_button_labels[index] = label
            toolbar_button_widths[index] = button_width
            toolbar_fixed_width = toolbar_fixed_width + button_width
        end
    end

    toolbar_fixed_width = toolbar_fixed_width + TOOLBAR_SMALL_GAP_COUNT * toolbar_gap

    local toolbar_separator_gap = MathfMax(0, content_w - toolbar_fixed_width) / TOOLBAR_SEPARATOR_COUNT

    -- Read once for the whole row - button rects never overlap, so at most one of
    -- them can be under the cursor on a given frame.
    local toolbar_cursor, toolbar_held = nil, false

    if ShowCursorStack.cursor_active() then
        toolbar_cursor = Mouse.axis(Mouse.axis_index("cursor"))
        toolbar_held = Mouse.button(Mouse.button_index("left")) == 1
    end

    local toolbar_clicked_id = nil
    local toolbar_x = content_x

    for index, item in ipairs(TOOLBAR_ITEMS) do
        if item.separator then
            toolbar_x = toolbar_x + toolbar_separator_gap
        else
            local button_width = toolbar_button_widths[index]

            local hovered = toolbar_cursor ~= nil
                and toolbar_cursor[1] >= toolbar_x and toolbar_cursor[1] <= toolbar_x + button_width
                and toolbar_cursor[2] >= toolbar_button_y and toolbar_cursor[2] <= toolbar_button_y + toolbar_button_height

            -- Fires on the down-transition only, so holding the mouse over a button
            -- doesn't repeat the action every frame.
            if hovered and toolbar_held and not self._toolbar_mouse_was_down then
                toolbar_clicked_id = item.id
            end

            local button_color = TOOLBAR_BUTTON_COLOR

            if item.id == "pin" and self:is_pinned() then
                button_color = TOOLBAR_BUTTON_ACTIVE_COLOR
            elseif hovered then
                button_color = TOOLBAR_BUTTON_HOVER_COLOR
            end

            UIRenderer.draw_rounded_rect(ui_renderer, { toolbar_x, toolbar_button_y, BASE_LAYER + 3 }, { button_width, toolbar_button_height }, TOOLBAR_BUTTON_CORNER_RADIUS * scale, button_color)

            local text_y = toolbar_button_y + toolbar_button_height / 2 - font_center_offset

            UIRenderer.draw_text(ui_renderer, toolbar_button_labels[index], FONT_MATERIAL, font_size, FONT_NAME, Vector3(toolbar_x + toolbar_text_padding, text_y, BASE_LAYER + 4), TEXT_COLOR)

            -- Only add the small fixed gap when the next item is another button -
            -- a following separator already brings its own (wider) gap, and adding
            -- both here is exactly the width the layout forgot to budget for,
            -- which pushed the row past the right border.
            local next_item = TOOLBAR_ITEMS[index + 1]

            toolbar_x = toolbar_x + button_width

            if next_item and not next_item.separator then
                toolbar_x = toolbar_x + toolbar_gap
            end
        end
    end

    self._toolbar_mouse_was_down = toolbar_held

    if toolbar_clicked_id then
        self:_handle_toolbar_click(toolbar_clicked_id)
    end

    local row_y = toolbar_row_y - toolbar_row_height

    -- Every row draws its own bottom border (see draw_row_separators), which doubles
    -- as the top border for the row below it - except the header, which has nothing
    -- above it to borrow one from, so it gets its own top border here.
    UIRenderer.draw_rect(ui_renderer, { content_x, row_y, BASE_LAYER + 2 }, { content_w, separator_thickness }, SEPARATOR_COLOR)

    for i, element in ipairs(meter_template.elements) do
        local text = element.category == "time" and FormatTime(scoreController.elapsed_time) or element.display_text
        local column_x = content_x + column_x_offsets[i] + cell_padding
        local max_width = column_x_offsets[i + 1] - column_x_offsets[i] - cell_padding

        draw_row_text(ui_renderer, text, font_size, column_x, max_width, row_y, row_height, font_center_offset, BASE_LAYER + 3)
    end

    draw_row_separators(ui_renderer, content_x, content_w, row_y, row_height, column_x_offsets, column_size, separator_thickness, BASE_LAYER + 2, self._dragging_separator)

    row_y = row_y - row_height

    for i = 1, #scores do
        local playerScores = scores[i].data
        local meterScores = playerScores[self._mode]
        local rect_percent = meterScores.percent
        local bar_width

        if rect_percent < 0.1 or rect_percent ~= rect_percent then
            bar_width = content_w * 0.001
        else
            bar_width = content_w * MathfMin(rect_percent, 100) * 0.01
        end

        local rect_color = playerScores.meterColor

        -- row_y is this row's far/top edge, with content filling downward into
        -- [row_y - row_height, row_y] (see draw_row_text) - anchor the bar the same
        -- way, otherwise it's drawn a full row_height off from the text it belongs to.
        -- Inset on all sides so it reads as a bar floating within the row rather than
        -- filling it edge to edge. Width loses two paddings, not one - one for the
        -- left inset (bar_x shifted in) and one so a 100% bar still stops short of
        -- the row's right edge instead of reaching it exactly.
        local bar_padding = BAR_PADDING * scale
        local bar_x = content_x + bar_padding
        local bar_y = row_y - row_height + bar_padding
        local bar_height = row_height - bar_padding * 2
        local padded_bar_width = MathfMax(0, bar_width - bar_padding * 2)

        UIRenderer.draw_rounded_rect(ui_renderer, { bar_x, bar_y, BASE_LAYER + 1 }, { padded_bar_width, bar_height }, BAR_CORNER_RADIUS * scale, { rect_alpha, rect_color[2], rect_color[3], rect_color[4] })

        for j, element in ipairs(meter_template.elements) do
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
                text = FormatScore(element, playerScores[element.category] or 0)
            end

            local column_x = content_x + column_x_offsets[j] + cell_padding
            local max_width = column_x_offsets[j + 1] - column_x_offsets[j] - cell_padding

            draw_row_text(ui_renderer, text, font_size, column_x, max_width, row_y, row_height, font_center_offset, BASE_LAYER + 3)
        end

        draw_row_separators(ui_renderer, content_x, content_w, row_y, row_height, column_x_offsets, column_size, separator_thickness, BASE_LAYER + 2, self._dragging_separator)

        row_y = row_y - row_height
    end
end

MeterHud.is_visible = function(self)
    return self._visible
end

-- Pinned state lives entirely in the "meter_tab_screen_only" setting (see
-- DPSTools_data.lua) rather than a separate in-memory flag, so the Pin/Unpin
-- button and the mod options checkbox both read/drive the exact same switch.
MeterHud.is_pinned = function(self)
    return not self._mod:get("meter_tab_screen_only")
end

MeterHud.toggle_pin = function(self)
    self._mod:set("meter_tab_screen_only", self:is_pinned(), true)
end

-- Called once a frame (see DPSTools.lua's IngameUI.post_update hook) with whether
-- the game's own tab/player-list screen is currently up. By default (pinned =
-- false) the meter is only visible while that screen is up; pinning it forces it
-- visible all the time regardless.
MeterHud.update_auto_visibility = function(self, tab_screen_active)
    local visible = self:is_pinned() or tab_screen_active

    if not visible then
        self._dragging_separator = nil
    end

    self._visible = visible
end

MeterHud.set_mode = function(self, mode)
    local meter_template = self._meters_template[mode]

    if not meter_template then
        self._mod:error(mode .. " is not supported meter_type")
        return
    end

    self._mode = mode
    self._current_meter_template = meter_template
end
