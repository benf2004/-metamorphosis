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
end

function FoodTruck:randomFood(attempt)
	if attempt == nil then attempt = 1 end
	if attempt > 5 then return nil end
	if #contents > 1 then 
		local random = math.random(1, #contents)
		local food = contents[random]
		if food:onScreen() then 
			return contents[random]
		else
			return self:randomFood(attempt + 1)
		end
	else
		return nil
	end
end

function FoodTruck:addFreeBody(food)
	table.insert(contents, food)
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
		food:removeSelf()
	end
	contents = {}
end
