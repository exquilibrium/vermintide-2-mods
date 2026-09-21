local mod = get_mod("Ubersreik5")

-- AI Director player-position clustering, hardcoded to at most 4 players/
-- bots in vanilla - extended to 5 as a full replace (not a wrapper), since
-- vanilla's own scratch tables aren't reachable from a hook. See README.md.

-- Scratch tables reused across calls (mirrors vanilla's own scratch-reuse
-- optimization), but cleared by capturing each table's live length from the
-- *previous* call before wiping it - unlike vanilla's own fixed "for i = 1, 3"
-- reset, this stays correct no matter how many positions a call has. See
-- README.md.
local cluster_positions_sizes = {}
local cluster_positions_index_lookup = {}
local cluster_positions_work_queue = {}

mod:hook(ConflictUtils, "cluster_positions", function (func, positions, min_dist)
	if #positions == 0 then
		return {}, {}, {}
	end

	local clusters = {
		positions[1],
	}
	local clusters_sizes = cluster_positions_sizes
	local cluster_index_lookup = cluster_positions_index_lookup
	local work_queue = cluster_positions_work_queue

	for i = 1, #clusters_sizes do
		clusters_sizes[i] = nil
	end

	for i = 1, #cluster_index_lookup do
		cluster_index_lookup[i] = nil
	end

	for i = 1, #work_queue do
		work_queue[i] = nil
	end

	clusters_sizes[1] = 1
	cluster_index_lookup[1] = 1

	local min_dist_sq = min_dist * min_dist

	for i = 2, #positions do
		work_queue[#work_queue + 1] = i
	end

	while #work_queue > 0 do
		local clustered = false
		local work_size = #work_queue

		for cluster_idx = 1, #clusters do
			local i = 1

			while work_size >= i do
				local pos_idx = work_queue[i]
				local dist_sq = Vector3.distance_squared(clusters[cluster_idx], positions[pos_idx])

				if dist_sq < min_dist_sq then
					cluster_index_lookup[pos_idx] = cluster_idx
					clusters_sizes[cluster_idx] = clusters_sizes[cluster_idx] + 1
					work_queue[i] = work_queue[work_size]
					work_queue[work_size] = nil
					work_size = work_size - 1
					clustered = true
				else
					i = i + 1
				end
			end

			if clustered then
				break
			end
		end

		if not clustered and #work_queue > 0 then
			local new_cluster_idx = #clusters + 1
			local pos_idx = work_queue[1]

			clusters[new_cluster_idx] = positions[pos_idx]
			cluster_index_lookup[pos_idx] = new_cluster_idx
			clusters_sizes[new_cluster_idx] = 1
			work_queue[1] = work_queue[#work_queue]
			work_queue[#work_queue] = nil
		end
	end

	return clusters, clusters_sizes, cluster_index_lookup
end)

-- Same hand-unrolled pairwise-distance shape vanilla uses for 1-4 positions,
-- extended with a 5th (e). See README.md.
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
