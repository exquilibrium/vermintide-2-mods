local mod = get_mod("MMONames")

mod:network_register("mmonames_set_color", function (peer_id, r, g, b)
	mod.player_colors[peer_id] = {
		r,
		g,
		b
	}
end)
mod:network_register("mmonames_request_color", function ()
	mod.set_color()
end)

mod.set_color = function ()
	local r = mod:get("user_color_r")
	local g = mod:get("user_color_g")
	local b = mod:get("user_color_b")

	mod:network_send("mmonames_set_color", "all", r, g, b)
end

mod.on_setting_changed = function ()
	mod.set_color()
end

mod.on_user_joined = function ()
	mod:network_send("mmonames_request_color", "all")
end
