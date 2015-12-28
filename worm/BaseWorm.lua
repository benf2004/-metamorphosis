require("Base")
require("effects.Effects")
require("game.Colors")

BaseWorm  = Base:new({diameter=32})

BaseWorm.sheetOptions = {
	width = 32,
	height = 32,
	numFrames = 64
}
BaseWorm.wormSheet = graphics.newImageSheet( "images/WormSheet.png", BaseWorm.sheetOptions )
BaseWorm.sheetIndex = {
	wormy = 1,
	wormyBlink = 2,
	angryWorm = 3,
	angryRed = 4,
	hungryWorm = 5,
	hungryEat = 6,
	neck = 7,
	green = 8,
	slashy = 9,
	pieChart = 10,
	stripes = 11,
	dots = 12,
	yingyang = 13,
	wild = 14,
	gravity = 15,
	red = 16,
	anchor = 22,
	blue = 23,
	poison = 24,
	purple = 25,
	shield = 26,
	yellow = 27
}

BaseWorm.wormSequence = {
	name = "Base",
	frames = {
		BaseWorm.sheetIndex.green,
		BaseWorm.sheetIndex.slashy,
		BaseWorm.sheetIndex.pieChart,
		BaseWorm.sheetIndex.stripes,
		BaseWorm.sheetIndex.dots,
		BaseWorm.sheetIndex.yingyang,
		BaseWorm.sheetIndex.wild,
		BaseWorm.sheetIndex.gravity,
		BaseWorm.sheetIndex.red,
		BaseWorm.sheetIndex.anchor,
		BaseWorm.sheetIndex.blue,
		BaseWorm.sheetIndex.poison,
		BaseWorm.sheetIndex.purple,
		BaseWorm.sheetIndex.shield,
		BaseWorm.sheetIndex.yellow
	}
}

BaseWorm.frameIndex = {
	green = 1,
	slashy = 2,
	pieChart = 3,
	stripes = 4,
	dots = 5,
	yingyang = 6,
	wild = 7,
	gravity = 8,
	red = 9,
	anchor = 10,
	blue = 11,
	poison = 12,
	purple = 13,
	shield = 14,
	yellow = 15,
	clock = 16
}

function BaseWorm:animateSprite(sceneLoader)
	self.sprite = display.newSprite( self.wormSheet, self.wormSequence )
	self.sceneLoader = sceneLoader
	self.sceneLoader:addDisplayObject(self.sprite)
	self.density = 1
	self.sprite.obj = self
	self.sprite.xF, self.sprite.xY = 0, 0
	self.sprite.name = "baseworm"
	self.defaultSkin = self.frameIndex.dots
	self:setSkin(self.defaultSkin)
end

function BaseWorm:initializeSprite(sceneLoader)
	self:animateSprite(sceneLoader)
end

function BaseWorm:initializePhysics(physics)
	physics.addBody( self.sprite, { radius = (self.diameter / 2), density=self.density, friction=0.0, bounce=0.0})
	self.physics = physics
	self.sprite.gravityScale = 0
	self.sprite.linearDamping = 4
	self.sprite.angularDamping = 2
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

function BaseWorm:attachAction()
end

function BaseWorm:printWorm()
	if self:trailing() ~= nil then
		if self.shielded then
			return self.sprite.name.."(S)-"..self.trailing():printWorm()
		else 
			return self.sprite.name.."--"..self:trailing():printWorm()
		end
	else
		if self.shielded then
			return self.sprite.name
		end
	end
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
			next:setSkin(next.defaultSkin)
			if self.shielded == true then
				next:setShield(self.shield)
			end
			next:reorderZ()
			next:attachAction()
		end
	else
		self:trailing():attach(next, x, y)
	end
end

function BaseWorm:reorderZ()
	self.sprite:toFront()
	if not self:isHead() then
		self:leading():reorderZ()
	end
end

function BaseWorm:die(sound)
	self:death(sound)
end

function BaseWorm:death(sound)
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
	if self.shield == nil then
		self:die()
	end
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
				self.sceneLoader:runTimer(5, eat, {self, self.sprite})
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
			self.sceneLoader:runTimer(5, eat, {self, self.sprite})
		end
	end
	local grow = function()
		if self.sprite ~= nil then
			self.sprite.width = self.diameter * 1.3
			self.sprite.height = self.diameter * 1.3
			self.sceneLoader:runTimer(50, shrink, {self, self.sprite})
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

function BaseWorm:setShield(shield)
	self:setSkin(shield)
	self.shield = shield
	self.shielded = true

	if self:trailing() ~= nil then
		self:trailing():setShield(shield)
	end
end

function BaseWorm:removeShield()
	self.shield = nil
	self.shielded = false
	self:skin(self.defaultSkin)

	if self:trailing() ~= nil then
		self:trailing():removeShield()
	end
end

function BaseWorm:shieldAll(shield)
	self:head():setShield(shield)
end

function BaseWorm:unshieldAll()
	self:head():removeShield()
end

function BaseWorm:skin(skin)
	self:head():skinAll(skin)
end

function BaseWorm:skinAll(skin)
	if skin == nil and self.defaultSkin ~= nil then
		skin = self.defaultSkin
	end
	if self:trailing() ~= nil then
		self:trailing():skinAll(skin)
	end
	self:setSkin(skin)
end

function BaseWorm:setSkin(skin)
	if self.sprite ~= nil and self.sprite.setFrame ~= nil then
		if skin ~= nil then
			self.currentSkin = skin
		else 
			self.currentSkin = self.defaultSkin
		end
		self.sprite:setFrame(self.currentSkin)
	end
end