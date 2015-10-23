------------------------------------------------------------------------------------------
--		STAGE									--
------------------------------------------------------------------------------------------
-- Determine physic world boundaries and contains game level objects.			--
-- It is assumed that there is global variable accessible from 				--
-- here:										--
-- 	-player -> declared in main							--
------------------------------------------------------------------------------------------

--------------------------------------------------
-- 		STATIC VARIABLES		--
--------------------------------------------------

local GROUND = "Ground"
local CEILING = "Ceiling"
local LEFT_WALL = "Left wall"
local RIGHT_WALL = "Right wall"

--------------------------------------------------
--		CONSTRUCTOR			--
--------------------------------------------------
-- world: 	world to wich the stage belongs
-- color:	background color
-- width: 	(optional) stage width and world boundary
-- height: 	(optional) stage height and world boundary
-- returns => stage instance or nil if cannot create the stage
function Stage(world, color, width, height)
	local self = {}
	if not world or not color then return nil end					-- check required params
	
	--check optional params and fill with default vaules if necessary
	width = width or love.graphics.getWidth()
	height = height or love.graphics.getHeight()
	
	love.graphics.setBackgroundColor(color)						-- set background color
	player.setColor(invertColor(color))						-- set player with negative color
	--------------------------------------------------
	-- 		   PROPERTIES			--
	--------------------------------------------------
	local color = color
	local ground = {}								-- ground element (bottom limit)
	ground.body = love.physics.newBody(world) 					-- love2d body
	ground.shape = love.physics.newEdgeShape( 0, height, width, height )		-- love2d shape
	ground.fixture = love.physics.newFixture(ground.body, ground.shape);		-- love2d fixture
	ground.fixture:setUserData(GROUND)						-- set ID

	local ceiling = {}								-- ceiling element (top limit)
	ceiling.body = love.physics.newBody(world) 					-- love2d body
	ceiling.shape = love.physics.newEdgeShape( 0, 0, width, 0 )			-- love2d shape
	ceiling.fixture = love.physics.newFixture(ceiling.body, ceiling.shape);		-- love2d fixture
	ceiling.fixture:setUserData(CEILING)						-- set ID

	local leftWall = {}								-- left wall element (left limit)
	leftWall.body = love.physics.newBody(world) 					-- love2d body
	leftWall.shape = love.physics.newEdgeShape( 0, 0, 0, height )			-- love2d shape
	leftWall.fixture = love.physics.newFixture(leftWall.body, leftWall.shape);	-- love2d fixture
	leftWall.fixture:setUserData(LEFT_WALL)						-- set ID

	local rightWall = {}								-- right wall element (right limit)
	rightWall.body = love.physics.newBody(world) 					-- love2d body
	rightWall.shape = love.physics.newEdgeShape( width, 0, width, height )		-- love2d shape
	rightWall.fixture = love.physics.newFixture(rightWall.body, rightWall.shape);	-- love2d fixture
	rightWall.fixture:setUserData(RIGHT_WALL)					-- set ID

	--------------------------------------------------
	-- 		INSTANCE METHODS		--
	--------------------------------------------------
	
	-- Changes the stage color. That implies a change color of the player too.
	-- c:	(optional) new color. Random if not defined.
	function self.changeColor(c)
		if not c then					-- color not specified
			newcolor = randomColor()		-- get a random color
			while newcolor == color do		-- while same color...
				newcolor = randomColor()	--	...get new random color
			end
			c=newcolor				-- set c with random color
		end
		color=c						-- assign new color
		love.graphics.setBackgroundColor(color)		-- set background color
		player.setColor(invertColor(color))		-- set player color with stage negative color
	end
	
	--Set stage color
	-- c:	setting color
	function self.setColor(c)
		color = c
	end

	-- Get stage color
	function self.getColor()
		return color
	end


	return self									-- stage instance
end






