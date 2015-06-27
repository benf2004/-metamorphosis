local pex = require("effects.pex")

function explode(x, y)
	local particle = pex.load("effects/explosion.pex","effects/texture.png")
	local emitter = display.newEmitter(particle)
	emitter.x = x
	emitter.y = y

	local remove = function() emitter:removeSelf( ) end
	timer.performWithDelay( 1000, remove )
end
