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
	self.sceneLoader:addDisplayObject(self.sprite)
	self.density = 1
	self.sprite.obj = self
	self.sprite.xF, self.sprite.xY = 0, 0
end

function HeadWorm:initialize(x, y, physics, foodTruck, sceneLoader)
	-- self:initializeSprite("wormhead", sceneLoader)
	self:initializeAnimatedSprite("BlinkSheet", sceneLoader)
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
	local blinkTimeSwitch = function()
    	local timeScale = math.random(5, 23) * .1
    	self.sprite.timeScale = timeScale
    end
    local blinkTimer = self.sceneLoader:runTimer(1000, blinkTimeSwitch, self.sprite, -1)
	self.sprite:play()
end

function HeadWorm:pause()
	if self.sprite ~= nil and self.sprite.pause ~= nil then
		self.sprite:pause()
	end
end

function HeadWorm:die(sound)
	if self.sprite ~= nil and self.sprite.removeEventListener ~= nil then
		self.sprite:removeEventListener( "collision", self.sprite )
	end
	self:death(sound)
end

function HeadWorm:dieAll()
	if self:trailing() ~= nil then
		self:trailing():dieAll()
	end
	self:die("squak")
end

function HeadWorm:activate()
	if self.shield == nil then
		self:dieAll()
	end
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
	self.sceneLoader:playSound("click")

	self:digest(wormNode, self.displayGroup, self.foodTruck)
end

NeckWorm = BaseWorm:new()

NeckWorm.wormSequence = {
	name = "Base",
	frames = {7},
	loopCount = 1
}

function NeckWorm:initialize( physics, sceneLoader )
	self:initializeSprite("neck", sceneLoader)
	self.type = "neck"
	self:initializePhysics( physics )
end

function NeckWorm:activate()
	if self.shield == nil then
		self:head():dieAll()
	end
end
