local mod = get_mod("MMONames")

return {
	name = "MMONames",
	is_togglable = true,
	description = mod:localize("mod_description"),
	custom_gui_textures = {
		atlases = {
			{
				"atlases/mods/MMONames/v2_career_icons",
				"v2_career_icons"
			}
		},
		ui_renderer_injections = {
			{
				"ingame_ui",
				"materials/mods/MMONames/v2_career_icons"
			}
		}
	},
	options = {
		widgets = {
			{
				setting_id = "last_build_group",
				type = "group",
				sub_widgets = {}
			},
			{
				setting_id = "font_size_group",
				type = "group",
				sub_widgets = {
					{
						default_value = 1,
						setting_id = "font",
						type = "dropdown",
						options = {
							{
								text = "hell_shark_body",
								value = 1
							},
							{
								text = "hell_shark_header",
								value = 2
							},
							{
								text = "arial",
								value = 3
							}
						}
					},
					{
						default_value = 10,
						setting_id = "min_font_size",
						type = "numeric",
						range = {
							1,
							255
						}
					},
					{
						default_value = 20,
						setting_id = "max_font_size",
						type = "numeric",
						range = {
							1,
							255
						}
					}
				}
			},
			{
				setting_id = "render_distance_group",
				type = "group",
				sub_widgets = {
					{
						default_value = 0,
						setting_id = "min_render_distance",
						type = "numeric",
						range = {
							0,
							1000
						}
					},
					{
						default_value = 255,
						setting_id = "max_render_distance",
						type = "numeric",
						range = {
							0,
							1000
						}
					}
				}
			},
			{
				setting_id = "group_user_color_specific_name_not_to_match_children_startswith",
				type = "group",
				sub_widgets = {
					{
						default_value = 255,
						setting_id = "user_color_r",
						type = "numeric",
						range = {
							0,
							255
						}
					},
					{
						default_value = 255,
						setting_id = "user_color_g",
						type = "numeric",
						range = {
							0,
							255
						}
					},
					{
						default_value = 255,
						setting_id = "user_color_b",
						type = "numeric",
						range = {
							0,
							255
						}
					}
				}
			},
			{
				setting_id = "misc_group",
				type = "group",
				sub_widgets = {
					{
						default_value = true,
						setting_id = "show_name",
						type = "checkbox"
					},
					{
						default_value = true,
						setting_id = "show_career_icon",
						type = "checkbox"
					},
					{
						default_value = true,
						setting_id = "show_health",
						type = "checkbox"
					},
					{
						default_value = true,
						setting_id = "text_shadow",
						type = "checkbox"
					},
					{
						default_value = true,
						setting_id = "transparent_at_distance",
						type = "checkbox"
					},
					{
						default_value = 100,
						setting_id = "aim_opacity",
						type = "numeric",
						range = {
							0,
							100
						}
					},
					{
						default_value = false,
						setting_id = "display_own_name",
						type = "checkbox"
					},
					{
						default_value = false,
						setting_id = "color_override",
						type = "checkbox"
					}
				}
			}
		}
	}
}
