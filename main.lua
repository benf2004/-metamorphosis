-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- require("core.MemoryMonitor")

-- local function unhandledErrorListener( event )
-- 	print(event.errorMessage)
-- 	print(event.stackTrace)
--     return false
-- end

-- Runtime:addEventListener("unhandledError", unhandledErrorListener)

--global current scene properties
currentScene = nil

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"

-- load menu screen
require("core.Menu")
local options = {
	params = {
		sceneLoader = Menu:new()
	}
}
composer.gotoScene( "core.CoreScene", options )