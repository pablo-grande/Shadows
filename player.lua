local size = 50 -- square
-- center coordinates
local x = screenWidth/2
local y = screenHeight-size/2
local color = black 

player = {}
player.jumpForce = -400
player.moveForce = 600
player.body = love.physics.newBody(world, x,y, "dynamic")
player.shape = love.physics.newRectangleShape( 0,0, size, size )
player.fixture = love.physics.newFixture(player.body, player.shape);
player.fixture:setFriction(1)

function player.draw()
	love.graphics.setColor(color)
	love.graphics.polygon("fill", player.body:getWorldPoints(player.shape:getPoints()))
end

function player.jump()
	if not player.jumping() then
		player.body:applyLinearImpulse(0, player.jumpForce)
	end
end

function player.jumping()
	--TODO: not working when vx ~= 0
	vx, vy = player.body:getLinearVelocity()
	return vy ~= 0
end

function player.moveLeft()
	player.body:applyForce(-player.moveForce, 0)
end

function player.moveRight()
	player.body:applyForce(player.moveForce, 0)
end

