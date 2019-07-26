require("core.SceneBase")
require("server.LocalWorldServer")

ServerSceneLoader  = SceneBase:new()

function ServerSceneLoader:load()
	self.worldServer = LocalWorldServer:new()
	self.worldServer:initialize(self)

	self:initializePhysics()
	self:initializeGravity()
	self:initializeBackground()
	self:initializeWorm()
	self:initializeFoodTruck()
end

function ServerSceneLoader:launch()
	self:start()
end

function ServerSceneLoader:start()
	self.adManager:hideAd()
	self:addEventListener( "touch", self.touchListener )
	self.physics.start()
	self:resumeAllTimers()
	self:resumeAllMusic()

	if self.spouts ~= nil then
		for i=#self.spouts, 1, -1 do
			self.spouts[i]:unpause()
		end
	end

	self.head:initializeEffect()
end

function ServerSceneLoader:pause()
	self.view:setMask(nil)
	self.physics.pause()
	self:removeEventListener( "touch", self.touchListener )
	self.head:pause()

	self:pauseAllTimers()
	self:removeAllGlobalEventListeners()
	self:pauseAllMusic()

	if self.spouts ~= nil then
		for i=#self.spouts, 1, -1 do
			self.spouts[i]:pause()
		end
	end	
end

-- 
-- This section sets up a tiled background.
-- 
function ServerSceneLoader:initializeBackground()
	self.tilesFilled = {}
	self:createBackground(0, 0)
	self.maximumSpeed = 60

	local scrollFunction = function()
		if self.head and self.head.engaged then
			local serverId = self.head.serverId
			local cx, cy = self.head:xy()
			local tx, ty = self.head.targetX, self.head.targetY
			local dx = tx - cx
			local dy = ty - cy
			local c = math.sqrt((dx * dx) + (dy * dy))
			if c > self.maximumSpeed then
				local ratio = self.maximumSpeed / c
				local x, y = dx * ratio + cx, dy * ratio + cy
				self.head:moveToLocation(x, y)
				-- self.worldServer:publishLocationAndTarget(serverId, cx, cy, x, y)
			else
				self.head:moveToLocation(tx, ty)
				-- self.worldServer:publishLocationAndTarget(serverId, cx, cy, tx, ty)
			end
		end

		local bottomScrollBound = self.screenH * .6
		local topScrollBound = self.screenH * .4
		local leftScrollBound = self.screenW * .6
		local rightScrollBound = self.screenW * .4
		if (self.head ~= nil and self.head.sprite ~= nil and self.head.sprite.x ~= nil) then
			local cx, cy = self.view:localToContent(self.head.sprite.x, self.head.sprite.y)
			local dx, dy = 0, 0

			if (cx > leftScrollBound) then
				dx = (cx - leftScrollBound) * -1
			elseif (cx < rightScrollBound) then
				dx = (cx - rightScrollBound) * -1
			end

			if (cy > bottomScrollBound) then
				dy = (cy - bottomScrollBound) * -1
			elseif (cy < topScrollBound) then
				dy = (cy - topScrollBound) * -1
			end
			if self.head.targetX and self.head.targetY then
				self.head.targetX = self.head.targetX + (dx * -1)
				self.head.targetY = self.head.targetY + (dy * -1)
			end
			self:moveCamera(dx, dy)
		end
	end
	if not singlePlayer then 
		self.scrollTimer = self:runTimer(5, scrollFunction, self.view, -1)
		self:pauseTimer(self.scrollTimer)
	end
end

function ServerSceneLoader:extendBackground()
	local cx, cy = self.view:contentToLocal(0, 0)
	
	local left = math.floor(cx / display.contentWidth) - 1
	local right = left + 3
	local top = math.floor(cy / display.contentHeight) - 1
	local bottom = top + 3

	for i=left, right do
		for j=top, bottom do
			local key = self:createBackgroundKey(i, j)
			if self.tilesFilled[key] == nil then
				self:createBackground(i, j)
			end
		end
	end
end

function ServerSceneLoader:createBackgroundKey(x, y)
	return "("..x..","..y..")"
end

function ServerSceneLoader:createBackground(x, y)
	local key = self:createBackgroundKey(x, y)

	local bx = x * display.contentWidth
	local by = y * display.contentHeight

	local background = display.newImageRect( "images/Background.png", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = bx, by

	self.tilesFilled[key] = true

	self:addDisplayObject(background)
	background:toBack()
	self:initializeZoneObstacles(x, y)
end

function ServerSceneLoader:cameraCoordinates(x, y)
	if (x ~= nil and y ~= nil and self.view ~= nil) then
		return self.view:localToContent(x, y)
	else 
		return 0, 0
	end
end

function ServerSceneLoader:initializeZoneObstacles(x, y)
	local zone = self.worldServer:getZone(x, y)
	local dx, dy = zone.worldPosition.x, zone.worldPosition.y

	local walls = zone.obstacles.walls or {}
	for i=#walls, 1, -1 do
		local wallx, wally = walls[i].x + dx, walls[i].y + dy
		local width, height = walls[i].width, walls[i].height
		local wall = Wall:new()
		wall:initialize(wallx, wally, width, height, self.physics, self)
	end
end

function ServerSceneLoader:initializeWorm()
	self.head = HeadWorm:new()
	local position = self.worldServer:randomWorldPosition()
	local x, y = position.x, position.y --self.centerX, self.centerY
	self.head:initialize(x, y, self.physics, self.foodTruck, self)
	self.head:initializeMotion()
end

function ServerSceneLoader:initializeRemoteWorm(wormState)
	local oids = {
		wormState[4].o,
		wormState[3].o,
		wormState[2].o,
		wormState[1].o
	}

	local headState = wormState[#wormState]
	local remoteHead = HeadWorm:new()
	remoteHead.oid = headState.o
	local x, y = headState.x, headState.y
	remoteHead:initialize(x, y, self.physics, self.foodTruck, self, oids)
end

function ServerSceneLoader:initializePhysics()
	self.physics = require( "physics" )
	self.physics.start(); self.physics.pause()

	self.touchListener = function( event )
		if ( event.phase == "began" or event.phase == "moved") then
			self.head.engaged = true
			local x, y = self.view:contentToLocal(event.x, event.y)
			self.head.targetX = x
			self.head.targetY = y
		elseif (event.phase == "ended" or event.phase == "cancelled") then
			self.head.engaged = false
    	end
    	return true
    end
end

function ServerSceneLoader:initializeGravity()
	physics.setGravity( 0, -19.6 )
	-- physics.setDrawMode( "hybrid" )
end

function ServerSceneLoader:initializeFoodTruck()
	self.foodTruck = FoodTruck:new()
	self.foodTruck:initialize(physics, {standardWorm = 100}, self)
	self.makeDelivery = function() 
		self:deliverLocalFood() 
	end
	self.foodTruckTimer = self:runTimer(self.foodTruck.interval, self.makeDelivery, self.foodTruck, -1)
	self:pauseTimer(self.foodTruckTimer)
end

function ServerSceneLoader:receiveRemoteFood(oid, x, y)
	self.foodTruck:remoteFood(oid, x, y)
end

function ServerSceneLoader:deliverLocalFood()
	local food = self.foodTruck:makeDelivery()
	self.worldServer:deliverFood(food)
end

function ServerSceneLoader:consumeFood(food)
	self.worldServer:consumeFood(self.head, food)
end