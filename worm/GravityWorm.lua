require("worm.BaseWorm")

GravityWorm = BaseWorm:new()

function GravityWorm:initialize( physics, sceneLoader )
	self.defaultSkin = sceneLoader.defaultSkin

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

function GravityWorm:attachAction()
	if self.sprite ~= nil then
		self.sprite.gravityScale = 1
	end	
end