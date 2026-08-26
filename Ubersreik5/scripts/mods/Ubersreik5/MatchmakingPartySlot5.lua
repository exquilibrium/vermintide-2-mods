local mod = get_mod("Ubersreik5")

-- 5th-player readiness dot on the matchmaking overlay (the small light next
-- to the party portraits that goes green when a player is standing in the
-- "ready to proceed" zone, blue otherwise). All of that logic is 100%
-- vanilla and already player-count-agnostic:
-- MatchmakingUI._sync_players_ready_state checks each human player's
-- status_extension:is_in_end_zone() and calls _set_player_ready_state, which
-- swaps player_status_N's texture between "matchmaking_light_01" (ready) and
-- "matchmaking_light_02" (not ready) - and every loop involved
-- (_get_party_slot_index_by_peer_id, _update_portraits, _get_portrait_index)
-- is bounded by self._max_number_of_players, not a hardcoded 4. So the only
-- thing actually missing for a 5th player is the widget/scenegraph entries
-- themselves - matches the original Ubersreik Five mod's own scope here
-- (scripts/ui/views/matchmaking_ui_definitions.lua, just party_slot_5 and
-- player_status_5 added at reasonable positions, no custom logic).

-- Same size party_slot_1-4 use. The actual party_slot_5 scenegraph node is
-- added in CustomScoreboard.lua's init_scenegraph hook, not here - this mod
-- framework doesn't chain multiple mod:hook registrations from the same mod
-- on the same (table, method) pair (only the first one to register actually
-- takes effect), and CustomScoreboard.lua's scoreboard hook on
-- UISceneGraph.init_scenegraph already existed first, so that's where every
-- init_scenegraph patch for this mod has to live. This constant just needs
-- to match the size used there.
local PARTY_SLOT_5_SIZE = {
	60,
	70,
}

-- Mirrors the private create_status_widget() local in vanilla's
-- matchmaking_ui_definitions.lua (not exposed via UIWidgets, so it can't be
-- called directly) - every player_status_N widget is built from this same
-- shape, differing only by their offset into the shared "window" scenegraph
-- node.
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

-- Same offset the original mod used: same Y as player_status_1 (43), further
-- left (-171 vs -89) so it sits its own gap to the left of the 1-4 row.
local PLAYER_STATUS_5_OFFSET = {
	-171,
	43,
}

-- Unlike the scenegraph_definition table above (module-level, shared, so it
-- needs the once-guard), create_ui_elements builds self._widgets/
-- self._widgets_by_name/etc fresh every single call - so no "already added"
-- guard is needed here, this just runs after vanilla's own body every time.
mod:hook_safe(MatchmakingUI, "create_ui_elements", function (self)
	UIUtils.create_widgets({
		player_status_5 = create_status_widget("matchmaking_light_02", PLAYER_STATUS_5_OFFSET),
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

-- _update_status spins each party_slot's "connecting..." icon while its
-- player is still loading in - unlike every other per-slot loop in this
-- file, it hardcodes "for i = 1, 4" instead of self._max_number_of_players,
-- so party_slot_5's connecting icon would silently never spin. Duplicate
-- just that one calculation for slot 5 rather than touching vanilla's own
-- loop for 1-4.
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
