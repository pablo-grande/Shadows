require "Shape"

function Square(x, y, size, color)
	local self = Shape(x,y,size,color)
	local shape = love.physics.newRectangleShape( 0,0, size, size )		-- love2d shape
	
	function self.setBody(world,type)
		type = type or "kinematic"
		body = love.physics.newBody(world, x,y, type)		-- love2d body
		return body
	end
	
	function self.setFixture(body,name)
		fixture = love.physics.newFixture(body, shape)-- love2d fixture
		fixture:setUserData(name)	-- set ID = CLASS_NAME + number
		return fixture
	end
	
	function self.getShape()
		return shape
	end

	return self
end
