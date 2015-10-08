local Stage = {}
Stage.__index = Stage

function Stage.new(world, width, height)
	local self = setmetatable({}, Stage)

	self.ground = {}
	self.ground.body = love.physics.newBody(world) 
	self.ground.shape = love.physics.newEdgeShape( 0, height, width, height )
	self.ground.fixture = love.physics.newFixture(ground.body, ground.shape);

	self.ceiling = {}
	self.ceiling.body = love.physics.newBody(world) 
	self.ceiling.shape = love.physics.newEdgeShape( 0, 0, width, 0 )
	self.ceiling.fixture = love.physics.newFixture(ceiling.body, ceiling.shape);

	self.leftWall = {}
	self.leftWall.body = love.physics.newBody(world) 
	self.leftWall.shape = love.physics.newEdgeShape( 0, 0, 0, height )
	self.leftWall.fixture = love.physics.newFixture(leftWall.body, leftWall.shape);

	self.rightWall = {}
	self.rightWall.body = love.physics.newBody(world) 
	self.rightWall.shape = love.physics.newEdgeShape( width, 0, width, height )
	self.rightWall.fixture = love.physics.newFixture(rightWall.body, rightWall.shape);
	
	return self
end



