local widget = require( "widget" )

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
	return displayLabel
end

function homeButton(label, x, y, w, h, font, fontSize, action)
	local homeButton = display.newRoundedRect( x, y, w, h, 10 )
	homeButton.fill = colors.brown
	homeButton.stroke = colors.black
	homeButton.strokeWidth = 4

	return homeButton
end
