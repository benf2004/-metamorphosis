require("worm.HeadWorm")
require("worm.FireTongue")

AngryWorm = HeadWorm:new()

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
	self.targetTimer = timer.performWithDelay( targetTimerWait, target , -1 )
	self.moveTimer = timer.performWithDelay( 100, move, -1 )
	self.sceneLoader:addTimer(self.targetTimer)
	self.sceneLoader:addTimer(self.moveTimer)
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
end

function AngryWorm:moveToLocation(x, y)
	if (x ~= nil and y ~= nil and self.sprite ~= nil and self.sprite.x ~= nil and self.sprite.y ~= nil) then 
		local dt = self.speed / display.fps
		local dx = x - self.sprite.x
		local dy = y - self.sprite.y
		self.sprite:setLinearVelocity( dx/dt, dy/dt )
	end
end