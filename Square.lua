require "Shape"

function Square(x, y, size, color)
	local self = Shape(x,y, color)
	local size = size

	function self.setSize(s)
		size = s
	end

	function self.getSize(s)
		return size
	end

	return self
end
