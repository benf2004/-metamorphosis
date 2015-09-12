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
	activators = {
		{512, 384}
	},
	miniFireSpouts = {
		{x = 256, y = 192, rotation = 45, rotate = true},
		{x = 768, y = 576, rotation = 135, rotate = true},
		{x = 256, y = 576, rotation = 225, rotate = true},
		{x = 768, y = 192, rotation = 315, rotate = true},
		{x = 56, y = 359+25, rotation = 90, rotate = true},
		{x = 568, y = 359+25, rotation = 90, rotate = true},
		{x = 487+25, y = 496, rotation = 180, rotate = true},
		{x = 487+25, y = 72, rotation = 180, rotate = true},
		{x = 56+400, y = 359+25, rotation = 270, rotate = true},
		{x = 568+400, y = 359+25, rotation = 270, rotate = true},
		{x = 487+25, y = 496+200, rotation = 0, rotate = true},
		{x = 487+25, y = 72+200, rotation = 0, rotate = true}
	},
	secondsAllowed = 60,
	lengthObjective = 35
}

return level