require("worm.BaseWorm")
require("game.Colors")

AnchorWorm = BaseWorm:new()

function AnchorWorm:initialize( physics, sceneLoader )
	self:initializeSprite("simpleblue", sceneLoader)
	self.type = "body"

	self:initializePhysics( physics )
	self.sprite.name = "AnchorWorm"
end

function AnchorWorm:activate()
	if not self.shielded and not self.anchor and self.sprite and self.sprite.x and self.sprite.y then 
		self.anchor = display.newCircle( self.sprite.x, self.sprite.y, 2 )
		self.anchor:setFillColor( 0, 0, 0, 0)
		self.sceneLoader:addDisplayObject(self.anchor)
		self.physics.addBody( self.anchor, { radius = 2, density=100000000})
		self.anchorJoint = self.physics.newJoint( "pivot", self.sprite, self.anchor, self.sprite.x, self.sprite.y )
		self.anchor.gravityScale = 0.0

		local destroyAnchor = function()
			self.sceneLoader:removeDisplayObject(self.anchor)
			self:die()
		end

		local upAnchor = timer.performWithDelay( 5000, destroyAnchor, 1)
		self.sceneLoader:addTimer(upAnchor)
	end
end