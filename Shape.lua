-- x,y of center
local function Shape(x, y, color)
  	local self = {}

  	local x = x
	local y = y
	local color = color
	
	function self.setColor(c)
		color = c
	end

	function self.getColor()
		return color
	end

	return self
end



