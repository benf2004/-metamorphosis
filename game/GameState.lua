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

function completeLevel(level, timeRemaining, stars)
	local message = "Completed level"..level.." "..timeRemaining.." "..stars
	print(message)

	local lvl = "Level"..level
	gameState[lvl] = {
		completed = true,
		timeRemaining = timeRemaining,
		stars = stars
	}
	saveGameState(gameState)
end