local widget = require( "widget" )

local commonIconOptions = {
	width = 64,
	height = 64,
	numFrames = 3
}

local commonIconSheet = graphics.newImageSheet( "images/gameicons.png", commonIconOptions )

local commonIconSequence = {
	name = "Icons",
	frames = {1, 2, 3}
}

local wormIconOptions = {
	width = 32,
	height = 32,
	numFrames = 64
}

local wormIconSheet = graphics.newImageSheet( "images/WormSheet.png", wormIconOptions )

local wormIconSequence = {
	name = "Icons",
	frames = {1}
}

function button(label, x, y, width, height, action) 
	local button = widget.newButton
		{
		    label = label,
		    labelColor = { default = colors.black },
		    emboss = true,
		    shape="roundedRect",
		    width = width,
		    height = height,
		    x = x,
		    y = y,
		    cornerRadius = 10,
		    fillColor = { default = colors.brown, over = colors.brown },
		    strokeColor = { default = colors.black, over = colors.black },
		    strokeWidth = 4,
		    onRelease = action,
		    font = "Desyrel",
		    fontSize = 24
		}	
	return button
end

function label(label, x, y, font, fontSize, displayGroup)
	local labelOptions = {
		parentGroup = displayGroup,
		text = label,
		x = x,
		y = y,
		font = font,
		fontSize = fontSize
	}
	local displayLabel = display.newText( labelOptions )
	displayLabel:setFillColor(colors.yellow[1], colors.yellow[2], colors.yellow[3])
	return displayLabel
end

function homeButton(x, y, w, h, sceneLoader)
	local homeGroup = display.newGroup()

	local homeButton = display.newRoundedRect( x, y, w, h, 10 )
	homeButton.fill = {colors.brown[1], colors.brown[2], colors.brown[3], 0.75}
	homeButton.stroke = colors.black
	homeButton.strokeWidth = 4

	local homeIcon = display.newSprite( commonIconSheet, commonIconSequence )
	homeIcon.x = x
	homeIcon.y = y
	homeIcon.width = h - 20
	homeIcon.height = h - 20

	homeGroup:insert(homeButton)
	homeGroup:insert(homeIcon)

	local function onRelease( event ) 
		if ( event.phase == "ended" ) then
			sceneLoader:menu()
		end
	end
	
	homeGroup:addEventListener( "touch", onRelease )
	return homeGroup
end

function restartButton(x, y, w, h, sceneLoader)
	local restartGroup = display.newGroup()

	local restartButton = display.newRoundedRect( x, y, w, h, 10 )
	restartButton.fill = {colors.brown[1], colors.brown[2], colors.brown[3], 0.75}
	restartButton.stroke = colors.black
	restartButton.strokeWidth = 4

	local restartIcon = display.newSprite( commonIconSheet, commonIconSequence )
	restartIcon:setFrame(2)
	restartIcon.x = x
	restartIcon.y = y
	restartIcon.width = h - 20
	restartIcon.height = h - 20

	restartGroup:insert(restartButton)
	restartGroup:insert(restartIcon)

	local function onRelease( event ) 
		if ( event.phase == "ended" ) then
			sceneLoader:restart()
		end
	end
	
	restartGroup:addEventListener( "touch", onRelease )
	return restartGroup
end

function timeRemainingBox(x, y, w, h, font, fontSize, startTime)
	local timeGroup = display.newGroup()
	timeGroup.originX = x

	local equalsOptions = {
		text = " = ",
		x = x,
		y = y,
		font = font,
		fontSize = fontSize
	}
	timeGroup.equals = display.newText( equalsOptions )
	timeGroup.equals:setFillColor(colors.black[1], colors.black[2], colors.black[3])

	local labelOptions = {
		text = tostring(startTime),
		x = x + 25,
		y = y,
		font = font,
		fontSize = fontSize
	}
	timeGroup.label = display.newText( labelOptions )
	timeGroup.label:setFillColor(colors.black[1], colors.black[2], colors.black[3])

	timeGroup.timeBox = display.newRect(x, y, w, h)
	timeGroup.timeBox.fill = {colors.brown[1], colors.brown[2], colors.brown[3], 0.75}
	timeGroup.timeBox.stroke = colors.black
	timeGroup.timeBox.strokeWidth = 4

	timeGroup.setTime = function(newTime)
		timeGroup.label.text = tostring(newTime)
	
		-- local labelWidth = timeGroup.label.width
		-- local iconWidth = timeGroup.timeIcon.width
		-- local totalWidth = labelWidth + iconWidth
		-- local halfWidth = totalWidth / 2

		-- timeGroup.timeBox.x = timeGroup.originX - halfWidth
		-- timeGroup.timeBox.width = totalWidth

		-- timeGroup.timeIcon.x = timeGroup.timeBox.x - (timeGroup.timeIcon.width / 2)
		-- timeGroup.label.x = timeGroup.timeBox.x + (timeGroup.timeIcon.width / 2)
	end

	timeGroup.timeIcon = display.newSprite( commonIconSheet, commonIconSequence )
	timeGroup.timeIcon:setFrame(3)
	timeGroup.timeIcon.x = x - 25
	timeGroup.timeIcon.y = y
	timeGroup.timeIcon.width = h - 20
	timeGroup.timeIcon.height = h - 20

	timeGroup:insert(timeGroup.timeBox)
	timeGroup:insert(timeGroup.timeIcon)
	timeGroup:insert(timeGroup.equals)
	timeGroup:insert(timeGroup.label)

	return timeGroup
end

function objectiveBox(x, y, w, h, font, fontSize, length, objective, wormIndex)
	local objGroup = display.newGroup()
	local iconW = (h - 20)
	local padding = 5
	local iconX = x - (w / 2) + iconW - padding
	local equalsX = iconX + (iconW / 2) + 17
	local textX = equalsX + 45

	local equalsOptions = {
		text = " = ",
		x = equalsX,
		y = y,
		font = font,
		fontSize = fontSize
	}
	objGroup.equals = display.newText( equalsOptions )
	objGroup.equals:setFillColor(colors.black[1], colors.black[2], colors.black[3])

	local labelOptions = {
		text = tostring(length).."/"..tostring(objective),
		x = textX,
		y = y,
		font = font,
		fontSize = fontSize
	}
	objGroup.label = display.newText( labelOptions )
	objGroup.label:setFillColor(colors.black[1], colors.black[2], colors.black[3])

	objGroup.box = display.newRect(x, y, w, h)
	objGroup.box.fill = {colors.brown[1], colors.brown[2], colors.brown[3], 0.75}
	objGroup.box.stroke = colors.black
	objGroup.box.strokeWidth = 4

	objGroup.setLength = function(newLength)
		objGroup.label.text = tostring(newLength).."/"..tostring(objective)
	end

	objGroup.icon = display.newSprite( BaseWorm.wormSheet, BaseWorm.wormSequence )
	objGroup.icon:setFrame(wormIndex)
	objGroup.icon.x = iconX
	objGroup.icon.y = y
	objGroup.icon.width = iconW
	objGroup.icon.height = h - 20

	objGroup:insert(objGroup.box)
	objGroup:insert(objGroup.icon)
	objGroup:insert(objGroup.equals)
	objGroup:insert(objGroup.label)

	return objGroup
end
