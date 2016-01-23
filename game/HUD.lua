require("Base")
require("effects.Effects")
require("game.Colors")

HUD  = Base:new()

function HUD:initialize(sceneLoader)
	self.displayGroup = display.newGroup()

	self.sceneLoader = sceneLoader

	-- local restartClosure = function() self.sceneLoader:restart() end
	-- local reset = button("Reset", (self.sceneLoader.screenW - 50), 25, 100, 50, restartClosure)
	-- self:addDisplayObject(reset)

	-- local menuClosure = function() self.sceneLoader:menu() end
	-- local menu = button("Menu", (self.sceneLoader.screenW - 160), 25, 100, 50, menuClosure)
	-- self:addDisplayObject(menu)

	local restartButton = restartButton((self.sceneLoader.screenW - 40), 25, 60, 50, self.sceneLoader)
	self:addDisplayObject(restartButton)

	local homeButton = homeButton((self.sceneLoader.screenW - 110), 25, 60, 50, self.sceneLoader)
	self:addDisplayObject(homeButton)

	self.statistics = {}
	self.statistics.wormLength = self.sceneLoader.head:lengthToEnd()
	self.statistics.timeRemaining = currentScene.secondsAllowed
	self.startingStars = levelStars(currentLevel)

	-- local lengthLabel = label(tostring(self.statistics.wormLength.." / "..currentScene.lengthObjective), 50, 25, "Desyrel", 30, self.view)
	-- self:addDisplayObject(lengthLabel)
	-- local timerLabel = label(tostring(self.statistics.timeRemaining), 160, 25, "Desyrel", 30, self.view)
	-- self:addDisplayObject(timerLabel)

	local objBox = objectiveBox((self.sceneLoader.screenW - 345), 25, 145, 50, "Desyrel", 25, self.statistics.wormLength, currentScene.lengthObjective, self.sceneLoader.defaultSkin)
	self:addDisplayObject(objBox)

	local timeBox = timeRemainingBox((self.sceneLoader.screenW - 205), 25, 100, 50, "Desyrel", 25, self.statistics.timeRemaining)
	self:addDisplayObject(timeBox)

	self.updateHud = function ()
		self.statistics.timeRemaining = self.statistics.timeRemaining - 1

		if (self.statistics.timeRemaining <= 5 and self.statistics.timeRemaining >= 1) then
			self.sceneLoader:playSound("ding")
			local unskin = function() 
				self.sceneLoader.head:skinAll()				
			end

			self.sceneLoader.head:skinAll(self.sceneLoader.head.frameIndex.red)
			self.sceneLoader:runTimer(150, unskin, self.sceneLoader.head, 1)
		end

		self.statistics.wormLength = self.sceneLoader.head:lengthToEnd()
		if (self.statistics.wormLength > currentScene.lengthObjective) then
			self.statistics.wormLength = currentScene.lengthObjective
		end
		self.statistics.maximumWormLength = math.max(self.statistics.wormLength or (self.statistics.maximumWormLength or 0))
		-- lengthLabel.text = self.statistics.wormLength.." / "..currentScene.lengthObjective
		objBox.setLength(self.statistics.wormLength)
		-- timerLabel.text = self.statistics.timeRemaining
		timeBox.setTime(self.statistics.timeRemaining)

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
			local resultLabel = label(self.statusLabel, self.sceneLoader.screenW/2, self.sceneLoader.screenH/2, "Desyrel", 72, self.sceneLoader.view)
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

function HUD:lose(message)
	self.sceneLoader.head:unshieldAll()
	self.sceneLoader:playSound("gong")
	self.sceneLoader.head:dieAll()
	self.statusLabel = message
	self.sceneLoader:pause()
	self:endLevel(false)
end

function HUD:win()
	self.sceneLoader.head:unshieldAll()
	self.sceneLoader:playSound("happy")
	self.statusLabel = "You Win!"
	self.sceneLoader.head:burstWithHappiness()
	self:endLevel(true)
end

function HUD:endLevel(completed)
	self.sceneLoader:showAdvertisement()
	endLevel(currentLevel, completed, self.statistics.timeRemaining, self.statistics.maximumWormLength, self.startingStars)
end