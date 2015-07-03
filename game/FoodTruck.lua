require("Base")
require("worm.StandardWorm")
require("worm.GravityWorm")

FoodTruck  = Base:new()
local contents = {}

function FoodTruck:initialize( physics )
	self.physics = physics
end

function FoodTruck:makeDelivery(event)
	local x = math.random(0, display.contentWidth)
	local y = math.random(0, display.contentHeight)
	local food = GravityWorm:new()
	food:initialize( self.physics )
	food.sprite.x = x
	food.sprite.y = y
	table.insert(contents, food)
end

function FoodTruck:consumeFood(food)
	contents.remove(food)
end

function FoodTruck:empty()
	for i, food in pairs(contents) do
		if food.sprite ~= nil and food.sprite.removeSelf ~= nil then
			food.sprite:removeSelf( )
		end
	end
	contents = {}
end
