require("worm.HeadWorm")

MenuWorm = HeadWorm:new()

function MenuWorm:initializeMotion(speed)
	if speed > 29 then speed = 29 end
	if speed < 0 then speed = 0 end
	self.speed = (30 - speed)

	self.adHeight = 100
	if adsDisabled() then
		self.adHeight = 0
	end

	local screenW = self.sceneLoader.screenW
	local screenH = self.sceneLoader.screenH - self.adHeight

	local offsetX = screenW * 0.0675
	local offsetY = screenH * 0.0675

	local targetIndex = 2

	self.targets = {
		{offsetX, offsetY},
		{screenW - offsetX, offsetY},
		{screenW - offsetX, screenH - offsetY},
		{offsetX, screenH - offsetY}
	}

	self.target = self.targets[targetIndex]
	self.targetTimer = nil
	self.moveTimer = nil

	local target = function() 
		targetIndex = targetIndex + 1
		if targetIndex > 4 then targetIndex = 1 end
		self.target = self.targets[targetIndex]
	end

	local move = function()
		self:moveToLocation(self.target[1], self.target[2])
	end

	local targetTimerWait = 2500
	self.targetTimerWait = self.sceneLoader:runTimer(targetTimerWait, target, self.targets, -1)

	local firstMove = function()
		self.moveTimer = self.sceneLoader:runTimer(100, move, self.target, -1)
	end

	self.firstMoveTimer = self.sceneLoader:runTimer(1500, firstMove)
end

function MenuWorm:destroy()
	if self.trailing ~= nil then
		self.trailing:destroy()
	end
	self:detachFromLeading()
	self:detachFromTrailing()
	self:removeSelf( )
	self.dead = true
end

function MenuWorm:moveToLocation(x, y)
	if (x ~= nil and y ~= nil and self.sprite ~= nil and self.sprite.x ~= nil and self.sprite.y ~= nil) then 
		local dt = self.speed / display.fps
		local dx = x - self.sprite.x
		local dy = y - self.sprite.y
		self.sprite:setLinearVelocity( dx/dt, dy/dt )
	end
end