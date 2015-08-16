require("core.SceneBase")
require("game.Colors")

Modal = SceneBase:new()

function Modal:load(parent)
	self.parent = parent
	self:initializeBackground()
	self:initializePopup()
	-- self:initializeCloseButton()
	self:sceneInstructions()
	self:goButton()

end

function Modal:initializeBackground()
	self.centerX, self.centerY = display.contentWidth / 2, display.contentHeight / 2
	local background = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	background.anchorX, background.anchorY = 0, 0
	background.fill = {0, 0, 0, 0.5}
	self:addDisplayObject(background)
end

function Modal:initializePopup()
	local width = display.contentWidth * .55
	local height = display.contentHeight * .55
	self.popup = display.newRoundedRect( self.centerX, self.centerY, width, height, 20 )
	self.popup.fill = colors.brown
	self:addDisplayObject(self.popup)
end

function Modal:initializeCloseButton()
	local width, height = 64, 64
	local posX = self.popup.x + (self.popup.width / 2) - 40
	local posY = self.popup.y - (self.popup.height / 2) + 40
	local closeButton = display.newImageRect( "images/close.png", width, height )
	closeButton.x = posX
	closeButton.y = posY
	self:addDisplayObject(closeButton)

	local closeModal = function() self.parent:closeModal() end
	closeButton:addEventListener( "touch", closeModal )
end

function Modal:sceneInstructions()
	local instruction = currentScene.instructions or 
		"Wormy is hungry!\nDrag him to his food!\nQuick! Before time runs out!"

	local countdown = currentScene.countdown or 5000

	local width = self.popup.width - 60
	local options = {
		text = instruction,
		x = self.centerX,
		y = self.centerY,
		width = width,
		font = self:getFont(),
		fontSize = 30,
		align = "center"
	}
	local label = display.newText( options)
	label.y = self.centerY - (self.popup.height / 2) + (label.height / 2) + 30
	label.fill = colors.black

	self.instFrame = display.newRoundedRect( label.x, label.y, label.width + 15, label.height + 15, 10 )
	self.instFrame.fill = colors.yellow

	self:addDisplayObject(self.instFrame)
	self:addDisplayObject(label)
end

function Modal:goButton()
	local width, height = 220,220
	local posX = self.centerX --self.popup.x + (self.popup.width / 2) - 40
	local posY = self.popup.y + (self.popup.height / 5)
	local goButton = display.newImageRect( "images/go.png", width, height )
	goButton.x = posX
	goButton.y = posY
	self:addDisplayObject(goButton)

	local closeModal = function() self.parent:closeModal() end
	goButton:addEventListener( "touch", closeModal )
end

function Modal:getFont()
	local fonts = native.getFontNames( )
	local font = nil
	for _,v in pairs(fonts) do
	  if v == "Chalkduster" then
	    font = v
	    break
	  end
	end
	font = font or native.systemFontBold
	return font
end
		

---------------------------------------

local composer = require( "composer" )

local scene = composer.newScene()

function scene:show( event )
	local phase = event.phase
	local parent = event.parent
	if (phase == "will") then
		self.modal = Modal:new()
		self.modal:initialize(self)
		self.modal:load(parent)
	end
end

scene:addEventListener( "show", scene )

return scene