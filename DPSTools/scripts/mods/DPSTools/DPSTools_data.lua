local mod = get_mod("DPSTools")

mod.restriction_ratio = 0.15
mod.max_restriction = 100

mod.scoreTypeDefinitions = {
	headshots = {
		meter_type = "dps",
	},
	critical_hit = {
		meter_type = "dps",
	},
	critical_headshot = {
		meter_type = "dps",
	},
	damage = {
		meter_type = "dps",
		use_score_sum = true,
	},
	boss_damage = {
		meter_type = "dps",
		use_score_sum = true,
	},
	kills_normal = {
		meter_type = "dps",
		kills_score = true,
	},
	kills_elite = {
		meter_type = "dps",
		kills_score = true,
	},
	kills_boss = {
		meter_type = "dps",
		kills_score = true,
	},
	kills_special = {
		meter_type = "dps",
		kills_score = true,
	},
	kills_total = {
		meter_type = "dps",
	},
	healed_temp = {
		meter_type = "hps",
		use_score_sum = true,
	},
	healed = {
		meter_type = "hps",
		use_score_sum = true,
	},
	damage_taken = {
		meter_type = "hps",
	},
	assist = {
		meter_type = "hps",
	},
	dead = {
		meter_type = "hps",
	},
	knocked_down = {
		meter_type = "hps",
	}
}

mod.meter_templates = {
	dps = {
		elements = {
			{
				category = "time",
				display_text = "000:00",
			},
			{
				category = "name",
				display_text = "Name",
			},
			{
				category = "dps",
				display_text = "DPS",
				use_float = true
			},
			{
				category = "headshots",
				display_text = "Headshot",
			},
			{
				category = "critical_hit",
				display_text = "CriticalHit",
			},
			{
				category = "critical_headshot",
				display_text = "CriticalHeadshot",
			},
			{
				category = "kills_total",
				display_text = "Kills"
			},
			{
				category = "damage",
				display_text = "Damage",
				use_float = true
			},
			{
				category = "boss_damage",
				display_text = "BossDamage",
				use_float = true
			},
			{
				category = "damage_score",
				display_text = "TotalDamage",
				use_float = true
			},
		},
	},
	hps = {
		elements = {
			{
				category = "time",
				display_text = "000:00",
			},
			{
				category = "name",
				display_text = "Name",
			},
			{
				category = "hps",
				display_text = "HPS",
				use_float = true
			},
			{
				category = "dead",
				display_text = "Death",
			},
			{
				category = "knocked_down",
				display_text = "KnockedDown",
			},
			{
				category = "assist",
				display_text = "Assist",
			},
			{
				category = "damage_taken",
				display_text = "DamageTaken",
				use_float = true,
			},
			{
				category = "healed",
				display_text = "Healed",
				use_float = true
			},
			{
				category = "healed_temp",
				display_text = "TempHealed",
				use_float = true
			},
			{
				category = "heal_score",
				display_text = "TotalHealed",
				use_float = true
			},
		},
	},
}

for _, meter in pairs(mod.meter_templates) do
	meter.column_size = #meter.elements
end

mod.meter_option_template = {
	elements = {
		{
			display_text = "Start",
			on_pressed = function(meter, scoreController)
				scoreController:start()
			end
		},
		{
			display_text = "End",
			on_pressed = function(meter, scoreController)
				scoreController:finish()
			end
		},
		{
			display_text = "Clear",
			on_pressed = function(meter, scoreController)
				scoreController:clear()
			end,
			next_column = true
		},
		{
			display_text = "Default",
			on_pressed = function(meter, scoreController)
				mod.SaveDefaultSettings()
				meter:refresh_size_and_position()
			end,
			next_column = true
		},
		{
			display_text = "DPS",
			on_pressed = function(meter, scoreController)
				meter:set_mode("dps")
				scoreController:set_mode("dps")
			end
		},
		{
			display_text = "HPS",
			on_pressed = function(meter, scoreController)
				meter:set_mode("hps")
				scoreController:set_mode("hps")
			end,
			next_column = true
		},
		{
			display_text = "Lock",
			on_pressed = function(meter, scoreController)
				meter:lock_input()
			end
		},
		{
			display_text = "Close",
			on_pressed = function(meter, scoreController)
				mod.close_meter_ui()
			end,
			next_column = true
		},
	},
}

local option_column_size = 0

for _, option in ipairs(mod.meter_option_template.elements) do
	if option.next_column then
		option_column_size = option_column_size + 1
	end
end

mod.meter_option_template.columns = option_column_size

mod.shortened_career_lookup = {
	dr_ranger = " RV",
	dr_slayer = " SL",
	dr_ironbreaker = " IB",
	dr_engineer = " OE",
	we_waywatcher = " WS",
	we_shade = " SH",
	we_maidenguard = " HM",
	es_huntsman = " HS",
	es_mercenary = " ME",
	es_knight = " FK",
	es_questingknight = " GK",
	bw_adept = " BW",
	bw_scholar = " PY",
	bw_unchained = " UN",
	bw_necromancer = " NM",
	wh_captain = " WH",
	wh_bountyhunter = " BH",
	wh_zealot = " ZE",
	we_thornsister = " ST",
	wh_priest = " WP",
	unknown = "Unknown"
}

mod.data = {
	name = mod:localize("mod_title"),
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
		widgets = {
			{
				setting_id      = "meter_width_ratio",
				type            = "numeric",
				default_value   = 0.110,
				range           = { 0, 1 },
				decimals_number = 3,
			},
			{
				setting_id      = "meter_height_ratio",
				type            = "numeric",
				default_value   = 0.132,
				range           = { 0, 1 },
				decimals_number = 3,
			},
			{
				setting_id      = "meter_window_x_ratio",
				type            = "numeric",
				default_value   = 0.5,
				range           = { 0, 1 },
				decimals_number = 3,
			},
			{
				setting_id      = "meter_window_y_ratio",
				type            = "numeric",
				default_value   = 0.5,
				range           = { 0, 1 },
				decimals_number = 3,
			},
			{
				setting_id    = "meter_background_alpha",
				type          = "numeric",
				default_value = 60,
				range         = { 0, 255 },
			},
			{
				setting_id    = "meter_rect_alpha",
				type          = "numeric",
				default_value = 180,
				range         = { 0, 255 },
			},
			{
				setting_id    = "meter_font_scale",
				type          = "numeric",
				default_value = 1,
				range         = { 0, 10 },
			},
			{
				setting_id      = "meter_keybind",
				type            = "keybind",
				default_value   = { "f7" },
				keybind_global  = true,
				keybind_trigger = "pressed",
				keybind_type    = "function_call",
				function_name   = "on_meter_keypressed",
			},
			{
				setting_id      = "meter_reset_keybind",
				type            = "keybind",
				default_value   = { "f8" },
				keybind_global  = true,
				keybind_trigger = "pressed",
				keybind_type    = "function_call",
				function_name   = "on_meter_reset_keypressed",
			},
			{
				setting_id = "meter_disable_reset_keybind",
				type = "checkbox",
				default_value = false,
			},
		},
	},
}

return mod.data
