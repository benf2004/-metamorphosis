require("core.SceneBase")
require("game.UI")
require("game.Colors")

Menu = SceneBase:new()

function Menu:load()
	self.columns = 3
	self.rows = 3

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
		self.scene:moveToScene("core.CoreScene")
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

--------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event ) 
end

function scene:show( event )
    local phase = event.phase
    
    if ( phase == "will" ) then
    	if self.sceneLoader == nil then
    		self.sceneLoader = Menu:new()
    		self.sceneLoader:initialize( self )
    	end
    	self.sceneLoader:load()
    elseif ( phase == "did" ) then
    	self.sceneLoader:start()
    end
end

function scene:hide( event )
    local phase = event.phase
    
    if ( phase == "will" ) then
    	composer.removeScene( "core.CoreScene" )
    	self.sceneLoader:pause()
    elseif ( phase == "did" ) then
    	self.sceneLoader:unload()
    	self.sceneLoader = nil
    end
end

function scene:destroy( event )
 	if self.sceneLoader ~= nil then
 		self.sceneLoader:pause()
 		self.sceneLoader:unload()
 		self.sceneLoader = nil
 	end   
end

function scene:moveToScene( sceneName )
	composer.gotoScene( sceneName, "fade", 250 )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene