require("core.SceneBase")
require("game.FoodTruck")
require("game.Colors")
require("game.UI")
require("worm.HeadWorm")
require("worm.HungryWorm")
require("worm.AngryWorm")
require("worm.FlashlightWorm")
require("obstacles.Wall")
require("obstacles.Activator")
require("obstacles.DriftingWall")
require("obstacles.WaterCanon")
require("obstacles.FireSpout")
require ("effects.Lightning")

SceneLoader  = SceneBase:new()

function SceneLoader:load()
	self:initializePhysics()
	self:initializeBackground()
	self:initializeLightning()
	self:initializeMusic()
	self:initializeFoodTruck()
	self:initializeWorm()
	self:initializeHungryWorms()
	self:initializeAngryWorms()
	self:initializeActivators()
	self:initializeWalls()
	self:initializeWaterCanons()
	self:initializeFireSpout()
	self:initializeDriftingWallTruck()
	self:initializeHud()
	self:initializeGravity()
	self:initializeJointCheck()
end

function SceneLoader:start()
	self:addEventListener( "touch", self.touchListener )
	self.physics.start()

	self.hudTimer = timer.performWithDelay( 1000, self.hud.updateHud, -1)
	self:addTimer(self.hudTimer)

	self.foodTruckTimer = timer.performWithDelay( 750, self.makeDelivery, -1 )
	self:addTimer(self.foodTruckTimer)

	self.jointCheckTimer = timer.performWithDelay( 250, self.jointCheck, -1)
	self:addTimer(self.jointCheckTimer)

	self:playAudio("background")
end

function SceneLoader:pause()
	self.view:setMask(nil)
	self.physics.pause()
	self:removeEventListener( "touch", self.touchListener )
	self.head:pause()

	self:removeAllTimers()

	if self.driftingWallTruck ~= nil then self.driftingWallTruck:pause() end

	if self.spouts ~= nil then
		for i=#self.spouts, 1, -1 do
			self.spouts[i]:pause()
		end
	end	
end

function SceneLoader:restart()
	self:unload()
	self.hud:removeAllDisplayObjects()
	display.remove(self.blackGroup)
	self.scene:moveToScene("core.CutScene")
end

function SceneLoader:menu()
	self:unload()
	self.hud:removeAllDisplayObjects()
	display.remove(self.blackGroup)
	self.scene:moveToScene("core.Menu")
end

function SceneLoader:initializePhysics()
	self.physics = require( "physics" )
	-- self.physics.setDrawMode("hybrid")
	self.physics.start(); self.physics.pause()

	self.touchListener = function( event )
		if ( event.phase == "began" ) then
			if (event.target.obj) then
				self.touchTarget = event.target.obj
			end
		elseif ( event.phase == "moved" ) then
			-- if self.touchTarget ~= nil and self.touchTarget.moveToLocation ~= nil then
			-- 	self.touchTarget:moveToLocation(event.x, event.y)
			-- else
				self.head:moveToLocation(event.x, event.y)
			-- end
		elseif (event.phase == "ended" or event.phase == "cancelled") then
			self.touchTarget = nil
    	end
    	return true
    end
end

function SceneLoader:initializeBackground()
	self.blackGroup = display.newGroup()
	local blackBase = display.newRect( self.centerX, self.centerY, self.screenW, self.screenH )
	blackBase:setFillColor( 0 )
	self.blackGroup:insert(blackBase)

	local background = display.newImageRect( "images/Background.png", self.screenW, self.screenH )
	background.anchorX = 0
	background.anchorY = 0
	background:setFillColor( 1 )

	self:addDisplayObject(blackBase)
	self:addDisplayObject(background)
end

function SceneLoader:initializeLightning()
	if currentScene.sceneEffect == "lightning" then
		self.lightning = Lightning:new()
		self.lightning:initialize (currentScene, self)
	end
end

function SceneLoader:initializeMusic()
	self:loadAudio("background", "audio/background1.mp3")
end

function SceneLoader:initializeFoodTruck()
	self.foodTruck = FoodTruck:new()
	self.foodTruck:initialize(physics, currentScene, self)
	self.makeDelivery = function() self.foodTruck:makeDelivery() end
end

function SceneLoader:initializeWorm()
	if currentScene.sceneEffect == "midnight" then
		self.head = FlashlightWorm:new()
	else
		self.head = HeadWorm:new()
	end
	local x, y = currentScene.worm.x, currentScene.worm.y
	self.head:initialize(x, y, self.physics, self.foodTruck, self)
	self.head:initializeMotion()
end

function SceneLoader:initializeHungryWorms()
	self.hungryWorms = {}
	local hungryWormsDefinitions = currentScene.hungryWorms or {}
	local speed = currentScene.hungryWormSpeed or 20
	for i, hungryWormDefinition in ipairs(hungryWormsDefinitions) do
		local hungryWorm = HungryWorm:new()
		local x, y = hungryWormDefinition[1], hungryWormDefinition[2]
		hungryWorm:initialize(x, y, self.physics, self.foodTruck, self)
		hungryWorm:initializeMotion(speed)
		table.insert(self.hungryWorms, hungryWorm)
	end
end

function SceneLoader:initializeAngryWorms()
	self.angryWorms = {}
	local angryWormsDefinitions = currentScene.angryWorms or {}
	local speed = currentScene.angryWormSpeed or 20
	for i, angryWormDefinition in ipairs(angryWormsDefinitions) do
		local angryWorm = AngryWorm:new()
		local x, y = angryWormDefinition[1], angryWormDefinition[2]
		angryWorm:initialize(x, y, self.physics, self.foodTruck, self)
		angryWorm:initializeMotion(speed, self.head)
		table.insert(self.angryWorms, angryWorm)
	end
end

function SceneLoader:initializeActivators()
	local activators = currentScene.activators or {}
	for i, activatorDefinition in ipairs(activators) do
		local activator = Activator:new()
		activator:initializeSprite(activatorDefinition[1], activatorDefinition[2], self)
		activator:initializePhysics(self.physics)
	end
end

function SceneLoader:initializeWaterCanons()
	self.spouts = self.spouts or {}
	local waterCanons = currentScene.waterCanons or {}
	for i, waterCanonDefinition in ipairs(waterCanons) do
		local x, y = waterCanonDefinition.x, waterCanonDefinition.y
		local rotation = waterCanonDefinition.rotation or 0
		local rotating = waterCanonDefinition.rotate or false
		local waterCanon = WaterCanon:new()
		waterCanon:initialize(x, y, self)
		waterCanon:setRotation( rotation )
		if rotating == true then waterCanon:rotate() end
		waterCanon:on()
		table.insert(self.spouts, waterCanon)
	end
end

function SceneLoader:initializeFireSpout()
	self.spouts = self.spouts or {}
	local fireSpouts = currentScene.fireSpouts or {}
	for i, fireSpoutDefinition in ipairs(fireSpouts) do
		local x, y = fireSpoutDefinition.x, fireSpoutDefinition.y
		local rotation = fireSpoutDefinition.rotation or 0
		local rotating = fireSpoutDefinition.rotate or false
		local fireSpout = FireSpout:new()
		fireSpout:initialize(x, y, self)
		fireSpout:setRotation( rotation )
		if rotating == true then fireSpout:rotate() end
		fireSpout:on()
		table.insert(self.spouts, fireSpout)
	end
end

function SceneLoader:initializeWalls()
	local walls = currentScene.walls or {}
	for i, wallDefinition in ipairs(walls) do
  		local wall = Wall:new()
  		wall:initialize(
  			wallDefinition[1],
 			wallDefinition[2],
 			wallDefinition[3],
 			wallDefinition[4], 
 			self.physics, self)
	end
end

function SceneLoader:initializeDriftingWallTruck(sceneGroup)
	if currentScene.driftingWalls ~= nil then
		local interval = currentScene.driftingWalls.interval or 5
		local step = currentScene.driftingWalls.step or 0.3
		local direction = currentScene.driftingWalls.direction or "vertical"
		
		self.driftingWallTruck = DriftingWallTruck:new()

		self.driftingWallTruck:initialize(self.physics, interval, step, direction, self.screenW, self.screenH, self)
		self.driftingWallTruck:makeDelivery()
	end
end

function SceneLoader:initializeHud(sceneGroup)
	require("game.HUD")
	self.hud = HUD:new()
	self.hud:initialize(self)
end

function SceneLoader:initializeGravity()
	physics.setGravity( 0, -19.6 )
	physics.setTimeStep( 0 )
	-- physics.setDrawMode( "hybrid" )
end

function SceneLoader:initializeJointCheck()
	self.jointCheck = function()
		self.head:killBadJoints()
	end
end
