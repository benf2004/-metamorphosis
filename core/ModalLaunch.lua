local composer = require( "composer" )

local scene = composer.newScene()

function scene:show( event )
	local phase = event.phase
	if (phase == "will") then
		local parent = event.parent
		self.modal = parent.modal
		self.modal:initialize(self)
		self.modal:load(parent)
	end
end

scene:addEventListener( "show", scene )

return scene