require("worm.BaseWorm")

StandardWorm = BaseWorm:new()

function StandardWorm:initialize( physics, sceneLoader )
	self.defaultSkin = sceneLoader.defaultSkin
	
	self:animateSprite(sceneLoader)
	self.type = "body"

	self:initializePhysics( physics )
end

function StandardWorm:activate()
	if self.shield == nil then
		self:die()
	end
end