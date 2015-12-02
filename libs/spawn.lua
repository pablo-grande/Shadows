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
--      - spawnSameBasic: same place of player
--      - spawnBehindOrNear: behind the player or near(adjacent)
--      - ...(others models)
--
----------------------------------------------------------------------------------------------------------
-- NOTE:TODO: This could be extended to any object, not only shadows
----------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------
--              MODEL 1
----------------------------------------------------------------------------------------------------------

-- The position of the shadow is same as player
-- player: player that creates the shadow
-- return => shadow position
-- NOTE:XXX: shadow can't be created over player so may produce odd results
function spawnSameBasic (player)
    return player.getX(),player.getY()
end

----------------------------------------------------------------------------------------------------------
--              MODEL 2
----------------------------------------------------------------------------------------------------------

-- Calculate priority for 'behindOrNear' model
-- vx: X component of player linear velocity
-- vy: Y component of player linear velocity
-- return => zones sorted by priority
-- TODO: aplicar un margen de desviacion ya que aunque se mueva solo en horizontal la friccion puede
--      generar una cierta componente vy, lo mismo en vertical. Probar con un margen de {-2,2}
local function getBehindOrNearPriority(vx,vy)
    local priority = {} 						-- priority order of zones
	if (vx==0) then								-- vertical movement
		if (vy==0) then 						-- not moving
			priority = {2.1,2.3,1.2,3.2,1.1,1.3,3.1,3.3}
		elseif (vy<0) then 						-- moving up
			priority = {3.2,3.1,3.3,2.1,2.3,1.1,1.3,1.2}
		else									-- moving down
			priority = {1.2,1.1,1.3,2.1,2.3,3.1,3.3,3.2}
		end
	elseif (vy==0) then							-- horizontal movement
		if (vx>0) then 							-- moving right
			priority = {2.1,1.1,3.1,1.2,3.2,1.3,3.3,2.3}
		else									-- moving left
			priority = {2.3,1.3,3.3,1.2,2.1,1.1,3.1,2.1}
		end
	else										-- diagonal movement
		if (vx>0) then
			if (vy<0) then						-- moving upright
				priority = {3.1,2.1,3.2,1.1,3.3,1.2,2.3,1.3}
			else								-- moving downright
				priority = {1.1,2.1,1.2,3.1,1.3,3.2,2.3,3.3}
			end
		else
			if (vy<0) then						-- moving upleft
				priority = {3.3,3.2,2.3,3.1,1.3,2.1,1.2,1.1}
			else								-- moving downleft
				priority = {1.3,1.2,2.3,1.1,3.3,2.1,3.2,3.1}
			end
		end
	end

	return priority
end

-- Transalate a given zone of 'spawnBehindOrNear' scheme to its corresponent position
-- using the player as reference bypplies a shift from player to zone
-- zone: zone to convert. Decimal number with format x.y where x=row and y=column
-- cx,cy: center of the reference element
-- size: player size
local function transalteZoneToPosition (zone,cx,cy,size)
    local x,y = cx,cy
    -- adjust Y
    if (zone < 2) then      -- first row
        y = cy - size       -- shift up
    elseif (zone > 3) then  -- third row
        y = cy + size       -- shift down
    end
    -- adjust X
    local col = math.floor(10*(zone-math.floor(zone)))  -- get decimal part
    if (col==1) then        -- first column
        x = cx - size       -- shift left
    elseif (col==3) then    -- third column
        x = cx + size       -- shift right
    end
    return x,y              -- return position
end

-- Check if the object fits on a especific position
-- x,y:  position to check(center)
-- size: object size
-- return => true if fits
-- NOTE:XXX: assuming a square object
local function fitIn (x,y,size)
    local fit       = true      -- result
    local half      = size/2
    -- define object boundaries
    local left      = x-half
    local right     = x+half
    local top       = y-half
    local bottom    = y+half

    --check game boundaries
    if (left < 0 or right > screenWidth or top < 0 or bottom > screenHeight) then return false end

    --Create dummy square
    --HACK: creating actual object to study how interact. May be a better solution.
    local dummyBody = love.physics.newBody(world, x,y, "kinematic")			-- love2d body
	local dummyShape = love.physics.newRectangleShape( 0,0, size, size )	-- love2d shape
	local dummyFixture = love.physics.newFixture(dummyBody, dummyShape)		-- love2d fixture
    dummyFixture:setUserData("dummy")        								-- set ID
    --Check contacts with dummy. Looking for overlaps: overlap = don't fit
    local contacts = dummyBody:getContactList()                            -- XXX: don't now if already updated
    for i,c in ipairs(contacts) do                                         -- loop every contact to check if overlapping
        local x1,y1,x2,y2 = c:getPositions()
        if not x2 then goto next end                                    -- only one contact point XXX: guess this is enough to not overlapping
        -- managing two contacts points
        if (x1 > left and x1 < right and y1 > top and y1 < bottom) or       -- if first point inside dummy or...
            (x2 > left and x2 < right and y2 > top and y2 < bottom) then    -- ...second point inside dummy
            fit = false                                                     -- then some point overlapping
            break
        end
        ::next:: --XXX: added in Lua 5.2
    end
    dummyFixture:destroy()  -- destroy dummy square
    return fit
end

-- Select the first position where a shadow fits
-- return => x,y of position
local function getFittingPosition (positions,size)
    for k,p in pairs(positions) do             -- for each position
        if fitIn(p[1],p[2],size) then           -- check if shadow fit
            return p[1],p[2]                    -- return position
        end
    end
    return -1,-1                                -- don't fit at any position
end

-- Calculate equivalent coordinates for each zone
-- player: player used as reference
-- zones: list of zones
-- return => list of coordinates
local function getPositionsFromZones (player, zones)
        local size = player.getSize() --NOTE:XXX: assuming player and shadow have the same size always!
        local positions = {}                                                    -- store results
        local x,y = player.getX(),player.getY()                                 -- center reference to convert
        for priority,zone in ipairs(zones) do                                   -- for each zone...
            table.insert(positions,{transalteZoneToPosition(zone,x,y,size)})    -- add equivalent coordinate
        end
        return positions
end

-- The position of the shadow is calculated relative to the player given the
-- following scheme, where P is the player and the rest are the adjacent zones:
--        	-------------------
--			| 1.1 | 1.2 | 1.3 |
--        	|-----------------|
--			| 2.1 |  P  | 2.3 |
--			|-----------------|
--			| 3.1 | 3.2 | 3.3 |
--			-------------------
-- Numeric areas are the only ones taken into consideration. Entire part represents
-- the row and decimal part represents the column.
--
-- If the player don't move then try to place the shadow next to in
-- following this order: 2.1,2.3,1.2,3.2,1.1,1.3,3.1,3.3
--
-- If the player is moving then try to place de shadow behind. So the priority order
-- is as follows:
--		moving right 		=> 2.1,1.1,3.1,1.2,3.2,1.3,3.3,2.3
-- 		moving left	 		=> 2.3,1.3,3.3,1.2,2.1,1.1,3.1,2.1
-- 		moving up 			=> 3.2,3.1,3.3,2.1,2.3,1.1,1.3,1.2
-- 		moving down	  		=> 1.2,1.1,1.3,2.1,2.3,3.1,3.3,3.2
-- 		moving upleft 		=> 3.3,3.2,2.3,3.1,1.3,2.1,1.2,1.1
-- 		moving upright 		=> 3.1,2.1,3.2,1.1,3.3,1.2,2.3,1.3
-- 		moving downleft		=> 1.3,1.2,2.3,1.1,3.3,2.1,3.2,3.1
-- 		moving downright	=> 1.1,2.1,1.2,3.1,1.3,3.2,2.3,3.3
--
-- if shadow don't fit in any area then it can't be created
--
-- player: player instance that creates the shadow. Used as reference.
-- returns => spawn position (x,y) or (-1,-1) if not possible
function spawnBehindOrNear (player)
    local zones = getBehindOrNearPriority(player.getLinearVelocity())           -- zones sorted by priority
    local positions = getPositionsFromZones(player,zones)                       -- zones converted to coordinates
    return getFittingPosition(positions,player.getSize())                       -- get spawn coordinates
end
