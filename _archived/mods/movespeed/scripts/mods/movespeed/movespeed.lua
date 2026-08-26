local mod = get_mod("movespeed")

-- Local variables
local activated = false
local logging = false

local t = 0
local time = 0
local timer = 3
local add_dist = 0
local distance = 0
local distance_all = 0

local file = nil
local player_unit = nil
local pos = nil

local start_x = 0
local start_y = 0
local start_time = os.clock()

-- Update function
mod.update = function(dt)
    if activated then
        player_unit = Managers.player:local_player().player_unit
        pos = Unit.local_position(player_unit, 0)
        if pos ~= nil then
            add_dist = math.sqrt((pos.x - start_x) * (pos.x - start_x) + (pos.y - start_y) * (pos.y - start_y))
            distance = distance + add_dist
            start_x = pos.x
            start_y = pos.y

            if logging then
                distance_all = distance_all + distance
                io.write(add_dist/(os.clock() - t) .. "\n")
                t = os.clock()
            end
            if timer < os.clock() - start_time then
                start_time = os.clock()
                mod:echo(distance/timer, " U/s")
                distance = 0
            end
        else
            mod:echo("ERROR: Can't access player position!")
        end
    end
end

-- Print help
local function ms_help()
	mod:echo(
        "Usage:\n"..
		"1.)\"/ms\" or \"/ms help\" - print help\n"..
		"2.)\"/ms toggle\" - toggle print movespeed in chat\n"..
        "3.)\"/ms timer <intervall>\" - set intervall to print movement speed\n" ..
        "4.)\"/ms log\" or \"/ms log <name>\" - toggle log movement speed to file with filename: \"mslog_<date>_<time>\" or \"mslog_<name>\". \"ms log\" is enough to toggle logging off"
	)
end

-- Toggle print movespeed
local function ms_toggle()
    activated = not activated
    logging = false
end

-- Set intervall
local function ms_timer(intervall)
    if tonumber(intervall) <= 0 then
        mod:echo("ERROR: Invalid intervall!")
        return
    end
    timer = tonumber(intervall)
    mod:echo("Timer set to " .. timer)
end

-- Toggle log movement
local function ms_log(filename)
    if activated then
        logging = not logging
        if logging then
            if filename ~= nil then
                filename = "mslog_" .. filename .. ".txt"
                file = io.open(filename, "a")
                io.output(file)
            else
                date = os.date("*t")
                filename = "mslog_" .. date.year .. "-" .. date.month .. "-" .. date.day .. "_" .. date.hour .. "-" .. date.min .. "-" .. date.sec .. ".txt"
                file = io.open(filename, "a")
                io.output(file)
            end
            io.write("------------------------------ START : ")
            io.write(os.date() .. "\n")
            t = os.clock()
            time = t
        else
            io.write("------------------------------\n")
            io.write("Logged time: " .. (os.clock() - time) .. "\n")
            io.write("Logged distance: " .. distance_all .. "\n")
            io.write("------------------------------ END\n")
            io.close(file)
            time = 0
            distance_all = 0
        end
    else
        mod:echo("ERROR: Print Movement Speed not toggled!")
    end
end

-- Function to recognize chat commands
local function ms_command(action, ...)
	if action == nil then
		action = "help"
    end
    
    if action == "help" then ms_help()
    elseif action == "toggle" then ms_toggle()
    elseif action == "timer" then ms_timer(...)
    elseif action == "log" then ms_log(...)
    else
        mod:echo("ERROR: Invalid command")
    end
end

mod:command("ms", "Movespeed mod commands help", ms_command)

--[[ Mod Description 

Title: Print Movement Speed

Description:
Prints movement speed in chat.

Usage:
"/ms" or "/ms help" - prints help
"/ms toggle" - toggle print movement speed in chat
"/ms timer <intervall>" - set intervall to print movement speed
"/ms log" or "/ms log <name>" - toggle log movement speed to file with filename: "mslog_<date>_<time>" or "mslog_<name>". "ms log" is enough to toggle logging off

Notes:
- Movement speed precision depends on your FPS e.g. with 60 FPS the distance is calculated every 1/60 seconds.
- Default timer intervall is 3. Increase this to get an average value from a longer period.
- The log command protocolls movement speed every frame into a file. Using the same filename twice results in writing the file again (not overwriting).
Additionally the overall logged time and distance will be written at the bottom.
The file is under
"C:\Program Files (x86)\Steam\steamapps\common\Warhammer Vermintide 2\binaries" or
"C:\Program Files (x86)\Steam\steamapps\common\Warhammer Vermintide 2\binaries_dx12"
depending on which DirectX version the mod was used.

--]]
