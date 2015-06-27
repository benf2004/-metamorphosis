StandardWorm = BaseWorm:new()

function StandardWorm:initialize( physics )
	self:initializeSprite("simplegreen")
	self.type = "body"

	self:initializePhysics( physics )
end

function StandardWorm:activate()
	self:die()
end