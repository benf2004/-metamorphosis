local widget = require( "widget" )

function button(label, x, y, action) 
	local button = widget.newButton
		{
		    label = label,
		    labelColor = { default = colors.black },
		    emboss = true,
		    --shape="roundedRect", --defect??
		    width = 100,
		    height = 50,
		    x = x,
		    y = y,
		    cornerRadius = 10,
		    fillColor = { default = colors.brown },
		    strokeColor = { default = colors.black },
		    strokeWidth = 4,
		    onRelease = action
		}	
	return button
end
