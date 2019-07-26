require("Base")
require("worm.StandardWorm")
require("worm.GravityWorm")
require("worm.AnchorWorm")
require("worm.ShieldWorm")
require("worm.PoisonWorm")
require("worm.ClockWorm")
require("worm.NinjaWorm")
require("worm.FireWorm")

FoodTruck  = Base:new()
local contents = {}

function FoodTruck:initialize( physics, config, sceneLoader, offsetX, offsetY )
	self.offsetX = offsetX or 0
	self.offsetY = offsetY or 0
	self.physics = physics
	self.sceneLoader = sceneLoader
	self.interval = config.interval or 3000

	self.worms = {
		{StandardWorm, config.standardWorm or 0},
		{GravityWorm, config.gravityWorm or 0},
		{AnchorWorm, config.anchorWorm or 0},
		{ShieldWorm, config.shieldWorm or 0},
		{PoisonWorm, config.poisonWorm or 0},
		{ClockWorm, config.clockWorm or 0},
		{NinjaWorm, config.ninjaWorm or 0},
		{FireWorm, config.fireWorm or 0}
	}

	local compare = function(a,b)
		return a[2] > b[2]
	end

	table.sort(self.worms, compare)
end

function FoodTruck:makeDelivery(event)
	local x = math.random(0, display.contentWidth) + self.offsetX
	local y = math.random(0, display.contentHeight) + self.offsetY

	local kind = math.random(1, 100)
	local food = nil

	for _,v in pairs(self.worms) do
		if v[2] >= kind then
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
	return food
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

function FoodTruck:remoteFood(oid, x, y)
	local food = StandardWorm:new()
	food:initialize( self.physics, self.sceneLoader )
	food.sprite.x = x
	food.sprite.y = y
	table.insert(contents, food)
end

function FoodTruck:fixedFood(x, y, count, delay)
	local f = function()
		for i=0, count do
			food = StandardWorm:new()
			food:initialize( self.physics, self.sceneLoader)
			local dx = 0
			local dy = 0
			if count > 1 then
				dx = math.random(0, 5)
				dy = math.random(0, 5)
			end
			food.sprite.x = x + dx + self.offsetX
			food.sprite.y = y + dy + self.offsetY
			table.insert(contents, food)
		end
	end
	self.sceneLoader:runTimer(delay, f)
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
