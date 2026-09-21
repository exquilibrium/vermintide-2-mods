local atlas = {
		es_mercenary = {
		size = {
			60,
			60,
		},
		uv00 = {
			0,
			0,
		},
		uv11 = {
			0.25,
			0.2,
		},
	},
		es_huntsman = {
		size = {
			60,
			60,
		},
		uv00 = {
			0.25,
			0,
		},
		uv11 = {
			0.5,
			0.2,
		},
	},
		es_knight = {
		size = {
			60,
			60,
		},
		uv00 = {
			0.5,
			0,
		},
		uv11 = {
			0.75,
			0.2,
		},
	},
		es_questingknight = {
		size = {
			60,
			60,
		},
		uv00 = {
			0.75,
			0,
		},
		uv11 = {
			1,
			0.2,
		},
	},
		dr_ranger = {
		size = {
			60,
			60,
		},
		uv00 = {
			0,
			0.2,
		},
		uv11 = {
			0.25,
			0.4,
		},
	},
		dr_ironbreaker = {
		size = {
			60,
			60,
		},
		uv00 = {
			0.25,
			0.2,
		},
		uv11 = {
			0.5,
			0.4,
		},
	},
		dr_slayer = {
		size = {
			60,
			60,
		},
		uv00 = {
			0.5,
			0.2,
		},
		uv11 = {
			0.75,
			0.4,
		},
	},
		dr_engineer = {
		size = {
			60,
			60,
		},
		uv00 = {
			0.75,
			0.2,
		},
		uv11 = {
			1,
			0.4,
		},
	},
		we_waywatcher = {
		size = {
			60,
			60,
		},
		uv00 = {
			0,
			0.4,
		},
		uv11 = {
			0.25,
			0.6,
		},
	},
		we_maidenguard = {
		size = {
			60,
			60,
		},
		uv00 = {
			0.25,
			0.4,
		},
		uv11 = {
			0.5,
			0.6,
		},
	},
		we_shade = {
		size = {
			60,
			60,
		},
		uv00 = {
			0.5,
			0.4,
		},
		uv11 = {
			0.75,
			0.6,
		},
	},
		we_thornsister = {
		size = {
			60,
			60,
		},
		uv00 = {
			0.75,
			0.4,
		},
		uv11 = {
			1,
			0.6,
		},
	},
		wh_captain = {
		size = {
			60,
			60,
		},
		uv00 = {
			0,
			0.6,
		},
		uv11 = {
			0.25,
			0.8,
		},
	},
		wh_bountyhunter = {
		size = {
			60,
			60,
		},
		uv00 = {
			0.25,
			0.6,
		},
		uv11 = {
			0.5,
			0.8,
		},
	},
		wh_zealot = {
		size = {
			60,
			60,
		},
		uv00 = {
			0.5,
			0.6,
		},
		uv11 = {
			0.75,
			0.8,
		},
	},
		wh_priest = {
		size = {
			60,
			60,
		},
		uv00 = {
			0.75,
			0.6,
		},
		uv11 = {
			1,
			0.8,
		},
	},
		bw_adept = {
		size = {
			60,
			60,
		},
		uv00 = {
			0,
			0.8,
		},
		uv11 = {
			0.25,
			1,
		},
	},
		bw_scholar = {
		size = {
			60,
			60,
		},
		uv00 = {
			0.25,
			0.8,
		},
		uv11 = {
			0.5,
			1,
		},
	},
		bw_unchained = {
		size = {
			60,
			60,
		},
		uv00 = {
			0.5,
			0.8,
		},
		uv11 = {
			0.75,
			1,
		},
	},
		bw_necromancer = {
		size = {
			60,
			60,
		},
		uv00 = {
			0.75,
			0.8,
		},
		uv11 = {
			1,
			1,
		},
	},
}

local copy = {}

for key, value in pairs(atlas) do
	copy["copy_" .. key] = value
end

print(copy)

return copy
