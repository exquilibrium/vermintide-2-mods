local mod = get_mod("Ubersreik5")

-- End-of-level scoreboard: a real 5th player panel + a scrollbar for extra
-- stat columns. See README.md for why this needs full widget recreation
-- rather than just resizing scenegraph nodes.

-- Row capacity to build every score widget with (independent of how many
-- rows are shown at once - see mod.scoreboard.rows below).
local WIDGET_ROW_CAPACITY = 25

mod.scores = {}

-- Row layout math mirrors vanilla's own row-height formula (39px, not 40).
-- BOTTOM_PADDING_ROWS cancels out dead space that otherwise grows with the
-- "extend" setting. See README.md.
local BOTTOM_PADDING_ROWS = 1

mod.scoreboard = {
	rows_default = 11,
	row_height = 39,
	rows = mod:get("extend"),
	extension = function (self)
		return (self.rows - self.rows_default) * self.row_height
	end,
	player_score_size_default = {
		200,
		80 + (11 + BOTTOM_PADDING_ROWS) * 39,
	},
	player_score_size = function (self)
		return {
			self.player_score_size_default[1],
			self.player_score_size_default[2] + self:extension(),
		}
	end,
}

mod.custom_entries = {
	list = {},
	register = function (self, id, text, sort_type, callback)
		if self:get(id) then
			mod:echo("Entry '" .. id .. "' has already been registered!")

			return false
		end

		self:add(id, text, sort_type, callback)

		return true
	end,
	add = function (self, id, text, sort_type, callback)
		self.list[#self.list + 1] = {
			enabled = true,
			id = id,
			text = text,
			type = sort_type,
			callback = callback,
		}
	end,
	get = function (self, id)
		for _, entry in ipairs(self.list) do
			if entry.id == id then
				return entry
			end
		end

		return nil
	end,
}

mod.register_entry = function (self, id, text, sort_type, callback)
	return self.custom_entries:register(id, text, sort_type, callback)
end

-- Scrollbar over self._scoreboard_rows (row 1, player names, is fixed and
-- excluded). Manual scroll only - see README.md for why.
mod.scrollbar = {
	start_index = 1,
	total_rows = 0,
	create = function (self, end_view_state_score)
		local size = {
			10,
			mod.scoreboard:player_score_size()[2] - 80,
		}

		self.size = size
		self.widget = UIWidget.init(UIWidgets.create_scrollbar("scrollbar", size), end_view_state_score.ui_renderer)
	end,
	visible_rows = function (self)
		return mod.scoreboard.rows - 1
	end,
	set = function (self, total_rows)
		self.start_index = 1
		self.total_rows = total_rows

		local visible_rows = self:visible_rows()
		local scroll_bar_info = self.widget.content.scroll_bar_info

		if total_rows <= visible_rows then
			self.widget.content.visible = false
			scroll_bar_info.bar_height_percentage = 1
		else
			self.widget.content.visible = true
			scroll_bar_info.bar_height_percentage = visible_rows / total_rows
		end

		scroll_bar_info.value = 0
	end,
	is_hovered = function (self)
		return self.widget.content.scroll_bar_info.is_hover
	end,
	is_held = function (self)
		return self.widget.content.scroll_bar_info.is_held
	end,
	-- Returns true if the visible window changed (caller should re-render).
	update = function (self)
		local total_rows = self.total_rows
		local visible_rows = self:visible_rows()

		if total_rows <= visible_rows then
			return false
		end

		local scroll_bar_info = self.widget.content.scroll_bar_info
		local rows_to_scroll = total_rows - visible_rows
		local new_start_index = math.max(0, math.round(scroll_bar_info.value * rows_to_scroll)) + 1
		local changed = new_start_index ~= self.start_index

		self.start_index = new_start_index

		return changed
	end,
	scroll = function (self, dt, input_service)
		if not self.widget.content.visible then
			return
		end

		local scroll_axis = input_service:get("scroll_axis")

		if scroll_axis and scroll_axis[2] ~= 0 then
			local rows_to_scroll = math.max(self.total_rows - self:visible_rows(), 1)
			local scroll_bar_info = self.widget.content.scroll_bar_info
			local step = 1 / rows_to_scroll
			local new_value = scroll_bar_info.value - scroll_axis[2] * step

			scroll_bar_info.value = math.max(0, math.min(1, new_value))
		end
	end,
}

-- Only patches EndViewStateScore's scenegraph (checked via its unique
-- player_panel_4 + scores_topics shape) - and doubles as the matchmaking
-- party_slot_5 patch below, since this framework can't chain two hooks on
-- the same (table, method) pair. See README.md.
mod:hook(UISceneGraph, "init_scenegraph", function (func, scenegraph_def, ...)
	if scenegraph_def.player_panel_4 and scenegraph_def.scores_topics then
		local panel_size = mod.scoreboard:player_score_size()
		-- "top" alignment needs no extension()-size compensation, unlike
		-- "center" would. See README.md.
		local TOP_OFFSET = -220

		scenegraph_def.scores_topics.horizontal_alignment = "center"
		scenegraph_def.scores_topics.vertical_alignment = "top"
		scenegraph_def.scores_topics.size[2] = panel_size[2]
		scenegraph_def.scores_topics.position[1] = -700
		scenegraph_def.scores_topics.position[2] = TOP_OFFSET

		-- scenegraph_def is vanilla's shared module-level table, so add-once
		-- guard the new nodes, but keep re-applying "extend"-dependent sizing
		-- below on every call. See README.md.
		if not scenegraph_def.player_panel_5 then
			-- vertical_alignment/position[2] are placeholders; the loop below
			-- overwrites both for all 5 panels.
			scenegraph_def.player_panel_5 = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				parent = "screen",
				size = panel_size,
				position = {
					650,
					0,
					1,
				},
			}
			scenegraph_def.player_frame_5 = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				parent = "player_panel_5",
				size = {
					0,
					0,
				},
				position = {
					0,
					-15,
					10,
				},
			}
			scenegraph_def.scrollbar = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				parent = "scores_topics",
				size = {
					10,
					panel_size[2] - 80,
				},
				position = {
					-4,
					0,
					5,
				},
			}
		end

		for i = 1, 5 do
			local panel = scenegraph_def["player_panel_" .. i]

			panel.vertical_alignment = "top"
			panel.size = panel_size
			panel.position[2] = TOP_OFFSET
		end

		scenegraph_def.scrollbar.size[2] = panel_size[2] - 80
	end

	-- Matchmaking overlay's party_slot_5 node - see MatchmakingPartySlot5.lua
	-- and README.md.
	if scenegraph_def.party_slot_4 and scenegraph_def.party_slot_root and not scenegraph_def.party_slot_5 then
		scenegraph_def.party_slot_5 = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			parent = "party_slot_root",
			size = {
				60,
				70,
			},
			position = {
				-135,
				-175,
				1,
			},
		}
	end

	return func(scenegraph_def, ...)
end)

-- Re-registers vanilla's entrance-animation rest spots for panels 1-4 so
-- panel 5 (position 650) doesn't land on top of them. See README.md.
local function move_inner_panels(ui_scenegraph, scenegraph_definition, widgets, progress, params)
	local anim_progress = math.easeInCubic(1 - progress)

	ui_scenegraph.player_panel_2.local_position[1] = -100 - 400 * anim_progress
	ui_scenegraph.player_panel_3.local_position[1] = 150 + 400 * anim_progress
end

local function move_outer_panels(ui_scenegraph, scenegraph_definition, widgets, progress, params)
	local anim_progress = math.easeInCubic(1 - progress)

	ui_scenegraph.player_panel_1.local_position[1] = -350 - 400 * anim_progress
	ui_scenegraph.player_panel_4.local_position[1] = 400 + 400 * anim_progress
end

-- Calls vanilla's create_ui_elements first, then rebuilds scores_topics and
-- all 5 score widgets at this mod's size/row-capacity.
mod:hook(EndViewStateScore, "create_ui_elements", function (func, self, params)
	func(self, params)

	for _, anim in ipairs(self.ui_animator._animation_definitions.transition_enter) do
		if anim.name == "move_inner_panels" then
			anim.update = move_inner_panels
		elseif anim.name == "move_outer_panels" then
			anim.update = move_outer_panels
		end
	end

	local panel_size = mod.scoreboard:player_score_size()
	-- Matches vanilla's own topics_hover_length formula
	-- (scripts/ui/views/level_end/states/definitions/end_view_state_score_definitions.lua).
	local topics_hover_length = 1400 + panel_size[1]

	self._widgets_by_name.scores_topics = UIWidget.init(UIWidgets.create_score_topics("scores_topics", {
		350,
		panel_size[2],
	}, topics_hover_length, WIDGET_ROW_CAPACITY), self.ui_renderer)

	for index, widget in ipairs(self._widgets) do
		if widget.content.num_rows then
			self._widgets[index] = self._widgets_by_name.scores_topics

			break
		end
	end

	self._score_widgets = {
		UIWidget.init(UIWidgets.create_score_entry("player_panel_1", panel_size, WIDGET_ROW_CAPACITY, "left"), self.ui_renderer),
		UIWidget.init(UIWidgets.create_score_entry("player_panel_2", panel_size, WIDGET_ROW_CAPACITY), self.ui_renderer),
		UIWidget.init(UIWidgets.create_score_entry("player_panel_3", panel_size, WIDGET_ROW_CAPACITY, "left"), self.ui_renderer),
		UIWidget.init(UIWidgets.create_score_entry("player_panel_4", panel_size, WIDGET_ROW_CAPACITY), self.ui_renderer),
		UIWidget.init(UIWidgets.create_score_entry("player_panel_5", panel_size, WIDGET_ROW_CAPACITY, "left"), self.ui_renderer),
	}

	mod.scrollbar:create(self)
end)

-- Captures the per-player stats_id list, in vanilla's own widget-index
-- order (must run BEFORE calling through - see README.md for why sorting
-- this breaks player-to-column attribution), then nils out unused trailing
-- hero/score widget slots so no empty panel renders. See README.md.
mod:hook(EndViewStateScore, "_setup_player_scores", function (func, self, players_session_scores)
	local stats_ids = {}

	for stats_id in pairs(players_session_scores) do
		stats_ids[#stats_ids + 1] = stats_id
	end

	self._stats_id_by_widget_index = stats_ids

	local result = func(self, players_session_scores)
	local num_players = #stats_ids

	for index = num_players + 1, #self._hero_widgets do
		self._hero_widgets[index] = nil
	end

	for index = num_players + 1, #self._score_widgets do
		self._score_widgets[index] = nil
	end

	return result
end)

-- Appends the mod's custom entries as scrollable rows after vanilla's own
-- native rows.
mod:hook_safe(EndViewStateScore, "_setup_score_panel", function (self, score_panel_scores, player_names)
	local num_players = #self._stats_id_by_widget_index
	local native_row_count = 1

	for _, group_data in pairs(score_panel_scores) do
		native_row_count = native_row_count + #group_data
	end

	local rows = {}

	for _, group_data in pairs(score_panel_scores) do
		for _, score_data in ipairs(group_data) do
			rows[#rows + 1] = {
				topic_text = Localize(score_data.display_text),
				scores = score_data.player_scores,
				lowest_is_best = score_data.stat_name == "damage_taken",
			}
		end
	end

	for _, entry in ipairs(mod.custom_entries.list) do
		if entry.enabled then
			local scores = {}

			for player_index = 1, num_players do
				scores[player_index] = entry.callback(mod, self._stats_id_by_widget_index[player_index], entry.id)
			end

			rows[#rows + 1] = {
				topic_text = entry.text,
				scores = scores,
				lowest_is_best = entry.type == "lowest",
			}
		end
	end

	self._scoreboard_rows = rows
	self._scoreboard_native_row_count = native_row_count

	mod.scrollbar:set(#rows)
	self:_render_scoreboard_rows(1)
end)

EndViewStateScore._render_scoreboard_rows = function (self, start_index)
	local rows = self._scoreboard_rows
	local score_widgets = self._score_widgets
	local visible_rows = mod.scrollbar:visible_rows()

	for offset = 0, visible_rows - 1 do
		local screen_row = offset + 2
		local line_suffix = "_" .. screen_row
		local score_text_name = "score_text" .. line_suffix
		local row_name = "row_bg" .. line_suffix
		local row = rows[start_index + offset]

		if row then
			local best_score, best_player_index

			for player_index, player_score in pairs(row.scores) do
				player_score = math.round(player_score)

				if not best_score or (row.lowest_is_best and player_score < best_score) or (not row.lowest_is_best and player_score > best_score) then
					best_score = player_score
					best_player_index = player_index
				end
			end

			for player_index, player_score in pairs(row.scores) do
				local widget = score_widgets[player_index]

				if widget then
					local row_content = widget.content[row_name]

					row_content[score_text_name] = math.round(player_score)
					row_content.has_background = screen_row % 2 == 0
					row_content.has_highscore = player_index == best_player_index and best_score ~= 0
					row_content.has_score = true
				end
			end

			self:_set_score_topic_by_row(screen_row, row.topic_text)
		else
			for player_index = 1, #self._stats_id_by_widget_index do
				local widget = score_widgets[player_index]

				if widget then
					local row_content = widget.content[row_name]

					row_content[score_text_name] = ""
					row_content.has_score = false
					row_content.has_highscore = false
				end
			end

			self:_set_score_topic_by_row(screen_row, "")
		end
	end
end

mod:hook_safe(EndViewStateScore, "update", function (self, dt, t)
	if not self._scoreboard_rows then
		return
	end

	local input_service = self.input_manager:get_service("end_of_level")

	mod.scrollbar:scroll(dt, input_service)

	if mod.scrollbar:update() then
		self:_render_scoreboard_rows(mod.scrollbar.start_index)
	end
end)

-- Own begin_pass/end_pass: vanilla's pass has already ended by the time
-- hook_safe runs, so a bare draw_widget call here would crash.
mod:hook_safe(EndViewStateScore, "draw", function (self, input_service, dt)
	if not self._scoreboard_rows then
		return
	end

	local ui_renderer = self.ui_renderer

	UIRenderer.begin_pass(ui_renderer, self.ui_scenegraph, input_service, dt, nil, self.render_settings)
	UIRenderer.draw_widget(ui_renderer, mod.scrollbar.widget)
	UIRenderer.end_pass(ui_renderer)
end)

-- While actively scrolling, don't let vanilla's own hover-highlight logic
-- react to rows sliding under a stationary mouse cursor.
mod:hook(EndViewStateScore, "_update_entry_hover", function (func, self, ...)
	if mod.scrollbar.widget and (mod.scrollbar:is_hovered() or mod.scrollbar:is_held()) then
		local widgets_by_name = self._widgets_by_name
		local topics_widget = widgets_by_name and widgets_by_name.scores_topics

		if topics_widget then
			local num_rows = topics_widget.content.num_rows

			for i = 1, num_rows do
				local hotspot = topics_widget.content["hotspot_" .. i]

				if hotspot then
					hotspot.is_hover = false
				end
			end
		end

		return
	end

	return func(self, ...)
end)
