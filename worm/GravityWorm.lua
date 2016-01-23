require("worm.BaseWorm")

GravityWorm = BaseWorm:new()

function GravityWorm:initialize( physics, sceneLoader )
	self.defaultSkin = BaseWorm.frameIndex.red

	self:initializeSprite(sceneLoader)
	self.type = "body"
	
	self:setSkin(self.frameIndex.gravity)

	self:initializePhysics( physics )
	self.sprite.name = "GravityWorm"
end

function GravityWorm:postInitializePhysics( physics, sceneLoader)
	self.sprite.gravityScale = 1
end

function GravityWorm:activate()
	if not self.shielded then
		self:die()
	end
end