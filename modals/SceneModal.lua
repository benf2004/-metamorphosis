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
	self:levelLine()
	self:bottomLine()
	-- self:sceneInstructions()
	self:goButton()
	self:menuButton()
	self:unlockButton()
end

function SceneModal:initializeCloseButton(closeAction)
end

function SceneModal:menuButton()
	local x = self.centerX - self.width / 3 - 5
	local y = self.centerY + self.height / 2 - 33 - 5
	local w = self.width / 3 - 20
	local h = 75 - 20
	local instructionsButton = button("Menu", x, y, w, h, instructionsSelected)
	self:addDisplayObject(instructionsButton)
end

function SceneModal:unlockButton()
	local x = self.centerX + self.width / 3 + 5
	local y = self.centerY + self.height / 2 - 33 - 5
	local w = self.width / 3 - 20
	local h = 75 - 20
	local instructionsButton = button("Unlock Levels", x, y, w, h, instructionsSelected)
	self:addDisplayObject(instructionsButton)
end	

function SceneModal:initializePopup(w, h)
	self.width = w or display.contentWidth * .55
	self.height = h or display.contentHeight * .55
	self.popup = display.newRoundedRect( self.centerX, self.centerY, self.width, self.height, 20 )
	self.popup.fill = colors.darkbrown
	self:addDisplayObject(self.popup)

	local innerFrame = display.newRect( self.centerX, self.centerY, self.width, self.height - 150 )
	innerFrame.fill = colors.brown
	self:addDisplayObject(innerFrame)
end

function SceneModal:starLine()
	
end

function SceneModal:levelLine()
	local label = label("Level "..tostring(currentLevel), self.centerX, self.centerY - self.popup.height / 2 + 40, "Desyrel", 50)
	label.fill = colors.brown
	self:addDisplayObject(label)
end

function SceneModal:bottomLine()
	local label = label("Wormy", self.centerX, self.centerY + self.popup.height / 2 - 33, "Neon", 50)
	label.fill = colors.brown
	self:addDisplayObject(label)
end

function SceneModal:sceneInstructions()
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

function SceneModal:goButton()
	local width, height = 80,80
	local posX = self.centerX --self.popup.x + (self.popup.width / 2) - 40
	local posY = self.popup.y + (self.popup.height / 5)
	local goButton = display.newImageRect( "images/go.png", width, height )
	goButton.x = posX
	goButton.y = posY
	self:addDisplayObject(goButton)

	local closeModal = function() self.parent:closeModal() end
	goButton:addEventListener( "touch", closeModal )
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