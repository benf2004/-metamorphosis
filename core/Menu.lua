require("core.SceneBase")
require("core.SceneLoader")
require("game.UI")
require("game.Colors")
require("game.GameState")

Menu = SceneBase:new()

function Menu:load()
	self.columns = 5
	self.rows = 5

	self:initializeBackground()
	self:initializeButtons()
end
function Menu:start() end
function Menu:pause() end

function Menu:initializeBackground()
	local background = display.newImageRect( "images/Background.png", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	self:addDisplayObject(background)
end

function Menu:initializeButtons()
	local sceneGroup = self.view
	local columns = self.columns
	local rows = self.rows
	local spacing = 10

	local width = ((self.screenW - (spacing * (columns+1))) / columns)
	local height = ((self.screenH - (spacing * (rows+1))) / rows)

	local menuSelected = function(event)
		if not event.target.locked then
			currentLevel = event.target.level
			currentScene = require( "scenes.Level" .. currentLevel)
			local sceneLoader = SceneLoader:new()
			self.scene:moveToScene(sceneLoader)
			return true
		else
			return false
		end
	end

	for i=0, columns-1 do
		for j=0, rows-1 do
			local x = (i * width) + ((i+1) * spacing) + (width / 2)
			local y = (j * height) + ((j+1) * spacing) + (height / 2)

			local level = (columns * j + i) + 1
			local label = level
			local locked = false

			if not self:isLevelUnlocked(level) then
				label = "Locked"
				locked = true
			end
			
			local menuButton = button(label, x, y, width, height, menuSelected)
			menuButton.level = level
			menuButton.locked = locked

			self:addDisplayObject(menuButton)
		end
	end
end

function Menu:isLevelUnlocked(level)
	local lvl = "Level"..(level-1)
	self:printTable(gameState[lvl])
	return (gameState[lvl] and gameState[lvl].completed)
end
