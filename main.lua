require "libs/graphics"
require "libs/physics"
require "libs/sounds"

require "world"
require "controls"
require "Player"
require "Shadow"
require "Stage"

player = Player(world, screenWidth/2, screenHeight-50/2)
stage = Stage(world, screenWidth, screenHeight)

function love.load()
	graphics_set_up()
	world:setCallbacks(beginContact, endContact, preSolve, postSolve)
end

function love.update(dt)
	world:update(dt) --this puts the world into motion
	keyboardControls()

	if string.len(text) > 768 then    -- cleanup when 'text' gets too long
		text = ""
	end
end


function love.draw()
 	player.draw()
end

