local mod = get_mod("Ubersreik5")

mod:hook(BackendInterfaceLootPlayfab, "generate_end_of_level_loot", function (func, self, ...)
	local id = self:_new_id()

	self._loot_requests[id] = {}

	return id
end)