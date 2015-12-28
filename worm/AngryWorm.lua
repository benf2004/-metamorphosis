require("worm.HeadWorm")
require("worm.FireTongue")

AngryWorm = HeadWorm:new()

function AngryWorm:initializeAnimatedSprite(imageSheet, sceneLoader)
	self.blinkSequence = {
        name = "blink",
        start = 3,
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

function AngryWorm:initializeMotion(speed, targetWorm)
	self.targetWorm = targetWorm
	if speed > 29 then speed = 29 end
	if speed < 0 then speed = 0 end
	self.speed = (30 - speed)

	self.targetFood = nil
	self.targetTimer = nil
	self.moveTimer = nil

	local target = function() 
		self.targetFood = self.targetWorm:tail() 
	end

	local move = function()
		if self.targetFood ~= nil and self.targetFood.sprite ~= nil then
			self:moveToLocation(self.targetFood.sprite.x, self.targetFood.sprite.y)
		end
	end

	local targetTimerWait = math.random(2000, 3000)
	self.targetTimer = self.sceneLoader:runTimer(targetTimerWait, target, {self.targetFood, self.targetWorm}, -1)
	self.moveTimer = self.sceneLoader:runTimer(100, move, self.targetFood, -1)
end

function AngryWorm:initializeEffect()
	local angryWormFireTongues = self.sceneLoader.currentScene.angryWormFireTongues or false
	if angryWormFireTongues then 
		self.fireTongue = FireTongue:new()
		self.fireTongue:initialize( self.sprite.x, self.sprite.y, self.sceneLoader)
		self.fireTongue:on()
		self.fireTongue:lashIn()
		local synchronizeTongue = function()
			if self.sprite then
				self.fireTongue:pairWithWorm(self.sprite)
			end
		end
		self.sceneLoader:addGlobalEventListener( "enterFrame", synchronizeTongue )
	end

	local blinkTimeSwitch = function()
    	local timeScale = math.random(5, 23) * .1
    	self.sprite.timeScale = timeScale
    end
    local blinkTimer = self.sceneLoader:runTimer(1000, blinkTimeSwitch, self.sprite, -1)
	self.sprite:play()
end

function AngryWorm:moveToLocation(x, y)
	if (x ~= nil and y ~= nil and self.sprite ~= nil and self.sprite.x ~= nil and self.sprite.y ~= nil) then 
		local dt = self.speed / display.fps
		local dx = x - self.sprite.x
		local dy = y - self.sprite.y
		self.sprite:setLinearVelocity( dx/dt, dy/dt )
	end
end