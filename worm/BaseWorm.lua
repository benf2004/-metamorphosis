require("Base")
require("effects.Effects")

BaseWorm  = Base:new({diameter=32})

function BaseWorm:initializeSprite(textureName, sceneLoader)
	self.sprite = display.newImageRect( "images/"..textureName..".png", self.diameter, self.diameter )
	self.sceneLoader = sceneLoader
	self.sceneLoader:addDisplayObject(self.sprite)
	self.density = 1
	self.sprite.obj = self
	self.sprite:addEventListener( "touch", self.sceneLoader.touchListener )
end

function BaseWorm:initializePhysics(physics)
	physics.addBody( self.sprite, { radius = (self.diameter / 2), density=self.density, friction=0.0, bounce=0.0})
	self.physics = physics
	self.sprite.gravityScale = 0
	self.sprite.linearDamping = 4
	self.sprite.angularDamping = 2
	self.sprite.name = "baseworm"
	self:postInitializePhysics(physics)
end

function BaseWorm:postInitializePhysics(physics)
end

function BaseWorm:moveToLocation(x, y)
	if (x ~= nil and y ~= nil and self.sprite ~= nil and self.sprite.x ~= nil and self.sprite.y ~= nil) then 
		local dt = 2.0 / display.fps
		local dx = x - self.sprite.x
		local dy = y - self.sprite.y
		self.sprite:setLinearVelocity( dx/dt, dy/dt )
	end
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

function BaseWorm:attach(next, x, y)
	if self:isTail() and self ~= next then
		next.density = self.density * 0.9
		next:initialize( self.physics, self.sceneLoader )
		if next.sprite.name ~= "gravityworm" then
			next:affectedByGravity(false)
		else
			next:affectedByGravity(true)
		end
		-- if (x == nil) then x = self.sprite.x - next.sprite.width / 2 end
		-- if (y == nil) then y = self.sprite.y end

		next.sprite.x = self.sprite.x - next.sprite.width / 2
		next.sprite.y = self.sprite.y

		local joint = self.physics.newJoint( "pivot", self.sprite, next.sprite, next.sprite.x, next.sprite.y )
		self.rearwardJoint = joint
		next.forwardJoint = joint
		self.trailing = next
		next.leading = self
		next:reorderZ()
		next:setShield(self.shielded)
	else
		if self ~= next then
	 		self.trailing:attach(next, x, y)
	 	end
	end
end

function BaseWorm:replace(replacement)
	local previous = self.leading
	local trailing = self.trailing

	self:detachFromLeading()
	self:detachFromTrailing()
	self.sceneLoader:removeDisplayObject(self.sprite)

	if previous ~= nil then
		local x, y = self.sprite.x, self.sprite.y
		previous:attach(replacement, x, y)
	end

	if trailing ~= nil and trailing.sprite ~= nil then 
		trailing.sprite.x = replacement.sprite.x - trailing.sprite.width / 2
		trailing.sprite.y = replacement.sprite.y
		local joint = self.physics.newJoint( "pivot", trailing.sprite, replacement.sprite, trailing.sprite.x, trailing.sprite.y )
		replacement.rearwardJoint = joint
		trailing.forwardJoint = joint
		replacement.trailing = trailing
		trailing.leading = replacement
		trailing:reorderZ()
		trailing:setShield(replacement.shielded)
	end
end

function BaseWorm:reorderZ()
	self.sprite:toFront()
	if not self:isHead() then
		self.leading:reorderZ()
	end
end

function BaseWorm:detachFromLeading()
	if self.leading ~= nil then
		if self.forwardJoint.removeSelf ~= nil then
			self.forwardJoint:removeSelf( )
		end
		self.forwardJoint = nil
		self.leading.rearwardJoint = nil
		self.leading.trailing = nil
		self.leading = nil
	end
end

function BaseWorm:detachFromTrailing() 
	if self.trailing ~= nil then
		if self.rearwardJoint.removeSelf ~= nil then 
			self.rearwardJoint:removeSelf( )
		end
		self.rearwardJoint = nil
		self.trailing.forwardJoint = nil
		self.trailing.leading = nil
		self.trailing = nil
	end
end

function BaseWorm:die()
	self:detachFromLeading()
	self:affectedByGravity(true)
	self:detachFromTrailing()
	if self.sprite ~= nil then
		local locationx, locationy = self.sprite.x, self.sprite.y
		explode(locationx, locationy)
		self.sceneLoader:removeDisplayObject(self.sprite)
	end
	self.dead = true
end

function BaseWorm:destroy()
	if self.trailing ~= nil then
		self.trailing:destroy()
	end
	self:detachFromLeading()
	self:detachFromTrailing()
	self:removeSelf()
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

function BaseWorm:onScreen()
	if self.sprite ~= nil and self.sprite.x ~= nil and
	   self.sprite.x <= 1024 and self.sprite.x > 0 and 
	   self.sprite.y <= 768 and self.sprite.y > 0 then
		return true
	else
		return false
	end
end

function BaseWorm:digest(wormNode, displayGroup)
	local eat = function()
		if self.trailing == nil then
			if self.sprite == nil or self.sprite.x == nil then
				timer.performWithDelay( 5, eat )
			else 
				self:attach(wormNode, displayGroup)
			end
		else
			self.trailing:digest(wormNode, displayGroup)
		end
	end
	local shrink = function()
		if self.sprite ~= nil then 
			self.sprite.width = self.diameter
			self.sprite.height = self.diameter
			timer.performWithDelay (5, eat)
		end
	end
	local grow = function()
		if self.sprite ~= nil then
			self.sprite.width = self.diameter * 1.3
			self.sprite.height = self.diameter * 1.3
			timer.performWithDelay( 50, shrink )
		end
	end
	grow()
end

function BaseWorm:affectedByGravity(affected)
	if self.sprite ~= nil then 
		if affected then
			self.sprite.gravityScale = 1.0
		else
			self.sprite.gravityScale = 0.0
		end
		if self.trailing ~= nil then
			self.trailing:affectedByGravity(affected)
		end
	end
end

function BaseWorm:setShield(shielded)
	if shielded == true then
		self.glow = display.newCircle( self.sprite.x, self.sprite.y, (self.diameter / 2) + 2)
		self.glow:setFillColor( 1, 1, 0)
		self.sceneLoader:addDisplayObject(self.glow)
		self.physics.addBody( self.glow, { radius = (self.diameter / 2) + 2, density=0} )
		self.physics.newJoint( "pivot", self.sprite, self.glow, self.sprite.x, self.sprite.y )
		self:reorderZ()
	else
		if self.glow ~= nil then
			self.sceneLoader:removeDisplayObject(self.glow)
		end
	end

	self.shielded = shielded
	if self.trailing ~= nil then
		self.trailing:setShield(shielded)
	end
end