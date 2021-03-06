require("core.SceneBase")
require("core.CutScene")
require("game.FoodTruck")
require("game.Colors")
require("game.UI")
require("worm.HeadWorm")
require("worm.HungryWorm")
require("worm.AngryWorm")
require("worm.FlashlightWorm")
require("obstacles.Wall")
require("obstacles.Activator")
require("obstacles.FlyingActivator")
require("obstacles.DriftingWall")
require("obstacles.WaterCanon")
require("obstacles.FireSpout")
require("obstacles.MiniFireSpout")
require ("effects.Lightning")

SceneLoader  = SceneBase:new()

function SceneLoader:load()
	self.currentScene = currentScene
	self:initializePhysics()
	self:initializeBackground()
	self:initializeSkin()
	self:initializeLightning()
	self:initializeMusic()
	self:initializeFoodTruck()
	self:initializeWorm()
	self:initializeHungryWorms()
	self:initializeAngryWorms()
	self:initializeActivators()
	self:initializeFlyingActivators()
	self:initializeWalls()
	self:initializeWaterCanons()
	self:initializeFireSpout()
	self:initializeMiniFireSpout()
	self:initializeDriftingWallTruck()
	self:initializeHud()
	self:initializeGravity()
	self:initializeJointCheck()
	self:initializeFood()
end

function SceneLoader:launch()
	local audioToPlay = currentScene.backgroundMusic or "background"
	self:resetAllMusic()
	self:playAudio(audioToPlay)
	self:pauseAllMusic()

	local restarting = currentScene.restarting or false
	if restarting then
		currentScene.restarting = false
		self:start()
	else
		self:openModal()
	end
end

function SceneLoader:confirmConsumeFreePass(passLevel)
	local level = passLevel or currentLevel
	self:openModal("ConfirmConsumePass")
end

function SceneLoader:confirmPurchaseFreePass(passLevel)
	local level = passLevel or currentLevel
	self:openModal("ConfirmPurchasePass")
end

function SceneLoader:prepareForMenu()
	self.hud:cancelEndLevelModal()
	self.hud:removeAllDisplayObjects()
end

function SceneLoader:start()
	self.adManager:hideAd()
	self:addEventListener( "touch", self.touchListener )
	self.physics.start()
	self:resumeAllTimers()
	self:resumeAllMusic()

	if self.spouts ~= nil then
		for i=#self.spouts, 1, -1 do
			self.spouts[i]:unpause()
		end
	end

	self.head:initializeEffect()
end

function SceneLoader:pause()
	self.view:setMask(nil)
	self.physics.pause()
	self:removeEventListener( "touch", self.touchListener )
	self.head:pause()

	self:pauseAllTimers()
	self:removeAllGlobalEventListeners()
	self:pauseAllMusic()

	if self.spouts ~= nil then
		for i=#self.spouts, 1, -1 do
			self.spouts[i]:pause()
		end
	end	
end

function SceneLoader:restart()
	currentScene.restarting = true
	self:unload()
	self.hud:cancelEndLevelModal()
	self.hud:removeAllDisplayObjects()
	local sceneLoader = SceneLoader:new()
	self.scene:moveToScene(sceneLoader)
end

function SceneLoader:moveToNextLevel()
	self:unload()
	self.hud:cancelEndLevelModal()
	self.hud:removeAllDisplayObjects()

	currentLevel = currentLevel + 1
	currentScene = require( "scenes.Level" .. currentLevel)
	local lvl = "Level"..(currentLevel)
	currentScene.levelState = gameState[lvl]
	local sceneLoader = SceneLoader:new()
	self:hideAdvertisement()
	self.scene:moveToScene(sceneLoader)	
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
	local background = display.newImageRect( "images/Background.png", self.screenW, self.screenH )
	background.anchorX = 0
	background.anchorY = 0
	background:setFillColor( 1 )

	self:addDisplayObject(background)
end

function SceneLoader:initializeSkin()
	local threeStars = threeStars()
	if threeStars >= 15 then
		self.defaultSkin = BaseWorm.frameIndex.wild
	elseif threeStars >=12 then
		self.defaultSkin = BaseWorm.frameIndex.yingyang
	elseif threeStars >=9 then
		self.defaultSkin = BaseWorm.frameIndex.pieChart
	elseif threeStars >=6 then
		self.defaultSkin = BaseWorm.frameIndex.stripes
	elseif threeStars >=3 then
		self.defaultSkin = BaseWorm.frameIndex.dots
	else
		self.defaultSkin = BaseWorm.frameIndex.green
	end
end

function SceneLoader:initializeLightning()
	if currentScene.sceneEffect == "lightning" then
		self.lightning = Lightning:new()
		self.lightning:initialize (currentScene, self)
	end
end

function SceneLoader:initializeMusic()
	self:loadAudio("background", "audio/background1.mp3")
	-- self:loadAudio("stormyBackground", "audio/background2.mp3")
	self:loadAudio("happy", "audio/happy.mp3")
	self:loadAudio("gong", "audio/gong.wav")
	self:loadSound("pop", "audio/pop3.wav")
	self:loadSound("click", "audio/click.wav")
	self:loadSound("bang", "audio/rocket.wav")
	self:loadSound("squak", "audio/squak.wav")
	self:loadSound("ding", "audio/ding.mp3")
end

function SceneLoader:initializeFoodTruck()
	self.foodTruck = FoodTruck:new()
	self.foodTruck:initialize(physics, currentScene, self)
	self.makeDelivery = function() 
		self.foodTruck:makeDelivery() 
	end
	self.foodTruckTimer = self:runTimer(self.foodTruck.interval, self.makeDelivery, self.foodTruck, -1)
	self:pauseTimer(self.foodTruckTimer)
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

function SceneLoader:initializeFlyingActivators()
	if currentScene.flyingActivators then 
		self.flyingActivatorTruck = FlyingActivatorTruck:new()
		self.flyingActivatorTruck:initialize(currentScene, self)
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

function SceneLoader:initializeMiniFireSpout()
	self.spouts = self.spouts or {}
	local fireSpouts = currentScene.miniFireSpouts or {}
	for i, fireSpoutDefinition in ipairs(fireSpouts) do
		local x, y = fireSpoutDefinition.x, fireSpoutDefinition.y
		local rotation = fireSpoutDefinition.rotation or 0
		local rotating = fireSpoutDefinition.rotate or false
		local fireSpout = MiniFireSpout:new()
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

function SceneLoader:initializeFood()
	local standardWorms = currentScene.standardFood or {}
	for i, wormDef in ipairs(standardWorms) do
		local x = wormDef.x
		local y = wormDef.y
		local c = wormDef.count
		local d = wormDef.delay
		self.foodTruck:fixedFood(x, y, c, d)
	end
end

function SceneLoader:initializeDriftingWallTruck(sceneGroup)
	if currentScene.driftingWalls ~= nil then
		local interval = currentScene.driftingWalls.interval or 5
		local step = currentScene.driftingWalls.step or 0.3
		local direction = currentScene.driftingWalls.direction or "vertical"
		
		self.driftingWallTruck = DriftingWallTruck:new()

		self.driftingWallTruck:initialize(self.physics, interval, step, direction, self.screenW, self.screenH, self)

		local closure = function() 
			self.driftingWallTruck:makeDelivery() 
		end
		self.wallTruckTimer = self:runTimer(interval * 1000, closure, self.driftingWallTruck, -1)
		self:pauseTimer(self.wallTruckTimer)
		self.driftingWallTruck:makeDelivery()
	end
end

function SceneLoader:initializeHud(sceneGroup)
	require("game.HUD")
	self.hud = HUD:new()
	self.hud:initialize(self)

	self.hudTimer = self:runTimer(1000, self.hud.updateHud, self.hud, -1)
	self:pauseTimer(self.hudTimer)
end

function SceneLoader:initializeGravity()
	physics.setGravity( 0, -19.6 )
	-- physics.setDrawMode( "hybrid" )
end

function SceneLoader:initializeJointCheck()
	self.jointCheck = function()
		self.head:killBadJoints()
	end
	self.jointCheckTimer = self:runTimer(250, self.jointCheck, self.head, -1)
	self:pauseTimer(self.jointCheckTimer)
end