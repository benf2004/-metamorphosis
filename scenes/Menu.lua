-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------
require( "game.Colors")

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

local buttons = {}

--------------------------------------------

local function pressAButton(event)
	local level = event.target:getLabel()
	currentScene = require( "scenes.Level" .. level)
	composer.gotoScene( "scenes.BaseScene", "fade", 250 )
	return true	
end

function scene:create( event )
	local sceneGroup = self.view

	-- display a background image
	local background = display.newImageRect( "images/Background.png", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	sceneGroup:insert( background )

	local columns = 3
	local rows = 3
	local spacing = 10

	local width = ((display.contentWidth - (spacing * (columns+1))) / columns)
	local height = ((display.contentHeight - (spacing * (rows+1))) / rows)

	for i=0, columns-1 do
		for j=0, rows-1 do
			local x = (i * width) + ((i+1) * spacing) + (width / 2)
			local y = (j * height) + ((j+1) * spacing) + (height / 2)

			local label = (columns * j + i) + 1

			button = widget.newButton
				{
				    label = label,
				    labelColor = { default = colors.black },
				    emboss = true,
				    shape="roundedRect",
				    width = width,
				    height = height,
				    cornerRadius = 10,
				    fillColor = { default = colors.brown, over = colors.brown },
				    strokeColor = { default = colors.black, over = colors.black },
				    strokeWidth = 4,
				    onRelease = pressAButton
				}
			button.x, button.y = x, y
			sceneGroup:insert(button)
			buttons[label] = button
		end
	end
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		composer.removeScene( "scenes.BaseScene", false )
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
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.

	for i=1,#buttons do
		buttons[i]:removeSelf( )
		buttons[i] = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene