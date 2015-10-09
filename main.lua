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
end

function love.keypressed(key)
	--player.shadow(key)
end

function love.update(dt)
	world:update(dt) --this puts the world into motion
	keyboardControls()
end


function love.draw()
 	player.draw()
end

