local json = require( "json" )

local gameStateLocation = system.DocumentsDirectory
local wormyStateFile = "wormyState"
local path = system.pathForFile( wormyStateFile, gameStateLocation)

local defaultGameState = {
	adsDisabled = false,
	freePasses = 2,
	unlocked = {},
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

function endLevel(level, completed, timeRemaining, maximumLength, startingStars)
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

	if completed and startingStars < 3 then
		local endingStars = levelStars(level)
		if endingStars == 3 then
			local threeStars = gameState.threeStars or 0
			gameState.threeStars = threeStars + 1
			saveGameState(gameState)
		end
	end
end

function disableAds()
	adManager:hideAd()
	gameState.adsDisabled = true
	saveGameState(gameState)
end

function freePassesAvailable()
	local freePasses = gameState.freePasses or 0
	return freePasses
end

function consumeFreePassOnLevel(level)
	if (isLevelCompleted(level)) then
		print("WARNING: Attempted to use free pass on a level that was already completed.")
	else 
		local freePasses = gameState.freePasses or 0
		if freePasses > 0 then
			gameState.freePasses = freePasses - 1
			local lvl = "Level"..level
			local levelState = gameState[lvl] or {}
			levelState.completed = true
			gameState[lvl] = levelState
			saveGameState(gameState)
		else
			print("WARNING: Attempted to consume a free pass, but none are available.")
		end
	end
end

function addFreePasses(count)
	print("Adding free passes "..tostring(count))
	local freePasses = gameState.freePasses or 0
	gameState.freePasses = freePasses + count
	saveGameState(gameState)
end

function isLevelUnlocked(level)
	return isLevelCompleted(level - 1)
end

function isLevelCompleted(level)
	local lvl = "Level"..tostring(level)
	local levelState = gameState[lvl] or {}
	local completed = levelState.completed or false
	return completed
end

function levelStars(level)
	local lvl = "Level"..tostring(level)
	local levelState = gameState[lvl] or {}
	local completed = levelState.completed or false
	local bestTime = levelState.bestTime or 0

	local stars = 0
	if completed and bestTime > 0 then stars = stars + 1 end
	if completed and bestTime >= 10 then stars = stars + 1 end
	if completed and bestTime >= 20 then stars = stars + 1 end
	return stars
end

function threeStars()
	local threeStars = gameState.threeStars or 0
	return threeStars
end

function adsDisabled()
	local disabled = gameState.adsDisabled or false
	return disabled
end

function resetGameState()
	gameState = defaultGameState
	saveGameState(gameState)
end