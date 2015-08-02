require ("Base")
Lightning = Base:new()



function Lightning:initialize( level, sceneLoader )
	self.level = level
	self.sceneLoader = sceneLoader
	self.lightning = graphics.newMask("images/Lightningmask.png")
	self.sceneLoader.view:setMask(self.lightning)
	self.sceneLoader.view.isHitTestMasked = false
	self:storm()
end

function Lightning:flash(count)
	self.hidemask = function ()
		self.sceneLoader.view:setMask(nil)
		timer.performWithDelay(100, self.showmask)
	end
	 self.showmask = function ()
		self.sceneLoader.view:setMask(self.lightning)
		
	end
	timer.performWithDelay(150, self.hidemask, count)
 
end  

function Lightning:storm()
	local pause = math.random (500,5000)
	local count = math.random (1,5)
	self:flash(count)
	local closure = function ()
		self:storm()
	end
	local stormTimer = timer.performWithDelay (pause, closure)
	self.sceneLoader:addTimer(stormTimer)
end

