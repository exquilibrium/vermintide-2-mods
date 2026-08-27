local mod = get_mod("Ubersreik5")

-- End-of-level scoreboard: a real 5th player panel + a scrollbar for extra
-- stat columns, matching the original Ubersreik Five mod's design. Vanilla's
-- own row widgets (UIWidgets.create_score_entry/create_score_topics) bake in
-- their row count and *size* at widget-creation time (a `size` constructor
-- parameter, not something read live from the scenegraph node) - so getting
-- players 1-4 to actually render thinner/taller requires fully recreating
-- those widgets with the new size, not just resizing their scenegraph nodes.

-- Row capacity to build every score widget with (independent of how many
-- rows are actually shown at once - see mod.scoreboard.rows below). Matches
-- the original mod's own widget-creation row count.
local WIDGET_ROW_CAPACITY = 25

mod.scores = {}

-- Row layout math below (header offset 80, row height 39) mirrors vanilla's
-- own UIWidgets.create_score_entry/create_score_topics: both lay out row k at
-- y = size[2] - 80 - k * row_bg_settings.size[2], where row_bg_settings comes
-- from the "scoreboard_topic_bg" atlas entry (scripts/ui/atlas_settings/
-- gui_menus_atlas.lua) - 39px tall, not the round 40 you'd guess. Sizing the
-- panel for anything but exactly header + rows_default * 39 leaves dead space
-- below the last row that grows by the same amount at every "extend" value
-- (extension adds height 1:1 per row, so the mismatch never gets absorbed).
-- BOTTOM_PADDING_ROWS adds exactly that much dead space back deliberately -
-- it's added to the base size (not run through extension()), so it stays a
-- constant 1 empty row of padding below the last row at every "extend" value,
-- without shifting the scrollbar's visible_rows count (which only counts
-- real content rows).
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

-- Scrollbar. Index space is into self._scoreboard_rows (built in
-- _setup_score_panel below): row 1 (player names) is fixed and never part of
-- this; the scrollbar covers rows 2..(1 + total scrollable rows). Manual
-- (mouse wheel / gamepad) scrolling only - the original's idle auto-scroll
-- animation had the heaviest decompiler corruption of anything in this file
-- (unclear timing constants, several undefined locals) and is skipped as a
-- deliberate simplification rather than guessed at.
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

-- init_scenegraph only needs to add player_panel_5/player_frame_5 (the
-- widgets consuming panels 1-4 get fully recreated in create_ui_elements
-- below regardless, but the scenegraph *nodes* for 1-4 still need their
-- size/position updated since UISceneGraph resolves world positions from
-- these). Only patch EndViewStateScore's scenegraph: init_scenegraph is
-- shared by dozens of unrelated UI screens; player_panel_4 + scores_topics
-- together are a shape unique to the end-of-level score screen.
--
-- Single init_scenegraph hook for the whole mod: this modding framework does
-- not chain multiple mod:hook registrations from the SAME mod on the SAME
-- (table, method) pair - only the first one to register actually takes
-- effect, later ones silently never fire. So every UISceneGraph.
-- init_scenegraph patch (this scoreboard one, and the matchmaking party_slot_5
-- one below) has to live in this one hook, each behind its own independent
-- shape check, rather than each registering its own separate hook.
mod:hook(UISceneGraph, "init_scenegraph", function (func, scenegraph_def, ...)
	if scenegraph_def.player_panel_4 and scenegraph_def.scores_topics then
		local panel_size = mod.scoreboard:player_score_size()
		-- UIRenderer.begin_pass calls UISceneGraph.update_scenegraph every frame
		-- (scripts/ui/ui_renderer.lua), which *does* apply vertical_alignment via
		-- align() - against the engine's real per-resolution screen height, not a
		-- hardcoded 1080. With vertical_alignment "top", a child's top edge
		-- resolves to position[2] + screen_height regardless of the child's own
		-- size - so pinning TOP_OFFSET here needs no compensation for
		-- mod.scoreboard:extension() at all (unlike "center", which would need
		-- half the size delta subtracted to hold an edge fixed), and it stays
		-- correct across resolutions/aspect ratios since screen_height comes from
		-- the engine instead of an assumed 1080. player_frame_i (portraits) and
		-- the level icon attach "top" further down this same parent chain, so
		-- they inherit this fixed position automatically.
		local TOP_OFFSET = -220

		scenegraph_def.scores_topics.horizontal_alignment = "center"
		scenegraph_def.scores_topics.vertical_alignment = "top"
		scenegraph_def.scores_topics.size[2] = panel_size[2]
		scenegraph_def.scores_topics.position[1] = -700
		scenegraph_def.scores_topics.position[2] = TOP_OFFSET

		-- scenegraph_def is vanilla's own module-level table (scripts/ui/views/
		-- level_end/states/definitions/end_view_state_score_definitions.lua),
		-- shared/reused for every scoreboard built for the rest of the game
		-- session - not recreated per build. So player_panel_5/player_frame_5/
		-- scrollbar must only be added once (they'd otherwise just be
		-- overwritten harmlessly, but there's no reason to redo it), while
		-- everything below that depends on the *current* "extend" setting (size,
		-- position[2], vertical_alignment) must run on every call - otherwise a
		-- setting change after the first scoreboard of the session never takes
		-- effect on the scenegraph (create_ui_elements still rebuilds the
		-- widgets fresh every time against the stale, frozen anchor, which is
		-- what made the panel look bottom-anchored again after changing "extend"
		-- more than once without reloading).
		if not scenegraph_def.player_panel_5 then
			-- vertical_alignment/position[2] are placeholders here - the loop
			-- below overwrites both for all 5 panels, including this one.
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

	-- Matchmaking overlay's 5th-player readiness dot (see
	-- MatchmakingPartySlot5.lua) - party_slot_N widgets attach to this node,
	-- so it needs to exist before MatchmakingUI.create_ui_elements builds
	-- them. party_slot_4 + party_slot_root together are a shape unique to
	-- the matchmaking screen.
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

-- Vanilla's own entrance animation (transition_enter's move_inner_panels /
-- move_outer_panels, in end_view_state_score_definitions.lua) directly
-- overwrites player_panel_1-4's local_position[1] every frame, sliding them
-- to vanilla's hardcoded 4-player rest spots (-700, -375, 375, 700) -
-- overriding whatever init_scenegraph set as their base position. Since
-- player_panel_5 has no animation entry of its own, it just sits at its
-- init_scenegraph position (650), landing on top of panels 3/4's vanilla
-- rest spots. Re-registering both callbacks with new rest spots (evenly
-- spaced alongside the topics column at -700 and panel 5 at 650) is how the
-- original mod fixed this; same fix, same rest-spot values.
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

-- Full replace: call vanilla's own create_ui_elements first (creates
-- player_panel_1-4's widgets at vanilla's default size, and the default
-- scores_topics widget), then rebuild scores_topics and all 5 score widgets
-- at our size/row-capacity, matching the original mod's approach.
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

-- Vanilla's own _setup_player_scores/_setup_score_panel already handle a 5th
-- player correctly once _score_widgets[5] exists (they iterate however many
-- players are actually in players_session_scores, not a hardcoded 4) - no
-- need to replace that logic. This just captures the per-player stats_id
-- list, in the SAME order vanilla assigns widget indices, for the
-- custom-entry callbacks below. Must run BEFORE calling through to vanilla,
-- not hook_safe after: vanilla's own _setup_player_scores calls
-- _setup_score_panel internally near its own end, and that hook (below)
-- depends on _stats_id_by_widget_index already being set.
--
-- Deliberately NOT table.sort()-ed: vanilla's own widget_index assignment
-- (further down in this same function, for _players_by_widget_index/
-- _score_widgets) is a plain incrementing counter over its own
-- pairs(players_session_scores) loop - unsorted. A previous version of this
-- sorted stats_ids alphabetically for (mistaken) determinism, which put our
-- list in a different order than vanilla's, so self._stats_id_by_widget_index
-- [i] and vanilla's own player at widget index i were often two different
-- players - misattributing every custom stat column to the wrong player.
-- Plain pairs() with no sort here lands in the exact same order vanilla's own
-- subsequent pairs() call over this same, unmodified table does (Lua's
-- pairs()/next() iteration order is deterministic for an unchanged table).
mod:hook(EndViewStateScore, "_setup_player_scores", function (func, self, players_session_scores)
	local stats_ids = {}

	for stats_id in pairs(players_session_scores) do
		stats_ids[#stats_ids + 1] = stats_id
	end

	self._stats_id_by_widget_index = stats_ids

	local result = func(self, players_session_scores)

	-- Both _hero_widgets (vanilla's own, pre-created at a fixed 4 slots in
	-- create_ui_elements) and _score_widgets (this mod's, pre-created at a
	-- fixed 5 slots) are built before the real player count is known. The
	-- loop above only overwrites slots 1..num_players with a real player's
	-- widget, so any slot beyond that still holds its original empty
	-- placeholder - an extra panel/frame with no player in it. Nil those
	-- trailing slots out so vanilla's own draw() (which walks both arrays
	-- with ipairs, stopping at the first nil) simply skips them.
	local num_players = #stats_ids

	for index = num_players + 1, #self._hero_widgets do
		self._hero_widgets[index] = nil
	end

	for index = num_players + 1, #self._score_widgets do
		self._score_widgets[index] = nil
	end

	return result
end)

-- After vanilla writes its own native rows (1 name row + 1 per stat topic)
-- into _score_widgets[1..N].content, append our custom entries as
-- additional scrollable rows.
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

-- Own begin_pass/end_pass: vanilla's real draw() already ended its own pass
-- by the time a hook_safe body runs, so drawing the scrollbar needs a
-- separate pass, not a bare draw_widget call after the fact (that crashes -
-- self.ui_renderer.ui_scenegraph is nil once a pass has ended).
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
