require "libs/graphics"
require "libs/physics"
require "libs/sounds"

require "world"
require "controls"
require "Player"
require "Shadow"
require "Stage"

player = Player(world, screenWidth/2, screenHeight-50/2)
stage = Stage(world, white, screenWidth, screenHeight)

function love.load()
	graphicsSetUp()
	world:setCallbacks(beginContact, endContact, preSolve, postSolve)
end

function love.update(dt)
	world:update(dt) --this puts the world into motion
	keyboardControls()
end


function love.draw()
 	player.draw()
end

