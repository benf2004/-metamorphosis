require("obstacles.Spout")

FireSpout = Spout:new()

function FireSpout:initialize(x, y, sceneLoader)
	local width = 30
	local height = 350
	local power = 150

	self:initializeSpout("effects/fire.pex", x, y, width, height, power, sceneLoader)
end

function FireSpout:spray(object)
	local closure = function()
		if object.obj ~= nil and object.obj.dieAll ~= nil then 
			object.obj:dieAll() 
		end
	end
	timer.performWithDelay( 10, closure )
end

function FireSpout:unspray(object)
	
end