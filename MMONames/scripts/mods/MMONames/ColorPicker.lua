local vmf = get_mod("VMF")
local mod = get_mod("MMONames")
local MOD_NAME = "MMONames"
ColorPicker = class(ColorPicker)

ColorPicker.init = function (self, color, callback)
	self.color = {
		color[1] / 255,
		color[2] / 255,
		color[3] / 255
	}
	self.callback = callback
end

ColorPicker.open = function (self)
	Imgui.open_imgui()
	self:capture_input()
end

ColorPicker.capture_input = function ()
	Imgui.enable_imgui_input_system(Imgui.KEYBOARD)
	Imgui.enable_imgui_input_system(Imgui.MOUSE)
end

ColorPicker.draw = function (self)
	Imgui.begin_window("Color Picker")

	local r, g, b = Imgui.color_picker_3("Color", self.color[1], self.color[2], self.color[3], self.color[4])
	self.color = {
		r,
		g,
		b
	}

	if Imgui.button("Confirm") then
		self:save()
	end

	Imgui.end_window()

	if Keyboard.pressed(Keyboard.button_index("esc")) then
		self:close()
	end
end

ColorPicker.save = function (self)
	local r = self.color[1] * 255
	local g = self.color[2] * 255
	local b = self.color[3] * 255

	mod:set("user_color_r", r)
	mod:set("user_color_g", g)
	mod:set("user_color_b", b)
	self.callback({
		r,
		g,
		b
	})
	self:close()
end

ColorPicker.release_input = function ()
	Imgui.disable_imgui_input_system(Imgui.KEYBOARD)
	Imgui.disable_imgui_input_system(Imgui.MOUSE)
end

ColorPicker.close = function (self)
	Imgui.close_imgui()
	self:release_input()
end

mod:hook(vmf, "register_view", function (func, self1, options, ...)
	if options.view_name == "vmf_options_view" then
		mod:hook_safe(VMFOptionsView, "callback_change_numeric_menu_visibility", function (self, widget_content)
			if widget_content.mod_name == MOD_NAME and widget_content.is_numeric_menu_opened and string.starts_with(widget_content.setting_id, "user_color_") then
				local old_color = {
					mod:get("user_color_r"),
					mod:get("user_color_g"),
					mod:get("user_color_b")
				}
				mod.colorpicker = ColorPicker:new(old_color, function (new_color)
					local new_values = {
						user_color_r = new_color[1],
						user_color_g = new_color[2],
						user_color_b = new_color[3]
					}

					for _, widgets in pairs(self.settings_list_widgets) do
						for _, widget in pairs(widgets) do
							if widget.content and widget.content.setting_id and string.starts_with(widget.content.setting_id, "user_color_") then
								widget.content.current_value_text = string.format("%d", new_values[widget.content.setting_id])
							end
						end
					end

					mod.on_setting_changed()
				end)

				mod.colorpicker:open()
			end
		end)
	end

	func(self1, options, ...)
end)

mod.update = function ()
	if mod.colorpicker then
		mod.colorpicker:draw()
	end
end
