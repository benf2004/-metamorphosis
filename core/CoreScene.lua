require("core.ModalLaunch")
require("modals.SceneModal")
require("modals.EndModal")
require("modals.ConfirmConsumePass")
require("modals.ConfirmPurchasePass")

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

function scene:openModal( modal )
    local modalType = modal or "SceneModal"
    self.sceneLoader:pause()
    if ( modalType == "EndModal" ) then
        self.modal = EndModal:new()
    elseif (modalType == "SceneModal") then
        self.modal = SceneModal:new()
    elseif (modalType == "ConfirmConsumePass") then
        self.modal = ConfirmConsumePass:new()
    elseif (modalType == "ConfirmPurchasePass") then
        self.modal = ConfirmPurchasePass:new()
    end
    composer.showOverlay( "core.ModalLaunch" )
end

function scene:closeModal( )
    composer.hideOverlay( "fade", 250 )
    self.sceneLoader:start()
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene