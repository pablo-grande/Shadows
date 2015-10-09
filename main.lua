require "libs/graphics"
require "libs/physics"
require "libs/sounds"

require "world"
require "controls"
require "Player"
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
	showDetails()
end

function showDetails()
	vx,vy = player.getLinearVelocity()
	love.graphics.print("x: " .. player.getX() .. ", y: " .. player.getY(), 0, 0)
	love.graphics.print("vx: " .. vx .. ", vy: " .. vy, 0, 10)
end
