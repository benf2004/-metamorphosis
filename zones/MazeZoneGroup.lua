require("Base")

MazeZoneGroup = Base:new()

function MazeZoneGroup:mazeWalls(width, height, zoneManager)
	local pixelWidth = width * zoneManager.zoneWidth
	local pixelHeight = height * zoneManager.zoneHeight

	local initialRadius = 100
	local channelWidth = 128
	local rings = (pixelHeight - initialRadius) / channelWidth

	print("Rings"..rings)

	local allWalls = {}

	for i=1, 4 do
		self:mazeBox(initialRadius + (i * channelWidth), allWalls)
	end

	return allWalls
end

function MazeZoneGroup:mazeBox(radius, allWalls)
	local entrance = math.random(1, 4)
	local wallLength = radius*2
	local wallWidth = 15
	local halfWidth = wallWidth / 2
	local adjustedPosition = radius - halfWidth

	for i=1, 4 do
		if i == 1 then
			if i == entrance then
				self:makeEntranceWalls(-radius, -radius, wallLength, wallWidth, allWalls)
			else
				self:makeWall(-radius, -radius, wallLength, wallWidth, allWalls)
			end
		elseif i == 2 then
			if i == entrance then
				self:makeEntranceWalls(adjustedPosition, -radius, wallWidth, wallLength, allWalls)
			else
				self:makeWall(adjustedPosition, -radius, wallWidth, wallLength, allWalls)
			end
		elseif i == 3 then
			if i == entrance then
				self:makeEntranceWalls(-radius, adjustedPosition, wallLength, wallWidth, allWalls)
			else
				self:makeWall(-radius, adjustedPosition, wallLength, wallWidth, allWalls)
			end
		else 
			if i == entrance then
				self:makeEntranceWalls(-radius, -radius, wallWidth, wallLength, allWalls)
			else
				self:makeWall(-radius, -radius, wallWidth, wallLength, allWalls)
			end
		end
	end
end

function MazeZoneGroup:makeWall(x, y, width, height, allWalls)
	local wall = {x = x, y = y, width = width, height = height}
	table.insert(allWalls, wall)
end

function MazeZoneGroup:makeEntranceWalls(x, y, width, height, allWalls)
	local splitWidth = 80
	local halfSplitWidth = splitWidth / 2
	if (width > height) then
		local splitAt = math.random(20, 80) * 0.01 * width
		local leftWall = {x = x, y = y, width = splitAt - halfSplitWidth, height = height}
		local rightWall = {x = x + splitAt + halfSplitWidth, y = y, width = width - splitAt - halfSplitWidth, height = height}
		table.insert(allWalls, leftWall)
		table.insert(allWalls, rightWall)
	else
		local splitAt = math.random(20, 80) * 0.01 * height
		local topWall = {x = x, y = y, height = splitAt - halfSplitWidth, width = width}
		local bottomWall = {y = y + splitAt + halfSplitWidth, x = x, height = height - splitAt - halfSplitWidth, width = width}
		table.insert(allWalls, topWall)
		table.insert(allWalls, bottomWall)
	end
end