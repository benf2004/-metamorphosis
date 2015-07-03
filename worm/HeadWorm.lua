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

function HeadWorm:initialize(x, y, physics, foodTruck)
	self:initializeSprite("wormhead")
	self.sprite.x, self.sprite.y = x, y
	self.type = "head"
	self.displayGroup = display.newGroup( )
	self.displayGroup:insert( self.sprite )

	self:initializePhysics(physics)
	self:initializeNeck()

	self.sprite.collision = onLocalCollision
	self.sprite:addEventListener( "collision", self.sprite )
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
	wormNode.sprite:removeSelf( )
	wormNode.sprite = nil

	self:digest(wormNode, self.displayGroup)

	--if prev then prev:moveToLocation(self.sprite.x, self.sprite.y) end
	--if next then next:moveToLocation(self.sprite.x, self.sprite.y) end
end

NeckWorm = BaseWorm:new()

function NeckWorm:initialize( )
	self:initializeSprite("neck")
	self.type = "neck"
end
