local Square = {}
Square.__index = Square

setmetatable(Square, {
  __call = function (cls, ...)
  local self = setmetatable({}, cls)
      self:_init(...)
      return self
   end,
})

function Square:_init(init)
  self.value = init
end

function Square:set_value(newval)
	self.value = newval
end

function Square:get_value()
	return self.value
end

function Square.new(init)
	local self = setmetatable({}, Square)
	self.x = init
	return self
end
