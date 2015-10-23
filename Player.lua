require "Square" 			-- import base class

--------------------------------------------------
-- 		STATIC VARIABLES		--
--------------------------------------------------

local CLASS_NAME = "Player"
local COUNT = 0				-- instances generated, used for ID
local SIZE = 50				-- default size
local X = love.graphics.getWidth()/2	-- default X
local Y = love.graphics.getHeight()/2	-- default Y
local COLOR = black 			-- default color
local MAX_LIFE = 100			-- max life points(lp), min is 0
local DETERIORATION = 1			-- life deterioration rate (lp/dt). (static constant or instance propertie?)
local SHADOW_LIFE_CONSUMPTION = 2	-- life points required to generate a shadow	

--------------------------------------------------
--		CONSTRUCTOR			--
--------------------------------------------------
-- world: world to wich the player belongs
-- x,y	: (optional)initial player position in world
-- size	: (optional)player size (square form)
-- color: (optional)color used to paint the player on screen
-- returns => Player instance OR nil if cannot create the player	
function Player(world, x, y, size, color)
	
	if not world then return nil end					-- check required param
	
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
	local life = MAX_LIFE							-- set full life
	local jumpForce = -200							-- force amount used to make the player jump
	local moveForce = 600							-- force amount used to move the player
	local normalY = 0							-- total Y component of normal vector as sum of each contact
	local normalX = 0							-- total X component of normal vector as sum of each contact
	local body = love.physics.newBody(world, x,y, "dynamic")		-- love2d body
	local shape = love.physics.newRectangleShape( 0,0, size, size )		-- love2d shape
	local fixture = love.physics.newFixture(body, shape)			-- love2d fixture
	fixture:setFriction(1)							-- set player's friction to 1 (max)
	fixture:setUserData(CLASS_NAME..COUNT)					-- set ID = CLASS_NAME + number
	local shadows = {}							-- player's shadows
	local contacts = {}							-- current contacts.Array where key=object_ID;value=normalY
	
	--------------------------------------------------
	-- 		INSTANCE METHODS		--
	--------------------------------------------------
	
	-- Draw the player and its shadows
	function self.draw()
		love.graphics.setColor(self.realColor())				-- set graphics with player color 
		love.graphics.polygon("fill", body:getWorldPoints(shape:getPoints()))	-- paint player
		for k,sh in pairs(shadows) do						-- iterate through player shadows
			sh.draw()							-- draw shadow
		end
	end

	-- Player update operations based on delta time
	function self.update(dt)
		self.damage(DETERIORATION*dt)						-- update player life based on time
	end

	-- Makes the player jump
	-- returns => true if player actually jumps
	function self.jump()
		if not self.onAir() then						-- cannot jump if player is on air!
			body:applyLinearImpulse(0, normalY*jumpForce)			
			return true
		else
			return false
		end
	end
	
	-- Check if player is leaning on something. Note that in case the player is touching something
	-- from below(like jumping up to the ceiling) then it may still be consireded "on air".
	-- returns => true if player is on air
	function self.onAir()
		return normalY <= 0	
	end
	
	-- Makes de player move left if possible
	function self.moveLeft()
		body:applyForce(-moveForce, 0)
	end

	-- Makes de player move right if possible
	function self.moveRight()
		body:applyForce(moveForce, 0)
	end

	-- Create a shadow from player
	function self.createShadow()
		s = Shadow(body:getWorld(), body:getX(), body:getY(), self.getSize(), self.realColor())	-- create shadow
		table.insert(shadows, s)								-- store shadow
		self.damage(SHADOW_LIFE_CONSUMPTION)							-- consume life
	end

	-- returns => player ID
	function self.ID()
		return fixture:getUserData()
	end
	
	-- returns => player X coordiante
	function self.getX()
		return body:getX()	
	end
	
	-- returns => player Y coordiante
	function self.getY()
		return body:getY()	
	end
	
	-- Add a contact/collision with an object
	-- f :	fixture of contact object
	-- ny:	normal Y applied to player from object
	function self.addContact(f, ny)
		contacts[f:getUserData()] = ny	-- store the object and its normal Y
		normalY = normalY + ny		-- updates global normal Y of player
	end
	
	--key: ID of contact object
	--returns => true if contact removed
	function self.removeContact(key)
		ny = contacts[key]
		if not ny then return false end	-- contact doesn't exist
		normalY = normalY - ny
		contacts[key] = nil		-- remove contact
		return true
	end
	
	-- returns player life points
	function self.life()
		return life
	end

	-- returns player life %
	function self.lifepct()
		return life/MAX_LIFE	
	end

	-- Increase player life points
	-- p:	healing points(positive value)
	function self.heal(p)
		life = life + p			-- increase life points
		if life > MAX_LIFE then		-- ensure not exceed the limit
			life = MAX_LIFE
		end
	end

	-- Decrease player life points
	-- p:	damage points(positive value)
	function self.damage(p)
		life = life - p			-- decrease life points
		if life < 0 then		-- ensure not exceed the limit
			life = 0
		end
	end

	-- Real player color based on life points and its basic color. 
	-- The color approaches background with life decreasing
	function self.realColor()
		c1 = self.getColor()				-- player color
		c2 = stage.getColor()				-- stage color
		p = life/MAX_LIFE				-- life %
		realcolor = linearColorInterpolation(p,c1,c2)	-- new player color

		return realcolor				
	end

	return self 						-- player instance	
end

--------------------------------------------------
-- 		STATIC METHODS			--
--------------------------------------------------

-- Determine if the element is a player 
-- f:	element's fixture
-- returns => true if player
function isPlayer(f)
	data = f:getUserData()							-- get ID
	return string.sub(data,1,string.len(CLASS_NAME))==CLASS_NAME		-- split ID and check if first part is equal to class name
end
