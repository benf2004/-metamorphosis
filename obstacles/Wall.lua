require("Base")
require("game.Colors")

Wall  = Base:new()

function Wall:initialize(x, y, width, height, physics, sceneGroup)
	if width >= height then
		local capRadius = height / 2
		width = width - height
		x = x + capRadius
		local leftCapCenterX, leftCapCenterY = x, y + capRadius
		local rightCapCenterX, rightCapCenterY = x + width, y + capRadius
		local boxCenterX, boxCenterY = x + (width / 2), y + (height / 2)

		local box = display.newRect( boxCenterX, boxCenterY, width, height )
		local leftCap = display.newCircle( leftCapCenterX, leftCapCenterY, capRadius )
		local rightCap = display.newCircle( rightCapCenterX, rightCapCenterY, capRadius )

		box.fill = colors.brown
		leftCap.fill = colors.brown
		rightCap.fill = colors.brown

		physics.addBody(box, "static", { friction = 0.0, bounce = 0.0 } )
		physics.addBody(leftCap, "static", { radius=capRadius, friction=0.0, bounce=0.0 } )
		physics.addBody(rightCap, "static", { radius=capRadius, friction=0.0, bounce=0.0 } )

		sceneGroup:insert(box)
		sceneGroup:insert(leftCap)
		sceneGroup:insert(rightCap)
	end
end