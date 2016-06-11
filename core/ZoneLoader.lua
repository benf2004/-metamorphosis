require("core.SceneLoader")

ZoneLoader  = SceneLoader:new()

function ZoneLoader:load()
	local selectedScene = currentScene
	self.currentScene = selectedScene
	self:initializeJoystick()
	self:initializePhysics()
	self:initializeBackground()
	self:initializeSkin()
	self:initializeLightning()
	self:initializeMusic()
	self:initializeFoodTruck()
	self:initializeWorm()
	self:initializeHud()
	self:initializeGravity()
	self:initializeJointCheck()


	self.zones = require("zones.WorldZones")

	for i, zone in ipairs(self.zones) do
		self.offsetx = 1024 * i
		self.offsety = 0
		currentScene = zone.config
		self.currentScene = currentScene
	  	self:initializeHungryWorms()
		self:initializeAngryWorms()
		self:initializeActivators()
		self:initializeFlyingActivators()
		self:initializeWalls()
		self:initializeWaterCanons()
		self:initializeFireSpout()
		self:initializeMiniFireSpout()
		self:initializeDriftingWallTruck()
		self:initializeFood()
	end
	self.currentScene = selectedScene
	currentScene = selectedScene
end

function ZoneLoader:offsetPosition(x, y)
	return x + self.offsetx, y + self.offsety
end