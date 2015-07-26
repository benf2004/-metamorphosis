require("Base")

SceneBase  = Base:new()

function SceneBase:initialize(scene)
	self.scene = scene
	self.view = scene.view
	self.timers = {}
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
		print(self.timers[i])
		self:removeTimer(self.timers[i])
	end
end

function SceneBase:addEventListener(eventType, listener)
	self.view:addEventListener(eventType, listener)
end

function SceneBase:removeEventListener( eventType, listener )
	self.view:removeEventListener( eventType, listener )
end

function SceneBase:load() end
function SceneBase:start() end
function SceneBase:pause() end
function SceneBase:unload()
	self:removeAllDisplayObjects()
	self:removeAllTimers()
end


