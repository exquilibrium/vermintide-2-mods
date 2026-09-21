local mod = get_mod("SetWobble")

local function get_multiplier()
	return mod:get("camera_sway") / 100
end

-- Scales the recoil camera kick (NoWobble's CameraManager.weapon_recoil hook, but wraps instead of reimplementing).
mod:hook(CameraManager, "weapon_recoil", function (func, self, recoil_settings, ...)
	local multiplier = get_multiplier()
	local scaled_settings = {
		vertical_climb = recoil_settings.vertical_climb * multiplier,
		horizontal_climb = recoil_settings.horizontal_climb * multiplier,
		climb_start_time = recoil_settings.climb_start_time,
		climb_end_time = recoil_settings.climb_end_time,
		restore_start_time = recoil_settings.restore_start_time,
		restore_end_time = recoil_settings.restore_end_time,
		climb_function = recoil_settings.climb_function,
		restore_function = recoil_settings.restore_function,
		id = recoil_settings.id,
	}

	return func(self, scaled_settings, ...)
end)

-- Blends the first-person rig's idle/aim/attack sway bone toward identity, instead of NoWobble's unconditional hard reset.
mod.update = function (dt)
	if not mod:is_enabled() or Managers.state.network == nil then
		return
	end

	local multiplier = get_multiplier()

	if multiplier >= 1 then
		return
	end

	local local_player = Managers.player:local_player()
	local player_unit = local_player and local_player.player_unit

	if not player_unit or not Unit.alive(player_unit) then
		return
	end

	local first_person_extension = ScriptUnit.extension(player_unit, "first_person_system")
	local first_person_unit = first_person_extension:get_first_person_unit()
	local camera_node = Unit.node(first_person_unit, "camera_node")
	local current_rotation = Unit.local_rotation(first_person_unit, camera_node)
	local current_position = Unit.local_position(first_person_unit, camera_node)

	Unit.set_local_rotation(first_person_unit, camera_node, Quaternion.lerp(Quaternion.identity(), current_rotation, multiplier))
	Unit.set_local_position(first_person_unit, camera_node, Vector3.lerp(Vector3.zero(), current_position, multiplier))
end
