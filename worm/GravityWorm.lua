require("worm.BaseWorm")

GravityWorm = BaseWorm:new()

GravityWorm.wormSequence = {
	name = "Base",
	frames = {15},
	time = 10000,
	loopCount = 1
}

function GravityWorm:initialize( physics, sceneLoader )
	self:initializeSprite("simplered", sceneLoader)
	self.type = "body"

	self:initializePhysics( physics )
	self.sprite.name = "gravityworm"
end

function GravityWorm:postInitializePhysics( physics, sceneLoader)
	self.sprite.gravityScale = 1
end

function GravityWorm:activate()
	if not self.shielded then
		self:die()
	end
end