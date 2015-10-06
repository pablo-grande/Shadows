local size = 50 -- square
-- center coordinates
local x = screenWidth/2
local y = screenHeight-size/2
local color = black 

player = {}
player.body = love.physics.newBody(world, x, y, "dynamic") 
player.shape = love.physics.newPolygonShape( {x-size/2, y-size/2, x+size/2, y-size/2, x+size/2, y+size/2, x-size/2, y+size/2} )
player.fixture = love.physics.newFixture(player.body, player.shape);

function player.draw()
	love.graphics.setColor(color)
	love.graphics.polygon("fill", player.shape:getPoints())
end

