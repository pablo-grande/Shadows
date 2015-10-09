require "Square"

--static variables
local count = 0	-- instances generated, used as ID
local SIZE = 50
local X = love.graphics.getWidth()/2
local Y = love.graphics.getHeight()/2
local COLOR = black 

function Player(world, x, y, size, color)
	
	if not world then return nil end	-- required param
	
	--check optional params
	x = x or X
	y = y or Y
	size = size or SIZE
	color = color or COLOR

	local self = Square(x, y, size, color)	-- extends Square
	
	count = count + 1
	local jumpForce = -400
	local moveForce = 600
	local body = love.physics.newBody(world, x,y, "dynamic")
	local shape = love.physics.newRectangleShape( 0,0, size, size )
	local fixture = love.physics.newFixture(body, shape)
	fixture:setFriction(1)
	body:setUserData("Player" .. count)	-- ID
	local shadows = {}
	
	function self.draw()
		love.graphics.setColor(self.getColor())
		love.graphics.polygon("fill", body:getWorldPoints(shape:getPoints()))
		for k,sh in pairs(shadows) do
			sh.draw()
		end
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

	function self.createShadow()
		s = Shadow(body:getWorld(), body:getX(), body:getY(), self.getSize(), self.getColor())
		table.insert(shadows, s)
	end

	function self.ID()
		return body:getUserData()
	end

	function self.getX()
		return body:getX()	
	end

	function self.getY()
		return body:getY()	
	end

	return self	
end

