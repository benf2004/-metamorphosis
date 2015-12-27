require("worm.BaseWorm")

GravityWorm = BaseWorm:new()

function GravityWorm:initialize( physics, sceneLoader )
	self:initializeSprite(sceneLoader)
	self.type = "body"
	
	self.defaultSkin = self.frameIndex.red
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