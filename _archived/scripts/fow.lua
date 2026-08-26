local mod = get_mod("fow")
local fow = mod:persistent_table("fow")

fow.reset = function()
	TerrorEventBlueprints = fow.OriginalTerrorEventBlueprints
end

fow.disable = function(wave)
	fow.OriginalTerrorEventBlueprints = table.clone(TerrorEventBlueprints)
	if wave == 1 then
		TerrorEventBlueprints.plaza.plaza_wave_1 = {
			{
				"set_master_event_running",
				name = "survival"
			},
			{
				"flow_event",
				flow_event_name = "wave_1_complete"
			}
		}
	end
	if wave == 2 then
		TerrorEventBlueprints.plaza.plaza_wave_2 = {
			{
				"set_master_event_running",
				name = "survival"
			},
			{
				"flow_event",
				flow_event_name = "wave_2_complete"
			}
		}
	end
	if wave == 3 then
		TerrorEventBlueprints.plaza.plaza_wave_3 = {
			{
				"set_master_event_running",
				name = "survival"
			},
			{
				"flow_event",
				flow_event_name = "wave_3_complete"
			}
		}
	end
	if wave == 4 then
		TerrorEventBlueprints.plaza.plaza_wave_4 = {
			{
				"set_master_event_running",
				name = "survival"
			},
			{
				"flow_event",
				flow_event_name = "wave_4_complete"
			}
		}
	end
	if wave == 5 then
		TerrorEventBlueprints.plaza.plaza_wave_5 = {
			{
				"set_master_event_running",
				name = "survival"
			},
			{
				"flow_event",
				flow_event_name = "wave_5_complete"
			}
		}
	end
	if wave == 6 then
		TerrorEventBlueprints.plaza.plaza_wave_6 = {
			{
				"set_master_event_running",
				name = "survival"
			},
			{
				"flow_event",
				flow_event_name = "wave_6_complete"
			}
		}
	end
	if wave == 7 then
		TerrorEventBlueprints.plaza.plaza_wave_7 = {
			{
				"set_master_event_running",
				name = "survival"
			},
			{
				"flow_event",
				flow_event_name = "wave_7_complete"
			}
		}
	end
	if wave == 8 then
		TerrorEventBlueprints.plaza.plaza_wave_8 = {
			{
				"set_master_event_running",
				name = "survival"
			},
			{
				"flow_event",
				flow_event_name = "wave_8_complete"
			}
		}
	end

	fow.active = true
end

fow.check = function()
	if Managers.state.game_mode == nil or (Managers.state.game_mode._game_mode_key ~= "inn" and Managers.player.is_server) then
		mod:echo("You must be in the keep to do that!")
		return false
	end
	if Managers.matchmaking:_matchmaking_status() ~= "idle" then
		mod:echo("You must cancel matchmaking before toggling this.")
		return false
	end
	if not Managers.player.is_server then
		mod:echo("You must be the host to activate this.")
		return false
	end
	return true
end

fow.train = function(start_w, end_w)
	if not fow.check() then
		return
	end
	if start_wave > end_wave or start_wave < 1 or end_wave > 8 then
		mod:echo("ERROR: Invalid wave numbers!")
	end
	fow.reset()
	start_wave = tonumber(start_w)
	end_wave = tonumber(end_w)
	if start_wave > 1 then
		for i = 1, start_wave, 1 do
			fow.disable(i)
		end
	end
	if end_wave < 8 then
		for i = end_wave + 1, 8 - end_wave, 1 do
			fow.disable(i)
		end
	end
	mod:echo("Fortunes of War from wave ", start_wave, " to ", end_wave)
end

fow.light_show = function()
	if not fow.check() then
		return
	end
	fow.reset()
	for i = 1, 8, 1 do
		fow.disable(i)
	end
end

mod.on_game_state_changed = function(status, state)
	if not Managers.player.is_server and fow.active and Managers.state.game_mode ~= nil then
		mod:echo("The Fortunes of War Trainer was disabled because you are no longer the server.")
	end
	return
end

local function help()
	mod:echo(
		"Usage:\n" ..
		"/fow - show usage\n" ..
		"/fow help - show usage" ..
		"/fow train <start_wave> <end_wave> -\n" ..
		"<start_wave> : number from 1 to 8\n" ..
		"<end_wave> : number from <start_wave> to 8\n" ..
		"/fow light_show : disables all waves"
	)
end

local function fow_command(action, ...)
	if action == nil then
		action = "help"
	end

	if action == "help" then help()
	elseif action == "train" then fow.train(...)
	elseif action == "light_show" then fow.light_show()
	else
		mod:echo("ERROR : unknown command!")
	end
end

mod:command("fow", "Toggle FoW waves.", fow_command)