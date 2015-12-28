require("worm.BaseWorm")
require("game.Colors")

ClockWorm = BaseWorm:new()

function ClockWorm:initialize( physics, sceneLoader )
	self:initializeSprite(sceneLoader)
	self.type = "body"
	
	self:setSkin(self.frameIndex.clock)

	self:initializePhysics( physics )
	self.sprite.name = "ClockWorm"
end

function ClockWorm:attachAction()
	self.sceneLoader.hud.statistics.timeRemaining = self.sceneLoader.hud.statistics.timeRemaining + 3
end