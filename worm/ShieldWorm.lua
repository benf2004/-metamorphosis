require("worm.BaseWorm")
require("game.Colors")

ShieldWorm = BaseWorm:new()

function ShieldWorm:initialize( physics, sceneLoader )
	self:initializeSprite("simpleyellow", sceneLoader)
	self.type = "body"

	self:initializePhysics( physics )
	self.sprite.name = "ShieldWorm"
end

function ShieldWorm:activate()
	print("Trying to activate")
	if self.shielded == nil or self.shielded == false then
		print("Activating")
		self:head():setShield(true)

		local destroyShield = function()
			self:head():setShield(false)
			self:die()
		end

		local downShield = timer.performWithDelay( 5000, destroyShield, 1)
		self.sceneLoader:addTimer(downShield)
	end
end