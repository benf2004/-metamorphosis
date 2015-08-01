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
		self.statistics.timeRemaining = self.statistics.timeRemaining - 1
		self.statistics.wormLength = self.sceneLoader.head:lengthToEnd()
		lengthLabel.text = self.statistics.wormLength.." / "..currentScene.lengthObjective
		timerLabel.text = self.statistics.timeRemaining

		self.statusLabel = nil
		if self.statistics.wormLength >= currentScene.lengthObjective then
			self:win()
		elseif self.statistics.timeRemaining <= 0 then
			self:lose()
		elseif self.sceneLoader.head:lengthToEnd() < 3 then
			self:lose()
		elseif self.sceneLoader.head.sprite.y <= -250 or self.sceneLoader.head.sprite.x <= -250 then
			self:lose()
		end

		if self.statusLabel ~= nil then
			local resultLabel = label(self.statusLabel, self.sceneLoader.screenW/2, self.sceneLoader.screenH/2, 72, self.sceneLoader.view)
			self.sceneLoader:pause()
			self:addDisplayObject(resultLabel)
		end
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

function HUD:lose()
	self.sceneLoader.head:dieAll()
	self.statusLabel = "You Lose!"
	self.sceneLoader:pause()
end

function HUD:win()
	self.statusLabel = "You Win!"
	-- fireflies(0, 192)
	-- fireflies(256, 192)
	-- fireflies(512, 192)
	-- fireflies(768, 192)
	-- fireflies(1024, 192)
	-- fireflies(0, 576)
	-- fireflies(256, 576)
	-- fireflies(512, 576)
	-- fireflies(768, 576)
	-- fireflies(1024, 576)
	self.sceneLoader.head:burstWithHappiness()
end