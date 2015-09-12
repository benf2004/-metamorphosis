require("obstacles.Activator")

FlyingActivator = Activator:new()

function FlyingActivator:initializePhysics(physics, wormHead, velocity)
	physics.addBody( self.sprite, { radius = (self.diameter / 2), density=self.density, friction=0.0, bounce=0.0})
	self.physics = physics
	self.sprite.name = "activator"

	local dx = (wormHead.sprite.x - self.sprite.x) * velocity
	local dy = (wormHead.sprite.y - self.sprite.y) * velocity

	self.sprite.gravityScale = 0
	self.sprite:setLinearVelocity( dx, dy )
end

FlyingActivatorTruck = Base:new()

function FlyingActivatorTruck:initialize(level, sceneLoader)
	self.velocity = level.flyingActivators.velocity
	self.frequency = level.flyingActivators.frequency
	self.sceneLoader = sceneLoader

	local closure = function() self:deliver() end
	self.deliveryTimer = timer.performWithDelay( self.frequency, closure, -1 )
	self.sceneLoader:addTimer(self.deliveryTimer)
end

function FlyingActivatorTruck:deliver()
	local x = math.random(-200, display.contentWidth + 200)
	local y = math.random(-200, display.contentHeight + 200)

	local flyingActivator = FlyingActivator:new()
	flyingActivator:initializeSprite(x, y, self.sceneLoader)
	flyingActivator:initializePhysics(self.sceneLoader.physics, self.sceneLoader.head, self.velocity)
end

