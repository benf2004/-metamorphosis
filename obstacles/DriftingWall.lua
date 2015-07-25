require("Base")
require("obstacles.Wall")

DriftingWall = Wall:new()

function DriftingWall:adjustVelocity()
	local velocity = self.velocity or -25.0
	if self.direction == "horizontal" then
		self.xVelocity = 0
		self.yVelocity = velocity
	else
		self.xVelocity = velocity
		self.yVelocity = 0
	end
	if self.box.setLinearVelocity then self.box:setLinearVelocity( self.xVelocity, self.yVelocity ) end
	if self.leftCap.setLinearVelocity then self.leftCap:setLinearVelocity( self.xVelocity, self.yVelocity ) end
	if self.rightCap.setLinearVelocity then self.rightCap:setLinearVelocity( self.xVelocity, self.yVelocity ) end
end

DriftingWallTruck  = Base:new()

function DriftingWallTruck:initialize(physics, interval, ramp, direction, screenW, screenH, sceneLoader)
	self.physics = physics
	self.interval = interval
	self.ramp = ramp
	self.direction = direction
	self.min = 100
	self.maxWidth = screenW * 0.73
	self.maxHeight = screenH * 0.73
	self.screenW = screenW
	self.screenH = screenH
	self.sceneLoader = sceneLoader
	self.contents = {}
	self.deliveryTimer = nil
	self:adjustVelocity()
end

function DriftingWallTruck:adjustVelocity()
	if self.interval > 1 then 
		self.interval = self.interval - self.ramp 
		self.velocity = -200 / self.interval 

		for i, driftingWall in pairs(self.contents) do 
			driftingWall.velocity = self.velocity
			driftingWall:adjustVelocity()
		end
	end
end

function DriftingWallTruck:makeDelivery()
	if self.direction == "horizontal" or self.direction == "both" then
		self:makeHorizontalWalls()
	end

	if self.direction == "vertical" or self.direction == "both" then
		self:makeVerticalWalls()
	end

	-- self:adjustVelocity()

	if not self.paused then
		local closure = function() self:makeDelivery() end
		deliveryTimer = timer.performWithDelay( self.interval * 1000, closure)
	end
end

function DriftingWallTruck:makeHorizontalWalls()
	local s1 = math.random( 100, self.maxWidth / 2)
	local s2 = math.random( s1 + 200, self.maxWidth - 100 )
	local height = 50
	local x1 = -25
	local x2 = s1 + 25
	local x3 = s2 + 25
	local y = self.screenH + 75
	local width1 = s1
	local width2 = s2 - s1 - 50
	local width3 = self.screenW - s2

	local driftingWall1 = DriftingWall:new()
	driftingWall1:initialize(x1, y, width1, height, self.physics, self.sceneLoader)
	driftingWall1.direction = "horizontal"
	driftingWall1.velocity = self.velocity
	driftingWall1:adjustVelocity()
	table.insert(self.contents, driftingWall1)

	local driftingWall2 = DriftingWall:new()
	driftingWall2:initialize(x2, y, width2, height, self.physics, self.sceneLoader)
	driftingWall2.direction = "horizontal"
	driftingWall2.velocity = self.velocity
	driftingWall2:adjustVelocity()
	table.insert(self.contents, driftingWall2)

	local driftingWall3 = DriftingWall:new()
	driftingWall3:initialize(x3, y, width3, height, self.physics, self.sceneLoader)
	driftingWall3.direction = "horizontal"
	driftingWall3.velocity = self.velocity
	driftingWall3:adjustVelocity()
	table.insert(self.contents, driftingWall3)
end

function DriftingWallTruck:makeVerticalWalls()
	local s1 = math.random( 100, self.maxHeight / 2)
	local s2 = math.random( s1 + 175, self.maxHeight - 100 )
	local width = 50
	local y1 = -25
	local y2 = s1 + 25
	local y3 = s2 + 25
	local x = self.screenW + 75
	local height1 = s1
	local height2 = s2 - s1 - 50
	local height3 = self.screenH - s2

	local driftingWall1 = DriftingWall:new()
	driftingWall1:initialize(x, y1, width, height1, self.physics, self.sceneLoader)
	driftingWall1.direction = "vertical"
	driftingWall1.velocity = self.velocity
	driftingWall1:adjustVelocity()
	table.insert(self.contents, driftingWall1)

	local driftingWall2 = DriftingWall:new()
	driftingWall2:initialize(x, y2, width, height2, self.physics, self.sceneLoader)
	driftingWall2.direction = "vertical"
	driftingWall2.velocity = self.velocity
	driftingWall2:adjustVelocity()
	table.insert(self.contents, driftingWall2)

	local driftingWall3 = DriftingWall:new()
	driftingWall3:initialize(x, y3, width, height3, self.physics, self.sceneLoader)
	driftingWall3.direction = "vertical"
	driftingWall3.velocity = self.velocity
	driftingWall3:adjustVelocity()
	table.insert(self.contents, driftingWall3)	
end

function DriftingWallTruck:pause()
	self.paused = true
	if deliveryTimer ~= nil then
		timer.cancel( deliveryTimer )
	end
end