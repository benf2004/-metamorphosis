require("Base")
require("worm.StandardWorm")

FoodTruck  = Base:new()

function FoodTruck:initialize( physics )
	self.physics = physics
end

function FoodTruck:makeDelivery(event)
	local x = math.random(0, display.contentWidth)
	local y = math.random(0, display.contentHeight)
	local food = StandardWorm:new()
	food:initialize( self.physics )
	food.sprite.x = x
	food.sprite.y = y
end