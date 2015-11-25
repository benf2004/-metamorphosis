require("Base")
require("effects.Effects")
require("game.Colors")

BaseWorm  = Base:new({diameter=32})

function BaseWorm:initializeSprite(textureName, sceneLoader)
	self.sprite = display.newImageRect( "images/"..textureName..".png", self.diameter, self.diameter )
	-- self.sprite = display.newImageRect( "images/wormhead.png", self.diameter, self.diameter )
	self.sceneLoader = sceneLoader
	self.sceneLoader:addDisplayObject(self.sprite)
	self.density = 1
	self.sprite.obj = self
	self.sprite.xF, self.sprite.xY = 0, 0
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

function BaseWorm:leading()
	if self.leadingJoint ~= nil then
		return self.leadingJoint.leading
	else
		return nil
	end
end

function BaseWorm:trailing()
	if self.trailingJoint ~= nil then
		return self.trailingJoint.trailing
	else
		return nil
	end
end

function BaseWorm:isHead()
	return self.leadingJoint == nil
end

function BaseWorm:isTail()
	return self.trailingJoint == nil
end

function BaseWorm:head()
	if self:isHead() then
		return self
	else
		return self:leading():head()
	end
end

function BaseWorm:tail()
	if self:isTail() then
		return self
	else
		return self:trailing():tail()
	end
end

function BaseWorm:detachFromLeading()
	if self.leadingJoint ~= nil then
		local joint = self.leadingJoint.joint
		local leading = self.leadingJoint.leading

		if joint.removeSelf ~= nil then
			joint:removeSelf()
		end
		
		self.leadingJoint.joint = nil
		self.leadingJoint.leading = nil
		self.leadingJoint.trailing = nil
		self.leadingJoint = nil

		leading.trailingJoint = nil
	end
end

function BaseWorm:detachFromTrailing() 
	if self.trailingJoint ~= nil then
		local joint = self.trailingJoint.joint
		local trailing = self.trailingJoint.trailing

		if joint.removeSelf ~= nil then
			joint:removeSelf()
		end

		self.trailingJoint.joint = nil
		self.trailingJoint.leading = nil
		self.trailingJoint.trailing = nil
		self.trailingJoint = nil

		trailing.leadingJoint = nil
	end
end

function BaseWorm:attachJoint(trailing)
	local joint = self.physics.newJoint( "pivot", self.sprite, trailing.sprite, trailing.sprite.x, trailing.sprite.y)
	-- joint.isLimitEnabled = true
	-- joint:setRotationLimits( -20, 20 )
	local jointRef = {
		joint = joint,
		leading = self,
		trailing = trailing
	}

	self.trailingJoint = jointRef
	trailing.leadingJoint = jointRef
end


function BaseWorm:attach(next)
	if self:isTail() then
		if self ~= next then 
			self.sceneLoader:playSound("pop")
			next.density = self.density * 0.9
			next:initialize( self.physics, self.sceneLoader )
			if next.sprite.name ~= "gravityworm" then
				next:affectedByGravity(false)
			else
				next:affectedByGravity(true)
			end

			if self:leading() and self:leading().sprite ~= nil then
				local ref = self:leading().sprite
				local rx, ry = ref.x, ref.y
				local dx, dy = self.sprite.x - rx, self.sprite.y - ry
				next.sprite.x = self.sprite.x + dx
				next.sprite.y = self.sprite.y + dy
				next.sprite.rotation = ref.rotation
			else
				next.sprite.x = self.sprite.x - next.sprite.width / 2
				next.sprite.y = self.sprite.y	
			end

			self:attachJoint(next)
			next:setShield(self.shield)

			next:reorderZ()
		end
	else
		self:trailing():attach(next, x, y)
	end
end

function BaseWorm:replace(replacement)
	-- local previous = self.leading
	-- local trailing = self.trailing

	-- self:detachFromLeading()
	-- self:detachFromTrailing()
	-- self.sceneLoader:removeDisplayObject(self.sprite)

	-- if previous ~= nil then
	-- 	local x, y = self.sprite.x, self.sprite.y
	-- 	previous:attach(replacement, x, y)
	-- end

	-- if trailing ~= nil and trailing.sprite ~= nil and replacement ~= nil and replacement.sprite ~= nil then 
	-- 	trailing.sprite.x = replacement.sprite.x - trailing.sprite.width / 2
	-- 	trailing.sprite.y = replacement.sprite.y
	-- 	local joint = self.physics.newJoint( "pivot", trailing.sprite, replacement.sprite, trailing.sprite.x, trailing.sprite.y )
	-- 	replacement.rearwardJoint = joint
	-- 	trailing.forwardJoint = joint
	-- 	replacement.trailing = trailing
	-- 	trailing.leading = replacement
	-- 	trailing:reorderZ()
	-- 	trailing:setShield(replacement.shield)
	-- end
end

function BaseWorm:reorderZ()
	self.sprite:toFront()
	if not self:isHead() then
		self:leading():reorderZ()
	end
end

function BaseWorm:die(sound)
	if not self.shielded then 
		self:detachFromLeading()
		self:affectedByGravity(true)
		self:detachFromTrailing()
		if self.sprite ~= nil then
			local locationx, locationy = self.sprite.x, self.sprite.y
			local snd = sound or "bang"
			self.sceneLoader:playSound(snd)
			explode(locationx, locationy)
			self.sceneLoader:removeDisplayObject(self.sprite)
		end
		if self.glow ~= nil then
			self.sceneLoader:removeDisplayObject(self.glow)
		end
		self.dead = true
	end
end

function BaseWorm:dieAll()
	if self:trailing() ~= nil then
		self:trailing():dieAll()
	end
	self:die()
end

function BaseWorm:burstWithHappiness()
	if self:trailing() ~= nil then
		self:trailing():burstWithHappiness()
	end
	self:detachFromLeading()
	self:affectedByGravity(true)
	self:detachFromTrailing()
	if self.sprite ~= nil then
		local locationx, locationy = self.sprite.x, self.sprite.y
		-- heartSwirl(locationx, locationy)
		heartExplosion(locationx, locationy)
		self.sceneLoader:removeDisplayObject(self.sprite)
	end
	if self.glow ~= nil then
		self.sceneLoader:removeDisplayObject(self.glow)
	end
	self.dead = true
end

function BaseWorm:destroy()
	if self:trailing() ~= nil then
		self:trailing():destroy()
	end
	self:detachFromLeading()
	self:detachFromTrailing()
	self:removeSelf()
	self.dead = true
end

function BaseWorm:lengthToEnd()
	if self:trailing() ~= nil then
		return self:trailing():lengthToEnd() + 1
	else
		return 1
	end
end

function BaseWorm:killBadJoints()
	if self.sprite ~= nil and self:leading() ~= nil and self:leading().sprite ~= nil then
		local dx = math.abs(self:leading().sprite.x - self.sprite.x)
		local dy = math.abs(self:leading().sprite.y - self.sprite.y)
		if dx > self.sprite.width*2 or dy > self.sprite.width*2 then
			self:die()
		end
	end

	if self:trailing() ~= nil then
		self:trailing():killBadJoints()
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
		if self:trailing() == nil then
			if self.sprite == nil or self.sprite.x == nil then
				timer.performWithDelay( 5, eat )
			else 
				self:attach(wormNode)
			end
		else
			self:trailing():digest(wormNode, displayGroup)
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
		if self:trailing() ~= nil then
			self:trailing():affectedByGravity(affected)
		end
	end
end

function BaseWorm:addGlow(color)
	if self.glow == nil and self.sprite ~= nil and self.sprite.x ~= nil then 
		self.glow = display.newCircle( self.sprite.x, self.sprite.y, (self.diameter / 2) + 2)
		self.glow:setFillColor( color[1], color[2], color[3] )
		self.sceneLoader:addDisplayObject(self.glow)
		self.physics.addBody( self.glow, { radius = (self.diameter / 2) + 2, density=0} )
		self.physics.newJoint( "pivot", self.sprite, self.glow, self.sprite.x, self.sprite.y )
		self:reorderZ()
	end
end	

function BaseWorm:removeGlow()
	if self.glow ~= nil then
		self.sceneLoader:removeDisplayObject(self.glow)
		self.glowColor = nil
		self.glow = nil
		self.shield = nil
	end
end

function BaseWorm:setShield(shield)
	if shield ~= nil then
		if shield == "poison" then
			self.glowColor = colors.purple
		else
			self.glowColor = colors.yellow
		end
		self.shield = shield
		self.shielded = true
		self:addGlow(self.glowColor)
	else
		self:removeGlow()
		self.shielded = false
		self.shield = nil
	end

	if self:trailing() ~= nil then
		self:trailing():setShield(shield)
	end
end