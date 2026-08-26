local mod = get_mod("Ubersreik5")

-- AI Director player-position clustering (scripts/managers/conflict_director/
-- conflict_utils.lua), hardcoded to at most 4 players/bots. Called constantly
-- throughout a mission - horde_spawner.lua uses cluster_positions to decide
-- WHERE to spawn hordes relative to the party, conflict_director.lua uses
-- both for pacing, and perception_utils.lua uses cluster_weight_and_loneliness
-- to pick which player is most "lonely" (e.g. who an isolated-player-seeking
-- special like a Gutter Runner should target). Without patching these, a 5th
-- player's position is silently invisible to all of that - not a visual bug,
-- a whole-mission gameplay-pacing one.
--
-- Full replace rather than wrapping vanilla's func: both originally close
-- over module-level scratch tables reused across calls as a performance
-- optimization (avoids a table allocation per call) - those locals aren't
-- reachable from a hook, and reusing them at a different size would need
-- reimplementing anyway. Using a fresh table per call instead is simpler and
-- avoids a real correctness bug that optimization has: cluster_positions's
-- scratch queue only gets reset up to its old fixed size, so a call with
-- fewer positions right after a call with more would see stale leftover
-- entries and miscount how many are actually queued.

mod:hook(ConflictUtils, "cluster_positions", function (func, positions, min_dist)
	local clusters = {
		positions[1],
	}
	local clusters_sizes = {
		1,
	}
	local cluster_index_lookup = {
		1,
	}

	min_dist = min_dist * min_dist

	local work_queue = {}

	for i = 2, #positions do
		work_queue[i - 1] = i
	end

	local work_size = #work_queue

	while work_size > 0 do
		local clustered = false

		for i = 1, #clusters do
			for j = 1, work_size do
				local index = work_queue[j]
				local dist = Vector3.distance_squared(clusters[i], positions[index])

				if dist < min_dist then
					work_queue[j] = work_queue[work_size]
					work_size = work_size - 1
					cluster_index_lookup[index] = i
					clusters_sizes[i] = clusters_sizes[i] + 1
					clustered = true

					break
				end
			end
		end

		if not clustered then
			local i = #clusters + 1
			local index = work_queue[1]

			clusters[i] = positions[index]
			cluster_index_lookup[index] = i
			clusters_sizes[i] = 1
			work_queue[1] = work_queue[work_size]
			work_size = work_size - 1
		end
	end

	return clusters, clusters_sizes, cluster_index_lookup
end)

-- Same hand-unrolled pairwise-distance shape vanilla uses for 1-4 positions
-- (kept identical, including index 5's max score following the same C(n,2)
-- pattern index 3 (3) and 4 (6) already use), extended with a 5th position e.
-- Processed highest-index-down so each block's cross-terms (e.g. cd, ce) are
-- already computed by the time a lower block needs them, exactly mirroring
-- vanilla's own d-then-c-then-b-then-a ordering.
local CLUSTER_MAX_SCORE = {
	1,
	2,
	3,
	6,
	10,
}

mod:hook(ConflictUtils, "cluster_weight_and_loneliness", function (func, positions, min_dist)
	local distance_squared = Vector3.distance_squared

	min_dist = min_dist * min_dist

	local num_positions = math.min(#positions, 5)

	if num_positions == 1 then
		return 1, 1, 100
	elseif num_positions == 0 then
		return 0, 0, 0
	end

	local loneliness = {}
	local a = positions[1]
	local b = positions[2]
	local c = positions[3]
	local d = positions[4]
	local e = positions[5]
	local utility_sum = 0
	local ab, ac, ad, ae, bc, bd, be, cd, ce, de = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

	if e then
		ae = distance_squared(a, e)
		be = distance_squared(b, e)
		ce = distance_squared(c, e)
		de = distance_squared(d, e)
		utility_sum = utility_sum + (ae < min_dist and 1 or 0)
		utility_sum = utility_sum + (be < min_dist and 1 or 0)
		utility_sum = utility_sum + (ce < min_dist and 1 or 0)
		utility_sum = utility_sum + (de < min_dist and 1 or 0)
		loneliness[5] = ae + be + ce + de
	end

	if d then
		ad = distance_squared(a, d)
		bd = distance_squared(b, d)
		cd = distance_squared(c, d)
		utility_sum = utility_sum + (ad < min_dist and 1 or 0)
		utility_sum = utility_sum + (bd < min_dist and 1 or 0)
		utility_sum = utility_sum + (cd < min_dist and 1 or 0)
		loneliness[4] = ad + bd + cd + de
	end

	if c then
		ac = distance_squared(a, c)
		bc = distance_squared(b, c)
		utility_sum = utility_sum + (ac < min_dist and 1 or 0)
		utility_sum = utility_sum + (bc < min_dist and 1 or 0)
		loneliness[3] = ac + bc + cd + ce
	end

	if b then
		ab = distance_squared(a, b)
		utility_sum = utility_sum + (ab < min_dist and 1 or 0)
		loneliness[2] = ab + bc + bd + be
	end

	loneliness[1] = ab + ac + ad + ae

	local cluster_utility = utility_sum / CLUSTER_MAX_SCORE[num_positions]
	local loneliest_value = 0
	local loneliest_index = 1

	for i = 1, num_positions do
		if loneliest_value < loneliness[i] then
			loneliest_value = loneliness[i]
			loneliest_index = i
		end
	end

	loneliest_value = math.sqrt(loneliest_value) / num_positions

	return cluster_utility, loneliest_index, loneliest_value, loneliness
end)
