local mod = get_mod("stickybots")

local FOLLOW_TELEPORT_DISTANCE_SQ = mod:get("FOLLOW_TELEPORT_DISTANCE") * mod:get("FOLLOW_TELEPORT_DISTANCE")
    
mod:hook(BTConditions, "should_teleport", function (func, blackboard)
	local follow_unit = blackboard.ai_bot_group_extension.data.follow_unit

	if not ALIVE[follow_unit] or blackboard.has_teleported then
		return false
	end

	local self_unit = blackboard.unit
	local level_settings = LevelHelper:current_level_settings()
	local disable_bot_main_path_teleport_check = level_settings.disable_bot_main_path_teleport_check

	if not disable_bot_main_path_teleport_check then
		local conflict_director = Managers.state.conflict
		local self_segment = conflict_director:get_player_unit_segment(self_unit) or 1
		local target_segment = conflict_director:get_player_unit_segment(follow_unit)

		if not target_segment or target_segment < self_segment then
			return false
		end
	end

	local has_priority_target = blackboard.target_unit and blackboard.target_unit == blackboard.priority_target_enemy

	if blackboard.target_ally_need_type or has_priority_target then
		return false
	end

	local bot_whereabouts_extension = ScriptUnit.extension(self_unit, "whereabouts_system")
	local follow_unit_whereabouts_extension = ScriptUnit.extension(follow_unit, "whereabouts_system")
	local self_position = bot_whereabouts_extension:last_position_on_navmesh()
	local follow_unit_position = follow_unit_whereabouts_extension:last_position_on_navmesh()

	if not self_position or not follow_unit_position then
		return false
	end

	local distance_squared = Vector3.distance_squared(self_position, follow_unit_position)

	return FOLLOW_TELEPORT_DISTANCE_SQ <= distance_squared
end)
