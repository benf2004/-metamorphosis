require("worm.Baseworm")

StandardWorm = BaseWorm:new()

function StandardWorm:initialize( physics, sceneLoader )
	self:initializeSprite("simplegreen", sceneLoader)
	self.type = "body"

	self:initializePhysics( physics )
end

function StandardWorm:activate()
	self:die()
end