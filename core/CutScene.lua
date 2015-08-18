local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event ) 
end

function scene:show( event )
    local phase = event.phase
    
    if ( phase == "will" ) then
    	composer.removeScene( "core.CoreScene" )
    elseif ( phase == "did" ) then
        local options = {
            effect = event.params.effect,
            time = event.params.time,
            params = {
                sceneLoader = event.params.sceneLoader
            }
        }
    	composer.gotoScene( "core.CoreScene", options )
    end
end

function scene:hide( event ) 
end

function scene:destroy( event ) 
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene