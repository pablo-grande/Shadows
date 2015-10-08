local Shape = {}
Shape.__index = Shape

setmetatable(Shape, {
  __call = function (cls, ...)
  local self = setmetatable({}, cls)
      self:_init(...)
      return self
   end,
})

function Shape:_init(init)
  self.value = init
end

function Shape:set_value(newval)
	self.value = newval
end

function Shape:get_value()
	return self.value
end

function Shape.new(init)
	local self = setmetatable({}, Shape)
	self.x = init
	return self
end
