require( "core.SceneLoader" )

local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event ) 
end

function scene:show( event )
    local phase = event.phase
    
    if ( phase == "will" ) then
    	if self.sceneLoader == nil then
    		self.sceneLoader = SceneLoader:new()
    		self.sceneLoader:initialize( self )
    	end
    	self.sceneLoader:load()
    elseif ( phase == "did" ) then
    	self.sceneLoader:start()
    end
end

function scene:hide( event )
    local phase = event.phase
    
    if ( phase == "will" ) then
    	self.sceneLoader:pause()
    elseif ( phase == "did" ) then
    	self.sceneLoader:unload()
    	self.sceneLoader = nil
    end
end

function scene:destroy( event )
 	if self.sceneLoader ~= nil then
 		self.sceneLoader:pause()
 		self.sceneLoader:unload()
 		self.sceneLoader = nil
 	end   
end

function scene:moveToScene( sceneName )
	composer.gotoScene( sceneName, "fade", 250 )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene