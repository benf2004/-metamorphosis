require("modals.SceneModal")

EndModal = SceneModal:new()

function EndModal:initializeContent()
	self:starLine()
	self:bottomLine()
	self:restartButton()
	self:homeButton()
	if currentLevel < 25 then
		self:nextButton()
	end
end

function EndModal:restartButton()
	local width, height = 90,75
	local yOffset = 65
	local posX = self.centerX --self.popup.x + (self.popup.width / 2) - 40
	local posY = self.centerY + yOffset

	local button = restartButton(posX, posY, width, height, self.parent.sceneLoader)
	self:addDisplayObject(button)

	local label = label("Try Again", posX, posY + (height / 2) + 15, "Desyrel", 22)
	label.fill = colors.black
	self:addDisplayObject(label)
end