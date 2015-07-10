require("worm.HeadWorm")

AngryWorm = HeadWorm:new()

function AngryWorm:initializeMotion()
		
end

function AngryWorm:destroy()
	if self.trailing ~= nil then
		self.trailing:destroy()
	end
	self:detachFromLeading()
	self:detachFromTrailing()
	self:removeSelf( )
	self.dead = true
end
