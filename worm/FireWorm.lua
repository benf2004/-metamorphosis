require("worm.BaseWorm")

FireWorm = BaseWorm:new()

function FireWorm:initialize( physics, sceneLoader )
	self.defaultSkin = sceneLoader.defaultSkin

	self:initializeSprite(sceneLoader)
	self.type = "body"
	
	self:setSkin(self.frameIndex.gravity)

	self:initializePhysics( physics )
	self.sprite.name = "gravityWorm"
end

function FireWorm:attachAction()
	if self.sprite ~= nil then
		if self.fireTongue == nil then
			local head = self:head()
			self.fireTongue = FireTongue:new()
			local wx = head.sprite.x
			local wy = head.sprite.y
			self.fireTongue:initialize(wx, wy, self.sceneLoader)
			self.fireTongue:pairWithWorm(head.sprite)
			self.fireTongue:lashOnce()
			local synchronizeTongue = function()
				if self.sceneLoader.head.sprite then
					self.fireTongue:pairWithWorm(head.sprite)
				end
			end
			self.sceneLoader:addGlobalEventListener( "enterFrame", synchronizeTongue )
		else
			self.fireTongue:lashOnce()
		end
	end	
end