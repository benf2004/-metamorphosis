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
	if self.shield == nil then
		self:head():setShield("shield")

		local destroyShield = function()
			self:head():setShield(nil)
			local replacement = StandardWorm:new()
			self:replace(replacement)
		end

		self.sceneLoader:runTimer(5000, destoryShield, {}, 1)
	end
end