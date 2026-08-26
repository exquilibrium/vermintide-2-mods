local mod = get_mod("dtes")

mod.update = function(t)
    local ts = 1.2
    local level_key = Managers.state.game_mode:level_key()
    local terror_events = TerrorEventBlueprints[level_key]
    local spawner_system = Managers.state.entity:system("spawner_system")
    for key, event in pairs(terror_events) do
       for _, tbl in pairs(event) do
            if tbl and tbl.spawner_id then
                local unit = spawner_system:get_raw_spawner_unit(tbl.spawner_id)
                if unit then
                    script_data.disable_debug_draw = false
                    local h = 70
                    local add_height = Vector3(0, 0, h)
                    local color = Color(255, 0, 200, 0)
                    local debug_text_manager = Managers.state.debug_text
                
                    local pos = Unit.local_position(unit, 0)
                
                    QuickDrawer:line(pos, pos + add_height, color)
                
                    local d = 7 * t % 10
                
                    QuickDrawer:sphere(pos + Vector3(0, 0, d), 0.5, color)
                    QuickDrawer:sphere(pos + Vector3(0, 0, (d + 10) % h), 0.5, color)
                    QuickDrawer:sphere(pos + Vector3(0, 0, (d + 20) % h), 0.5, color)
                
                    local text = tbl.spawner_id
                    local text_size = ts
                    local offset_vector = Vector3(0, 0, -1)
                    local category = "spawner_id"
                    local color_table = Colors.get_table("white")
                    local color_vector = Vector3(color_table[2], color_table[3], color_table[4])
                    local viewport_name = "player_1"
                
                    debug_text_manager:clear_unit_text(unit, category)
                    debug_text_manager:output_unit_text(text, text_size, unit, 0, offset_vector, nil, category, color_vector, viewport_name)
                else
                    local spawners = spawner_system._id_lookup[tbl.spawner_id]
                    if not spawners then
                        mod:echo("No unit for %s", tbl.spawner_id)
                    end
                    for _, unit in pairs(spawners) do
                        script_data.disable_debug_draw = false
                        local h = 70
                        local add_height = Vector3(0, 0, h)
                        local color = Color(255, 0, 200, 0)
                        local debug_text_manager = Managers.state.debug_text
                    
                        local pos = Unit.local_position(unit, 0)
                    
                        QuickDrawer:line(pos, pos + add_height, color)
                    
                        local d = 7 * t % 10
                    
                        QuickDrawer:sphere(pos + Vector3(0, 0, d), 0.5, color)
                        QuickDrawer:sphere(pos + Vector3(0, 0, (d + 10) % h), 0.5, color)
                        QuickDrawer:sphere(pos + Vector3(0, 0, (d + 20) % h), 0.5, color)
                    
                        local text = tbl.spawner_id
                        local text_size = ts
                        local offset_vector = Vector3(0, 0, -1)
                        local category = "spawner_id"
                        local color_table = Colors.get_table("white")
                        local color_vector = Vector3(color_table[2], color_table[3], color_table[4])
                        local viewport_name = "player_1"
                    
                        debug_text_manager:clear_unit_text(unit, category)
                        debug_text_manager:output_unit_text(text, text_size, unit, 0, offset_vector, nil, category, color_vector, viewport_name)
                    end
                end
            end
        end
    end
end
