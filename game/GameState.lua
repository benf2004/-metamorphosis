local json = require( "json" )

local gameStateLocation = system.DocumentsDirectory
local wormyStateFile = "wormyState"
local path = system.pathForFile( wormyStateFile, gameStateLocation)

local defaultGameState = {
	Level0 = {completed = true}
}

function loadGameState()
	local file = io.open( path, "r" )
	if file then
		local contents = file:read( "*a" )
		local aTable = json.decode(contents)
		io.close( file )
		return aTable
	else
		return defaultGameState
	end
end

function saveGameState(gameState)
	local jsonEncoded = json.encode( gameState )
	local file = io.open( path, "w" )
	if file then
		file:write(jsonEncoded)
		io.close(file)
		return true
	else
		return false
	end
end

--Global GameState
gameState = loadGameState()

function endLevel(level, completed, timeRemaining, maximumLength)
	local lvl = "Level"..level
	local levelState = gameState[lvl] or {}
	levelState.completed = levelState.completed or completed
	levelState.bestTime = levelState.bestTime or 0
	if completed then
		levelState.bestTime = math.max( timeRemaining, levelState.bestTime or 0)
	end
	levelState.totalAttempts = (levelState.totalAttempts or 0) + 1
	levelState.maximumLength = math.max( maximumLength, (levelState.maximumLength or 0))
	levelState.totalTimeRemaining = timeRemaining + (levelState.totalTimeRemaining or 0)
	levelState.averageTimeRemaining = levelState.totalTimeRemaining / levelState.totalAttempts
	gameState[lvl] = levelState
	saveGameState(gameState)
end

function resetGameState()
	gameState = defaultGameState
	saveGameState(gameState)
end