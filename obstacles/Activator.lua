require("Base")

Activator  = Base:new({diameter=32})

local function onLocalCollision(self, event)
	if event.phase == "began" and event.other.obj then
		local otherType = event.other.obj.type or "none"
		if otherType == "neck" or otherType == "head" then
			return true
		elseif otherType == "body" then
			local closure = function() event.other.obj:activate() end
			timer.performWithDelay( 10, closure)
			return true
		end
	end
end

function Activator:initializeSprite(x, y)
	print("initializing"..x..","..y)
	self.sprite = display.newImageRect( "images/activator.png", self.diameter, self.diameter )
	self.sprite.x, self.sprite.y = x, y
	self.sprite.obj = self

	self.sprite.collision = onLocalCollision
	self.sprite:addEventListener( "collision", self.sprite )
end

function Activator:initializePhysics(physics)
	physics.addBody( self.sprite, "static", { radius = (self.diameter / 2), density=self.density, friction=0.0, bounce=0.0})
	self.physics = physics
	self.sprite.name = "activator"
end