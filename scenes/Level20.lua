local level = {
	worm = {
		x = 100,
		y = 374
	},
	foodTruck = {
		standardWorm = 100
	},
	driftingWalls = {
		direction = "both",
		interval = 5,
		minWidth = 300,
		maxWidth = 900
	},
	secondsAllowed = 60,
	lengthObjective = 20,
	miniFireSpouts = {
		{x = 256, y = 192, rotation = 45, rotate = true},
		{x = 768, y = 576, rotation = 135, rotate = true},
		{x = 256, y = 576, rotation = 225, rotate = true},
		{x = 768, y = 192, rotation = 315, rotate = true}
	}
}

return level