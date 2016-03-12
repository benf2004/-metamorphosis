require("core.Modal")

InstructionModal = Modal:new()

function InstructionModal:initializeContent()
	self:initializeInstructions()
	-- self:initializeTitle()
end

function InstructionModal:initializePopup(w, h)
	self.width = w or display.contentWidth * .80
	self.height = h or display.contentHeight * .80
	self.buttonOffset = 30
	self.popup = display.newRoundedRect( self.centerX, self.centerY, self.width, self.height, 20 )
	self.popup.fill = colors.brown
	self:addDisplayObject(self.popup)

	-- local innerFrameHeight = self.height - 150
	-- local innerFramePosition = self.centerY
	-- local innerFrame = display.newRect( self.centerX, innerFramePosition, self.width, innerFrameHeight )
	-- innerFrame.fill = colors.darkbrown
	-- self:addDisplayObject(innerFrame)
end

function InstructionModal:initializeCloseButton()
	local width, height = 40,40
	local yOffset = self.height / 2 - height / 2 - 20
	local posX = self.popup.x + (self.popup.width / 2) - 27
	local posY = self.popup.y - (self.popup.height / 2) + 30

	local button = cancelButton(posX, posY, width, height, self.parent.sceneLoader)
	self:addDisplayObject(button)
end

function InstructionModal:initializeInstructions()
	local width, height = self.width - 30, self.height - 75
	local posX = self.popup.x
	local posY = self.popup.y

	local instructions = display.newImage("images/Instructions.png", posX, posY )

	self:addDisplayObject(instructions)
end

function InstructionModal:initializeTitle()
	local posX = self.popup.x
	local posY = self.popup.y - (self.height / 2) + 37
	local posBY = self.popup.y + (self.height / 2) - 37
	local instructionLabel = label("How to Play", posX, posY, "Desyrel", 30)
	instructionLabel.fill = colors.darkbrown

	local gameLabel = label(gameName, posX, posBY, "Neon", 40)
	gameLabel.fill = colors.darkbrown

	self:addDisplayObject(instructionLabel)
	self:addDisplayObject(gameLabel)
end

