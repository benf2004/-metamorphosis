require("core.SceneBase")
require("game.Colors")

Modal = SceneBase:new()

function Modal:load(parent, w, h, closeAction)
	self.parent = parent
	self:initializeBackground()
	self:initializePopup(w, h)
	self:initializeContent()
	self:initializeCloseButton(action)
end

function Modal:initializeBackground()
	self.centerX, self.centerY = display.contentWidth / 2, display.contentHeight / 2
	local background = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	background.anchorX, background.anchorY = 0, 0
	background.fill = {0, 0, 0, 0.5}
	self:addDisplayObject(background)
end

function Modal:initializePopup(w, h)
	self.width = w or display.contentWidth * .55
	self.height = h or display.contentHeight * .55
	self.popup = display.newRoundedRect( self.centerX, self.centerY, self.width, self.height, 20 )
	self.popup.fill = colors.brown
	self:addDisplayObject(self.popup)
end

function Modal:initializeCloseButton(closeAction)
	local width, height = 64, 64
	local posX = self.popup.x + (self.popup.width / 2) - 40
	local posY = self.popup.y - (self.popup.height / 2) + 40
	local closeButton = display.newImageRect( "images/close.png", width, height )
	closeButton.x = posX
	closeButton.y = posY
	self:addDisplayObject(closeButton)

	local closeModal = function() 
		if action ~= nil then action() end
		self.parent:closeModal()
	end
	closeButton:addEventListener( "touch", closeModal )
end

function Modal:initializeContent()
end	