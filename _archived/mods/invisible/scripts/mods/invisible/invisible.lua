local mod = get_mod("invisible")

local b_invisible = false

mod.invisible = function(invisible)
    local local_player = Managers.player:local_player()
    
    if Unit.alive(local_player.player_unit) then
        local status_ext = ScriptUnit.extension(local_player.player_unit, "status_system")

        status_ext:set_invisible(invisible)
    end
end

mod:command("invisible", "", function()
    b_invisible = not b_invisible
    if b_invisible then
        mod:echo("invisible [ON]")
    else
        mod:echo("invisible [OFF]")
    end
    mod.invisible(b_invisible)
end)