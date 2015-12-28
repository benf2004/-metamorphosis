require("core.SceneBase")
require("core.SceneLoader")
require("game.UI")
require("game.Colors")
require("game.GameState")
require("worm.MenuWorm")
require("ads.AdManager")

Menu = SceneBase:new()

Menu.sheetOptions = {
	width = 64,
	height = 64,
	numFrames = 2
}
Menu.starSheet = graphics.newImageSheet( "images/StarSheet.png", Menu.sheetOptions )
Menu.starSequence = {
	name = "Stars",
	frames = {1, 2}
}

function Menu:load()
	self.columns = 5
	self.rows = 5
	self.menuWorms = {}
	self.contents = {}

	self:initializeAdvertising()
	self:initializePhysics()
	self:initializeBackground()
	self:initializeButtons()
	self:initializeFoodTruck()
	self:initializeMenuWorm()
	self:initializeFood()
	self:showAdvertisement()
end

function Menu:start() 
	self.physics.start() 
	self:resumeAllTimers()
end

function Menu:pause() 
	self.physics.pause()

	self:pauseAllTimers()
	self:removeAllGlobalEventListeners()
	self:pauseAllMusic()
end

function Menu:initializeBackground()
	local background = display.newImageRect( "images/Background.png", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	self:addDisplayObject(background)
end

function Menu:initializeFoodTruck()
	self.foodTruck = FoodTruck:new()
	self.foodTruck:initialize(physics, {foodTruck={}}, self)
end

function Menu:initializeMenuWorm()
	local menuWormsDefinitions = {{150, 50}}
	local speed = 22
	for i, menuWormDefinition in ipairs(menuWormsDefinitions) do
		local menuWorm = MenuWorm:new()
		local x, y = menuWormDefinition[1], menuWormDefinition[2]
		menuWorm:initialize(x, y, self.physics, self.foodTruck, self)
		menuWorm:initializeMotion(speed)
		table.insert(self.menuWorms, menuWorm)
	end
end

function Menu:initializeFood()
	local screenW = self.screenW
	local screenH = self.screenH

	local offsetX = screenW * 0.0675
	local offsetY = screenH * 0.0675

	local targetIndex = 2

	local standardWorms = {
		{screenW - offsetX - 410, offsetY, 0, 100},
		{screenW - offsetX - 310, offsetY, 0, 100},
		{screenW - offsetX - 210, offsetY, 0, 100},
		{screenW - offsetX - 110, offsetY, 0, 100},
		{screenW - offsetX - 50, offsetY, 0, 100},
		{screenW - offsetX, screenH - offsetY - 50, 0, 2000},
		{offsetX + 50, screenH - offsetY, 0, 4000},
		{offsetX, offsetY + 50, 0, 6000},
		{screenW - offsetX - 50, offsetY, 0, 8000},
		{screenW - offsetX, screenH - offsetY - 50, 0, 10000},
		{offsetX + 50, screenH - offsetY, 0, 12000},
		{offsetX, offsetY + 50, 0, 14000}
	}

	for i, wormDef in ipairs(standardWorms) do
		local x = wormDef[1]
		local y = wormDef[2]
		local c = wormDef[3]
		local d = wormDef[4]
		self.foodTruck:fixedFood(x, y, c, d)
	end
end

function Menu:initializePhysics()
	self.physics = require( "physics" )
	-- self.physics.setDrawMode("hybrid")
	self.physics.start(); self.physics.pause()

	self.touchListener = function( event )
		if ( event.phase == "began" ) then
			if (event.target.obj) then
				self.touchTarget = event.target.obj
			end
		elseif ( event.phase == "moved" ) then
			-- if self.touchTarget ~= nil and self.touchTarget.moveToLocation ~= nil then
			-- 	self.touchTarget:moveToLocation(event.x, event.y)
			-- else
				self.head:moveToLocation(event.x, event.y)
			-- end
		elseif (event.phase == "ended" or event.phase == "cancelled") then
			self.touchTarget = nil
    	end
    	return true
    end
end

function Menu:initializeButtons()
	local sceneGroup = self.view
	local columns = self.columns
	local rows = self.rows
	local spacing = 10
	
	local adHeight = 100
	local availableScreenH = self.screenH - adHeight

	local menuWidth = self.screenW * 0.75
	local menuHeight = availableScreenH * 0.75
	local upperX = self.screenW * .125
	local upperY = availableScreenH * .125

	local commandButtonHeight = 75
	local adHeight = 0

	local background = display.newRoundedRect( upperX, upperY, menuWidth, menuHeight, 15)
	background.anchorX, background.anchorY = 0, 0
	background.fill = {0, 0, 0, 0.5}
	self:addDisplayObject(background)

	local width = ((menuWidth - (spacing * (columns+1))) / columns)
	local height = (((menuHeight - commandButtonHeight - adHeight) - (spacing * (rows+1))) / rows)

	local instW = (menuWidth - (spacing * 3)) / 3
	local instX = spacing + (instW / 2) + upperX
	local instY = (rows * (height + spacing)) + spacing + upperY + ((commandButtonHeight - spacing) / 2)

	local menuSelected = function(event)
		if not event.target.locked then
			self:pause()
			currentLevel = event.target.level
			currentScene = require( "scenes.Level" .. currentLevel)
			currentScene.levelState = self:levelState(currentLevel)
			local sceneLoader = SceneLoader:new()
			self:hideAdvertisement()
			self.scene:moveToScene(sceneLoader)
			return true
		else
			lockedLevel = event.target.level
			self:openUnlockModal()
			return false
		end
	end

	for i=0, columns-1 do
		for j=0, rows-1 do
			local x = (i * width) + ((i+1) * spacing) + (width / 2) + upperX
			local y = (j * height) + ((j+1) * spacing) + (height / 2) + upperY

			local level = (columns * j + i) + 1
			local label = level

			local levelState = self:levelState(level)

			local locked = false
			local completed = levelState and levelState.completed

			if not self:isLevelUnlocked(level) then
				locked = true
			end

			local menuButton = button(label, x, y, width, height, menuSelected)
			self:addDisplayObject(menuButton)

			if locked == true then
				local diameter = math.min(width, height) * .35
				imageIcon = display.newImageRect( "images/padlock.png", diameter, diameter )
				imageIcon.anchorX, imageIcon.anchorY = 0, 0
				imageIcon.x = x + (width * .2)
				imageIcon.y = y + (height * .1)
				self:addDisplayObject(imageIcon)
			end

			local bestTime = (levelState and levelState.bestTime) or -1

			local stars = {
				display.newSprite( self.starSheet, self.starSequence ),
				display.newSprite( self.starSheet, self.starSequence ),
				display.newSprite( self.starSheet, self.starSequence )
			}

			stars[1].x = x - width * .3
			stars[2].x = x
			stars[3].x = x + width * .3

			if completed and bestTime >= 0 then stars[1]:setFrame(2) else stars[1].alpha = 0.3 end
			if completed and bestTime >= 10 then stars[2]:setFrame(2)	else stars[2].alpha = 0.3 end
			if completed and bestTime >= 20 then stars[3]:setFrame(2) else stars[3].alpha = 0.3 end

			for i = 1, #stars do
				stars[i].y = y - height * .25
				stars[i].width = 25
				stars[i].height = 25
				self:addDisplayObject(stars[i])
			end
		 
			menuButton.level = level
			menuButton.locked = locked
		end
	end

	local instructionsSelected = function(event)
		self:openInstructionModal()
	end

	local unlockLevelPack = function(event)
		self:openUnlockModal()
	end

	local instructionsButton = button("How to Play", instX, instY, instW, commandButtonHeight - spacing, instructionsSelected)
	self:addDisplayObject(instructionsButton)

	local options = {
		text = "Feeding Frenzy",
		x = self.centerX,
		y = self.centerY,
		width = instW,
		font = "Neon",
		fontSize = 38,
		align = "center"
	}
	local label = display.newText(options)
	label.y = instY + 8
	label.fill = colors.brown
	self:addDisplayObject(label)

	local unlockButton = button("Unlock Levels 1-25", (instX + instW + instW + spacing) , instY, instW, commandButtonHeight - spacing, unlockLevelPack)
	self:addDisplayObject(unlockButton)
end

function Menu:isLevelUnlocked(level)
	local lvl = "Level"..(level-1)
	return (gameState[lvl] and gameState[lvl].completed)
end

function Menu:levelState(level)
	local lvl = "Level"..(level)
	return gameState[lvl]
end

function Menu:openInstructionModal()
	
end

function Menu:openUnlockModal()
	resetGameState()
end

function Menu:initializeAdvertising()
	self.adManager = AdManager:new()
	self.adManager:initialize()
end

function Menu:showAdvertisement()
	self.adManager:showBannerAd(0, 768)
end

function Menu:hideAdvertisement()
	self.adManager:hideAd()
end