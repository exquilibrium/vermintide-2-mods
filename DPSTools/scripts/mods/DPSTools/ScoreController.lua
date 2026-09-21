ScoreController = class(ScoreController)

ScoreController.init = function(self, mod)
    self._scores = {}
    self._sorted_scores = {}

    self._mod = mod
    self._scoreTypeDefinitions = mod.scoreTypeDefinitions
    self._shortened_career_lookup = mod.shortened_career_lookup

    self._isStarted = false

    self.elapsed_time = 0
    self._next_calculation_time = 0

    self._mode = "dps"
end

ScoreController.update = function(self, dt)
    if not self._isStarted then
        return
    end

    local newElapsedTime = self.elapsed_time
    newElapsedTime = newElapsedTime + dt
    self.elapsed_time = newElapsedTime

    if newElapsedTime - self._next_calculation_time > 1 then
        self._next_calculation_time = newElapsedTime + 1

        local scores = self._scores
        local meterMode = self._mode
        local totalScoreSum = 0

        for _, playerScores in pairs(scores) do
            local meterScores = playerScores[meterMode]
            meterScores.scorePerSeconds = meterScores.scores / newElapsedTime
            totalScoreSum = totalScoreSum + meterScores.scores
        end

        for _, playerScores in pairs(scores) do
            local meterScores = playerScores[meterMode]
            meterScores.percent = (meterScores.scores / totalScoreSum) * 100
        end

        -- desc sort
        table.sort(self._sorted_scores, function(a, b) return a.data[meterMode].scores > b.data[meterMode].scores end)
    end
end

ScoreController.set_mode = function(self, mode)
    self._mode = mode
end

ScoreController.is_started = function(self)
    return self._isStarted
end

ScoreController.start = function(self)
    if self._isStarted then
        return;
    end

    self._mod.SubscribeEvent()

    self._isStarted = true
end

ScoreController.finish = function(self)
    if not self._isStarted then
        return
    end

    self._mod.UnsubscribeEvent()

    self._isStarted = false
end

ScoreController.clear = function(self)
    self._scores = {}
    self._sorted_scores = {}

    self.elapsed_time = 0
    self._next_calculation_time = 0

    self:finish()
end

ScoreController._add_player = function(self, uniqueId, player)
    local career = player:career_name()
    local careerLookup = self._shortened_career_lookup
    local shortCareerName = careerLookup[career] or careerLookup.unknown

    self._scores[uniqueId] = {
        dps = {
            scorePerSeconds = 0,
            scores = 0,
            percent = 0,
        },
        hps = {
            scorePerSeconds = 0,
            scores = 0,
            percent = 0,
        },
        name = player:name(),
        careerName = career,
        meterColor = Colors.get_table(career),
        shortCareerName = shortCareerName
    }

    self._sorted_scores[#self._sorted_scores + 1] = {
        id = uniqueId,
        data = self._scores[uniqueId]
    }
end

ScoreController._check_override_player = function(self, uniqueId, player)
    local career = player:career_name()
    local careerLookup = self._shortened_career_lookup
    local shortCareerName = careerLookup[career] or careerLookup.unknown
    local playerName = player:name()

    local data = self._scores[uniqueId]

    if data.name ~= playerName then
        data.name = playerName
    end

    if data.careerName ~= career then
        data.careerName = career
        data.meterColor = Colors.get_table(career)
        data.shortCareerName = shortCareerName
    end
end

ScoreController.add_score = function(self, player, scoreType, value)
    if value == nil then
        return
    end

    if not self._isStarted then
        self:start()
    end

    local scores = self._scores

    local playerUniqueId = player:unique_id()
    local playerScores = scores[playerUniqueId]

    if not playerScores then
        self:_add_player(playerUniqueId, player)
        playerScores = scores[playerUniqueId]
    else
        self:_check_override_player(playerUniqueId, player)
    end

    local scoreTypeDefinition = self._scoreTypeDefinitions[scoreType]
    playerScores[scoreType] = (playerScores[scoreType] or 0) + value

    if scoreTypeDefinition.kills_score then
        playerScores.kills_total = (playerScores.kills_total or 0) + 1
    end

    if scoreTypeDefinition.use_score_sum then
        local meterMode = scoreTypeDefinition.meter_type
        playerScores[meterMode].scores = (playerScores[meterMode].scores or 0) + value
    end
end

ScoreController.GetScores = function(self)
    return self._sorted_scores
end
