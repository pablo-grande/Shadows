local function Square(x, y, size, color)
	local self = Shape(x,y, color)
	local size = size
	
	local setColor = self.setColor
	local getColor = self.getColor

	return self
end
