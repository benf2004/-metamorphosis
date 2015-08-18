require("obstacles.Spout")

WaterSpout = Spout:new()

function WaterSpout:initialize(x, y, sceneLoader)
	local width = 80
	local height = 300
	local power = 35

	self:initializeSpout("effects/wind.pex", x, y, width, height, power, sceneLoader)
end

function WaterSpout:spray(object)
	object.xF = (object.xF or 0) + self.xF
	object.yF = (object.yF or 0) + self.yF

	object.constantForce = function()
		if not (object.xF ==0 and object.yF == 0) and object.applyForce ~= nil then
			object:applyForce(object.xF, object.yF, object.x, object.y)
		end
	end

	--special case headworm
	if object.obj ~= nil and object.obj.targetJoint ~= nil then 
		object.obj.targetJoint.maxForce = object.obj.targetJoint.maxForce * 0.1
	end

   	Runtime:addEventListener( "enterFrame", object.constantForce )
end

function WaterSpout:unspray(object)
	object.xF = object.xF or 0
	object.yF = object.yF or 0
	object.xF, object.yF = 0, 0 --object.xF - self.xF, object.yF - self.yF

	if object.constantForce ~= nil then
		Runtime:removeEventListener( "enterFrame", object.constantForce )
		object.constantForce = nil
	end

	--special case headworm
	if object.obj ~= nil and object.obj.targetJoint ~= nil then 
		object.obj.targetJoint.maxForce = object.obj.targetJoint.maxForce * 10
	end
end