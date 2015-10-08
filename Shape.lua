local function Shape(init)
  local self = {}

  local private_field = init

  function self.foo()
    return private_field
  end

  function self.bar()
    private_field = private_field + 1
  end

  -- return the instance
  return self
end

