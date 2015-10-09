require "Square"

--static variables
local count = 0
local SIZE = 50
local X = love.graphics.getWidth()/2
local Y = love.graphics.getHeight()/2
local COLOR = black

function Shadow(world, x, y, size, color)
	
	if not world then return nil end	-- required param
	
	--check optional params
	x = x or X
	y = y or Y
	size = size or SIZE
	color = color or COLOR

	local self = Square(x, y, size, color)	-- extends Square
	
	count = count + 1
	local body = love.physics.newBody(world, x,y, "kinematic")
	local shape = love.physics.newRectangleShape( 0,0, size, size )
	local fixture = love.physics.newFixture(body, shape)
	body:setUserData("Shadow" .. count)	-- ID

	function self.draw()
		love.graphics.setColor(self.getColor())
		love.graphics.polygon("fill", body:getWorldPoints(shape:getPoints()))
	end

	return self
end
