local mod = get_mod("Ubersreik5")

-- 5th-player readiness dot on the matchmaking overlay. The readiness logic
-- itself is 100% vanilla and already player-count-agnostic - only the
-- widget/scenegraph entries were missing. See README.md.

-- Same size party_slot_1-4 use. The actual party_slot_5 scenegraph node is
-- added in CustomScoreboard.lua's init_scenegraph hook, not here - see
-- README.md.
local PARTY_SLOT_5_SIZE = {
	60,
	70,
}

-- Mirrors the private create_status_widget() local in vanilla's
-- matchmaking_ui_definitions.lua (not exposed via UIWidgets).
local function create_status_widget(texture, offset)
	return {
		scenegraph_id = "window",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "texture_id",
					texture_id = "texture_id",
					content_check_function = function (content)
						return content.is_connecting or content.is_connected
					end,
					content_change_function = function (content, style, animations, dt)
						local color = style.color

						if content.is_connecting then
							local color_progress = ((content.color_progress or 1) + dt) % 1

							content.color_progress = color_progress

							local anim_progress = math.ease_pulse(color_progress)

							color[1] = 255 * anim_progress
						elseif content.is_connected then
							color[1] = 255
						end
					end,
				},
			},
		},
		content = {
			is_connected = false,
			is_connecting = false,
			texture_id = texture,
		},
		style = {
			texture_id = {
				horizontal_alignment = "right",
				vertical_alignment = "bottom",
				texture_size = {
					30,
					30,
				},
				color = {
					255,
					255,
					255,
					255,
				},
				offset = {
					offset[1] or 0,
					offset[2] or 0,
					offset[3] or 0,
				},
			},
		},
	}
end

-- New dots take vanilla's old socket positions shifted down by one: dot 2
-- sits where dot 1 used to, dot 3 where dot 2 used to, etc, so dots 2-5
-- land on the 4 existing background sockets. Dot 1 stays at its own old
-- x position, just raised in y by roughly the y-distance between dots 2
-- and 3, so it sits a bit above dot 2 without a socket of its own.
-- See README.md.
local VANILLA_PLAYER_STATUS_OFFSET = {
	{ -89, 43 }, -- { -320 + 67.5, -89 },
	{ -71, 22 }, -- { -320 + 135, -89 },
	{ -45, 12 }, -- { -320 + 202.5, -89 },
	{ -18, 15 }, -- { -320 + 270, -89 },
}
local PLAYER_STATUS_OFFSET = {
	{
		-40,
		VANILLA_PLAYER_STATUS_OFFSET[1][2] + 15,
	},
	VANILLA_PLAYER_STATUS_OFFSET[1],
	VANILLA_PLAYER_STATUS_OFFSET[2],
	VANILLA_PLAYER_STATUS_OFFSET[3],
	VANILLA_PLAYER_STATUS_OFFSET[4],
}

-- create_ui_elements rebuilds self._widgets fresh every call, so no
-- "already added" guard is needed here (unlike the scenegraph hook above).
mod:hook_safe(MatchmakingUI, "create_ui_elements", function (self)
	for i = 1, 4 do
		local widget = self._widgets_by_name["player_status_" .. i]

		if widget then
			widget.style.texture_id.offset[1] = PLAYER_STATUS_OFFSET[i][1]
			widget.style.texture_id.offset[2] = PLAYER_STATUS_OFFSET[i][2]
		end
	end

	UIUtils.create_widgets({
		player_status_5 = create_status_widget("matchmaking_light_02", PLAYER_STATUS_OFFSET[5]),
	}, self._widgets, self._widgets_by_name)

	-- Defensive: party_slot_5 should always exist by now (added in
	-- CustomScoreboard.lua's init_scenegraph hook), but skip cleanly instead
	-- of erroring if something upstream ever changes that.
	if not self.scenegraph_definition.party_slot_5 then
		mod:echo("[Ubersreik5] party_slot_5 missing from matchmaking scenegraph, skipping that widget.")

		return
	end

	UIUtils.create_widgets({
		party_slot_5 = UIWidgets.create_matchmaking_portrait(PARTY_SLOT_5_SIZE, "party_slot_5"),
	}, self._detail_widgets, self._detail_widgets_by_name)
end)

-- Vanilla's "connecting..." icon spinner hardcodes "for i = 1, 4", so
-- party_slot_5 would never spin. Duplicated here for slot 5 only.
mod:hook_safe(MatchmakingUI, "_update_status", function (self, dt)
	if self._active_mechanism == "versus" then
		return
	end

	local widget = self:_get_detail_widget("party_slot_5")

	if not widget then
		return
	end

	local connecting_rotation_speed = 200
	local connecting_radians = math.degrees_to_radians(dt * connecting_rotation_speed % 360)
	local content = widget.content
	local connecting_icon_style = widget.style.connecting_icon

	connecting_icon_style.angle = content.is_connecting and connecting_icon_style.angle + connecting_radians or 0
end)
