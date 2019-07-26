require("worm.HeadWorm")

SmartWorm = HeadWorm:new()

function SmartWorm:initializeMotion()
	self.targetJoint = physics.newJoint( "touch", self.sprite, self.sprite.x, self.sprite.y )
	self.targetJoint.dampingRatio = 1
	self.targetJoint.freqency = 1
	self.targetJoint.maxForce = 3000

	local closure = function()
		local x,y = self:xy()
		local targetX = x - 100
		self:moveToLocation(targetX, y)
	end
	self.sceneLoader:runTimer(20, closure, self.sprite, -1)
end

function SmartWorm:targetsWithinRange()
	local wormx, wormy = self:xy()
	local potentialTargets = {}
	for a = 1, self.sceneLoader.view.numChildren,1 do
		local potentialTarget = self.sceneLoader.view[a]
		if potentialTarget.targetable == true then
			local x, y = potentialTarget.x, potentialTarget.y
			local d = self:distanceBetween(wormx, wormy, x, y)
			local target = {
				distance = d,
				target = potentialTarget
			}
			table.insert(potentialTargets, target)
		end
	end
	local sortFunction = function(a, b) 
		return a.distance < b.distance
	end
	table.sort(potentialTargets, sortFunction)
	
end

function SmartWorm:findPathToTarget()
	self:targetsWithinRange()
end

function SmartWorm:distanceBetween( x1, y1, x2, y2 )
    local dX = x2 - x1
    local dY = y2 - y1
 
    local distance = math.sqrt( ( dX^2 ) + ( dY^2 ) )
    return distance 
end