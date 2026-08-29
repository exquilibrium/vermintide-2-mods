local mod = get_mod("Ubersreik5")

local WORKSHOP_ITEM_ID = "3790000790"

-- Unix timestamp (UTC) + 1000s (buffer)
-- Timestamp below serves as marker for "_Version Mod.bat"
-- 2026-08-30 00:07 UTC
local OUR_VERSION_TIMESTAMP = 1788048471

-- Shown in the mod options menu as the "last_build_group" widget's header
-- (see Ubersreik5_data.lua - that widget has no sub_widgets, so this header
-- is all it displays). Local time, not UTC, since this is player-facing and
-- doesn't depend on the Steam check below succeeding.
mod.last_build_string = os.date("%Y-%m-%d %H:%M", OUR_VERSION_TIMESTAMP)

-- Intercepts the "last_build_group" option header to splice in
-- mod.last_build_string above, falling through to the normal localization
-- for every other key.
local original_localize = mod.localize

mod.localize = function (self, key, ...)
	if key == "last_build_group" then
		return original_localize(self, key, mod.last_build_string)
	end

	return original_localize(self, key, ...)
end

mod.up_to_date_callbacks = {}

mod.register_MUC_callback = function (callback)
	table.insert(mod.up_to_date_callbacks, callback)
end

local function mod_update_check_callback(success, code, headers, data, userdata)
	mod:pcall(function ()
		if not success or not data then
			mod:echo(mod:localize("MUC_fail", mod:get_readable_name()))

			return
		end

		local decode_ok, decoded = pcall(cjson.decode, data)
		local details = decode_ok and decoded and decoded.response and decoded.response.publishedfiledetails and decoded.response.publishedfiledetails[1]
		local latest_timestamp = details and details.time_updated

		if not latest_timestamp then
			mod:echo(mod:localize("MUC_fail", mod:get_readable_name()))

			return
		end

		mod.up_to_date = latest_timestamp <= OUR_VERSION_TIMESTAMP

		if not mod.up_to_date then
			mod:echo(mod:localize("MUC_out_of_date", mod:get_readable_name()))
		end

		for _, cb in ipairs(mod.up_to_date_callbacks) do
			cb(mod.up_to_date)
		end
	end)
end

mod.MUC_check_for_update = function ()
	Managers.curl:post("https://api.steampowered.com/ISteamRemoteStorage/GetPublishedFileDetails/v1/", "itemcount=1&publishedfileids[0]=" .. WORKSHOP_ITEM_ID, {
		"Content-Type: application/x-www-form-urlencoded",
	}, mod_update_check_callback)
end

mod.MUC_check_for_update()
