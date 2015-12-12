require("Base")
require("effects.Effects")

Spout  = Base:new()

function Spout:initializeSpout(effect, x, y, width, height, power, sceneLoader)
	self.sceneLoader = sceneLoader
	self.physics = sceneLoader.physics
	self.power = power

	local halfWidth, halfHeight = (width / 2), (height/2)

	--initialize sensor shape
	local vertices = {x,y,  x-halfWidth,y-height,   x+halfWidth, y-height }
	self.sensor = display.newPolygon( x, y, vertices )
	self.sensor.anchorX, self.sensor.anchorY = 0.5, 1
	self.sensor:setFillColor( 0, 0, 0, 0)
	self.sceneLoader:addDisplayObject(self.sensor)

	--initialize sensor
	self.edges = {0,halfHeight,  -halfWidth,-halfHeight,  halfWidth,-halfHeight}
	self.sensor.isSpout = true
	self.sensor.obj = self

	--initialize emitter
	local pex = require("effects.pex")
	local particle = pex.load(effect, "effects/texture.png")
	self.emitter = display.newEmitter( particle )
	self.emitter.x = x
	self.emitter.y = y
	self.sceneLoader:addDisplayObject(self.emitter)
	self.emitter:stop()

	--initialize stack
	self.stack = {}

	--initialize forces
	self.xF, self.yF = self:sprayForce()
end

local function collide(sensor, event)
	local self = sensor.obj
	local other = event.other
	if event.phase == "began" then
		self:addToStack(other)
		self:spray(other)
	elseif event.phase == "ended" then
		self:unspray(other)
		self:removeFromStack(other)
	end
end

function Spout:on()
	self.physics.addBody(self.sensor, "kinematic", {isSensor=true, shape=self.edges})
	self.sensor.collision = collide
	if self.sensor.addEventListener ~= nil then
		self.sensor:addEventListener( "collision", self.sensor )
		self.emitter:start()
	end
end

function Spout:off()
	self:clearStack()
	self.physics.removeBody(self.sensor)
	self.sensor.collision = nil
	if self.sensor.removeEventListener ~= nil then
		self.sensor:removeEventListener( "collision", self.sensor )
		self.emitter:stop()
	end
end

function Spout:addToStack(object)
	table.insert(self.stack, object)
end

function Spout:removeFromStack(object)
	for i,element in ipairs(self.stack) do
		if element == object then
			table.remove(self.stack, i)
		end
	end
end

function Spout:clearStack()
	for i=#self.stack, 1, -1 do	
		local event = {}
		event.other = self.stack[i]
		event.phase = "ended"
		self.sensor:collision(event)
	end
end

function Spout:sprayForce()
	local angle = self.sensor.rotation
	local xF = math.cos( (angle-90)*(math.pi/180) ) * self.power
 	local yF = math.sin( (angle-90)*(math.pi/180) ) * self.power
 	return xF,yF
 end

function Spout:spray(object)
end

function Spout:unspray(object)
end

function Spout:setRotation(degrees)
	self.emitter.rotation = degrees
	self.sensor.rotation = degrees
	self.xF, self.yF = self:sprayForce()
end

function Spout:rotate()
	if (self.rotator ~= nil) then timer.cancel( self.rotator ) end
	self.rotationFunction = function()
		self:setRotation(self.sensor.rotation + 1)
	end
	self.rotator = self.sceneLoader:runTimer(30, self.rotationFunction, {self, self.sensor}, -1)
end

function Spout:moveToLocation(x, y)
	self.sensor.x = x
	self.sensor.y = y
	self.emitter.x = x
	self.emitter.y = y
end

function Spout:pause()
	self:off()
	if (self.rotator ~= nil) then
		timer.cancel( self.rotator )
	end
end

function Spout:unpause()
	if (self.rotator ~= nil) then
		self:rotate()
	end
	self:on()
end
