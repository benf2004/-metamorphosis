require("Base")

SceneBase  = Base:new()

function SceneBase:initialize(scene)
	self.adManager = adManager
	self.scene = scene
	self.view = scene.view
	self.timers = {}
	self.globalListeners = {}
	self.audio = {}
	self.screenW = display.contentWidth
	self.screenH = display.contentHeight
	self.centerX = self.screenW / 2
	self.centerY = self.screenH / 2
end

function SceneBase:addDisplayObject(displayObject)
	if self.view.insert ~= nil then
		self.view:insert(displayObject)
	end
end

function SceneBase:removeDisplayObject(displayObject)
	if displayObject.removeSelf ~= nil then 
		displayObject:removeSelf( )
	end
	displayObject = nil
end

function SceneBase:removeAllDisplayObjects()
	for i=#self.view, 1, -1 do
		self:removeDisplayObject(self.view[i])
	end
end

function SceneBase:runTimer(delay, listener, targets, iterations)
	local function onTimer(event)
		if (listener ~= nil) then
			listener()
		end
		local params = event.source.params
		if params.iterations ~= nil then
			if params.iterations > 0 then
				params.iterations = params.iterations - 1
				if params.iterations == 0 then
					self:removeTimer(event.source)
				end
			end
		else
			self:removeTimer(event.source)
		end
	end

	local timerId = timer.performWithDelay( delay, onTimer, iterations )
	timerId.params = {targets = targets, iterations = iterations}
	self:addTimer(timerId)
	return timerId
end

function SceneBase:addTimer(timerId)
	table.insert( self.timers, timerId )
end

function SceneBase:pauseTimer(timerId)
	-- if timerId.paused == nil or timerId.paused == false then
		timer.pause(timerId)
		-- timerId.paused = true		
	-- end
end

function SceneBase:pauseAllTimers()
	for i=#self.timers, 1, -1 do
		self:pauseTimer(self.timers[i])
	end
end

function SceneBase:resumeTimer(timerId)
	-- if timerId.paused then
		timer.resume(timerId)
		-- timerId.paused = false
	-- end
end

function SceneBase:resumeAllTimers()
	for i=#self.timers, 1, -1 do
		self:resumeTimer(self.timers[i])
	end
end

function SceneBase:removeTimer(timerId)
	timer.cancel( timerId )
	for i=#self.timers, 1, -1 do
		if self.timers[i] == timerId then
			table.remove( self.timers, i )
		end
	end
	timerId = nil
end

function SceneBase:removeAllTimers()
	for i=#self.timers, 1, -1 do
		self:removeTimer(self.timers[i])
	end
end

function SceneBase:addEventListener(eventType, listener)
	self.view:addEventListener(eventType, listener)
end

function SceneBase:removeEventListener( eventType, listener )
	self.view:removeEventListener( eventType, listener )
end

function SceneBase:loadSound( name, audioFile )
	self.audio[name] = audio.loadSound( audioFile )
end

function SceneBase:playSound(name)
	audio.play(self.audio[name])
end

function SceneBase:loadAudio( name, audioFile )
	self.audio[name] = audio.loadStream( audioFile )
end

function SceneBase:playAudio( name, loops)
	audio.play(self.audio[name], { channel=30, loops=-1 })
end

function SceneBase:pauseAllMusic()
	-- for i=32, 1, -1 do
	-- 	if audio.isChannelPlaying( i ) then
	-- 		audio.pause( i )
	-- 	end
	-- end
	audio.pause(30)
end

function SceneBase:resumeAllMusic()
	for i=32, 1, -1 do
		if audio.isChannelPaused( i ) then
			audio.resume( i )
		end
	end
end

function SceneBase:resetAllMusic()
	for i=32, 1, -1 do
		if audio.isChannelPaused( i ) then
			audio.rewind( i )
		end
	end
end

function SceneBase:addGlobalEventListener( event, funct )
	local tuple = {event, funct}
	table.insert(self.globalListeners, tuple)
	Runtime:addEventListener( event, funct )
end

function SceneBase:removeGlobalEventListener( event, funct )
	Runtime:removeEventListener( event, funct )
end

function SceneBase:removeAllGlobalEventListeners( )
	for i=#self.globalListeners, 1, -1 do
		self:removeGlobalEventListener(self.globalListeners[i])
	end
end

function SceneBase:openModal()
	self.scene:openModal()
end

function SceneBase:load() end
function SceneBase:launch() 
	self:start()
end
function SceneBase:start() end
function SceneBase:pause() end
function SceneBase:unload()
	self:removeAllGlobalEventListeners()
	self:removeAllTimers()
	self:removeAllDisplayObjects()
end

function SceneBase:showAdvertisement()
	local currentTime = os.time()
	print("Current time is ", currentTime)
	local timeSinceLastVideoAd = currentTime - lastVideoAdTime
	if timeSinceLastVideoAd >= timeBetweenVideoAds then
		print("Showing a video ad.")
		self.adManager:showVideoAd()
	else 
		print("Showing a banner ad.  Time remaining until video ad (seconds)", (timeBetweenVideoAds - timeSinceLastVideoAd))
		self.adManager:showBannerAd(0, 768)
	end
end

function SceneBase:hideAdvertisement()
	self.adManager:hideAd()
end


