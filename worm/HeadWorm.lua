require("worm.BaseWorm")

local function onLocalCollision(self, event)
	if event.phase == "began" and event.other.obj then
		local otherType = event.other.obj.type or "none"
		if otherType == "neck" then
			return true
		elseif otherType == "body" then
			if event.other.obj:head().type == "head" then
				local closure = function() event.other.obj:activate() end
				timer.performWithDelay( 10, closure)
			else
				local closure = function() self.obj:consume(event.other.obj) end
				timer.performWithDelay( 10, closure)
			end
			return true
		end
	end
end

HeadWorm = BaseWorm:new()

local neckLength = 3

function HeadWorm:initialize(x, y, physics, foodTruck, sceneLoader)
	self:initializeSprite("wormhead", sceneLoader)
	self.sprite.x, self.sprite.y = x, y
	self.type = "head"

	self.foodTruck = foodTruck
	self:initializePhysics(physics)
	self:initializeNeck()

	self.sprite.collision = onLocalCollision
	self.sprite:addEventListener( "collision", self.sprite )
	self:initializeEffect()
end

function HeadWorm:initializeEffect()
end

function HeadWorm:pause()
end

function HeadWorm:initializeMotion()
	self.targetJoint = physics.newJoint( "touch", self.sprite, self.sprite.x, self.sprite.y )
	self.targetJoint.dampingRatio = 1
	self.targetJoint.freqency = 1
	self.targetJoint.maxForce = 3000
end

function HeadWorm:destroy()
	if self.targetJoint ~= nil and self.targetJoint.removeSelf ~= nil then
		self.targetJoint:removeSelf( )
	end
	self.targetJoint = nil

	if self.trailing ~= nil then
		self.trailing:destroy()
	end
	self:detachFromLeading()
	self:detachFromTrailing()
	self:removeSelf( )
	self.displayGroup:removeSelf()
	self.dead = true
end

function HeadWorm:moveToLocation(x, y)
	if self.targetJoint and self.targetJoint.setTarget then 
		self.targetJoint:setTarget( x, y ) 
	end
end

function HeadWorm:initializeNeck( )
	for i=1,neckLength do
		local neck = NeckWorm:new()
		self:attach(neck)
	end
end

function HeadWorm:consume( wormNode )
	local prev = wormNode.leading
	local next = wormNode.trailing

	wormNode:detachFromLeading()
	wormNode:detachFromTrailing()

	wormNode.sceneLoader:removeDisplayObject(wormNode.sprite)

	self.foodTruck:consumeFood(wormNode)

	self:digest(wormNode, self.displayGroup, self.foodTruck)
end

NeckWorm = BaseWorm:new()

function NeckWorm:initialize( physics, sceneLoader )
	self:initializeSprite("neck", sceneLoader)
	self.type = "neck"
	self:initializePhysics( physics )
end
