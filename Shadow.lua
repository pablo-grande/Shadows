require "Square"			-- import base class

--------------------------------------------------
-- 		STATIC VARIABLES		--
--------------------------------------------------

local CLASS_NAME = "Shadow"
local COUNT = 0				-- instances generated, used for ID
local SIZE = 50				-- default size
local X = love.graphics.getWidth()/2	-- default X
local Y = love.graphics.getHeight()/2	-- default Y
local COLOR = black 			-- default color


--------------------------------------------------
--		CONSTRUCTOR			--
--------------------------------------------------
-- world: world to wich the player belongs
-- x,y	: (optional)initial player position in world
-- size	: (optional)shadow size (square form)
-- color: (optional)color used to paint the shadow on screen
-- returns => Shadow instance OR nil if cannot create the shadow
function Shadow(world, x, y, size, color)
	
	if not world then return nil end			-- check required param
	
	--check optional params and fill with default vaules if necessary
	x = x or X
	y = y or Y
	size = size or SIZE
	color = color or COLOR
	
	--------------------------------------------------
	-- 		   INHERITANCE			--
	--------------------------------------------------
	local self = Square(x, y, size, color)					-- extends Square
	if not self then return nil end						-- failure(self should be something at this point!)
	
	COUNT = COUNT + 1							-- increment number of instaces generated
	
	--------------------------------------------------
	-- 		   PROPERTIES			--
	--------------------------------------------------
	-- local body = love.physics.newBody(world, x,y, "kinematic")		-- love2d body
	local body = self.setBody(world,"kinematic")
	local fixture = self.setFixture(body,CLASS_NAME..COUNT)	-- Square fixture
	local shape = self.getShape()

	--------------------------------------------------
	-- 		INSTANCE METHODS		--
	--------------------------------------------------

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
	data = f:getUserData()							-- get ID
	return string.sub(data,1,string.len(CLASS_NAME))==CLASS_NAME		-- split ID and check if first part is equal to class name
end
