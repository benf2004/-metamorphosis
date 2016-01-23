require("worm.BaseWorm")
require("game.Colors")

ShieldWorm = BaseWorm:new()

function ShieldWorm:initialize( physics, sceneLoader )
	self.defaultSkin = BaseWorm.frameIndex.yellow

	self:initializeSprite(sceneLoader)
	self.type = "body"

	self.shieldSkin = self.frameIndex.yellow
	self:setSkin(self.frameIndex.shield)

	self:initializePhysics( physics )
	self.sprite.name = "ShieldWorm"
end

function ShieldWorm:attachAction()
	if not self.shielded and not self.anchor and self.sprite and self.sprite.x and self.sprite.y then 
		self:shieldAll(self.shieldSkin)

		local destroyShield = function()
			self:unshieldAll()	
		end

		self.sceneLoader:runTimer(5000, destroyShield, self, 1)
	end
end