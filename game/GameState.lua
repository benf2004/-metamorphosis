local json = require( "json" )
local crypto = require( "crypto" )

local gameStateLocation = system.DocumentsDirectory
local wormyStateFile = "wormyState"
local path = system.pathForFile( wormyStateFile, gameStateLocation)

local defaultGameState = {
	adsDisabled = false,
	useJoystick = false,
	freePasses = 2,
	unlocked = {},
	Level0 = {completed = true}
}

-- WARNING!  Don't change this method ever.  
-- Add a version 2 method to calculate the signature differently
-- Always use this function to validate version 1 signatures.
function signatureV1(table)
	local key = "aced8d55-3fe8-4eae-8401-2166c3a96bee"
	for i=1,25 do
		local lvl = "Level"..i
		local levelState = table[lvl] or {}
		local completed = 0
		if levelState.completed then completed = 1 end
		local bestTime = levelState.bestTime or 0
		key = key..tostring(completed)..tostring(bestTime)
	end
	local adsDisabled = 0
	if table.adsDisabled then adsDisabled = 1 end
	local freePasses = table.freePasses or 0
	key = key..adsDisabled..freePasses
	local signature = crypto.digest( crypto.sha256, key )
	return signature
end

function loadGameState()
	local file = io.open( path, "r" )
	if file then
		local contents = file:read( "*a" )
		local aTable = json.decode(contents)
		io.close( file )

		local state = aTable.gameState or {}
		local sig = aTable.signature or {}
		local hash = signatureV1(state)
		if hash == sig then
			return aTable.gameState
		else
			print "Invalid signature in file."
			return defaultGameState
		end
	else
		return defaultGameState
	end
end

function saveGameState(gameState)
	local hash = signatureV1(gameState)

	local fileContainer = {
		gameState = gameState,
		signature = hash,
		version = 1
	}

	local fileJson = json.encode(fileContainer)
	
	local file = io.open( path, "w" )
	if file then
		file:write(fileJson)
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

function levelState(level)
	local lvl = "Level"..level
	local levelState = gameState[lvl] or {}
	return {
		completed = levelState.completed or false,
		bestTime = levelState.bestTime or 0,
		totalAttempts = levelState.totalAttempts or 0,
		maximumLength = levelState.maximumLength or 0,
		averageTimeRemaining = levelState.averageTimeRemaining or 0
	}
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

function useJoystick()
	local useJoystickOption = gameState.useJoystick or false
	return useJoystickOption
end

function setUseJoystick(useJoystickOption)
	gameState.useJoystick = useJoystickOption
	saveGameState(gameState)
end