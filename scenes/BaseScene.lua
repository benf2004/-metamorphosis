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
require "game.FoodTruck"
require "game.Colors"

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
local head = HeadWorm:new()

local function touchListener( event )
	if ( event.phase == "moved" ) then
		head:moveToLocation(event.x, event.y)
    end
end

function scene:create( event )
	local sceneGroup = self.view

	self:initializeBackground(sceneGroup)
	self:initializeHud(sceneGroup)
	self:initializeWorm()
	self:initializeGravity()
	self:initializeFoodTruck()

	sceneGroup:addEventListener( "touch", touchListener )
end

function scene:initializeBackground(sceneGroup)
	local background = display.newImageRect( "images/Background.png", screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0
	background:setFillColor( 1 )

	sceneGroup:insert( background )
end

function scene:initializeFoodTruck()
	local foodTruck = FoodTruck:new()
	foodTruck:initialize(physics)
	local closure = function() foodTruck:makeDelivery() end
	timer.performWithDelay( 1000, closure, -1 )
end

function scene:initializeGravity()
	physics.setGravity( 0, -19.6 )
end

function scene:initializeWorm()
	local x, y = currentScene.worm.x, currentScene.worm.y
	head:initialize(x, y, physics)
end

function scene:initializeHud(sceneGroup)
	local restartClosure = function() self:restart() end
	local button = widget.newButton
		{
		    label = "Restart",
		    labelColor = { default = colors.black },
		    emboss = true,
		    shape="roundedRect", --defect??
		    width = 100,
		    height = 50,
		    x = screenW - 50,
		    y = 25,
		    cornerRadius = 10,
		    fillColor = { default = colors.brown },
		    strokeColor = { default = colors.black },
		    strokeWidth = 4,
		    onRelease = restartClosure
		}
	sceneGroup:insert(button)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		--
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
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
	-- need to research how to restart a lua scene
	composer.gotoScene( "scenes.Transition", "fade", 50 )
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene