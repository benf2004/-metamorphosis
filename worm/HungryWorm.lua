require("worm.HeadWorm")

HungryWorm = HeadWorm:new()

function HungryWorm:initializeAnimatedSprite(imageSheet, sceneLoader)
	self.blinkSequence = {
        name = "blink",
        start = 5,
        count = 2,
        time = 4000,
        loopCount = 0,
        loopDirection = "forward"
    }

    self.sprite = display.newSprite( self.wormSheet, self.blinkSequence )

    -- self.sprite = display.newImageRect( "images/"..textureName..".png", self.diameter, self.diameter )
	-- self.sprite = display.newImageRect( "images/wormhead.png", self.diameter, self.diameter )
	self.sceneLoader = sceneLoader
	self.sceneLoader:addDisplayObject(self.sprite)
	self.density = 1
	self.sprite.obj = self
	self.sprite.xF, self.sprite.xY = 0, 0
end

function HungryWorm:initializeMotion(speed)
	if speed > 29 then speed = 29 end
	if speed < 0 then speed = 0 end
	self.speed = (30 - speed)

	self.targetFood = nil
	self.targetTimer = nil
	self.moveTimer = nil

	local target = function() 
		self.targetFood = self.foodTruck:randomFood()
		local x,y = 0,0
		if self.targetFood ~= nil and self.targetFood.sprite ~= nil then
			self.targetX,self.targetY = self.targetFood.sprite.x, self.targetFood.sprite.y
		else
			self.targetX = math.random(0, self.sceneLoader.screenW)
			self.targetY = math.random(0, self.sceneLoader.screenH)
		end
	end

	local move = function()
		if self.targetX ~= nil and self.targetY ~= nil then
			self:moveToLocation(self.targetX, self.targetY)
		end
	end

	local targetTimerWait = math.random(2000, 3000)
	self.targetTimer = self.sceneLoader:runTimer(targetTimerWait, target, self.foodTruck, -1)
	self.moveTimer = self.sceneLoader:runTimer(100, move, {}, -1)
end

function HungryWorm:destroy()
	if self.trailing ~= nil then
		self.trailing:destroy()
	end
	self:detachFromLeading()
	self:detachFromTrailing()
	self:removeSelf( )
	self.dead = true
end

function HungryWorm:moveToLocation(x, y)
	if (x ~= nil and y ~= nil and self.sprite ~= nil and self.sprite.x ~= nil and self.sprite.y ~= nil) then 
		local dt = self.speed / display.fps
		local dx = x - self.sprite.x
		local dy = y - self.sprite.y
		self.sprite:setLinearVelocity( dx/dt, dy/dt )
	end
end