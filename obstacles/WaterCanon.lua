require("obstacles.WaterSpout")

WaterCanon = WaterSpout:new()

function WaterCanon:initialize(x, y, sceneLoader)
	WaterSpout.initialize(self, x, y, sceneLoader )

	self.canon = display.newImageRect( "images/WaterCanon.png", 32, 32 )
	self.canon.anchorX = 0.5
	self.canon.anchorY = 0.5
	self.canon.x, self.canon.y = x, y
	self.sceneLoader:addDisplayObject(self.canon)

	physics.addBody( self.canon, "static")
end

function WaterCanon:setRotation(degrees)
	WaterSpout.setRotation(self, degrees)
	self.canon.rotation = degrees
end