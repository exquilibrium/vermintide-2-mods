-- complete raw spawn table
local fow_spawns = {
    Recruit = {
        {
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_slave",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_fanatic",
                    amount = 20
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 8
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 32
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 8
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 3
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "continue_when",
                    duration = 100,
                    condition = 3
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_fanatic",
                    amount = 30
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 2
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 20
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_warrior",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 4
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 3
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 2
                }
            },
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "chaos_fanatic",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "chaos_marauder",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_fanatic",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_marauder",
                    amount = 3
                },
                {
                    "delay",
                    duration = 7
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 10
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 30
                },
                {
                    "delay",
                    duration = 3
                },
                {
                    "spawn",
                    spawner_id = "manual_k",
                    breed_id = "chaos_spawn",
                    amount = 1
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_fanatic",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_fanatic",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_marauder",
                    amount = 3
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 1
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 3
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 35
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 2
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 3
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 4
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 35
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 2
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 12
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_b",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 2
                },
                {
                    "delay",
                    duration = 6
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 10
                }
            },
            {
                {
                    "delay",
                    duration = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_fanatic",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 8
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 8
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 7
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 3
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_berzerker",
                    amount = 5
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 3
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_fanatic",
                    amount = 16
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_marauder",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_fanatic",
                    amount = 16
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_marauder",
                    amount = 2
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 20
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "chaos_warrior",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_warrior",
                    amount = 2
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "manual_k",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 25
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 25
                },
                {
                    "delay",
                    duration = 6
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 25
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "spawn",
                    spawner_id = "manual_b",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 100,
                    condition = 1
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_fanatic",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 15
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_d",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_plague_monk",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_plague_monk",
                    amount = 4
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 8
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_stormfiend",
                    amount = 1
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 40
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 40
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_slave",
                    amount = 40
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 3
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 1
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 24
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_plague_monk",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_b",
                    breed_id = "skaven_plague_monk",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "skaven_plague_monk",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "skaven_plague_monk",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_plague_monk",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_plague_monk",
                    amount = 1
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 100,
                    condition = 8
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 6
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_slave",
                    amount = 30
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_slave",
                    amount = 30
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "spawn",
                    spawner_id = "manual_k",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 3
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_b",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_b",
                    breed_id = "chaos_fanatic",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_fanatic",
                    amount = 10
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 10
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 24
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 24
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 3
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_slave",
                    amount = 12
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "skaven_slave",
                    amount = 12
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 10
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 30
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 30
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 10
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_plague_monk",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_plague_monk",
                    amount = 3
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 8
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 8
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 2
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 2
                }
            },
            {
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "chaos_warrior",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "chaos_warrior",
                    amount = 3
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 30
                },
                {
                    "continue_when",
                    duration = 180,
                    condition = 2
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_fanatic",
                    amount = 15
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_warrior",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_fanatic",
                    amount = 15
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_warrior",
                    amount = 1
                },
                {
                    "delay",
                    duration = 20
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "chaos_troll",
                    amount = 1
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 20
                },
                {
                    "delay",
                    duration = 3
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_d",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "chaos_marauder",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_marauder",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 20
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_fanatic",
                    amount = 15
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_warrior",
                    amount = 1
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 4
                },
                {
                    "delay",
                    duration = 15
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 30
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_plague_monk",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_plague_monk",
                    amount = 2
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_raider",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_raider",
                    amount = 1
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 15
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 3
                },
                {
                    "delay",
                    duration = 25
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "chaos_warrior",
                    amount = 2
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_k",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 10
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 2
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_b",
                    breed_id = "chaos_marauder",
                    amount = 2
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_marauder",
                    amount = 2
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 2
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "chaos_marauder",
                    amount = 2
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_marauder",
                    amount = 2
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "chaos_marauder",
                    amount = 2
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "chaos_marauder",
                    amount = 2
                },
                {
                    "delay",
                    duration = 15
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 20
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 30
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_warrior",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_warrior",
                    amount = 2
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "continue_when",
                    duration = 300,
                    condition = 1
                }
            }
        }
    },
    Veteran = {
        {
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_slave",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_fanatic",
                    amount = 20
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 8
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 32
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 8
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 3
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "continue_when",
                    duration = 100,
                    condition = 3
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_fanatic",
                    amount = 30
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 3
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 20
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_warrior",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 4
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 3
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 2
                }
            },
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "chaos_fanatic",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "chaos_marauder",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_fanatic",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_marauder",
                    amount = 6
                },
                {
                    "delay",
                    duration = 7
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 10
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 25
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 2
                },
                {
                    "delay",
                    duration = 3
                },
                {
                    "spawn",
                    spawner_id = "manual_k",
                    breed_id = "chaos_spawn",
                    amount = 1
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_fanatic",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_fanatic",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_marauder",
                    amount = 6
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 1
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 3
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 35
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 3
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 3
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 4
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 40
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 3
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 12
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_b",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 2
                },
                {
                    "delay",
                    duration = 6
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 10
                }
            },
            {
                {
                    "delay",
                    duration = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_fanatic",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 10
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 8
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 8
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 4
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_berzerker",
                    amount = 6
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 3
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_fanatic",
                    amount = 16
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_marauder",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_fanatic",
                    amount = 16
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_marauder",
                    amount = 3
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 20
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "chaos_warrior",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_warrior",
                    amount = 2
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "manual_k",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 2
                },
                {
                    "delay",
                    duration = 6
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 2
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "spawn",
                    spawner_id = "manual_b",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 100,
                    condition = 1
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_fanatic",
                    amount = 18
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 12
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_d",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_plague_monk",
                    amount = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_plague_monk",
                    amount = 5
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 8
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_stormfiend",
                    amount = 1
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 35
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 8
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 35
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 10
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_slave",
                    amount = 35
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_clan_rat",
                    amount = 10
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 5
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 1
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 18
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_plague_monk",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_b",
                    breed_id = "skaven_plague_monk",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "skaven_plague_monk",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "skaven_plague_monk",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_plague_monk",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_plague_monk",
                    amount = 2
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 100,
                    condition = 8
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 8
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 8
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_slave",
                    amount = 30
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_clan_rat",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_slave",
                    amount = 30
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_clan_rat",
                    amount = 4
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "spawn",
                    spawner_id = "manual_k",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 3
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_b",
                    breed_id = "chaos_raider",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_b",
                    breed_id = "chaos_fanatic",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_raider",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_fanatic",
                    amount = 10
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 10
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 18
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 18
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 6
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 3
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_slave",
                    amount = 15
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "skaven_slave",
                    amount = 15
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 10
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 25
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 25
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 6
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 10
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_plague_monk",
                    amount = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_plague_monk",
                    amount = 5
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 8
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 8
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 3
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 2
                }
            },
            {
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "chaos_warrior",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "chaos_warrior",
                    amount = 4
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 25
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 6
                },
                {
                    "continue_when",
                    duration = 180,
                    condition = 2
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 15
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_raider",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_warrior",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 15
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_raider",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_warrior",
                    amount = 1
                },
                {
                    "delay",
                    duration = 20
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "chaos_troll",
                    amount = 1
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 8
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 8
                },
                {
                    "delay",
                    duration = 3
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_d",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "chaos_berzerker",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_berzerker",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 8
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 15
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_raider",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_warrior",
                    amount = 1
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "skaven_storm_vermin_with_shield",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_storm_vermin_with_shield",
                    amount = 1
                },
                {
                    "delay",
                    duration = 15
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 32
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_plague_monk",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_plague_monk",
                    amount = 2
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_raider",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_raider",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 1
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 15
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 4
                },
                {
                    "delay",
                    duration = 25
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "chaos_warrior",
                    amount = 3
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_k",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 10
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 3
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_b",
                    breed_id = "chaos_marauder",
                    amount = 3
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_marauder",
                    amount = 3
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 3
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "chaos_marauder",
                    amount = 3
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_marauder",
                    amount = 3
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "chaos_marauder",
                    amount = 3
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "chaos_marauder",
                    amount = 3
                },
                {
                    "delay",
                    duration = 15
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 8
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 32
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_warrior",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_warrior",
                    amount = 3
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "continue_when",
                    duration = 300,
                    condition = 1
                }
            }
        }
    },
    Champion = {
        {
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_slave",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_clan_rat",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_fanatic",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 2
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 8
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 35
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 8
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 4
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "continue_when",
                    duration = 100,
                    condition = 3
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_fanatic",
                    amount = 32
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 5
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 20
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_warrior",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 6
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 3
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 2
                }
            },
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "chaos_fanatic",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "chaos_marauder",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_fanatic",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_marauder",
                    amount = 10
                },
                {
                    "delay",
                    duration = 7
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 10
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 28
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 2
                },
                {
                    "delay",
                    duration = 3
                },
                {
                    "spawn",
                    spawner_id = "manual_k",
                    breed_id = "chaos_spawn",
                    amount = 1
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_fanatic",
                    amount = 12
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_fanatic",
                    amount = 12
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_marauder",
                    amount = 10
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 1
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 3
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 40
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 4
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_d",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 3
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 4
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 40
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 2
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 12
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_b",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 3
                },
                {
                    "delay",
                    duration = 6
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 10
                }
            },
            {
                {
                    "delay",
                    duration = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_fanatic",
                    amount = 23
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 10
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 8
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 6
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_berzerker",
                    amount = 8
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 3
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_fanatic",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_marauder",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_fanatic",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_marauder",
                    amount = 3
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 20
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "chaos_warrior",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_warrior",
                    amount = 3
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "manual_k",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 15
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 7
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 15
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 7
                },
                {
                    "delay",
                    duration = 6
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_storm_vermin_with_shield",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_storm_vermin_with_shield",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 15
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 7
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "spawn",
                    spawner_id = "manual_b",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 100,
                    condition = 1
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_fanatic",
                    amount = 18
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 15
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_d",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_plague_monk",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_plague_monk",
                    amount = 6
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 8
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_stormfiend",
                    amount = 1
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 40
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 10
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 35
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 15
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_b",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_slave",
                    amount = 35
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_clan_rat",
                    amount = 15
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 7
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 1
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_plague_monk",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_b",
                    breed_id = "skaven_plague_monk",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "skaven_plague_monk",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "skaven_plague_monk",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_plague_monk",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_plague_monk",
                    amount = 2
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 100,
                    condition = 8
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 8
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_storm_vermin_with_shield",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 8
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "skaven_storm_vermin_with_shield",
                    amount = 3
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_slave",
                    amount = 32
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_clan_rat",
                    amount = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_slave",
                    amount = 32
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_clan_rat",
                    amount = 5
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "spawn",
                    spawner_id = "manual_k",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 3
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_b",
                    breed_id = "chaos_raider",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_b",
                    breed_id = "chaos_fanatic",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_raider",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_fanatic",
                    amount = 10
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 10
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 6
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 3
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_slave",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "skaven_slave",
                    amount = 20
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 10
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 30
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 8
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 30
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 8
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 10
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_plague_monk",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_plague_monk",
                    amount = 6
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 4
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 2
                }
            },
            {
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "chaos_warrior",
                    amount = 7
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "chaos_warrior",
                    amount = 7
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_b",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_b",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 30
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 8
                },
                {
                    "continue_when",
                    duration = 180,
                    condition = 2
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 16
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_warrior",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 16
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_warrior",
                    amount = 1
                },
                {
                    "delay",
                    duration = 20
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "chaos_troll",
                    amount = 1
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "spawn",
                    spawner_id = "manual_d",
                    breed_id = "skaven_rat_ogre",
                    amount = 1
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 22
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 22
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 10
                },
                {
                    "delay",
                    duration = 3
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_d",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "chaos_berzerker",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_berzerker",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 22
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 10
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 16
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_warrior",
                    amount = 1
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "skaven_storm_vermin_with_shield",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_storm_vermin_with_shield",
                    amount = 2
                },
                {
                    "delay",
                    duration = 15
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_k",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 38
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_plague_monk",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_plague_monk",
                    amount = 3
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 2
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_d",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 15
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 6
                },
                {
                    "delay",
                    duration = 25
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "chaos_warrior",
                    amount = 4
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_k",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 10
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 4
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_b",
                    breed_id = "chaos_marauder",
                    amount = 4
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_marauder",
                    amount = 4
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 4
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "chaos_marauder",
                    amount = 4
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_marauder",
                    amount = 4
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "chaos_marauder",
                    amount = 4
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "chaos_marauder",
                    amount = 4
                },
                {
                    "delay",
                    duration = 15
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 22
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 10
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 38
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_warrior",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_warrior",
                    amount = 4
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "continue_when",
                    duration = 300,
                    condition = 1
                }
            }
        }
    },
    Legend = {
        {
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_slave",
                    amount = 24
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_clan_rat",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_fanatic",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 6
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 8
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 40
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 8
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 5
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "continue_when",
                    duration = 100,
                    condition = 3
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_fanatic",
                    amount = 36
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 8
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 20
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_warrior",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 6
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 3
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 2
                }
            },
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "chaos_fanatic",
                    amount = 25
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "chaos_marauder",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_fanatic",
                    amount = 25
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_marauder",
                    amount = 10
                },
                {
                    "delay",
                    duration = 7
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 10
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 30
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 5
                },
                {
                    "delay",
                    duration = 3
                },
                {
                    "spawn",
                    spawner_id = "manual_k",
                    breed_id = "chaos_spawn",
                    amount = 1
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_fanatic",
                    amount = 15
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_fanatic",
                    amount = 15
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_marauder",
                    amount = 10
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 1
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 3
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 45
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 7
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_d",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_k",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_b",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 3
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 4
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 40
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 7
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 4
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 12
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_b",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 4
                },
                {
                    "delay",
                    duration = 6
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 10
                }
            },
            {
                {
                    "delay",
                    duration = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_fanatic",
                    amount = 25
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 15
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 8
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 12
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 8
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_berzerker",
                    amount = 10
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 3
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_fanatic",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_marauder",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_fanatic",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_marauder",
                    amount = 3
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 20
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "chaos_warrior",
                    amount = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_warrior",
                    amount = 5
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "manual_k",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_b",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 15
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 15
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 10
                },
                {
                    "delay",
                    duration = 6
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_storm_vermin_with_shield",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_storm_vermin_with_shield",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 15
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 10
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "spawn",
                    spawner_id = "manual_b",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 100,
                    condition = 1
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_fanatic",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 20
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_d",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_b",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_plague_monk",
                    amount = 8
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_plague_monk",
                    amount = 8
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 8
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_stormfiend",
                    amount = 1
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 40
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 15
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 35
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 20
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_b",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_d",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_slave",
                    amount = 35
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_clan_rat",
                    amount = 20
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 8
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 1
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_plague_monk",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_b",
                    breed_id = "skaven_plague_monk",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "skaven_plague_monk",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "skaven_plague_monk",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_plague_monk",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_plague_monk",
                    amount = 3
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 100,
                    condition = 8
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_storm_vermin_with_shield",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "skaven_storm_vermin_with_shield",
                    amount = 3
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_slave",
                    amount = 35
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_clan_rat",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_slave",
                    amount = 35
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_clan_rat",
                    amount = 10
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "spawn",
                    spawner_id = "manual_k",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 3
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_b",
                    breed_id = "chaos_raider",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "directional_b",
                    breed_id = "chaos_fanatic",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_b",
                    breed_id = "chaos_marauder",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_raider",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_fanatic",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_marauder",
                    amount = 4
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_b",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 10
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 10
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 3
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_slave",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "skaven_slave",
                    amount = 20
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 10
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 35
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 35
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 10
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 10
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_plague_monk",
                    amount = 8
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_plague_monk",
                    amount = 8
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 6
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 2
                }
            },
            {
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "chaos_warrior",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "chaos_warrior",
                    amount = 10
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_b",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_b",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 35
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 10
                },
                {
                    "continue_when",
                    duration = 180,
                    condition = 2
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_warrior",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_warrior",
                    amount = 2
                },
                {
                    "delay",
                    duration = 20
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "chaos_troll",
                    amount = 1
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "spawn",
                    spawner_id = "manual_d",
                    breed_id = "skaven_rat_ogre",
                    amount = 1
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 15
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 15
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 20
                },
                {
                    "delay",
                    duration = 3
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_d",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "chaos_berzerker",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "chaos_raider",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_berzerker",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_raider",
                    amount = 4
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 15
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 20
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_warrior",
                    amount = 2
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 8
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "skaven_storm_vermin_with_shield",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 8
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_storm_vermin_with_shield",
                    amount = 2
                },
                {
                    "delay",
                    duration = 15
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_k",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_rat_ogre",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 45
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_plague_monk",
                    amount = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_plague_monk",
                    amount = 5
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 8
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_raider",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 8
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_raider",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 2
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_d",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 15
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 8
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 8
                },
                {
                    "delay",
                    duration = 25
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "chaos_warrior",
                    amount = 5
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_k",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 10
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 5
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_b",
                    breed_id = "chaos_marauder",
                    amount = 5
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_marauder",
                    amount = 5
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 5
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "chaos_marauder",
                    amount = 5
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_marauder",
                    amount = 5
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "chaos_marauder",
                    amount = 5
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "chaos_marauder",
                    amount = 5
                },
                {
                    "delay",
                    duration = 15
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 15
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 20
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 45
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_warrior",
                    amount = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_warrior",
                    amount = 5
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "continue_when",
                    duration = 300,
                    condition = 1
                }
            }
        }
    },
    Cataclysm = {
        {
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_slave",
                    amount = 18
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_clan_rat",
                    amount = 14
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_fanatic",
                    amount = 16
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 12
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 8
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_rat_ogre",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 32
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 12
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 8
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 7
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 7
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "continue_when",
                    duration = 100,
                    condition = 3
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_fanatic",
                    amount = 30
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 16
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 20
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_warrior",
                    amount = 7
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 2
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 3
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 2
                }
            },
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "chaos_fanatic",
                    amount = 21
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "chaos_marauder",
                    amount = 16
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_fanatic",
                    amount = 21
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_marauder",
                    amount = 16
                },
                {
                    "delay",
                    duration = 7
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 10
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 8
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 10
                },
                {
                    "delay",
                    duration = 3
                },
                {
                    "spawn",
                    spawner_id = "manual_k",
                    breed_id = "chaos_spawn",
                    amount = 1
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_fanatic",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 18
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_fanatic",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_marauder",
                    amount = 18
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_k",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 1
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 3
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 42
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 12
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_d",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_k",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_b",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 3
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 4
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 35
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 12
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 6
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 12
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "directional_b",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 6
                },
                {
                    "delay",
                    duration = 6
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 10
                }
            },
            {
                {
                    "delay",
                    duration = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_fanatic",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 3
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_k",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 8
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 12
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_berzerker",
                    amount = 12
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 3
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 12
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_marauder",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 12
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_marauder",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_raider",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_raider",
                    amount = 4
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 20
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "chaos_warrior",
                    amount = 7
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_warrior",
                    amount = 7
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "manual_k",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_b",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 15
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 15
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 3
                },
                {
                    "delay",
                    duration = 6
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_storm_vermin_with_shield",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_storm_vermin_with_shield",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 15
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 3
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "spawn",
                    spawner_id = "manual_b",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 100,
                    condition = 1
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_fanatic",
                    amount = 12
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 30
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_d",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_b",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_plague_monk",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_plague_monk",
                    amount = 10
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 8
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_stormfiend",
                    amount = 1
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 35
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 18
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 4
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 32
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 30
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_b",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_d",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_slave",
                    amount = 32
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_clan_rat",
                    amount = 30
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 10
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 1
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 12
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_plague_monk",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_b",
                    breed_id = "skaven_plague_monk",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "skaven_plague_monk",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "skaven_plague_monk",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_plague_monk",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_plague_monk",
                    amount = 4
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 100,
                    condition = 8
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 11
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_storm_vermin_with_shield",
                    amount = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 11
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "skaven_storm_vermin_with_shield",
                    amount = 5
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_slave",
                    amount = 35
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_clan_rat",
                    amount = 12
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_slave",
                    amount = 35
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_clan_rat",
                    amount = 12
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 3
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "spawn",
                    spawner_id = "manual_k",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 3
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_b",
                    breed_id = "chaos_raider",
                    amount = 7
                },
                {
                    "spawn",
                    spawner_id = "directional_b",
                    breed_id = "chaos_fanatic",
                    amount = 9
                },
                {
                    "spawn",
                    spawner_id = "directional_b",
                    breed_id = "chaos_marauder",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_raider",
                    amount = 7
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_fanatic",
                    amount = 9
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_marauder",
                    amount = 6
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_b",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 10
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 12
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 20
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 12
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 3
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 3
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_slave",
                    amount = 15
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_clan_rat",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "skaven_slave",
                    amount = 15
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "skaven_clan_rat",
                    amount = 3
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "chaos_troll",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 10
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 28
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 15
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 28
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 15
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 2
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 10
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_plague_monk",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_plague_monk",
                    amount = 10
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 11
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 8
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 11
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 8
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 80,
                    condition = 2
                }
            },
            {
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "chaos_warrior",
                    amount = 12
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "chaos_raider",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "chaos_warrior",
                    amount = 12
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "chaos_raider",
                    amount = 1
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_b",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_b",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 28
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 15
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 2
                },
                {
                    "continue_when",
                    duration = 180,
                    condition = 2
                }
            }
        },
        {
            {
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 22
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_warrior",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 22
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_warrior",
                    amount = 3
                },
                {
                    "delay",
                    duration = 20
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "chaos_troll",
                    amount = 1
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "spawn",
                    spawner_id = "manual_d",
                    breed_id = "skaven_rat_ogre",
                    amount = 1
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 12
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 24
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_slave",
                    amount = 12
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat",
                    amount = 24
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_in",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 4
                },
                {
                    "delay",
                    duration = 3
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_d",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "chaos_berzerker",
                    amount = 8
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "chaos_raider",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "chaos_marauder",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_berzerker",
                    amount = 8
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_raider",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_marauder",
                    amount = 2
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_i",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 12
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 24
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 4
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 22
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_raider",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_warrior",
                    amount = 3
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_e",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 5
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 8
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "skaven_storm_vermin_with_shield",
                    amount = 4
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 8
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "skaven_storm_vermin_with_shield",
                    amount = 4
                },
                {
                    "delay",
                    duration = 15
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_k",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_pack_master",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_rat_ogre",
                    amount = 1
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "spawn",
                    spawner_id = "manual_b",
                    breed_id = "skaven_stormfiend",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 120,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 37
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_plague_monk",
                    amount = 7
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "skaven_plague_monk",
                    amount = 7
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_c",
                    breed_id = "skaven_gutter_runner",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_poison_wind_globadier",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_ratling_gunner",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 6
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 8
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_raider",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 3
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 8
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_raider",
                    amount = 6
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder_with_shield",
                    amount = 3
                },
                {
                    "delay",
                    duration = 12
                },
                {
                    "spawn",
                    spawner_id = "manual_a",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_d",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 15
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 8
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "skaven_storm_vermin_with_shield",
                    amount = 2
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_storm_vermin_commander",
                    amount = 8
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "skaven_storm_vermin_with_shield",
                    amount = 2
                },
                {
                    "delay",
                    duration = 25
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_h",
                    breed_id = "skaven_warpfire_thrower",
                    amount = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "chaos_warrior",
                    amount = 5
                },
                {
                    "delay",
                    duration = 4
                },
                {
                    "spawn",
                    spawner_id = "manual_j",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "chaos_vortex_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_k",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_g",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "manual_f",
                    breed_id = "chaos_corruptor_sorcerer",
                    amount = 1
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 10
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_marauder",
                    amount = 6
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_b",
                    breed_id = "chaos_marauder",
                    amount = 6
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_c",
                    breed_id = "chaos_marauder",
                    amount = 6
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_marauder",
                    amount = 6
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_e",
                    breed_id = "chaos_marauder",
                    amount = 6
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_f",
                    breed_id = "chaos_marauder",
                    amount = 6
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_g",
                    breed_id = "chaos_marauder",
                    amount = 6
                },
                {
                    "delay",
                    duration = 1
                },
                {
                    "spawn",
                    spawner_id = "directional_h",
                    breed_id = "chaos_marauder",
                    amount = 6
                },
                {
                    "delay",
                    duration = 15
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 12
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 24
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat_with_shield",
                    amount = 4
                },
                {
                    "delay",
                    duration = 8
                },
                {
                    "continue_when",
                    duration = 160,
                    condition = 5
                }
            },
            {
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_slave",
                    amount = 37
                },
                {
                    "spawn",
                    spawner_id = "spawner_flush_out",
                    breed_id = "skaven_clan_rat",
                    amount = 10
                },
                {
                    "spawn",
                    spawner_id = "directional_d",
                    breed_id = "chaos_warrior",
                    amount = 5
                },
                {
                    "spawn",
                    spawner_id = "directional_a",
                    breed_id = "chaos_warrior",
                    amount = 5
                },
                {
                    "delay",
                    duration = 10
                },
                {
                    "continue_when",
                    duration = 300,
                    condition = 1
                }
            }
        }
    }
}

-- helper funtions
local function maxn(table)
	size = 0
	for idx, value in ipairs(table) do
		size = size + 1
	end
	return size
end

local function hasValue(table, value)
    for k, v in ipairs(table) do
        if v == value then return true end
    end
    return false
end

local function hasId(table, id)
    for k, v in ipairs(table) do
        if v[1] == id then return k end
    end
    return nil
end

local function hasKey(table, key)
    for k, v in pairs(table) do
        if k == key then return true end
    end
    return false
end

-- other tables
local difficulty = {
	"Recruit",
	"Veteran",
	"Champion",
	"Legend",
	"Cataclysm"
}

local horde = {
    "skaven_slave",
    "skaven_clan_rat",
    "skaven_clan_rat_with_shield",
    "chaos_fanatic",
    "chaos_marauder",
    "chaos_marauder_with_shield"
}

local danger = {
    "skaven_pack_master",
    "skaven_gutter_runner",
    "skaven_poison_wind_globadier",
    "skaven_ratling_gunner",
    "skaven_warpfire_thrower",
    "chaos_corruptor_sorcerer",
    "chaos_vortex_sorcerer",

    "skaven_rat_ogre",
    "skaven_stormfiend",
    "chaos_spawn",
    "chaos_troll"
}

local breedToName = {
    horde = "Horde",

    skaven_slave = "Slaverat",
    skaven_clan_rat = "Clanrat",
    skaven_clan_rat_with_shield = "Shielded Clanrat",
    chaos_fanatic = "Fanatic",
    chaos_marauder = "Marauder",
    chaos_marauder_with_shield = "Shielded Raider",

    skaven_plague_monk = "Plague Monk",
    skaven_storm_vermin_commander = "Stormvermin",
    skaven_storm_vermin_with_shield = "Shielded Stormvermin",
    chaos_berzerker = "Berzerker",
    chaos_raider = "Raider",
    chaos_warrior = "Chaos Warrior",

    skaven_pack_master = "Hookrat",
    skaven_gutter_runner = "Assassin",
    skaven_poison_wind_globadier = "Gasrat",
    skaven_ratling_gunner = "Gunrat",
    skaven_warpfire_thrower = "Flamerat",
    chaos_corruptor_sorcerer = "Leech",
    chaos_vortex_sorcerer = "Blightstormer",

    skaven_rat_ogre = "Rat Ogre",
    skaven_stormfiend = "Stormfiend",
    chaos_spawn = "Chaos Spawn",
    chaos_troll = "Troll"
}

local spawnerToName = {
    directional_a = "A",
    directional_b = "B",
    directional_c = "C",
    directional_d = "D",
    directional_e = "E",
    directional_f = "F",
    directional_g = "G",
    directional_h = "H",

    manual_a = "A",
    manual_b = "B",
    manual_c = "C",
    manual_d = "D",
    manual_e = "E",
    manual_f = "F",
    manual_g = "G",
    manual_h = "H",
    manual_i = "I",
    manual_j = "J",
    manual_k = "K",

    spawner_flush_in = "IN",
    spawner_flush_out = "OUT"
}

-- Make steam guide format
for d = 1, 5, 1 do
    -- Open a file in write mode
    fname = "steam_guide_diff_" .. tostring(d) .. ".txt"
    local file = io.open(fname, "w")

    -- Ensure the file was successfully opened
    if not file then
        error("Failed to open file for writing!")
    end

    -- make steam guide
    for wave, wave_data in ipairs(fow_spawns[difficulty[d]]) do
        file:write("[h1]Wave " .. wave .. "[/h1][list]")
        local subs = maxn(wave_data)
        for swave, swave_data in ipairs(wave_data) do
            file:write("[*][b][u]( " .. swave .. " / " .. subs .. " )[/u][/b][list]")
            local swave_max = 0
            local spawn_list = {}
            for event, event_data in ipairs(swave_data) do
                if event_data[1] == "spawn" then
                    local id = nil
                    if hasValue(horde, event_data.breed_id) then
                        id = "horde"
                    else
                        id = event_data.breed_id
                    end
                    local idx = hasId(spawn_list, id)
                    if idx then
                        spawn_list[idx].amount = spawn_list[idx].amount + event_data.amount
                        if not hasValue(spawn_list[idx].direction, event_data.spawner_id) then
                            table.insert(spawn_list[idx].direction, event_data.spawner_id)
                        end
                    else
                        element = {
                            id,
                            amount = event_data.amount,
                            direction = { event_data.spawner_id }
                        }
                        table.insert(spawn_list, element)
                    end
                end
                swave_max = swave_max + 1
            end
            for k, v in ipairs(spawn_list) do
                if hasValue(danger, v[1]) then
                    file:write("[*][h2][b][u]" .. v.amount .. "x" .. breedToName[v[1]] .. "[/u][/b] :")
                elseif v[1] ~= "horde" then
                    file:write("[*][h2][b]" .. v.amount .. "x" .. breedToName[v[1]] .. "[/b] :")
                else
                    file:write("[*][h2]Horde (" .. v.amount .. ") :")
                end
                table.sort(v.direction)
                for _, dir in ipairs(v.direction) do
                    file:write(" " .. spawnerToName[dir])
                end
                file:write("[/h2]")
            end
            file:write("[*][b]Continue after " .. swave_data[swave_max].duration .. "s or < " .. swave_data[swave_max].condition .. " enemies[/b][/list]")
        end
        file:write("[/list]")
    end

    -- Close the file after writing
    file:close()
end


