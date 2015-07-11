require("worm.HeadWorm")

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
end

function AngryWorm:destroy()
	if self.trailing ~= nil then
		self.trailing:destroy()
	end
	self:detachFromLeading()
	self:detachFromTrailing()
	self:removeSelf( )
	self.dead = true
end

function AngryWorm:moveToLocation(x, y)
	if (x ~= nil and y ~= nil and self.sprite ~= nil and self.sprite.x ~= nil and self.sprite.y ~= nil) then 
		local dt = self.speed / display.fps
		local dx = x - self.sprite.x
		local dy = y - self.sprite.y
		self.sprite:setLinearVelocity( dx/dt, dy/dt )
	end
end

function AngryWorm:endAnger()
	if self.targetTimer ~= nil then
		timer.cancel( self.targetTimer )
	end 

	if self.moveTimer ~= nil then
		timer.cancel( self.moveTimer )
	end
end