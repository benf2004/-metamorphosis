require("Base")
require("obstacles.Wall")

DriftingWall = Wall:new()

function DriftingWall:adjustVelocity()
	local velocity = self.velocity or -25.0
	if self.box.setLinearVelocity then self.box:setLinearVelocity( 0, velocity ) end
	if self.leftCap.setLinearVelocity then self.leftCap:setLinearVelocity( 0, velocity ) end
	if self.rightCap.setLinearVelocity then self.rightCap:setLinearVelocity( 0, velocity ) end
end

DriftingWallTruck  = Base:new()
local contents = {}

function DriftingWallTruck:initialize(physics, interval, ramp, minWidth, maxWidth, screenW, screenH, sceneGroup)
	self.physics = physics
	self.interval = interval
	self.ramp = ramp
	self.minWidth = minWidth
	self.maxWidth = maxWidth
	self.screenW = screenW
	self.screenH = screenH
	self.sceneGroup = sceneGroup
	self:adjustVelocity()
end

function DriftingWallTruck:adjustVelocity()
	if self.interval > 1 then 
		self.interval = self.interval - self.ramp 
		self.velocity = -150 / self.interval 

		print(self.interval)
		print(self.velocity)

		for i, driftingWall in pairs(contents) do 
			driftingWall.velocity = self.velocity
			driftingWall:adjustVelocity()
		end
	end
end

function DriftingWallTruck:makeDelivery()
	local split = math.random( self.minWidth, self.maxWidth)
	local height = 50
	local x1 = 0
	local x2 = x1 + split + 25
	local y = self.screenH + 75
	local width1 = x1 + split - 25
	local width2 = self.screenW - x2

	local driftingWall1 = DriftingWall:new()
	driftingWall1:initialize(x1-50, y, width1, height, self.physics, self.sceneGroup)
	driftingWall1.velocity = self.velocity
	driftingWall1:adjustVelocity()
	table.insert(contents, driftingWall1)

	local driftingWall2 = DriftingWall:new()
	driftingWall2:initialize(x2, y, width2 + 50, height, self.physics, self.sceneGroup)
	driftingWall2.velocity = self.velocity
	driftingWall2:adjustVelocity()
	table.insert(contents, driftingWall2)

	self:adjustVelocity()

	if not self.paused then
		local closure = function() self:makeDelivery() end
		timer.performWithDelay( self.interval * 1000, closure)
	end
end

function DriftingWallTruck:pause()
	self.paused = true
end

function DriftingWallTruck:empty()
	for i, driftingWall in pairs(contents) do 
		driftingWall:removeSelf()
	end
end