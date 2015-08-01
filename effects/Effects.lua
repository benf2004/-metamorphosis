local pex = require("effects.pex")

function createEmitter(fileName, x, y, lifespan)
	local particle = pex.load(fileName, "effects/texture.png")
	local emitter = display.newEmitter( particle )
	emitter.x = x
	emitter.y = y

	local completeEmission = function() complete(emitter) end
	timer.performWithDelay(lifespan, completeEmission)
	return emitter
end

function complete(emitter)
	local remove = function()
		if emitter.removeSelf ~= nil then
			emitter:removeSelf()
		end
	end
	if emitter.stop ~= nil then 
		emitter:stop()
	end
	timer.performWithDelay( 3000, remove, 1 )
end

function explode(x, y)
	createEmitter("effects/explosion.pex", x, y, 200)
end

function fireflies(x, y)
	createEmitter("effects/fireflies.pex", x, y, 750)
end

function heartExplosion(x, y)
	createEmitter("effects/hearts.pex", x, y, 1000)
end

function heartSwirl(x, y)
	createEmitter("effects/heartswirl.pex", x, y, 500)
end

function wind(x, y)
	return createEmitter("effects/wind.pex", x, y, 60000)
end