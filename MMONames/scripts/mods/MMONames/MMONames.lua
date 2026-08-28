local mod = get_mod("MMONames")
mod.player_colors = {}

mod:dofile("scripts/mods/MMONames/ColorPicker")
mod:dofile("scripts/mods/MMONames/NetworkColours")

local fonts = {
	{
		size_mod = 2,
		name = "gw_body"
	},
	{
		size_mod = 4,
		name = "gw_head"
	},
	{
		size_mod = 0,
		name = "arial"
	}
}

local FIRST_PERSON_DISTANCE_THRESHOLD = 0.5

local function draw_icon(renderer, unit, camera, player_position, is_local_player)
	if not Unit.alive(unit.player_unit) then
		return
	end

	local font_index = mod:get("font")
	local font_name = fonts[font_index].name
	local font_material = "materials/fonts/" .. font_name
	local head_node = Unit.has_node(unit.player_unit, "c_head") and Unit.node(unit.player_unit, "c_head")
	local head_pos = Unit.world_position(unit.player_unit, head_node)

	if not head_pos then
		return
	end

	local min_render_distance = mod:get("min_render_distance") or 0
	local max_render_distance = mod:get("max_render_distance") or 255
	local distance = Vector3.distance(head_pos, player_position)

	-- Own tag only makes sense when actually seeing yourself from outside your own head. Normally
	-- the game's own third-person camera states (hooked/grabbed/executed/awaiting respawn) are the
	-- only source of truth. The ThirdPerson mod pulls the camera back without ever touching those
	-- states though, so when it's loaded also fall back to a plain distance check: camera far from
	-- your own head means you're looking at yourself regardless of what moved the camera there.
	if is_local_player and not mod.is_in_third_person then
		if not mod.third_person_mod_loaded or distance < FIRST_PERSON_DISTANCE_THRESHOLD then
			return
		end
	end

	if max_render_distance < distance or distance < min_render_distance then
		return
	end

	head_pos = head_pos + Vector3(0, 0, 0.333)
	local screen_pos, depth = Camera.world_to_screen(camera, head_pos)

	if depth >= 1 then
		return
	end

	local arbitrary_max_distance_cutoff = 100
	local scale = math.clamp(1 - distance / arbitrary_max_distance_cutoff, 0, 1)
	local alpha = mod:get("transparent_at_distance") and math.clamp(1 - distance / arbitrary_max_distance_cutoff, 0.1, 1) * 255 or 255

	if mod.is_aiming then
		alpha = alpha * (mod:get("aim_opacity") / 100)
	end

	local render_scale = RESOLUTION_LOOKUP.inv_scale
	local font_render_scale = RESOLUTION_LOOKUP.scale
	local min_font_size = mod:get("min_font_size") * font_render_scale
	local max_font_size = mod:get("max_font_size") * font_render_scale
	local font_size = math.clamp(max_font_size * scale, min_font_size, max_font_size) + fonts[font_index].size_mod
	local player_color = mod.get_player_color(unit)
	local color = {
		alpha,
		player_color[1],
		player_color[2],
		player_color[3]
	}
	local name = unit:name()
	local text = ""

	if mod:get("show_name") then
		text = text .. name
	end

	if mod:get("show_health") then
		local player_unit = unit.player_unit
		local health_ext = ScriptUnit.extension(player_unit, "health_system")
		local health_percent = health_ext:current_health_percent()

		if health_percent then
			text = text .. string.format(" [%d%%]", math.floor(health_percent * 100))
		end
	end

	local min, max = Gui.text_extents(renderer.gui, text, font_material, font_size)
	local size = max - min
	local position = Vector3((screen_pos[1] - size.x / 2) * render_scale, (screen_pos[2] - size.y / 2) * render_scale, 0)

	if mod:get("show_career_icon") then
		local career_ext = ScriptUnit.extension(unit.player_unit, "career_system")

		if career_ext then
			position = position + Vector3(font_size / 3, 0, 0)
			local career_name = career_ext:career_name()

			local icon = "copy_" .. career_name
			local icon_position = position - Vector3(font_size, font_size / 3, 0)
			local icon_size = {
				font_size,
				font_size
			}

			UIRenderer.draw_texture(renderer, icon, icon_position, icon_size, color)
		end
	end

	if mod:get("text_shadow") then
		local offset = math.clamp(font_size / 30, 1, 3)

		UIRenderer.draw_text(renderer, text, font_material, font_size, font_name, position + Vector3(offset, -offset, 0), {
			alpha,
			0,
			0,
			0
		})
	end

	UIRenderer.draw_text(renderer, text, font_material, font_size, font_name, position, color)
end

mod.get_player_color = function (player)
	local current_player = Managers.player:local_player()

	if not player:is_player_controlled() then
		return {
			255,
			255,
			255
		}
	end

	if player == current_player or mod:get("color_override") then
		return {
			mod:get("user_color_r"),
			mod:get("user_color_g"),
			mod:get("user_color_b")
		}
	end

	return mod.player_colors[player.peer_id] or {
		255,
		255,
		255
	}
end

mod.get_camera = function (player)
	local world = Managers.world:world("level_world")
	local viewport = ScriptWorld.viewport(world, player.viewport_name)
	local camera = ScriptViewport.camera(viewport)

	return camera
end

mod.is_in_third_person = false
mod.is_in_third_person_timeout = 0

-- The ThirdPerson mod drives the camera itself without going through the game's own third-person
-- camera states, so the own-tag visibility check below needs a geometric fallback specifically
-- when it's loaded (see the comment in draw_icon).
mod.third_person_mod_loaded = false

mod.on_all_mods_loaded = function ()
	mod.third_person_mod_loaded = get_mod("ThirdPerson") ~= nil
end

mod:hook_safe(CameraStateFollowThirdPerson, "update", function (self, _, _, _, _, t)
	if self.name == "follow_third_person" then
		mod.is_in_third_person = true
		mod.is_in_third_person_timeout = t + 0.5
	else
		mod.is_in_third_person = false
	end
end)

mod.is_aiming = false

local function is_local_player_action(self)
	local owner_player = self.owner_player

	return owner_player ~= nil and not owner_player.remote and not owner_player.bot_player
end

-- Weapons whose charge/aim hold uses the generic "dummy" action kind, keyed by their
-- weapon_template.weapon_type. Add more here if other charge-hold weapons turn out to need it too.
local CHARGE_HOLD_WEAPON_TYPES = {
	THROWING_AXE = true,
	BRACE_OF_PISTOLS = true,
}

local function is_charge_hold_weapon_action(self)
	local item_data = self.item_name and rawget(ItemMasterList, self.item_name)
	local weapon_template_name = item_data and item_data.template
	local weapon_template = weapon_template_name and WeaponUtils.get_weapon_template(weapon_template_name)

	return weapon_template ~= nil and CHARGE_HOLD_WEAPON_TYPES[weapon_template.weapon_type] == true
end

-- Bounty Hunter's "Coup de Grace" ultimate: the actual holding-to-aim phase is this career-ability
-- item's "career_dummy" hold action, not ActionCareerWHBountyhunter (that's only the brief release
-- shot). ActionCareerDummy is shared by nearly every hero's career ability wield/hold wrapper, most
-- of which have nothing to do with aiming, so this is scoped to the Bounty Hunter's ability item.
local function is_bounty_hunter_ultimate_action(self)
	return self.item_name == "victor_bountyhunter_career_skill_weapon" or self.item_name == "victor_bountyhunter_career_skill_weapon_vs"
end

-- Javelin's (and any other weapon's) charged throw reuses ActionMeleeStart, which only zooms/aims
-- when the specific sub-action is configured to (set on client_owner_start_action, read back here)
local function is_zoom_charge_action(self)
	return self.zoom_condition_function ~= nil
end

local function register_aiming_action(action_class, extra_condition)
	mod:hook_safe(action_class, "client_owner_start_action", function (self, new_action, t)
		if is_local_player_action(self) and (not extra_condition or extra_condition(self)) then
			mod.is_aiming = true
		end
	end)
	mod:hook_safe(action_class, "finish", function (self, reason)
		if is_local_player_action(self) and (not extra_condition or extra_condition(self)) then
			mod.is_aiming = false
		end
	end)
end

-- Bows, crossbows, handguns, staves and most other ranged weapons' hold-to-aim/charge phase
register_aiming_action(ActionAim)

-- Moonfire Bow's energy-charge aim. It extends ActionAim but never defines its own "finish" -
-- the engine's class() does copy-based inheritance, not metatables, so a class that doesn't
-- override a method gets a frozen copy of it from load time, and hooking ActionAim.finish can't
-- reach that copy. client_owner_start_action IS overridden (and chains via .super, which is a
-- live reference), so only "finish" was silently missing, leaving is_aiming stuck true.
register_aiming_action(ActionAimEnergy)

-- Same copy-inheritance gap as ActionAimEnergy above, on the class used specifically by
-- Waystalker's "Piercing Shot" talent (the pierce-through variant of Trueflight Volley)
register_aiming_action(ActionCareerAim)

-- Bounty Hunter's handgun weapon; also the brief release-shot moment of "Coup de Grace"
register_aiming_action(ActionBountyHunterHandgun)

-- The actual holding phase of Bounty Hunter's "Coup de Grace" ultimate (see comment above)
register_aiming_action(ActionCareerDummy, is_bounty_hunter_ultimate_action)

-- Waystalker's "Trueflight Volley" and Pyromancer's "Piercing Flame" career ability target-lock/charge phase
register_aiming_action(ActionCareerTrueFlightAim)

-- Charged Throwing Axe throw and charged Brace of Pistols shot (see CHARGE_HOLD_WEAPON_TYPES)
register_aiming_action(ActionDummy, is_charge_hold_weapon_action)

-- Javelin's charged throw (and any other weapon's zoom-enabled charged heavy attack)
register_aiming_action(ActionMeleeStart, is_zoom_charge_action)

-- Drakegun and Flamestorm Staff's continuous flame stream (no ActionAim relation at all - a
-- standalone ActionBase subclass with its own client_owner_start_action/finish)
register_aiming_action(ActionFlamethrower)

-- Beam Staff's continuous beam (same standalone shape as ActionFlamethrower above)
register_aiming_action(ActionBeam)

-- Charge-up phase shared by Fireball Staff, Conflagration Staff, Bolt Staff and Drakefire
-- Pistols (also grenades and a couple of other charge-hold weapons, which is fine here too)
register_aiming_action(ActionCharge)

-- Conflagration Staff's ground-target aim (holding to place the geyser before it erupts)
register_aiming_action(ActionGeiserTargeting)

-- Drakefire Pistols' continuous ember spray alt-fire
register_aiming_action(ActionBulletSpray)

mod:hook_safe(IngameUI, "post_update", function (self, _, t)
	local renderer = self.ui_renderer
	local current_player = Managers.player:local_player()
	local camera = mod.get_camera(current_player)

	if not camera then
		return
	end

	if mod.is_in_third_person and mod.is_in_third_person_timeout <= t then
		mod.is_in_third_person = false
	end

	local player_status = Managers.party:get_player_status(current_player.peer_id, current_player._local_player_id)
	local health_state = player_status.game_mode_data.health_state

	if health_state == "respawn" then
		mod.is_in_third_person = true
	end

	local players = Managers.player:human_and_bot_players()
	local display_own_name = mod:get("display_own_name")

	-- The camera's own position is always correct as the "viewer" reference for distance-based
	-- font scaling, whether you're alive in first person, watching your downed body in third
	-- person while awaiting rescue, or spectating a teammate after dying - no need to track which
	-- unit is being followed separately.
	local player_position = Camera.world_position(camera)

	for _, player in pairs(players) do
		local is_local_player = player == current_player

		if not is_local_player or display_own_name then
			draw_icon(renderer, player, camera, player_position, is_local_player)
		end
	end
end)
