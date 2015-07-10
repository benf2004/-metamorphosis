require("Base")
require("worm.StandardWorm")
require("worm.GravityWorm")

FoodTruck  = Base:new()
local contents = {}

function FoodTruck:initialize( physics, level )
	self.physics = physics
	self.level = level
end

function FoodTruck:makeDelivery(event)
	local x = math.random(0, display.contentWidth)
	local y = math.random(0, display.contentHeight)
	local kind = math.random(1, 100)
	local food = nil
	if kind <= (self.level.foodTruck.standardWorm or 0) then
		food = StandardWorm:new()
	elseif kind <= (self.level.foodTruck.gravityWorm or 0) then
		food = GravityWorm:new()
	else
		food = StandardWorm:new()
	end
	food:initialize( self.physics )
	food.sprite.x = x
	food.sprite.y = y
	table.insert(contents, food)
	self:randomFood()
end

function FoodTruck:randomFood()
	if #contents > 1 then 
		local random = math.random(1, #contents)
		return contents[random]
	else
		return nil
	end
end

function FoodTruck:consumeFood(food)
	for i=#contents, 1, -1 do
		if contents[i] == food then
			table.remove(contents, i)
		end
	end
end

function FoodTruck:empty()
	for i, food in pairs(contents) do
		if food.sprite ~= nil and food.sprite.removeSelf ~= nil then
			food.sprite:removeSelf( )
		end
	end
	contents = {}
end
