return {
	mod_description = {
		en = "Play Vermintide 2 in third person. Bind a key to switch between first and third person view.",
	},
	toggle_third_person_keybind = {
		en = "Toggle third person",
	},
	toggle_third_person_keybind_tooltip = {
		en = "Switch between first person and third person camera."
			.."\nUses the game's own built-in over-the-shoulder third person camera, which keeps working correctly through attacking, aiming, and blocking.",
	},

	camera_settings_group = {
		en = "Camera Settings",
	},

	camera_shoulder_side = {
		en = "Default Camera Position",
	},
	camera_shoulder_side_tooltip = {
		en = "Which side of the character the third person camera sits on by default.",
	},
	camera_shoulder_side_left = {
		en = "Left shoulder",
	},
	camera_shoulder_side_right = {
		en = "Right shoulder",
	},
	camera_shoulder_side_center = {
		en = "Center",
	},

	camera_x_position = {
		en = "X Offset",
	},
	camera_x_position_tooltip = {
		en = "How far to the side of the character the camera sits."
			.."\nHas no effect while the default shoulder is set to Center.",
	},

	camera_y_position = {
		en = "Y Offset",
	},
	camera_y_position_tooltip = {
		en = "How high or low the camera sits. Negative values move it down, positive values move it up.",
	},

	camera_turn_horizontal = {
		en = "Yaw Offset",
	},
	camera_turn_horizontal_tooltip = {
		en = "Rotates the camera's view left/right, independent of the character's facing direction."
			.."\nThis only changes which way the camera looks, not where it sits.",
	},

	camera_turn_vertical = {
		en = "Pitch Offset",
	},
	camera_turn_vertical_tooltip = {
		en = "Rotates the camera's view up/down, independent of the character's facing direction."
			.."\nThis only changes which way the camera looks, not where it sits.",
	},

	camera_distance = {
		en = "Distance from player",
	},
	camera_distance_tooltip = {
		en = "How far behind the character the camera sits. Negative values move the camera closer than the default position.",
	},

	zoom_settings_group = {
		en = "Zoom Settings",
	},

	camera_first_person_when_aiming = {
		en = "First Person When Aiming",
	},
	camera_first_person_when_aiming_tooltip = {
		en = "Switch to a genuine first-person view while aiming a ranged weapon, instead of the third-person zoom below."
			.."\nWhile active, all Zoom and FOV settings below are ignored, and weapon zoom tiers (regular/special) behave exactly like normal first-person play.",
	},

	camera_zoom_enabled = {
		en = "Zoom",
	},
	camera_zoom_enabled_tooltip = {
		en = "Move the camera closer to the character while aiming a ranged weapon.",
	},

	camera_zoom_amount = {
		en = "Zoom Amount",
	},
	camera_zoom_amount_tooltip = {
		en = "How far the camera moves toward the character (on top of the normal distance above) while aiming."
			.."\nPositive values pull the camera closer/forward; negative values push it further away.",
	},

	camera_zoom_speed = {
		en = "Zoom Speed",
	},
	camera_zoom_speed_tooltip = {
		en = "How long the camera takes to transition between zoom states (no zoom, zoomed, weapon special zoom), in seconds."
			.."\nLower values transition faster.",
	},

	camera_weapon_special_zoom_enabled = {
		en = "Weapon Special Zoom",
	},
	camera_weapon_special_zoom_enabled_tooltip = {
		en = "Move the camera even closer while the weapon's special zoom is active (e.g. holding the secondary aim button on weapons that support it)."
			.."\nReplaces the regular zoom amount above while active, rather than adding to it.",
	},

	camera_weapon_special_zoom_amount = {
		en = "Weapon Special Zoom Amount",
	},
	camera_weapon_special_zoom_amount_tooltip = {
		en = "How far the camera moves toward the character (on top of the normal distance above) while the weapon's special zoom is active."
			.."\nPositive values pull the camera closer/forward; negative values push it further away.",
	},

	fov_settings_group = {
		en = "FOV Settings",
	},

	camera_fov_unzoomed = {
		en = "Unzoomed FOV",
	},
	camera_fov_unzoomed_tooltip = {
		en = "Vertical field of view, in degrees, used while not aiming a ranged weapon.",
	},

	camera_fov_zoomed = {
		en = "Zoomed FOV",
	},
	camera_fov_zoomed_tooltip = {
		en = "Vertical field of view, in degrees, used while aiming a ranged weapon (regular zoom)."
			.."\nLower values look more zoomed in.",
	},

	camera_fov_extra_zoomed = {
		en = "Extra Zoomed FOV",
	},
	camera_fov_extra_zoomed_tooltip = {
		en = "Vertical field of view, in degrees, used while the weapon's special zoom is active."
			.."\nLower values look more zoomed in.",
	},
}
