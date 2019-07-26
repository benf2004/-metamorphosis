require("server.NoobHub")
require("Base")

MessageRouter = Base:new()

function MessageRouter:initialize(ipAddress, port, worldId, messageCallback)
	self.maxServerId = 999999
	self.serverId = math.random(self.maxServerId)
	self.hub = noobhub.new({ server = ipAddress; port = port; });
	self.hub:subscribe({
	  channel = worldId;  
	  callback = function(message)
	  	self:receiveMessage(message)
	  end;
	}); 
	self.messageCallback = messageCallback
	self.buffer = {}
	self.messageCache = {}
	self.activeServers = {}
	self.bossServer = nil
	self.lastSend = nil

	local cleanServersCallback = function()
		local threeSecondsAgo = (os.time() - 3)
		for key,value in pairs(self.activeServers) do
			if value ~= nil and value < threeSecondsAgo then
				self.activeServers[key] = nil
			end
		end
	end
	self.cleanServersClock = timer.performWithDelay(3000, cleanServersCallback, -1)

	local heartbeatCallback = function()
		local twoSecondsAgo = (os.time() - 2)
		if self.lastSend == nil or self.lastSend < twoSecondsAgo then
			self:sendHeartbeat()
		end
	end
	self.heartbeatClock = timer.performWithDelay(1000, heartbeatCallback, -1)
end

function MessageRouter:amIBoss()
	if self.serverId == self.bossServer then return true end

	local bossIsActive = false
	local minServerId = self.maxServerId
	local threeSecondsAgo = (os.time() - 3)
	for key, value in pairs(self.activeServers) do
		if value ~= nil and value >= threeSecondsAgo then
			if key < minServerId then minServerId = key end
			if self.bossServer == key then bossIsActive = true end
		end
	end
	if bossIsActive then 
		return false
	elseif minServerId == self.serverId then
		self.bossServer = true
		return true
	else 
		return false
	end
end	

function MessageRouter:sendImmediate(message)
	message.sid = self.serverId
	message.one = true
	self:send(message)
end

function MessageRouter:sendInBatch(message)
	-- local cached = self.messageCache[message.m]
	-- if message.m == 'hb' or cached == nil or self:equalTables(cached, message) == false then
		-- self.messageCache[message.m] = message
		table.insert(self.buffer, message)
	-- end
end

function MessageRouter:sendBatch()
	local messageBatch = self.buffer
	self.buffer = {}
	if #messageBatch > 0 then
		local message = {
			sid = self.serverId,
			batch = messageBatch
		}
		self:send(message)
	end
end

function MessageRouter:send(message)
	self.lastSend = os.time()
	self.hub:publish({
		message = message
	})
end

function MessageRouter:receiveOneMessage(message)
	self.messageCallback(message)
end

function MessageRouter:receiveBatchMessage(message)
	if message ~= nil and message.batch ~= nil then
		local messageBatch = message.batch
		for i=1,#messageBatch do
			local message = messageBatch[i]
	        self:receiveOneMessage(message)
	    end
	else
		self:printTable(message)
	end
end

function MessageRouter:receiveMessage(message)
	self.activeServers[message.sid] = os.time()
	if message.sid ~= self.serverId then
		if message.one and message.one == true then
			self:receiveOneMessage(message)
		else
			self:receiveBatchMessage(message)
		end
	end
end

function MessageRouter:sendHeartbeat()
	local message = {
		m = "hb"
	}
	self:sendInBatch(message)
end
