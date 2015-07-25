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

		local downPoison = timer.performWithDelay( 5000, destroyPoison, 1)
		self.sceneLoader:addTimer(downPoison)

		local poisonTimer = timer.performWithDelay( 500, poisonMe, 9 )
		self.sceneLoader:addTimer(poisonTimer)

	end
end