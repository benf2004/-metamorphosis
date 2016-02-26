require("core.Modal")

ConfirmConsumePass = Modal:new()

function ConfirmConsumePass:initializeContent()
	self:initializeQuestion()
	self:initializeKeyIcon()
	self:initializeYesButton()
	self:initializeNoButton()
end

function ConfirmConsumePass:initializePopup(w, h)
	self.width = w or display.contentWidth * .55
	self.height = h or display.contentHeight * .3
	self.popup = display.newRoundedRect( self.centerX, self.centerY, self.width, self.height, 20 )
	self.popup.fill = colors.brown
	self:addDisplayObject(self.popup)
end

function ConfirmConsumePass:initializeCloseButton(closeAction)
end

function ConfirmConsumePass:initializeQuestion()
	local question = "Use a free pass to unlock Level "..tostring(currentLevel).."?"
	local x = self.centerX
	local y = self.centerY - self.height * .25
	local fontSize = 36
	local font = "Desyrel"

	local question = label(question, x, y, font, fontSize)
	question.fill = colors.black
	self:addDisplayObject(question)
end

function ConfirmConsumePass:initializeYesButton()
	local width, height = 90,75
	local yOffset = 35
	local posX = self.centerX - width * 2
	local posY = self.centerY + yOffset

	local button = confirmConsumePassButton(posX, posY, width, height, self.parent.sceneLoader)
	self:addDisplayObject(button)

	local label = label("Yes", posX, posY + (height / 2) + 15, "Desyrel", 22)
	label.fill = colors.black
	self:addDisplayObject(label)
end

function ConfirmConsumePass:initializeNoButton()
	local width, height = 100,75
	local yOffset = 35
	local posX = self.centerX + width * 2
	local posY = self.centerY + yOffset

	local button = cancelButton(posX, posY, width, height, self.parent.sceneLoader)
	self:addDisplayObject(button)

	local label = label("No", posX, posY + (height / 2) + 15, "Desyrel", 22)
	label.fill = colors.black
	self:addDisplayObject(label)
end

function ConfirmConsumePass:initializeKeyIcon()
	local width, height = 125,60
	local yOffset = 35
	local posx = self.centerX
	local posy = self.centerY + yOffset

	local keyBox = keyBox(posx, posy, width, height)
	self:addDisplayObject(keyBox)
end	