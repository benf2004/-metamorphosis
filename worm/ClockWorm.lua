require("worm.BaseWorm")
require("game.Colors")

ClockWorm = BaseWorm:new()

function ClockWorm:initialize( physics, sceneLoader )	
	self.defaultSkin = sceneLoader.defaultSkin

	self:initializeSprite(sceneLoader)
	self.type = "body"
	
	self:setSkin(self.frameIndex.clock)

	self:initializePhysics( physics )
	self.sprite.name = "ClockWorm"
end

function ClockWorm:attachAction()
	if not self.isUsed then 
		self.sceneLoader.hud.statistics.timeRemaining = self.sceneLoader.hud.statistics.timeRemaining + 3
	end
	self.isUsed = true
end