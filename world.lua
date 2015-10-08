
local gravity = 9.81
local meter = 50 --px

love.physics.setMeter(meter)
world = love.physics.newWorld(0, gravity*meter, true)

