local level = {
	worm = {
		x = 410,
		y = 200
	},
	foodTruck = {
		standardWorm = 100
	},
	walls = {
		{56, 359, 400, 50},
		{568, 359, 400, 50},
		{487, 72, 50, 200},
		{487, 496, 50, 200}
	},
	waterCanons = {
		{x = 512, y = 384, rotation = 45, rotate = true},
		{x = 512, y = 384, rotation = 135, rotate = true},
		{x = 512, y = 384, rotation = 225, rotate = true},
		{x = 512, y = 384, rotation = 315, rotate = true}
	},
	activators = {
		{512, 384},
		{512, 713},
		{512, 49},
		{45, 384},
		{980, 384}

	},
	secondsAllowed = 60,
	lengthObjective = 25,
	instructions = "The farmer is watering the garden today, but Wormy still has to eat!"
}

return level