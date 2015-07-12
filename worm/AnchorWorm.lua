AnchorWorm = BaseWorm:new()

function AnchorWorm:initialize( physics )
	self:initializeSprite("simplered")
	self.type = "body"

	self:initializePhysics( physics )
	self.sprite.name = "Anchorworm"
end

function AnchorWorm:postInitializePhysics( physics )
	self.sprite.MassScale = 1000000
end

function AnchorWorm:activate()
	self:die()
end