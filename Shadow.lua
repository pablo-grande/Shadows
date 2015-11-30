require "Square"			-- import base class
require "libs/spawn"		-- import spawn functions

--------------------------------------------------
-- 		STATIC VARIABLES		--
--------------------------------------------------

local CLASS_NAME = "Shadow"
local COUNT = 0					-- instances generated, used for ID
local SIZE = 50					-- default size
local COLOR = black 			-- default color
local SPAWN = spawnBehindOrNear	-- default spawn function. See spawn models: 'libs/spawn'

--------------------------------------------------
--		CONSTRUCTOR			--
--------------------------------------------------
-- world: world to wich the player belongs
-- player: player who spawned the shadow
-- size	: (optional)shadow size (square form)
-- color: (optional)color used to paint the shadow on screen
-- spawn: (optional)spawn function used
-- returns => Shadow instance OR nil if cannot create the shadow
function Shadow(world, player, size, color, spawn)

	if not world or not player then return nil end			-- check required param

	--check optional params and fill with default vaules if necessary
	size = size or SIZE
	color = color or COLOR
	spawn = spawn or SPAWN

	--------------------------------------------------
	-- 		   INHERITANCE			--
	--------------------------------------------------
	local x,y = spawn(player)								-- get position
	if (x<0 or y<0) then return nil end						-- cannot place shadow
	local self = Square(x, y, size, color)					-- extends Square
	if not self then return nil end							-- failure(self should be something at this point!)

	COUNT = COUNT + 1										-- increment number of instaces generated

	--------------------------------------------------
	-- 		   PROPERTIES			--
	--------------------------------------------------
	local body = love.physics.newBody(world, x,y, "kinematic")			-- love2d body
	local shape = love.physics.newRectangleShape( 0,0, size, size )		-- love2d shape
	local fixture = love.physics.newFixture(body, shape)				-- love2d fixture
	fixture:setUserData(CLASS_NAME..COUNT)								-- set ID = CLASS_NAME + number

	--------------------------------------------------
	-- 		INSTANCE METHODS		--
	--------------------------------------------------

	-- Set spawn model
	self.spawn = spawnBehindOrNear	-- behindOrNear model. For more info see: 'libs/spawn'

	-- Draw the shadow
	function self.draw()
		love.graphics.setColor(self.getColor())				-- set graphics with shadow color
		love.graphics.polygon("fill", body:getWorldPoints(shape:getPoints()))
	end

	return self								-- shadow instance
end

--------------------------------------------------
-- 		STATIC METHODS			--
--------------------------------------------------

-- Determine if the element is a shadow
-- f:	element's fixture
-- returns => true if shadow
function isShadow(f)
	data = f:getUserData()												-- get ID
	return string.sub(data,1,string.len(CLASS_NAME))==CLASS_NAME		-- split ID and check if first part is equal to class name
end
