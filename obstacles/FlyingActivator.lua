require("obstacles.Activator")

FlyingActivator = Activator:new()

function FlyingActivator:initializePhysics(physics, wormHead, velocity, targetx, targety)
	if wormHead.sprite ~= nil and wormHead.sprite.x ~= nil then
		physics.addBody( self.sprite, { radius = (self.diameter / 2), density=self.density, friction=0.0, bounce=0.0})
		self.physics = physics
		self.sprite.name = "activator"

		local dx = (wormHead.sprite.x - self.sprite.x) * velocity
		local dy = (wormHead.sprite.y - self.sprite.y) * velocity

		if targetx ~= nil then 
			dx = (targetx - self.sprite.x) * velocity
			dy = (targety - self.sprite.y) * velocity
		end

		self.sprite.gravityScale = 0
		self.sprite:setLinearVelocity( dx, dy )
		self.sprite.angularVelocity = 360
	end
end

FlyingActivatorTruck = Base:new()

function FlyingActivatorTruck:initialize(config, sceneLoader)
	self.velocity = config.velocity or 0.75
	self.frequency = config.frequency or 2000
	self.sceneLoader = sceneLoader

	local closure = function() self:deliver() end
	self.deliveryTimer = self.sceneLoader:runTimer(self.frequency, closure, self, -1)
end

function FlyingActivatorTruck:deliver()
	local x = math.random(-200, display.contentWidth + 200)
	local y = math.random(-200, display.contentHeight + 200)

	local flyingActivator = FlyingActivator:new()
	flyingActivator:initializeSprite(x, y, self.sceneLoader)
	flyingActivator:initializePhysics(self.sceneLoader.physics, self.sceneLoader.head, self.velocity)
end

