require("worm.BaseWorm")
require("game.Colors")

AnchorWorm = BaseWorm:new()

function AnchorWorm:initialize( physics, sceneLoader )
	self:initializeSprite(sceneLoader)
	self.type = "body"
	
	self.shieldSkin = self.frameIndex.blue
	self:setSkin(self.frameIndex.anchor)

	self:initializePhysics( physics )
	self.sprite.name = "AnchorWorm"
end

function AnchorWorm:attachAction()
	if not self.shielded and not self.anchor and self.sprite and self.sprite.x and self.sprite.y then 
		self.anchor = display.newCircle( self.sprite.x, self.sprite.y, 2 )
		self.anchor:setFillColor( 0, 0, 0, 0)
		self.sceneLoader:addDisplayObject(self.anchor)
		self.physics.addBody( self.anchor, { radius = 2, density=100000000})
		self.anchorJoint = self.physics.newJoint( "pivot", self.sprite, self.anchor, self.sprite.x, self.sprite.y )
		self.anchor.gravityScale = 0.0

		self:shieldAll(self.shieldSkin)

		local destroyAnchor = function()
			if self.sceneLoader.removeDisplayObject ~= nil and self.anchor ~= nil and self.unshieldAll ~= nil then
				self.sceneLoader:removeDisplayObject(self.anchor)
				self:head():unshieldAll()
				-- self:die()
			end
		end

		self.sceneLoader:runTimer(5000, destroyAnchor, self.anchor, 1)
	end
end