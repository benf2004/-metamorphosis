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

--adding this for screen captureability
--comment out for production build
-- hit 'c' to capture your screen
local function cap(event)
    if event.keyName== "c" and event.phase == "up" then
        local screenCap = display.captureScreen( true )
        display.remove (screenCap)
        screenCap = nil
    end
    return true
end
 
Runtime:addEventListener("key",cap)
-- hit 'c' to capture your screen

--global current scene properties
currentScene = nil
gameName = "Squirmy Wormy"

singlePlayer = false

--global adManager
adManager = require "ads.AdManager"
iapManager = require "iap.IAPManager"

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
