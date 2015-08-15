require("core.SceneBase")

Modal = SceneBase:new()

function Modal:load()
	self:initializeBackground()
end

function Modal:initializeBackground()
	local background = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	background.anchorX, background.anchorY = 0, 0
	background.fill = {0, 0, 0, 0.5}
	self:addDisplayObject(background)
end

---------------------------------------

local composer = require( "composer" )

local scene = composer.newScene()

function scene:show( event )
	self.modal = Modal:new()
	self.modal:initialize(self)
	self.modal:load()
	timer.performWithDelay( 5000, self.hideOverlay )
end

function scene:hide( event )
    local phase = event.phase
    local parent = event.parent

    if ( phase == "will" ) then
        parent:closeModal()
    end
end

function scene:hideOverlay()
	composer.hideOverlay( "fade", 250 )
end

scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
return scene