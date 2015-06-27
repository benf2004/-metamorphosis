require("Base")

LengthObjective = Base:new()

local objective = currentScene.lengthObjective

function LengthObjective:met(worm)
	if worm:length >= objective then
		return true
	else
		return false
	end
end
