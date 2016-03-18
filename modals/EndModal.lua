require("modals.SceneModal")

EndModal = SceneModal:new()

function EndModal:initializeContent()
	self:starLine()
	self:bottomLine()
	self:restartButton()
	self:homeButton()
	self:goal()
	if currentLevel < 25 then
		self:nextButton()
	end
end

function EndModal:restartButton()
	local width, height = 90,75
	local yOffset = self.buttonOffset
	local posX = self.centerX --self.popup.x + (self.popup.width / 2) - 40
	local posY = self.centerY + yOffset

	local button = restartButton(posX, posY, width, height, self.parent.sceneLoader)
	self:addDisplayObject(button)

	local label = label("Try Again", posX, posY + (height / 2) + 15, "Desyrel", 22)
	label.fill = colors.black
	self:addDisplayObject(label)
end

-- function EndModal:goal()
-- 	local levelState = levelState(currentLevel)

-- 	local maximumLength = levelState.maximumLength
-- 	local bestTime = levelState.bestTime
-- 	local lengthObjective = currentScene.lengthObjective
-- 	local secondsAllowed = currentScene.secondsAllowed
-- 	local skin = self.parent.sceneLoader.defaultSkin

-- 	local xOffset = -self.width / 7
-- 	local yOffset = -55
-- 	local posX = self.centerX + xOffset
-- 	local posY = self.centerY + yOffset

-- 	local width = 125
-- 	local height = 52
-- 	local textHeight = 32
-- 	local textOffset = height / 2 + textHeight + 3

-- 	local objBox = objectiveBox(posX, posY, width, height, "Desyrel", 32, nil, maximumLength, skin, false)
-- 	self:addDisplayObject(objBox)

-- 	-- local line1Label = label("Move the worm with your finger.", self.centerX, posY - textOffset - textHeight, "Desyrel", textHeight)
-- 	-- line1Label.fill = colors.black
-- 	-- self:addDisplayObject(line1Label)

-- 	-- local line2Label = label("Eat until you reach your goal.", self.centerX, posY - textOffset, "Desyrel", textHeight)
-- 	-- line2Label.fill = colors.brown
-- 	-- self:addDisplayObject(line2Label)

-- 	local inLabel = label("in", self.centerX, self.centerY + yOffset, "Desyrel", 32)
-- 	inLabel.fill = colors.brown
-- 	self:addDisplayObject(inLabel)

-- 	local timeBox = timeRemainingBox(self.centerX - xOffset, posY, width, height, "Desyrel", 32, bestTime, false)
-- 	self:addDisplayObject(timeBox)
-- end