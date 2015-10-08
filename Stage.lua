function Stage(world, width, height)
	local self = {}
	
	width = width or love.graphics.getWidth()
	height = height or love.graphics.getHeight()

	local ground = {}
	ground.body = love.physics.newBody(world) 
	ground.shape = love.physics.newEdgeShape( 0, height, width, height )
	ground.fixture = love.physics.newFixture(ground.body, ground.shape);

	local ceiling = {}
	ceiling.body = love.physics.newBody(world) 
	ceiling.shape = love.physics.newEdgeShape( 0, 0, width, 0 )
	ceiling.fixture = love.physics.newFixture(ceiling.body, ceiling.shape);

	local leftWall = {}
	leftWall.body = love.physics.newBody(world) 
	leftWall.shape = love.physics.newEdgeShape( 0, 0, 0, height )
	leftWall.fixture = love.physics.newFixture(leftWall.body, leftWall.shape);

	local rightWall = {}
	rightWall.body = love.physics.newBody(world) 
	rightWall.shape = love.physics.newEdgeShape( width, 0, width, height )
	rightWall.fixture = love.physics.newFixture(rightWall.body, rightWall.shape);

	return self
end






