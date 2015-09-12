require("Base")
require("worm.StandardWorm")
require("worm.GravityWorm")
require("worm.AnchorWorm")
require("worm.ShieldWorm")
require("worm.PoisonWorm")

FoodTruck  = Base:new()
local contents = {}

function FoodTruck:initialize( physics, level, sceneLoader )
	self.physics = physics
	self.level = level
	self.sceneLoader = sceneLoader

	self.worms = {
		{StandardWorm, self.level.foodTruck.standardWorm or 0},
		{GravityWorm, self.level.foodTruck.gravityWorm or 0},
		{AnchorWorm, self.level.foodTruck.anchorWorm or 0},
		{ShieldWorm, self.level.foodTruck.shieldWorm or 0},
		{PoisonWorm, self.level.foodTruck.poisonWorm or 0}
	}

	local compare = function(a,b)
		return a[2] > b[2]
	end

	table.sort(self.worms, compare)
end

function FoodTruck:makeDelivery(event)
	local x = math.random(0, display.contentWidth)
	local y = math.random(0, display.contentHeight)
	local kind = math.random(1, 100)
	local food = nil

	for _,v in pairs(self.worms) do
		if v[2] > kind then
			food = v[1]:new()
			break
		else
			kind = kind - v[2]
		end
	end

	if food == nil then
		food = StandardWorm:new()
	end

	food:initialize( self.physics, self.sceneLoader )
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
			self:consumeFood(food)
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
