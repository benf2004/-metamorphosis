require("Base")
require("effects.Effects")
require("game.Colors")

HUD  = Base:new()

function HUD:initialize(sceneLoader)
	self.displayGroup = display.newGroup()

	self.sceneLoader = sceneLoader
	local restartClosure = function() self.sceneLoader:restart() end
	local reset = button("Reset", (self.sceneLoader.screenW - 50), 25, 100, 50, restartClosure)
	self:addDisplayObject(reset)

	local menuClosure = function() self.sceneLoader:menu() end
	local menu = button("Menu", (self.sceneLoader.screenW - 160), 25, 100, 50, menuClosure)
	self:addDisplayObject(menu)

	self.statistics = {}
	self.statistics.wormLength = self.sceneLoader.head:lengthToEnd()
	self.statistics.timeRemaining = currentScene.secondsAllowed

	local lengthLabel = label(tostring(self.statistics.wormLength.." / "..currentScene.lengthObjective), 50, 25, 18, self.view)
	self:addDisplayObject(lengthLabel)
	local timerLabel = label(tostring(self.statistics.timeRemaining), 160, 25, 18, self.view)
	self:addDisplayObject(timerLabel)

	self.updateHud = function ()
		print("updating hud")
		self.statistics.timeRemaining = self.statistics.timeRemaining - 1
		self.statistics.wormLength = self.sceneLoader.head:lengthToEnd()
		if (self.statistics.wormLength > currentScene.lengthObjective) then
			self.statistics.wormLength = currentScene.lengthObjective
		end
		self.statistics.maximumWormLength = math.max(self.statistics.wormLength or (self.statistics.maximumWormLength or 0))
		lengthLabel.text = self.statistics.wormLength.." / "..currentScene.lengthObjective
		timerLabel.text = self.statistics.timeRemaining

		self.statusLabel = nil
		if self.statistics.wormLength >= currentScene.lengthObjective then
			self:win()
		elseif self.statistics.timeRemaining <= 0 then
			self:lose("Times up!")
		elseif self.sceneLoader.head:lengthToEnd() < 3 then
			self:lose("You lose!")
		elseif self.sceneLoader.head.sprite.y <= -250 or self.sceneLoader.head.sprite.x <= -250 then
			self:lose("You lose!")
		end

		if self.statusLabel ~= nil then
			local resultLabel = label(self.statusLabel, self.sceneLoader.screenW/2, self.sceneLoader.screenH/2, 72, self.sceneLoader.view)
			print("Pausing the game in HUD.")
			self.sceneLoader:pause()
			print("Adding the message to display.")
			self:addDisplayObject(resultLabel)
			print("Successfully added message to display.")
		end
		print("done updating hud")
	end
end

function HUD:addDisplayObject(displayObject)
	self.displayGroup:insert(displayObject)
end

function HUD:removeDisplayObject(displayObject)
	if displayObject.removeSelf ~= nil then 
		displayObject:removeSelf( )
	end
	displayObject = nil
end

function HUD:removeAllDisplayObjects()
	display.remove(self.displayGroup)
	self.displayGroup = nil
end

function HUD:lose(message)
	print("Starting lose sequence.")
	print("Playing sound.")
	self.sceneLoader:playSound("gong")
	print("Killing the worm")
	self.sceneLoader.head:dieAll()
	print("Setting the status message")
	self.statusLabel = message
	print("Pausing the game in lose.")
	self.sceneLoader:pause()
	print("Ending the level")
	self:endLevel(false)
	print("Lose cycle is done.")
end

function HUD:win()
	print("Starting win sequence")
	print("Playing happy sound")
	self.sceneLoader:playSound("happy")
	print("Setting the status message")
	self.statusLabel = "You Win!"
	print("Bursting the worm with happiness")
	self.sceneLoader.head:burstWithHappiness()
	print("Ending the level")
	self:endLevel(true)
	print("Win cycle is done")
end

function HUD:endLevel(completed)
	print("Going to save game state")
	endLevel(currentLevel, completed, self.statistics.timeRemaining, self.statistics.maximumWormLength)
	print("Done saving game state")
end