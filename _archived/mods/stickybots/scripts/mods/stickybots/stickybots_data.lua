local mod = get_mod("stickybots")

return {
	name = "Sticky Bots",
	description = mod:localize("mod_description"),
	is_togglable = false,
	options = {
		widgets = {
			{
				setting_id = "FOLLOW_TELEPORT_DISTANCE",
				type = "numeric",
				default_value = 7,
				range = { 0, 100 },
				title = "Follow Teleport Distance (REQUIRES RESTARTING)",
				tooltip = "The distance where bots will teleport to you. 1 unit is roughly 2 medpacks."
			}
		}
	},
}
