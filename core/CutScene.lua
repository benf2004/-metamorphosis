require("core.SceneLoader")

CutScene  = SceneLoader:new()

function CutScene:load()
	self:initializeBackground()
end

function CutScene:load() end
function CutScene:start() 
	self.scene:moveToScene("core.CoreScene")
end
function CutScene:pause() end
---------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event ) 
end

function scene:show( event )
    local phase = event.phase
    
    if ( phase == "will" ) then
    	composer.removeScene( "core.CoreScene" )
    	self.cutScene = CutScene:new()
    	self.cutScene:initialize( self )
    	self.cutScene:load()
    elseif ( phase == "did" ) then
    	self.cutScene:start()
    end
end

function scene:hide( event )
    local phase = event.phase
    
    if ( phase == "will" ) then
    	self.cutScene:pause()
    elseif ( phase == "did" ) then
    	self.cutScene:unload()
    	self.cutScene = nil
    end
end

function scene:destroy( event )
 	if self.cutScene ~= nil then
 		self.cutScene:pause()
 		self.cutScene:unload()
 		self.cutScene = nil
 	end   
end

function scene:moveToScene( sceneName )
	composer.gotoScene( sceneName )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene