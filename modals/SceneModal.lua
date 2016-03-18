require("core.Modal")

SceneModal = Modal:new()

SceneModal.sheetOptions = {
	width = 64,
	height = 64,
	numFrames = 2
}
SceneModal.starSheet = graphics.newImageSheet( "images/StarSheet.png", Menu.sheetOptions )
SceneModal.starSequence = {
	name = "Stars",
	frames = {1, 2}
}

function SceneModal:initializeContent()
	self:starLine()
	self:goal()
	self:bottomLine()
	self:homeButton()
	if currentLevel < 25 then
		self:nextButton()
	end

	if isLevelUnlocked(currentLevel) then
		self.isLocked = false
		self:goButton()
	else
		self.isLocked = true
		self:lockButton()
	end
end

function SceneModal:initializeCloseButton(closeAction)
end

function SceneModal:initializePopup(w, h)
	self.width = w or display.contentWidth * .55
	self.height = h or display.contentHeight * .45
	self.buttonOffset = 30
	self.popup = display.newRoundedRect( self.centerX, self.centerY, self.width, self.height, 20 )
	self.popup.fill = colors.darkbrown
	self:addDisplayObject(self.popup)

	local innerFrameHeight = self.height - 150
	local innerFramePosition = self.centerY
	local innerFrame = display.newRect( self.centerX, innerFramePosition, self.width, innerFrameHeight )
	innerFrame.fill = colors.brown
	self:addDisplayObject(innerFrame)
end

function SceneModal:starLine()
	local x = self.centerX
	local y = self.centerY
	local width = self.width
	local height = self.height
	local levelStars = levelStars(currentLevel)
	local stars = {
		display.newSprite( self.starSheet, self.starSequence ),
		display.newSprite( self.starSheet, self.starSequence ),
		display.newSprite( self.starSheet, self.starSequence )
	}

	stars[1].x = x - width * .3
	stars[2].x = x
	stars[3].x = x + width * .3

	if levelStars >= 1 then stars[1]:setFrame(2) else stars[1].alpha = 0.3 end
	if levelStars >= 2 then stars[2]:setFrame(2)	else stars[2].alpha = 0.3 end
	if levelStars >= 3 then stars[3]:setFrame(2) else stars[3].alpha = 0.3 end

	for i = 1, #stars do
		stars[i].y = y - height * .5 + (75 / 2)
		stars[i].width = 50
		stars[i].height = 50
		self:addDisplayObject(stars[i])
	end
end

function SceneModal:levelLine()
	local label = label("Level "..tostring(currentLevel), self.centerX, self.centerY - self.popup.height / 2 + 40, "Desyrel", 40)
	label.fill = colors.brown
	self:addDisplayObject(label)
end

function SceneModal:bottomLine()
	local title = currentScene.title
	local label = label("Level "..currentLevel.." - "..title, self.centerX, self.centerY + self.popup.height / 2 - 33, "Desyrel", 40)
	label.fill = colors.brown
	self:addDisplayObject(label)
end

function SceneModal:homeButton()
	local width, height = 90,75
	local yOffset = self.buttonOffset
	local posX = self.centerX - 120 - 50
	local posY = self.centerY + yOffset

	local button = homeButton(posX, posY, width, height, self.parent.sceneLoader)
	self:addDisplayObject(button)

	local label = label("Home", posX, posY + (height / 2) + 15, "Desyrel", 22)
	label.fill = colors.black
	self:addDisplayObject(label)
end

function SceneModal:goButton()
	local width, height = 90,75
	local yOffset = self.buttonOffset
	local posX = self.centerX --self.popup.x + (self.popup.width / 2) - 40
	local posY = self.centerY + yOffset

	local button = goButton(posX, posY, width, height, self.parent.sceneLoader)
	self:addDisplayObject(button)

	local label = label("Start", posX, posY + (height / 2) + 15, "Desyrel", 22)
	label.fill = colors.black
	self:addDisplayObject(label)
end

function SceneModal:nextButton()
	local width, height = 90,75
	local yOffset = self.buttonOffset
	local posX = self.centerX + 120 + 50
	local posY = self.centerY + yOffset

	local button = nextButton(posX, posY, width, height, self.parent.sceneLoader)
	self:addDisplayObject(button)

	local label = label("Next Level", posX, posY + (height / 2) + 15, "Desyrel", 22)
	label.fill = colors.black
	self:addDisplayObject(label)
end

function SceneModal:lockButton()
	local width, height = 90,75
	local yOffset = self.buttonOffset
	local posX = self.centerX
	local posY = self.centerY + yOffset

	local button = lockButton(posX, posY, width, height, self.parent.sceneLoader)
	self:addDisplayObject(button)

	local label = label("Locked", posX, posY + (height / 2) + 15, "Desyrel", 22)
	label.fill = colors.black
	self:addDisplayObject(label)
end

function SceneModal:getFont()
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

function SceneModal:goal()
	local lengthObjective = currentScene.lengthObjective
	local secondsAllowed = currentScene.secondsAllowed
	local skin = self.parent.sceneLoader.defaultSkin

	local xOffset = -self.width / 7
	local yOffset = -55
	local posX = self.centerX + xOffset
	local posY = self.centerY + yOffset

	local width = 125
	local height = 52
	local textHeight = 32
	local textOffset = height / 2 + textHeight + 3

	local objBox = objectiveBox(posX, posY, width, height, "Desyrel", 32, nil, lengthObjective, skin, true)
	self:addDisplayObject(objBox)

	-- local line1Label = label("Move the worm with your finger.", self.centerX, posY - textOffset - textHeight, "Desyrel", textHeight)
	-- line1Label.fill = colors.black
	-- self:addDisplayObject(line1Label)

	-- local line2Label = label("Eat until you reach your goal.", self.centerX, posY - textOffset, "Desyrel", textHeight)
	-- line2Label.fill = colors.brown
	-- self:addDisplayObject(line2Label)

	local inLabel = label("in", self.centerX, self.centerY + yOffset, "Desyrel", 32)
	inLabel.fill = colors.brown
	self:addDisplayObject(inLabel)

	local timeBox = timeRemainingBox(self.centerX - xOffset, posY, width, height, "Desyrel", 32, secondsAllowed, true)
	self:addDisplayObject(timeBox)
end
