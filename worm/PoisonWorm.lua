require("worm.BaseWorm")
require("game.Colors")

PoisonWorm = BaseWorm:new()

function PoisonWorm:initialize( physics, sceneLoader )
	self:initializeSprite("simplepurple", sceneLoader)
	self.type = "body"

	self:initializePhysics( physics )
	self.sprite.name = "PoisonWorm"
end

function PoisonWorm:activate()
	if self.shield == nil then
		self:head():setShield("poison")
		self.poisonedHead = self:head()

		local destroyPoison = function()
			self.poisonedHead:setShield(nil)
		end

		local poisonMe = function()
			self.poisonedHead:tail():die()
		end

		self.sceneLoader:runTimer(5000, destroyPoison, self.poisonedHead, 1)
		self.sceneLoader:runTimer(500, poisonMe, self.poisonedHead, 9)
	end
end