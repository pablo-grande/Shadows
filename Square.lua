local function Square(init, init2)
  local self = Shape(init)

  self.public_field = init2

  -- this is independent from the base class's private field that has the same name
  local private_field = init2

  -- save the base version of foo for use in the derived version
  local base_foo = self.foo
  function self.foo()
    return private_field + self.public_field + base_foo()
  end

  -- return the instance
  return self
end
