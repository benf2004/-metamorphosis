require("Base")
require("game.Colors")

Wall  = Base:new()

function Wall:initialize(x, y, width, height, physics, sceneGroup)
	local leftCapCenterX, leftCapCenterY = nil, nil
	local rightCapCenterX, rightCapCenterY = nil, nil
	local boxCenterX, boxCenterY = nil, nil
	local capRadius = nil

	if width >= height then
		capRadius = height / 2
		width = width - height
		x = x + capRadius
		leftCapCenterX, leftCapCenterY = x, y + capRadius
		rightCapCenterX, rightCapCenterY = x + width, y + capRadius
		boxCenterX, boxCenterY = x + (width / 2), y + (height / 2)
	else
		capRadius = width / 2
		height = height - width
		y = y + capRadius
		leftCapCenterX, leftCapCenterY = x + capRadius, y
		rightCapCenterX, rightCapCenterY = x + capRadius, y + height
		boxCenterX, boxCenterY = x + (width / 2), y + (height / 2)
	end

	self.box = display.newRect( boxCenterX, boxCenterY, width, height )
	self.leftCap = display.newCircle( leftCapCenterX, leftCapCenterY, capRadius )
	self.rightCap = display.newCircle( rightCapCenterX, rightCapCenterY, capRadius )

	self.box.fill = colors.brown
	self.leftCap.fill = colors.brown
	self.rightCap.fill = colors.brown

	physics.addBody(self.box, "kinematic", { friction = 0.0, bounce = 0.0 } )
	physics.addBody(self.leftCap, "kinematic", { radius=capRadius, friction=0.0, bounce=0.0 } )
	physics.addBody(self.rightCap, "kinematic", { radius=capRadius, friction=0.0, bounce=0.0 } )

	sceneGroup:insert(self.box)
	sceneGroup:insert(self.leftCap)
	sceneGroup:insert(self.rightCap)
end