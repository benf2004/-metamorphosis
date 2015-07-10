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
local targetJoint = nil

function HeadWorm:initialize(x, y, physics, foodTruck)
	self:initializeSprite("wormhead")
	self.sprite.x, self.sprite.y = x, y
	self.type = "head"
	self.displayGroup = display.newGroup( )
	self.displayGroup:insert( self.sprite )
	self.foodTruck = foodTruck

	self:initializePhysics(physics)
	self:initializeNeck()

	self.sprite.collision = onLocalCollision
	self.sprite:addEventListener( "collision", self.sprite )
end

function HeadWorm:initializeMotion()
	targetJoint = physics.newJoint( "touch", self.sprite, self.sprite.x, self.sprite.y )
	targetJoint.dampingRatio = 1
	targetJoint.freqency = 1
	targetJoint.maxForce = 3000
end

function HeadWorm:destroy()
	if targetJoint ~= nil and targetJoint.removeSelf ~= nil then
		targetJoint:removeSelf( )
	end
	targetJoint = nil

	if self.trailing ~= nil then
		self.trailing:destroy()
	end
	self:detachFromLeading()
	self:detachFromTrailing()
	self:removeSelf( )
	self.dead = true
end

function HeadWorm:moveToLocation(x, y)
	targetJoint:setTarget( x, y )
end

function HeadWorm:initializeNeck( )
	for i=1,neckLength do
		local neck = NeckWorm:new()
		neck:initialize( )
		neck:initializePhysics(self.physics)
		self:attach(neck, self.displayGroup)
	end
end

function HeadWorm:consume( wormNode )
	local prev = wormNode.leading
	local next = wormNode.trailing

	wormNode:detachFromLeading()
	wormNode:detachFromTrailing()

	--move the node offscreen so that it is hidden during digestion
	if wormNode.sprite ~= nil then
		wormNode:removeSelf( )
		wormNode.sprite = nil
	end

	self.foodTruck:consumeFood(wormNode)

	self:digest(wormNode, self.displayGroup, self.foodTruck)
end

NeckWorm = BaseWorm:new()

function NeckWorm:initialize( )
	self:initializeSprite("neck")
	self.type = "neck"
end
