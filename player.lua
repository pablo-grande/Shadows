require "Square"

local size = 50
local x = screenWidth/2
local y = screenHeight-size/2
local color = black 

function Player(world, x, y, size, color)
	local self = Square(x, y, size, color)
	
	local jumpForce = -400
	local moveForce = 600
	local body = love.physics.newBody(world, x,y, "dynamic")
	local shape = love.physics.newRectangleShape( 0,0, size, size )
	local fixture = love.physics.newFixture(body, shape)
	fixture:setFriction(1)
	
	function self.draw()
		love.graphics.setColor(color)
		love.graphics.polygon("fill", body:getWorldPoints(shape:getPoints()))
	end

	function self.jump()
		if not self.jumping() then
			body:applyLinearImpulse(0, jumpForce)
		end
	end

	function self.jumping()
		--TODO: not working when vx ~= 0 
		vx, vy = body:getLinearVelocity()
		return vy ~= 0
	end

	function self.moveLeft()
		body:applyForce(-moveForce, 0)
	end

	function self.moveRight()
		body:applyForce(moveForce, 0)
	end	
	
	return self	
end

