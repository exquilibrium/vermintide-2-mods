local mod = get_mod("DPSTools")

local Unit = Unit
local Unit_alive = Unit.alive
local Unit_get_data = Unit.get_data
local ScriptUnit = ScriptUnit
local Managers = Managers
local DamageDataIndex = DamageDataIndex
local AiUtils = AiUtils
local math = math

mod:hook_safe("StateInGameRunning", "gm_event_end_conditions_met", function()
    mod.scoreController:finish()
end)

mod:hook_safe("StateInGameRunning", "_setup_end_of_level_UI", function()
    mod.scoreController:finish()
end)

mod:hook_safe("StateInGameRunning", "_game_actually_starts", function(self)
    if self.is_in_inn then
        return
    end

    mod.scoreController:clear()
end)

mod:hook_safe("GenericStatusExtension", "set_dead", function(self, dead)
    if not dead then
        return
    end

    mod.scoreController:add_score(self.player, "dead", 1)
end)

mod:hook_safe("StatisticsUtil", "register_knockdown", function(victim_unit, damage_data, statistics_db, is_server)
    local victim_health_extension = ScriptUnit.has_extension(victim_unit, "health_system")
    local victim_damage_data = victim_health_extension.last_damage_data

    if not victim_damage_data then
        return
    end

    local victim_player = Managers.player:owner(victim_unit)

    if victim_player then
        mod.scoreController:add_score(victim_player, "knocked_down", 1)
    end
end)

mod:hook("StatisticsUtil", "register_kill", function(func, victim_unit, damage_data, statistics_db, is_server)
    local victim_health_extension = ScriptUnit.has_extension(victim_unit, "health_system")
    local victim_damage_data = victim_health_extension.last_damage_data

    if not victim_damage_data then
        return
    end

    local player_manager = Managers.player
    local victim_player = player_manager:owner(victim_unit)
    local breed_killed = Unit_get_data(victim_unit, "breed")
    local attacker_side = victim_damage_data.attacker_side
    local attacker_unique_id = victim_damage_data.attacker_unique_id
    local attacker_player = player_manager:player_from_unique_id(attacker_unique_id)

    if attacker_player and attacker_player ~= victim_player then
        if breed_killed then
            local sideManager = Managers.state.side
            local victim_side = sideManager.side_by_unit[victim_unit]
            local is_enemy = sideManager:is_enemy_by_side(attacker_side, victim_side)

            if is_enemy then
                local scoreController = mod.scoreController

                if breed_killed.elite then
                    scoreController:add_score(attacker_player, "kills_elite", 1)
                elseif breed_killed.special then
                    scoreController:add_score(attacker_player, "kills_special", 1)
                elseif breed_killed.boss then
                    scoreController:add_score(attacker_player, "kills_boss", 1)
                else
                    scoreController:add_score(attacker_player, "kills_normal", 1)
                end
            end
        end
    end

    func(victim_unit, damage_data, statistics_db, is_server)
end)

mod:hook("StatisticsUtil", "register_damage", function(func, victim_unit, damage_data, statistics_db)
    local scoreController = mod.scoreController

    local damage_amount = damage_data[DamageDataIndex.DAMAGE_AMOUNT]
    local player_manager = Managers.player
    local victim_player = player_manager:owner(victim_unit)

    if victim_player then
        scoreController:add_score(victim_player, "damage_taken", damage_amount)
    end

    local attacker_unit = damage_data[DamageDataIndex.ATTACKER]
    attacker_unit = AiUtils.get_actual_attacker_unit(attacker_unit)
    local attacker_player = player_manager:owner(attacker_unit)

    if attacker_player then
        local target_breed = Unit_alive(victim_unit) and Unit_get_data(victim_unit, "breed")

        if target_breed then
            local health_extension = ScriptUnit.extension(victim_unit, "health_system")
            local current_health = health_extension:current_health()

            if current_health > 0 then
                local clamped_damage_amount = math.clamp(damage_amount, 0, current_health)

                if target_breed.boss then
                    scoreController:add_score(attacker_player, "boss_damage", clamped_damage_amount)
                else
                    scoreController:add_score(attacker_player, "damage", clamped_damage_amount)
                end

                local hit_zone_name = damage_data[DamageDataIndex.HIT_ZONE]
                local is_critical_strike = damage_data[DamageDataIndex.CRITICAL_HIT]

                local is_headshot = hit_zone_name == "head"

                if is_headshot then
                    scoreController:add_score(attacker_player, "headshots", 1)
                end

                if is_critical_strike then
                    scoreController:add_score(attacker_player, "critical_hit", 1)
                end

                if is_headshot and is_critical_strike then
                    scoreController:add_score(attacker_player, "critical_headshot", 1)
                end
            end
        end
    end

    func(victim_unit, damage_data, statistics_db)
end)

mod:hook("PlayerUnitHealthExtension", "add_heal",
    function(func, self, healer_unit, heal_amount, heal_source_name, heal_type)
        if heal_amount > 0 then
            local healer_player = Managers.player:owner(healer_unit)

            if healer_player then
                local status_extension = self.status_extension

                local current_health = self:current_health()
                local current_temporary_health = self:current_temporary_health()
                local max_health = self:get_max_health()

                local scoreController = mod.scoreController

                if status_extension:is_permanent_heal(heal_type) and not status_extension:is_knocked_down() then
                    local new_temporary_health = current_temporary_health < heal_amount and 0 or
                        current_temporary_health - heal_amount

                    local new_health = max_health < current_health + new_temporary_health + heal_amount and max_health or
                        current_health + heal_amount

                    local healed = new_health - current_health

                    if healed > 0 then
                        scoreController:add_score(healer_player, "healed", healed)
                    end
                else
                    local new_temporary_health = max_health < current_health + current_temporary_health + heal_amount and
                        max_health - current_health or current_temporary_health + heal_amount

                    local temp_healed = new_temporary_health - current_temporary_health

                    if temp_healed > 0 then
                        scoreController:add_score(healer_player, "healed_temp", temp_healed)
                    end
                end
            end
        end

        func(self, healer_unit, heal_amount, heal_source_name, heal_type)
    end)

local eventSubscriptionState = false

mod.SubscribeEvent = function()
    if eventSubscriptionState then
        return
    end

    local event_manager = Managers.state.event

    if not event_manager then
        return
    end

    event_manager:register(mod, "add_coop_feedback", "on_add_coop_feedback")

    eventSubscriptionState = true
end

mod.UnsubscribeEvent = function()
    if not eventSubscriptionState then
        return
    end

    local event_manager = Managers.state.event

    if event_manager then
        event_manager:unregister("add_coop_feedback", mod)
    end

    eventSubscriptionState = false
end

mod.on_add_coop_feedback = function(self, hash, is_local_player, event_type, player1, player2)
    if not player1 then
        return
    end

    local scoreController = mod.scoreController

    if event_type == "save" then
        scoreController:add_score(player1, "assist", 1)
    elseif event_type == "aid" then
        scoreController:add_score(player1, "assist", 1)
    elseif event_type == "revive" then
        scoreController:add_score(player1, "assist", 1)
    elseif event_type == "assisted_respawn" then
        scoreController:add_score(player1, "assist", 1)
    elseif event_type == "heal" then
        scoreController:add_score(player1, "assist", 1)
    end
end
