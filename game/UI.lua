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
		    onRelease = action
		}	
	return button
end

function label(label, x, y, fontSize, displayGroup)
	local labelOptions = {
		parentGroup = displayGroup,
		text = label,
		x = x,
		y = y,
		font = native.systemFontBold,
		fontSize = fontSize
	}
	local displayLabel = display.newText( labelOptions )
	return displayLabel
end
