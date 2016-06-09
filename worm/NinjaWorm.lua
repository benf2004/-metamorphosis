require("worm.BaseWorm")
require("game.Colors")
require("obstacles.FlyingActivator")

NinjaWorm = BaseWorm:new()

function NinjaWorm:initialize( physics, sceneLoader )
	self.defaultSkin = sceneLoader.defaultSkin

	self:initializeSprite(sceneLoader)
	self.type = "body"

	self.shieldSkin = BaseWorm.frameIndex.purple
	self:setSkin(self.frameIndex.poison)

	self:initializePhysics( physics )
	self.velocity = 10
	self.sprite.name = "NinjaWorm"
end

function NinjaWorm:attachAction()
	local wx = self.sceneLoader.head.sprite.x
	local wy = self.sceneLoader.head.sprite.y
	local nx = self.sceneLoader.head:trailing().sprite.x
	local ny = self.sceneLoader.head:trailing().sprite.y

	local d = self.diameter + 10
	local dx = wx-nx
	local dy = wy-ny
	local x = 0
	local y = d
	local cx = 0
	local cy = d
	if dx ~= 0 then
		local m = (wy-ny)/(wx-nx)
		cx = math.abs(d/math.sqrt(1+math.pow(m,2)))
		cy = math.abs(m*d/math.sqrt(1+math.pow(m,2)))
	end

	local targetx = x + cx
	local targety = y + cy

	if dx<0 then 
		x = wx-cx
		targetx = x - cx
	else
		x = cx+wx
		targetx = x + cx
	end

	if dy<0 then
		y = wy-cy
		targety = y - cy
	else
		y = cy+wy
		targety = y + cy
	end

	

	local flyingActivator = FlyingActivator:new()
	flyingActivator:initializeSprite(x, y, self.sceneLoader)
	flyingActivator:initializePhysics(self.sceneLoader.physics, self.sceneLoader.head, self.velocity, targetx, targety)
	self.isUsed = true	
end	