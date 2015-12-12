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
		if self.sceneLoader.view ~= nil and self.sceneLoader.view.setMask ~= nil then
			self.sceneLoader.view:setMask(nil)
			self.sceneLoader:runTimer(100, self.showmask, self.sceneLoader.view)
		end
	end
	self.showmask = function ()
		if self.sceneLoader.view ~= nil and self.sceneLoader.view.setMask ~= nil then
			self.sceneLoader.view:setMask(self.lightning)
		end
	end
	self.sceneLoader:runTimer(150, self.hidemask, self.sceneLoader.view, count)
end  

function Lightning:storm()
	local pause = math.random (500,5000)
	local count = math.random (1,5)
	self:flash(count)
	local closure = function ()
		self:storm()
	end
	local stormTimer = self.sceneLoader:runTimer(pause, closure, self)
end

