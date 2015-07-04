GravityWorm = BaseWorm:new()

function GravityWorm:initialize( physics )
	self:initializeSprite("simplered")
	self.type = "body"

	self:initializePhysics( physics )
	self.sprite.name = "gravityworm"
end

function GravityWorm:postInitializePhysics( physics )
	self.sprite.gravityScale = 1
end

function GravityWorm:activate()
	self:die()
end