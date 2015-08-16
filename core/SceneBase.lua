require("Base")

SceneBase  = Base:new()

function SceneBase:initialize(scene)
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
	self.view:insert(displayObject)
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

function SceneBase:addTimer(timerId)
	table.insert( self.timers, timerId )
end

function SceneBase:pauseTimer(timerId)
	timer.pause(timerId)
end

function SceneBase:pauseAllTimers()
	for i=#self.timers, 1, -1 do
		self:pauseTimer(self.timers[i])
	end
end

function SceneBase:resumeTimer(timerId)
	timer.resume(timerId)
end

function SceneBase:resumeAllTimers()
	for i=#self.timers, 1, -1 do
		self:resumeTimer(self.timers[i])
	end
end

function SceneBase:removeTimer(timerId)
	for i=#self.timers, 1, -1 do
		if self.timers[i] == timerId then
			table.remove( self.timers, i )
		end
	end
	timer.cancel( timerId )
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

function SceneBase:loadAudio( name, audioFile )
	self.audio[name] = audio.loadStream( audioFile )
end

function SceneBase:playAudio( name, loops)
	return audio.play(self.audio[name], { channel=1, loops=-1 })
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
	self:removeAllDisplayObjects()
	self:removeAllTimers()
	self:removeAllGlobalEventListeners()
end


