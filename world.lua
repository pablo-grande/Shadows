
local gravity = 9.81
local meter = 50 --px

love.physics.setMeter(meter)
world = love.physics.newWorld(0, gravity*meter, true)

--world boundaries
ground = {}
ground.body = love.physics.newBody(world) 
ground.shape = love.physics.newEdgeShape( 0, screenHeight, screenWidth, screenHeight )
ground.fixture = love.physics.newFixture(ground.body, ground.shape);

ceiling = {}
ceiling.body = love.physics.newBody(world) 
ceiling.shape = love.physics.newEdgeShape( 0, 0, screenWidth, 0 )
ceiling.fixture = love.physics.newFixture(ceiling.body, ceiling.shape);

leftWall = {}
leftWall.body = love.physics.newBody(world) 
leftWall.shape = love.physics.newEdgeShape( 0, 0, 0, screenHeight )
leftWall.fixture = love.physics.newFixture(leftWall.body, leftWall.shape);

rightWall = {}
rightWall.body = love.physics.newBody(world) 
rightWall.shape = love.physics.newEdgeShape( screenWidth, 0, screenWidth, screenHeight )
rightWall.fixture = love.physics.newFixture(rightWall.body, rightWall.shape);
