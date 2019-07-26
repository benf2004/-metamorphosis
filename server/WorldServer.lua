require("Base")

WorldServer = Base:new()

function WorldServer:intialize()
end

-- Get the current state of a zone
-- zone.x, zone.y
function WorldServer:getZone(zone)
end

-- Add a worm to the world
function WorldServer:joinWorld(worm)
end

function WorldServer:synchronize(worldView, callback)
end

function WorldServer:postWorldView(worldView)
end

function WorldServer:getWorldView(worldPosition)
end

function WorldServer:publishLocationAndTarget(headX, headY, targetX, targetY)
end