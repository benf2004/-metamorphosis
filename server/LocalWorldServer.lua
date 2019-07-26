require("server.WorldServer")
require("server.ZoneManager")
require("server.NoobHub")
require("server.GameEvents")

LocalWorldServer = WorldServer:new()

function LocalWorldServer:initialize(sceneLoader)
	self.sceneLoader = sceneLoader
	self.zoneManager = ZoneManager:new()
	self.zoneManager:initialize()
	self.gameEvents = GameEvents:new()
	self.gameEvents:initialize(sceneLoader)
end

function LocalWorldServer:getZone(x, y)
	if self.zoneManager == nil then
		self.zoneManager = ZoneManager:new()
	end
	return self.zoneManager:getZone(x, y)
end

function LocalWorldServer:randomWorldPosition()
	return self.zoneManager:randomWorldPosition(0)
end

function LocalWorldServer:updateWormTarget(x, y)
	self.gameEvents:updateWormTarget(x, y)
end

function LocalWorldServer:deliverFood(food)
	self.gameEvents:deliverFood(food)
end

function LocalWorldServer:consumeFood(worm, food)
	self.gameEvents:sendConsumeFood(worm, food)
end

