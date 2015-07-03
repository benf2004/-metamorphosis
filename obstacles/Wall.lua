require("Base")

Wall  = Base:new()

function Wall:initializeSprite(x, y, width, height, textureName)
	self.sprite = display.newImageRect( "images/"..textureName..".png", width, height )
	self.sprite.x, self.sprite.y = x, y
	self.sprite.obj = self
end

function Wall:initializePhysics(physics)
	physics.addBody( self.sprite, "static", { density=1000, friction=0, bounce=0})
	self.physics = physics
	self.sprite.gravityScale = 0
	self.sprite.name = "wall"
end