require("core.SceneBase")
require("core.SceneLoader")
require("game.UI")
require("game.Colors")

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
		local level = event.target:getLabel()
		currentScene = require( "scenes.Level" .. level)
		local sceneLoader = SceneLoader:new()
		self.scene:moveToScene(sceneLoader)
		return true
	end

	for i=0, columns-1 do
		for j=0, rows-1 do
			local x = (i * width) + ((i+1) * spacing) + (width / 2)
			local y = (j * height) + ((j+1) * spacing) + (height / 2)

			local label = (columns * j + i) + 1

			local menuButton = button(label, x, y, width, height, menuSelected)

			self:addDisplayObject(menuButton)
		end
	end
end