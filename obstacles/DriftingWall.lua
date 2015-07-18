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

function DriftingWallTruck:initialize(physics, interval, ramp, minWidth, maxWidth, screenW, screenH, sceneLoader)
	self.physics = physics
	self.interval = interval
	self.ramp = ramp
	self.minWidth = minWidth
	self.maxWidth = maxWidth
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
	driftingWall1.velocity = self.velocity
	driftingWall1:adjustVelocity()
	table.insert(self.contents, driftingWall1)

	local driftingWall2 = DriftingWall:new()
	driftingWall2:initialize(x2, y, width2, height, self.physics, self.sceneLoader)
	driftingWall2.velocity = self.velocity
	driftingWall2:adjustVelocity()
	table.insert(self.contents, driftingWall2)

	local driftingWall3 = DriftingWall:new()
	driftingWall3:initialize(x3, y, width3, height, self.physics, self.sceneLoader)
	driftingWall3.velocity = self.velocity
	driftingWall3:adjustVelocity()
	table.insert(self.contents, driftingWall3)	

	-- self:adjustVelocity()

	if not self.paused then
		local closure = function() self:makeDelivery() end
		deliveryTimer = timer.performWithDelay( self.interval * 1000, closure)
	end
end

function DriftingWallTruck:pause()
	self.paused = true
	if deliveryTimer ~= nil then
		timer.cancel( deliveryTimer )
	end
end