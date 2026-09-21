file = io.open("fow_spawn.txt", "a")
io.output(file)
	
mod:hook(ConflictDirector, "spawn_queued_unit", function(func, self, breed, boxed_spawn_pos, boxed_spawn_rot, spawn_category, spawn_animation, spawn_type, optional_data, group_data, unit_data)
	mod:echo(breed.name)
	io.write(breed.name .. "\n")
	return func(self, breed, boxed_spawn_pos, boxed_spawn_rot, spawn_category, spawn_animation, spawn_type, optional_data, group_data, unit_data)
end)

file = io.open("fow_spawn.txt", "a")
io.output(file)
io.close(file)



