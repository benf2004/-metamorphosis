-----------------------------------------------------------------------------------------
--
-- BaseScene.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require( "widget" )

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()

require "worm.HeadWorm"
require "worm.StandardWorm"
require "obstacles.Wall"
require "obstacles.DriftingWall"
require "game.FoodTruck"
require "game.Colors"
require "game.UI"

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
local labelGroup = nil
local head = nil
local foodTruckTimer = nil
local foodTruck = nil
local driftingWallTruck = nil
local hudTimer = nil
local statistics = {}

local function touchListener( event )
	if ( event.phase == "moved" ) then
		head:moveToLocation(event.x, event.y)
    end
end

function scene:create( event )
	
end

function scene:initialize()
	local sceneGroup = self.view

	self:initializeBackground(sceneGroup)
	self:initializeWorm()
	self:initializeWalls(sceneGroup)
	self:initializeDriftingWallTruck(sceneGroup)
	self:initializeHud(sceneGroup)
	self:initializeGravity()
	self:initializeFoodTruck()

	sceneGroup:addEventListener( "touch", touchListener )

	physics.start()
end

function scene:pause()
	timer.cancel( foodTruckTimer )
	timer.cancel( hudTimer )
	physics.pause( )
	if driftingWallTruck ~= nil then
		driftingWallTruck:pause()
	end

	local sceneGroup = self.view
	sceneGroup:removeEventListener( "touch", touchListener )
end

function scene:reset()
	self:pause()
	head:destroy()
	foodTruck:empty()
	if driftingWallTruck ~= nil then
		driftingWallTruck:empty()	
	end
	labelGroup:removeSelf( )
	labelGroup = nil	
end

function scene:initializeBackground(sceneGroup)
	local background = display.newImageRect( "images/Background.png", screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0
	background:setFillColor( 1 )

	sceneGroup:insert( background )
end

function scene:initializeFoodTruck()
	foodTruck = FoodTruck:new()
	foodTruck:initialize(physics, currentScene)
	local closure = function() foodTruck:makeDelivery() end
	foodTruckTimer = timer.performWithDelay( 750, closure, -1 )
end

function scene:initializeGravity()
	physics.setGravity( 0, -19.6 )
	physics.setTimeStep( 0 )
end

function scene:initializeWorm()
	head = HeadWorm:new()
	local x, y = currentScene.worm.x, currentScene.worm.y
	head:initialize(x, y, physics)
end

function scene:initializeWalls(sceneGroup)
	local walls = currentScene.walls or {}
	for i, wallDefinition in ipairs(walls) do
  		local wall = Wall:new()
  		wall:initialize(
  			wallDefinition[1],
 			wallDefinition[2],
 			wallDefinition[3],
 			wallDefinition[4], 
 			physics, sceneGroup)
	end
end

function scene:initializeDriftingWallTruck(sceneGroup)
	if currentScene.driftingWalls ~= nil then
		local interval = currentScene.driftingWalls.interval or 5
		local step = currentScene.driftingWalls.step or 0.3
		local minWidth = currentScene.driftingWalls.minWidth or 100
		local maxWidth = currentScene.driftingWalls.maxWidth or 750
		driftingWallTruck = DriftingWallTruck:new()
		driftingWallTruck:initialize(physics, interval, step, minWidth, maxWidth, screenW, screenH, sceneGroup)

		driftingWallTruck:makeDelivery()
	end
end

function scene:initializeHud(sceneGroup)
	labelGroup = display.newGroup( )
	local restartClosure = function() self:restart() end
	local reset = button("Reset", (screenW - 50), 25, restartClosure)
	sceneGroup:insert(reset)

	local menuClosure = function() self:menu() end
	local menu = button("Menu", (screenW - 160), 25, menuClosure)
	sceneGroup:insert(menu)

	statistics.wormLength = head:lengthToEnd()
	statistics.timeRemaining = currentScene.secondsAllowed

	local lengthLabel = label(tostring(statistics.wormLength), 50, 25, 18, self.view)
	labelGroup:insert(lengthLabel)
	local timerLabel = label(tostring(statistics.timeRemaining), 160, 25, 18, self.view)
	labelGroup:insert(timerLabel)

	local updateHud = function ()
		statistics.timeRemaining = statistics.timeRemaining - 1
		statistics.wormLength = head:lengthToEnd()
		lengthLabel.text = statistics.wormLength.." / "..currentScene.lengthObjective
		timerLabel.text = statistics.timeRemaining

		local statusLabel = nil
		if statistics.wormLength >= currentScene.lengthObjective then
			statusLabel = "You Win!"
			self:pause()
		elseif statistics.timeRemaining <= 0 then
			statusLabel = "You Lose!"
			self:pause()
		elseif head.sprite.y <= -250 then
			statusLabel = "You Lose!"
			self:pause()
		end

		if statusLabel ~= nil then
			local resultLabel = label(statusLabel, screenW/2, screenH/2, 72, self.view)
			labelGroup:insert(resultLabel)
		end
	end
	hudTimer = timer.performWithDelay( 1000, updateHud, -1)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		self:initialize( )
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

function scene:restart()
	self:reset()
	self:initialize()
end

function scene:menu()
	self:reset()
	composer.gotoScene( "scenes.Menu", "fade", 250 )
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene