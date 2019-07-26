require("worm.BaseWorm")

local function onLocalCollision(self, event)
	if event.phase == "began" and event.other.obj then
		local otherType = event.other.obj.type or "none"
		if otherType == "neck" then
			return true
		elseif otherType == "body" then
			if event.other.obj:head().type == "head" then
				local closure = function() 
					event.other.obj:activate() 
				end
				self.obj.sceneLoader:runTimer(10, closure, event.other.obj)
			else
				local closure = function() 
					self.obj:consume(event.other.obj) 
				end
				self.obj.sceneLoader:runTimer(10, closure, {self.obj, event.other.obj})
			end
			return true
		end
	end
end

HeadWorm = BaseWorm:new()

local neckLength = 3

function HeadWorm:initializeAnimatedSprite(imageSheet, sceneLoader)
	local sheetOptions = {
		width = 32,
		height = 32,
		numFrames = 2
	}
	local blinkSheet = graphics.newImageSheet( "images/"..imageSheet..".png", sheetOptions )
	local blinkSequence = {
        name = "blink",
        start = 1,
        count = 2,
        time = 4000,
        loopCount = 0,
        loopDirection = "forward"
    }

    self.sprite = display.newSprite( blinkSheet, blinkSequence )

    -- self.sprite = display.newImageRect( "images/"..textureName..".png", self.diameter, self.diameter )
	-- self.sprite = display.newImageRect( "images/wormhead.png", self.diameter, self.diameter )
	self.sceneLoader = sceneLoader
	self.sceneLoader:addBaseObject(self)
	self.sceneLoader:addDisplayObject(self.sprite)
	self.density = 1
	self.sprite.obj = self
	self.sprite.xF, self.sprite.xY = 0, 0
end

function HeadWorm:initialize(x, y, physics, foodTruck, sceneLoader, oids)
	self:initializeAnimatedSprite("BlinkSheet", sceneLoader)
	self.sprite.x, self.sprite.y = x, y
	self.type = "head"
	self.sprite.name = "head"

	if oids ~= nil then
		self.oid = oids[1]
	end

	self.foodTruck = foodTruck
	self:initializePhysics(physics)
	self:initializeNeck(oids)

	self.sprite.collision = onLocalCollision
	self.sprite:addEventListener( "collision", self.sprite )
	
	self:initializeEffect()
	self:initializeJoint()
end

function HeadWorm:initializeEffect()
	local blinkTimeSwitch = function()
    	local timeScale = math.random(5, 23) * .1
    	self.sprite.timeScale = timeScale
    end
    local blinkTimer = self.sceneLoader:runTimer(1000, blinkTimeSwitch, self.sprite, -1)
    if self.sprite ~= nil and self.sprite.play ~= nil then
		self.sprite:play()
	end
end

function HeadWorm:setSkin(frame)
end

function HeadWorm:pause()
	if self.sprite ~= nil and self.sprite.pause ~= nil then
		self.sprite:pause()
	end
end

function HeadWorm:die(sound)
	if not self.shielded then 
		self:death(sound)
	end
end

function HeadWorm:dieAll()
	if not self.shielded then
		if self:trailing() ~= nil then
			self:trailing():dieAll()
		end
		self:die("squak")
	end
end

function HeadWorm:activate()
	if not self.shielded then
		self:dieAll()
	end
end

function HeadWorm:initializeJoint()
	self.targetJoint = physics.newJoint( "touch", self.sprite, self.sprite.x, self.sprite.y )
	self.targetJoint.dampingRatio = 1
	self.targetJoint.freqency = 1
	self.targetJoint.maxForce = 3000
end

function HeadWorm:initializeMotion()
end

function HeadWorm:xy()
	if (self.sprite and self.sprite.x) then
		return self.sprite.x, self.sprite.y
	else 
		return 0, 0
	end
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

function HeadWorm:getTarget()
	if self.targetJoint and self.targetJoint.getTarget then 
		return self.targetJoint:getTarget() 
	else
		return nil
	end
end

function HeadWorm:initializeNeck( oids )
	for i=1,neckLength do
		local neck = NeckWorm:new()
		if oids ~= nil then
			neck.oid = oids[i+1]
		end
		self:attach(neck)
	end
end

function HeadWorm:consume( wormNode )
	wormNode.consumed = true

	local prev = wormNode.leading
	local next = wormNode.trailing

	wormNode:detachFromLeading()
	wormNode:detachFromTrailing()

	wormNode.sceneLoader:removeDisplayObject(wormNode.sprite)
	wormNode.sceneLoader:consumeFood(food)
	FoodTruck:consumeFood(wormNode)
	-- self.sceneLoader:playSound("click")

	self:digest(wormNode, self.displayGroup, self.foodTruck)
end

NeckWorm = BaseWorm:new()

NeckWorm.wormSequence = {
	name = "neck",
	frames = {7},
	loopCount = 1
}

function NeckWorm:setSkin(skin)
end

function NeckWorm:initialize( physics, sceneLoader )
	self:initializeSprite(sceneLoader)
	self.type = "neck"
	self.sprite.name = "neck"
	self:initializePhysics( physics )
end

function NeckWorm:activate()
	if self.shield == nil then
		self:head():dieAll()
	end
end
