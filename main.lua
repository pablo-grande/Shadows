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

	text = ""   -- we'll use this to put info text on the screen later
    	persisting = 0    -- we'll use this to store the state of repeated callback calls
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

	--love.graphics.print(text, 10, 10)
end

