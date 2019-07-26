require("Base")
require("zones.MazeZoneGroup")

ZoneManager = Base:new()

function ZoneManager:initialize()
	self.zones = {}
	self.zoneHeight = 768
	self.zoneWidth = 1024
end

function ZoneManager:randomZone(span)
	local x = math.random(-span, span)
	local y = math.random(-span, span)
	return {
		x = x,
		y = y
	}
end

function ZoneManager:randomWorldPosition(span)
	local zone = self:randomZone(span)
	local x = math.random(0, self.zoneWidth)
	local y = math.random(0, self.zoneHeight)
	return self:worldPosition(zone.x, zone.y, x, y)
end

function ZoneManager:worldPosition(zonex, zoney, zx, zy)
	local x = (zonex * self.zoneWidth) + zx
	local y = (zoney * self.zoneHeight) + zy
	return {
		x = x,
		y = y
	}
end

function ZoneManager:zonePosition(x, y)
	local zonex = math.floor(x / self.zoneWidth)
	local zoney = math.floor(y / self.zoneHeight)
	local zx = x % self.zoneWidth
	local zy = y % self.zoneHeight

	return {
		zone = {
			x = zonex,
			y = zoney
		},
		offset = {
			x = zx,
			y = zy
		}
	}
end

function ZoneManager:getZone(x, y)
	local zoneKey = self:zoneKey(x, y)
	if self.zones[zoneKey] == nil then
		self.zones[zoneKey] = self:emptyZone(x, y) --self:generateRandomZone(x, y)
	end
	return self.zones[zoneKey]
end

function ZoneManager:zoneKey(x, y)
	return "("..x..","..y..")"
end

function ZoneManager:loadMazeZoneGroup(x, y)
	for i=x-1, x+1 do
		for j=y-1, y+1 do
			local zoneKey = self:zoneKey(i, j)
			self.zones[zoneKey] = self:emptyZone(i, j)
		end
	end

	local mazeZoneGroup = MazeZoneGroup:new()
	local centralZone = {
		zonePosition = {
			x = x,
			y = y
		},
		worldPosition = self:worldPosition(x, y, 0, 0),
		obstacles = {
			walls = mazeZoneGroup:mazeWalls(3, 3, self)
		}
	}
	local zoneKey = self:zoneKey(x, y)
	self.zones[zoneKey] = centralZone
	return centralZone
end

function ZoneManager:emptyZone(x, y)
	return {
		zonePosition = {x = x, y = y},
		worldPosition = self:worldPosition(x, y, 0, 0),
		obstacles = {}
	}
end

function ZoneManager:generateRandomZone(x, y)
	return {
		zonePosition = {
			x = x,
			y = y
		},
		worldPosition = self:worldPosition(x, y, 0, 0),
		obstacles = self:generateRandomObstacles()
	}
end

function ZoneManager:generateRandomObstacles()
	local walls = self:randomWalls()

	return {
		walls = walls
	}
end

function ZoneManager:randomWalls()
	local wallCount = math.random(1, 4)
	local walls = {}
	for i=1, wallCount do
		table.insert(walls, self:randomWall())
	end
	return walls
end

function ZoneManager:randomWall()
	local x = math.random(0, self.zoneWidth)
	local y = math.random(0, self.zoneHeight)
	local width = 35
	local height = math.random(0, self.zoneHeight / 2)
	if height < 35 then height = 35 end

	local orientation = math.random(0, 1)
	if orientation == 1 then
		width = height
		height = 35
	end

	return {
		x = x,
		y = y,
		width = width,
		height = height
	}
end

