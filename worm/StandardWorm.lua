require("worm.BaseWorm")

StandardWorm = BaseWorm:new()

function StandardWorm:initialize( physics, sceneLoader )
	self:initializeSprite("simplegreen", sceneLoader)
	self.type = "body"

	self:initializePhysics( physics )
end

function StandardWorm:activate()
	if not self.shielded then
		self:die()
	end
end