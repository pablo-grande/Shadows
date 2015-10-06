require "libs/graphics"
require "libs/physics"
require "libs/sounds"

require "world"
require "player"

objects = {}

function love.load()
	graphics_set_up()
end

function love.keypressed(key)
	--player.shadow(key)
end

function love.update(dt)
	world:update(dt) --this puts the world into motion
end


function love.draw()
 	player.draw()
end

