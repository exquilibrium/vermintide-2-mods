local mod = get_mod("GKQuestComplete")

local function complete_all_grail_knight_quests()
	local challenge_manager = Managers.venture and Managers.venture.challenge
	local player = Managers.player and Managers.player:local_player(1)

	if not challenge_manager or not player then
		return
	end

	local owner_unique_id = player:unique_id()
	local challenges = challenge_manager:get_challenges_filtered({}, "questing_knight", owner_unique_id)

	for i = 1, #challenges do
		local challenge = challenges[i]
		local _, required_progress = challenge:get_progress()

		challenge._progress = required_progress
		challenge:_complete(InGameChallengeResult.Completed)

		mod:echo(string.format("Completed quest %s -> reward %s", challenge:get_challenge_name(), challenge:get_reward_name()))
	end
end

mod:command("complete_grail_quests", "Force-complete all active GK talent quests (host only).", complete_all_grail_knight_quests)