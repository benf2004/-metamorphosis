require("worm.HeadWorm")

FlashlightWorm = HeadWorm:new()

function FlashlightWorm:initializeEffect()
	self.flashlight = graphics.newMask( "images/circlemask.png" )
	self.sceneLoader.view:setMask( self.flashlight )
	self.sceneLoader.view.isHitTestMasked = false

	self.sceneLoader.view.maskX = self.sprite.x
	self.sceneLoader.view.maskY = self.sprite.y
	self.sceneLoader.view.maskScaleX = 1
	self.sceneLoader.view.maskScaleY = 1
	self:pulsate()
end

function FlashlightWorm:moveToLocation(x, y)
	if self.targetJoint ~= nil then
		self.targetJoint:setTarget( x, y )
		self.sceneLoader.view.maskX = x
		self.sceneLoader.view.maskY = y
	end
end

function FlashlightWorm:pulsate()
	self:setTargetFlashlight()

	local pulseClosure = function()
		local maskScaleX = math.round(self.sceneLoader.view.maskScaleX * 10) / 10
		if maskScaleX < self.flashlightTarget then
			self.sceneLoader.view.maskScaleX = self.sceneLoader.view.maskScaleX + 0.1
			self.sceneLoader.view.maskScaleY = self.sceneLoader.view.maskScaleY + 0.1
		elseif maskScaleX > self.flashlightTarget then
			self.sceneLoader.view.maskScaleX = self.sceneLoader.view.maskScaleX - 0.1
			self.sceneLoader.view.maskScaleY = self.sceneLoader.view.maskScaleY - 0.1
		else
			self:setTargetFlashlight()
		end
	end

	self.pulsateTimer = timer.performWithDelay( 20, pulseClosure, -1 )
end

function FlashlightWorm:setTargetFlashlight()
	self.flashlightTarget = (math.random( 3, 20 ) / 10)
end

function FlashlightWorm:pause()
	if self.pulsateTimer ~= nil then 
		timer.cancel( self.pulsateTimer )
		self.pulsateTimer = nil
	end
end