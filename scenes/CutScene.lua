-----------------------------------------------------------------------------------------
--
-- CutScene.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event )

end

function scene:show( event )
	if event.phase == "will" then
		composer.removeScene( "scenes.BaseScene", false )
		currentScene = require( "scenes.Level001")
		composer.gotoScene( "scenes.BaseScene", "fade", 250 )
	end
end

function scene:hide( event )

end

function scene:destroy( event )

end