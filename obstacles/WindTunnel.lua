require("Base")
require("effects.Effects")

WindTunnel  = Base:new()

local function onLocalCollision(self, event)
	local vent = self
	local other = event.other
	if other.xF == nil or other.yF == nil then other.xF, other.yF = 0, 0 end
	if ( event.phase == "began" and vent.isVent == true ) then
		if other.xF and other.yF and vent.xF and vent.yF then
    		other.xF = other.xF + vent.xF ; other.yF = other.yF + vent.yF
    	end
    	if other.windListener == nil then
    		other.windListener = function() 
   				if not ( other.xF == 0 and other.yF == 0 ) and other.applyForce ~= nil then
   					other:applyForce( other.xF, other.yF, other.x, other.y )
   				end
   			end
   		end
   		if other.obj ~= nil and other.obj.targetJoint ~= nil then 
   			other.obj.targetJoint.maxForce = other.obj.targetJoint.maxForce * 0.1
   		end
   		Runtime:addEventListener( "enterFrame", other.windListener )
   	elseif ( event.phase == "ended" and vent.isVent == true ) then
   		if other.xF ~= nil and other.yF ~= nil and vent.xF ~= nil and vent.yF ~= nil then
    		other.xF, other.yF = other.xF-vent.xF, other.yF-vent.yF
    	end

    	if other.windListener ~= nil then
    		Runtime:removeEventListener( "enterFrame", other.windListener )
    	end

    	if other.obj ~= nil and other.obj.targetJoint ~= nil then 
   			other.obj.targetJoint.maxForce = other.obj.targetJoint.maxForce * 10
   		end
   	end
end

function WindTunnel:initialize(sceneLoader, currentScene)
	self.sceneLoader = sceneLoader
	self.physics = sceneLoader.physics
	self.width = 100
	self.height = 50

	self.shape = display.newRect( 0, 0, 80, 300 )
	self.shape.anchorX, self.shape.anchorY = 0.5, 1
	self.shape:setFillColor( 0, 0, 0, 0 )
	self.physics.addBody(self.shape, "kinematic", { isSensor=true } )
	self.shape.isVent = true ; self.shape.rotation = 14 ; self.shape.x = 512 ; self.shape.y = 384
	self.shape.xF, self.shape.yF = self:getVentVals( self.shape.rotation, 120 )
	self.oscilation = 1

	self.shape.collision = onLocalCollision
	self.shape:addEventListener( "collision", self.shape )

	self.emitter = wind()
	self.emitter.rotation = self.shape.rotation
	self.emitter.x, self.emitter.y = self.shape.x, self.shape.y
	self:oscilate()
end	

function WindTunnel:getVentVals( angle, power )
   local xF = math.cos( (angle-90)*(math.pi/180) ) * power
   local yF = math.sin( (angle-90)*(math.pi/180) ) * power
   return xF,yF
end

function WindTunnel:oscilate()
	self.oscilationFunction = function()
		-- if self.oscilation > 0 and self.shape.rotation >= 90 then
		-- 	self.oscilation = self.oscilation * -1
		-- end

		-- if self.oscilation < 0 and self.shape.rotation <= -90 then
		-- 	self.oscilation = self.oscilation * -1
		-- end
		
		self.emitter.rotation = self.emitter.rotation + self.oscilation
		self.shape.rotation = self.shape.rotation + self.oscilation
		self.shape.xF, self.shape.yF = self:getVentVals( self.shape.rotation, 120 )
	end

	timer.performWithDelay( 30, self.oscilationFunction, -1 )
end