require("Base")
require("obstacles.Wall")

DriftingWall = Wall:new()

function DriftingWall:initializeAction()
	local velocity = self.velocity or -25.0
	self.box:setLinearVelocity( 0, velocity )
	self.leftCap:setLinearVelocity( 0, velocity )
	self.rightCap:setLinearVelocity( 0, velocity )
end

DriftingWallTruck  = Base:new()

function DriftingWallTruck:initialize(physics, velocity, minWidth, maxWidth, screenW, screenH, sceneGroup)
	self.physics = physics
	self.velocity = velocity
	self.minWidth = minWidth
	self.maxWidth = maxWidth
	self.screenW = screenW
	self.screenH = screenH
	self.sceneGroup = sceneGroup
end

function DriftingWallTruck:makeDelivery()
	local width = math.random( self.minWidth, self.maxWidth )
	local height = 50
	local x = math.random( 0, self.screenW - width )
	local y = self.screenH + 75
	local driftingWall = DriftingWall:new()
	driftingWall:initialize(x, y, width, height, self.physics, self.sceneGroup)
	driftingWall:initializeAction()
end