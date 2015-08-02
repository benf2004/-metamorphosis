require("obstacles.Spout")

FireTongue = Spout:new()

function FireTongue:initialize(x, y, sceneLoader)
	local width = 10
	local height = 100
	local power = 150

	self:initializeSpout("effects/firetongue.pex", x, y, width, height, power, sceneLoader)
end

function FireTongue:spray(object)
	local closure = function()
		if object.obj and object.obj.head ~= nil and object.obj:head().sprite ~= self.mate then
			if object.obj.dieAll then object.obj:dieAll() end
		end
	end
	timer.performWithDelay( 10, closure )
end

function FireTongue:unspray(object)
end

function FireTongue:pairWithWorm(headWormSprite)
	if headWormSprite ~= nil and headWormSprite.rotation ~= nil then 
		self.mate = headWormSprite
		self:setRotation(headWormSprite.rotation + 90)
		self:moveToLocation(headWormSprite.x, headWormSprite.y)
	end
end

function FireTongue:lashOut()
	local outTime = math.random(200, 1600)
	self:on()
	local closure = function() self:lashIn() end
	local timerId = timer.performWithDelay( outTime, closure )
	self.sceneLoader:addTimer(timerId)
end

function FireTongue:lashIn()
	local inTime = math.random(1000, 7000)
	self:off()
	local closure = function() self:lashOut() end
	local timerId = timer.performWithDelay( inTime, closure )
	self.sceneLoader:addTimer(timerId)
end