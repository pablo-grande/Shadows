function Shape(x, y, size, color)
    local self = {}

  	local x = x
	local y = y
	local color = color
	local size = size
	
	function self.setColor(c)
		color = c
	end

	function self.getColor()
		return color
	end

	function self.setSize(s)
		size = s
	end

	function self.getSize(s)
		return size
	end

	return self
end



