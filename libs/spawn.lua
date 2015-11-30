----------------------------------------------------------------------------------------------------------
--	            SHADOW SPAWN MODELS
----------------------------------------------------------------------------------------------------------
-- When a shadow is created and added to the world must be placed somewhere, here is
-- defined different ways of placing new shadows in the world. General process implies
-- three main tasks:
--      a) decide where we want to place the shadow (may be a list sorted by priority)
--      b) check if it's possible
--      c) finally return result:
--          - position (x,y) of available location
--          - not location available, expressed as an impossible location of x,y<0 (i.e: [-1,-1])
--
-- Spawn models/styles:
--      - spawnBehindOrNear: behind the player or near(adjacent)
--      - ...(others models)
--
----------------------------------------------------------------------------------------------------------
-- NOTE:TODO: This could be extended to any object, not only shadows
----------------------------------------------------------------------------------------------------------


-- The position of the shadow is calculated relative to the player given the
-- following scheme, where P is the player and the rest are the adjacent zones:
--        	-------------
--			| 1 | 2 | 3 |
--        	|-----------|
--			| 4 | P | 5 |
--			|-----------|
--			| 6 | 7 | 8 |
--			-------------
-- Numeric areas are the only ones taken into consideration.
--
-- If the player don't move check which is the first area where the shadow fits
-- following this order: 4,5,2,7,1,3,6,8
--
-- If the player is moving then try to place de shadow behind. So the priority order
-- is as follows:
--		moving right 		=> 4,1,6,2,7,3,8,5
-- 		moving left	 		=> 5,3,8,2,4,1,6,4
-- 		moving up 			=> 7,6,8,4,5,1,3,2
-- 		moving down	  		=> 2,1,3,4,5,6,8,7
-- 		moving upleft 		=> 8,7,5,6,3,4,2,1
-- 		moving upright 		=> 6,4,7,1,8,2,5,3
-- 		moving downleft		=> 3,2,5,1,8,4,7,6
-- 		moving downright	=> 1,4,2,6,3,7,5,8
--
-- if shadow don't fit in any area then it can't be created
----------------------
-- player: player instance that creates the shadow. Used as reference.
-- returns => spawn position (x,y) or (-1,-1) if not possible
function spawnBehindOrNear (player)
    local zones = getBehindOrNearPriority(player.getLinearVelocity())           -- zones sorted by priority
    --TODO: comprobar si se puede poner la sombra en dichas zonas
end

-- Calculate priority for 'behindOrNear' model
-- vx: X component of player linear velocity
-- vy: Y component of player linear velocity
local function getBehindOrNearPriority(vx,vy)
    local priority = {} 						-- priority order of zones
	if (vx==0) then								-- vertical movement
		if (vy==0) then 						-- not moving
			priority = {4,5,2,7,1,3,6,8}
		elseif (vy>0) then 						-- moving up
			priority = {7,6,8,4,5,1,3,2}
		else									-- moving down
			priority = {2,1,3,4,5,6,8,7}
		end
	elseif (vy==0) then							-- horizontal movement
		if (vx>0) then 							-- moving right
			priority = {4,1,6,2,7,3,8,5}
		else									-- moving left
			priority = {5,3,8,2,4,1,6,4}
		end
	else										-- diagonal movement
		if (vx>0) then
			if (vy>0) then						-- moving upright
				priority = {6,4,7,1,8,2,5,3}
			else								-- moving downright
				priority = {1,4,2,6,3,7,5,8}
			end
		else
			if (vy>0) then						-- moving upleft
				priority = {8,7,5,6,3,4,2,1}
			else								-- moving downleft
				priority = {3,2,5,1,8,4,7,6}
			end
		end
	end
	return priority
end
