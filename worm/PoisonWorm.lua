require("worm.BaseWorm")
require("game.Colors")

PoisonWorm = BaseWorm:new()

function PoisonWorm:initialize( physics, sceneLoader )
	self:initializeSprite(sceneLoader)
	self.type = "body"

	self.shieldSkin = self.frameIndex.purple
	self:setSkin(self.frameIndex.poison)

	self:initializePhysics( physics )
	self.sprite.name = "PoisonWorm"
end

function PoisonWorm:attachAction()
	if not self.shielded and not self.anchor and self.sprite and self.sprite.x and self.sprite.y then 
		self:shieldAll(self.shieldSkin)
		local head = self:head()

		local destroyShield = function()
			head:unshieldAll()	
		end

		local poisonMe = function()
			head:tail().shielded = false
			head:tail():die()
		end

		head.sceneLoader:runTimer(5000, destroyShield, head, 1)
		head.sceneLoader:runTimer(500, poisonMe, head, 8)		
	end
end