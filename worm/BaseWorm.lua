require("Base")
require("effects.Effects")

BaseWorm  = Base:new({diameter=32})

function BaseWorm:initializeSprite(textureName)
	self.sprite = display.newImageRect( "images/"..textureName..".png", self.diameter, self.diameter )
	self.sprite.obj = self
end

function BaseWorm:initializePhysics(physics)
	physics.addBody( self.sprite, { radius = (self.diameter / 2), density=1000, friction=0.3, bounce=0.3})
	self.physics = physics
	self.sprite.gravityScale = 0
	self.sprite.linearDamping = 4
	self.sprite.angularDamping = 2
	self.sprite.name = "baseworm"
end

function BaseWorm:moveToLocation(x, y)
	local dt = 2.0 / display.fps
	local dx = x - self.sprite.x
	local dy = y - self.sprite.y
	self.sprite:setLinearVelocity( dx/dt, dy/dt )
end

function BaseWorm:isHead()
	return self.leading == nil
end

function BaseWorm:isTail()
	return self.trailing == nil
end

function BaseWorm:head()
	if self:isHead() then
		return self
	else
		return self.leading:head()
	end
end

function BaseWorm:tail()
	if self:isTail() then
		return self
	else
		return self.trailing:tail()
	end
end

function BaseWorm:attach(next, displayGroup)
	if self:isTail() and self ~= next then
		if next.sprite == nil then
			next:initialize( self.physics )
		end
		if next.sprite.name ~= "gravityworm" then
			next:affectedByGravity(false)
		else
			next:affectedByGravity(true)
		end
		next.sprite.x = self.sprite.x - next.sprite.width / 2
		next.sprite.y = self.sprite.y
		local joint = self.physics.newJoint( "pivot", self.sprite, next.sprite, next.sprite.x, next.sprite.y )
		self.rearwardJoint = joint
		next.forwardJoint = joint
		self.trailing = next
		next.leading = self
		displayGroup:insert(next.sprite)
		next.sprite:toBack( )
	else
		if self ~= next then
	 		self.trailing:attach(next, displayGroup)
	 	end
	end
end

function BaseWorm:detachFromLeading()
	if self.leading ~= nil then
		self.forwardJoint:removeSelf( )
		self.forwardJoint = nil
		self.leading.rearwardJoint = nil
		self.leading.trailing = nil
		self.leading = nil
		self:affectedByGravity(true)
	end
end

function BaseWorm:detachFromTrailing() 
	if self.trailing ~= nil then
		self.rearwardJoint:removeSelf( )
		self.rearwardJoint = nil
		self.trailing.forwardJoint = nil
		self.trailing.leading = nil
		self.trailing = nil
	end
end

function BaseWorm:die()
	self:detachFromLeading()
	self:detachFromTrailing()
	local locationx, locationy = self.sprite.x, self.sprite.y
	explode(locationx, locationy)
	self.sprite:removeSelf( )
	self.dead = true
end

function BaseWorm:destroy()
	if self.trailing ~= nil then
		self.trailing:destroy()
	end
	self:detachFromLeading()
	self:detachFromTrailing()
	self.sprite:removeSelf( )
	self.dead = true
end

function BaseWorm:lengthToEnd()
	if self.trailing ~= nil then
		return self.trailing:lengthToEnd() + 1
	else
		return 1
	end
end

function BaseWorm:activate()
end

function BaseWorm:digest(wormNode, displayGroup)
	local eat = function()
		if self.trailing == nil then
			if self.sprite.x == nil then
				timer.performWithDelay( 5, eat )
			else 
				self:attach(wormNode, displayGroup)
			end
		else
			self.trailing:digest(wormNode, displayGroup)
		end
	end
	local shrink = function()
		if self.sprite then 
			self.sprite.width = self.diameter
			self.sprite.height = self.diameter
			timer.performWithDelay (5, eat)
		end
	end
	local grow = function()
		if self.sprite then
			self.sprite.width = self.diameter * 1.3
			self.sprite.height = self.diameter * 1.3
			timer.performWithDelay( 50, shrink )
		end
	end
	grow()
end

function BaseWorm:affectedByGravity(affected)
	if affected then
		self.sprite.gravityScale = 1.0
	else
		self.sprite.gravityScale = 0.0
	end
	if self.trailing ~= nil then
		self.trailing:affectedByGravity(affected)
	end
end