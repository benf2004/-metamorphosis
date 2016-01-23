local level = {
	title = "Sprinklers",
	worm = {
		x = 410,
		y = 200
	},
	foodTruck = {
		standardWorm = 95,
		clockWorm = 5
	},
	walls = {
		{56, 359, 400, 50},
		{568, 359, 400, 50},
		{487, 72, 50, 200},
		{487, 496, 50, 200}
	},
	-- activators = {
	-- 	{512, 384}
	-- },
	waterCanons = {
		{x = 256, y = 192, rotation = 45, rotate = true},
		{x = 768, y = 576, rotation = 135, rotate = true},
		{x = 256, y = 576, rotation = 225, rotate = true},
		{x = 768, y = 192, rotation = 315, rotate = true},
	},
	secondsAllowed = 60,
	lengthObjective = 40
}

return level