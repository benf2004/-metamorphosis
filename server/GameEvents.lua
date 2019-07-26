require("Base")
require("server.MessageRouter")

GameEvents = Base:new()

function GameEvents:initialize(sceneLoader)
	self.sceneLoader = sceneLoader

	--TODO ... look up game server and information
	local ipAddress = "54.152.47.245"
	local port = 1337
	local worldId = "Simple"

	self.bossServer = nil
	self.iamBoss = false

	self.messageRouter = MessageRouter:new()
	local callback = function(message)
		self:receive(message)
	end
	self.messageRouter:initialize(ipAddress, port, worldId, callback)
	local worldSyncCallback = function()
		self:synchronizeWorld()
	end
	self.syncClock = timer.performWithDelay(1000, worldSyncCallback, -1)

	local targetSyncCallback = function()
		self:synchronizeTarget()
	end
	self.targetClock = timer.performWithDelay(100, targetSyncCallback, -1)
end

function GameEvents:receive(message)
	if message.m == "ws" then
		self:updateWormState(message.s)
	elseif message.m == "wt" then
		self:updateWormTarget(message.t)
	elseif message.m == "df" then
		self:receiveFood(message)
	elseif message.m == "cf" then
		self:receiveConsumeFood(message)
	else
		self:printTable(message)
	end
end

function GameEvents:sendInBatch(message)
	self.messageRouter:sendInBatch(message)	
end

function GameEvents:sendBatch()
	self.messageRouter:sendBatch()
end

function GameEvents:sendImmediate(message)
	self.messageRouter:sendImmediate(message)
end

----------WORM STATE---------------
function GameEvents:sendWormState()
	local head = self.sceneLoader.head
	local wormState = head:wormState()
	local message = {
		m = "ws",
		s = wormState,
	}
	self:sendInBatch(message)
end

function GameEvents:updateWormState(wormState)
	local head = self.sceneLoader:getBaseObject(wormState[#wormState].o)
	if head == nil then
		self.sceneLoader:initializeRemoteWorm(wormState)
	end

	for i=#wormState, 1, -1 do 
		local ws = wormState[i]
		local seg = self.sceneLoader:getBaseObject(ws.o)
		if seg ~= nil then
			seg:reposition(ws.x, ws.y)
		end
	end
end

----------WORM TARGET---------------
function GameEvents:sendWormTarget()
	local head = self.sceneLoader.head
	local targetX, targetY = head:getTarget()
	local oid = head:getOid()
	local message = {
		m = "wt",
		t = {
			o = oid,
			x = math.round(targetX),
			y = math.round(targetY)
		}
	}
	self:sendInBatch(message)
end

function GameEvents:updateWormTarget(wormTarget)
	local head = self.sceneLoader:getBaseObject(wormTarget.o)
	if head ~= nil then
		head:moveToLocation(wormTarget.x, wormTarget.y)
	end
end

----------DELIVER FOOD---------------
function GameEvents:deliverFood(food)
	if food.sprite ~= nil and food.sprite.x ~= nil then
		local x, y = food.sprite.x, food.sprite.y
		local oid = food:getOid()
		local foodType = food.name
		local message = {
			m = "df",
			f = {
				o = oid,
				x = math.round(x),
				y = math.round(y)
			}
		}
		self:sendInBatch(message)
	end
end

function GameEvents:receiveFood(message)
	local x, y = message.f.x, message.f.y
	local oid = message.f.o
	self.sceneLoader:receiveRemoteFood(oid, x, y)
end

----------CONSUME FOOD---------------
function GameEvents:sendConsumeFood(worm, food)
	local headOid = worm:head():getOid()
	local foodOid = food:getOid()
	local message = {
		m = "cf",
		f = {
			w = headOid,
			f = foodOid
		}
	}
	self:sendImmediate(message)
end

function GameEvents:receiveConsumeFood(message)
	local foodOid = message.f.f
	local food = self.sceneLoader:getBaseObject(foodOid)
	if food ~= nil and food.consumed == false then
		local headOid = message.f.w
		local head = self.sceneLoader.getBaseObject(food)
		if head ~= nil and head.consume ~= nil then
			head:consume(food)
		end
	end
end

----------EVENTS---------------
function GameEvents:synchronizeWorld()
	-- if self.messageRouter:amIBoss() then
		self:sendWormState()
	-- end
end

function GameEvents:synchronizeTarget()
	self:sendWormTarget()
	self:sendBatch()
end



