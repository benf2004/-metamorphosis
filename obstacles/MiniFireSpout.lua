require("obstacles.Spout")

MiniFireSpout = Spout:new()

function MiniFireSpout:initialize(x, y, sceneLoader)
	local width = 10
	local height = 100
	local power = 150

	self:initializeSpout("effects/firetongue.pex", x, y, width, height, power, sceneLoader)
end

function MiniFireSpout:spray(object)
	local closure = function()
		if object.obj.dieAll then object.obj:dieAll() end
	end
	timer.performWithDelay( 10, closure )
end

function MiniFireSpout:unspray(object)
	
end