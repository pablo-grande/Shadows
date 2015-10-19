--------------------------------------------------
--		LOVE2D WORLD ENTITY		--
--------------------------------------------------
-- It contains all game entities		--
--------------------------------------------------

-- Global properties
local GRAVITY = 9.81					-- Value of gravity
local METER = 50 					-- Meter size of our world in pixels

-- Initialization
love.physics.setMeter(METER)				-- init meter size
world = love.physics.newWorld(0, GRAVITY*METER, true) 	-- create the world. The specific love2d class.


----------------------------------------------------------------------------------------------------------
--			COLLISION MANAGMENT								--
----------------------------------------------------------------------------------------------------------
-- Specification of 4 functions used for world collision						--
-- callbacks: beginContact, endContact, preSolve and postSolve				 		--
--													--
-- references:												--
-- vector normal => https://en.wikipedia.org/wiki/Normal_(geometry) 					--
-- collision callbacks => https://love2d.org/wiki/Tutorial:PhysicsCollisionCallbacks 			--
----------------------------------------------------------------------------------------------------------

-- Gets called when two fixtures start overlapping (two objects collide)
-- a:		the first fixture object in the collision.
-- b:		the second fixture object in the collision.
-- coll: 	the contact object created.
function beginContact(a, b, coll)
    	x,y = coll:getNormal()			-- get collision vector normal with direction a->b
	-- check if player is in collision. Order determines vector normal direction, we only consider v.normal aplied to player
	if isPlayer(a) then			-- player is the first object
		player.addContact(b,y)		-- save collision with second object (same normal direction)
	elseif isPlayer(b) then			-- player is the second object
		player.addContact(a,-y)		-- save collision with first object (invert normal direction)
	end
end

-- Gets called when two fixtures stop overlapping (two objects disconnect).This will also be called outside of a world update, when colliding
-- objects are destroyed.
-- a:		the first fixture object in the collision.
-- b:		the second fixture object in the collision.
-- coll: 	the contact object created.
function endContact(a, b, coll)
	-- check if player is in finished collision
	if isPlayer(a) then				-- player is the first object
		player.removeContact(b:getUserData())	-- remove b from player contacts
	elseif isPlayer(b) then				-- player is the second object
		player.removeContact(a:getUserData())	-- remove a from player contacts
	end
end

-- Called just before a frame is resolved for a current collision
-- a:		the first fixture object in the collision.
-- b:		the second fixture object in the collision.
-- coll: 	the contact object created.
function preSolve(a, b, coll)
end

-- Called just after a frame is resolved for a current collision
-- a:			the first fixture object in the collision.
-- b:			the second fixture object in the collision.
-- coll: 		the contact object created.
-- normalimpulse1:	amount of impulse applied along the normal of the first point of collision. It only applies to the postsolve callback
-- tangentimpulse1:	amount of impulse applied along the tangent of the first point of collision. It only applies to the postsolve callback
function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
end

