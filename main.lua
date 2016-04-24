require "libs/graphics"
require "libs/physics"
require "libs/sounds"

require "world"
require "controls"
require "debugger"
require "Player"
require "Shadow"
require "Stage"

player = Player(world, screenWidth/2, screenHeight-50/2)
stage = Stage(world, white, screenWidth, screenHeight)

function love.load()
	love.graphics.setNewFont(14)
	graphicsSetUp()
	world:setCallbacks(beginContact, endContact, preSolve, postSolve)
end

function love.update(dt)
	if player.isAlive() then
		world:update(dt) 	--this puts the world into motion
		keyboardControls()
	end
end


function love.draw()
	if player.isAlive() then
		player.draw()
	else
		love.graphics.printf("Game\nOver", 0,300,800, 'center')
	end
	debug()
end
