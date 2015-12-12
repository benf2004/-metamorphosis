local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event ) 
end

function scene:show( event )
    local params = event.params
    local phase = event.phase
    
    if ( phase == "will" ) then
    	self.sceneLoader = params.sceneLoader
    	self.sceneLoader:initialize( self )
    	self.sceneLoader:load()
    elseif ( phase == "did" ) then
        self.sceneLoader:launch()
    	-- self.sceneLoader:start()
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

function scene:moveToScene( sceneLoader )
    local options = {
        params = {
            effect = "fade",
            time = 250,
            sceneLoader = sceneLoader
        }
    }
	composer.gotoScene( "core.CutScene", options )
end

function scene:openModal( )
    self.sceneLoader:pause()
    composer.showOverlay( "core.Modal" )
end

function scene:closeModal( )
    composer.hideOverlay( "fade", 250 )
    self.sceneLoader:start()
end

function scene:openInstructionModal( )
    self.sceneLoader:pause()
    composer.showOverlay( "core.InstructionModal" )
end

function scene:closeInstructionModal( )
    composer.hideOverlay( "fade", 250 )
    self.sceneLoader:start()
end

function scene:openUnlockModal( )
    self.sceneLoader:pause()
    composer.showOverlay( "core.UnlockModal" )
end

function scene:closeUnlockModal( )
    composer.hideOverlay( "fade", 250 )
    self.sceneLoader:start()
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene