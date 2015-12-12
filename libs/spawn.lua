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

-- Calculate priority for 'behindOrNear' model.
-- The linear velocity is not completely accurate. Although the player moves only in one axis,
-- vertical or horizontal, also may be some (very small amount) of linear velocity along the other axis
-- due to friction or other reasons, so we have a margin of deviation that must be overcome to consider movement
-- vx: X component of player linear velocity
-- vy: Y component of player linear velocity
-- return => zones sorted by priority
local function getBehindOrNearPriority(vx,vy)
    local dev = 5                               -- deviation margin
    local priority = {} 						-- priority order of zones
    local avx,avy = math.abs(vx),math.abs(vy)   -- absolute linear velocity
	if (avx<dev) then				            -- not horizontal movement
		if (avy<dev) then			            -- not horizontal movement, not moving
			priority = {2.1,2.3,1.2,3.2,1.1,1.3,3.1,3.3}
		elseif (vy<-dev) then 					-- moving up
			priority = {3.2,3.1,3.3,2.1,2.3,1.1,1.3,1.2}
		elseif (vy>dev)	then					-- moving down
			priority = {1.2,1.1,1.3,2.1,2.3,3.1,3.3,3.2}
		end
	elseif (avy<dev) then						-- not vertical movement
		if (vx>dev) then						-- moving right
			priority = {2.1,1.1,3.1,1.2,3.2,1.3,3.3,2.3}
		elseif (vx<-dev) then					-- moving left
			priority = {2.3,1.3,3.3,1.2,2.1,1.1,3.1,2.1}
		end
	else										-- diagonal movement
		if (vx>dev) then
			if (vy<-dev) then					-- moving upright
				priority = {3.1,2.1,3.2,1.1,3.3,1.2,2.3,1.3}
			elseif (vy>dev) then				-- moving downright
				priority = {1.1,2.1,1.2,3.1,1.3,3.2,2.3,3.3}
			end
		else
			if (vy<-dev) then					-- moving upleft
				priority = {3.3,3.2,2.3,3.1,1.3,2.1,1.2,1.1}
			elseif (vy>dev) then				-- moving downleft
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
    local margin = 2        -- margin with player
    local shift = margin + size
    -- adjust Y
    if (zone < 2) then      -- first row
        y = cy - shift      -- shift up
    elseif (zone > 3) then  -- third row
        y = cy + shift      -- shift down
    end
    -- adjust X
    local col = math.floor(10*(zone-math.floor(zone))+0.1)  -- get decimal part
    if (col==1) then        -- first column
        x = cx - shift      -- shift left
    elseif (col==3) then    -- third column
        x = cx + shift      -- shift right
    end
    print(zone,x,y)
    return x,y              -- return position
end

-- Check if the object fits on a especific position
-- x,y:  position to check(center)
-- size: object size
-- return => true if fits
-- NOTE:XXX: assuming a square object
local function fitIn (x,y,size)
    print("check fit:",x,y)
    local half      = size/2
    -- define object boundaries
    local left      = x-half
    local right     = x+half
    local top       = y-half
    local bottom    = y+half

    --check game boundaries
    if (left < 0 or right > screenWidth or top < 0 or bottom > screenHeight) then return false end

    local contacts = {
        list = {},          -- [key] => value list of objects contacted as [object_ID] => #contacts
        totalCount = 0,     -- total contacts with all rays
        distinctCount = 0   -- distinct objects contacted (list lenght)
    }

    local function callback (fixture, x, y, xn, yn, fraction)
        local ID = fixture:getUserData()
        if not contacts.list[ID] then                   -- new object contact
            contacts.list[ID] = 1
            contacts.distinctCount = contacts.distinctCount + 1
        else
            contacts.list[ID] = contacts.list[ID] + 1
        end
        contacts.totalCount = contacts.totalCount + 1
        return 1
    end

    world:rayCast(left,top,right,top,callback)          -- top side
    world:rayCast(left,bottom,right,bottom,callback)    -- bottom side
    world:rayCast(left,top,left,bottom,callback)        -- left side
    world:rayCast(right,top,right,bottom,callback)      -- right side
    world:rayCast(left,top,right,bottom,callback)       -- diagonal 1
    world:rayCast(left,bottom,right,top,callback)       -- diagonal 2

    print("distinct hits", contacts.distinctCount)
    for object,count in pairs(contacts.list) do
        print(object,"=>",count,"hits")
    end

    return contacts.distinctCount==0
end

-- Select the first position where a shadow fits
-- return => x,y of position
local function getFittingPosition (positions,size)
    for k,p in pairs(positions) do              -- for each position
        if fitIn(p[1],p[2],size) then           -- check if shadow fit
            print("fit:",p[1],p[2])
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
        print("player: ",x,y)
        print("--------------------------------")
        print("zone","X","Y")
        print("--------------------------------")
        for priority,zone in ipairs(zones) do                                   -- for each zone...
            table.insert(positions,{transalteZoneToPosition(zone,x,y,size)})    -- add equivalent coordinate
        end
        print("--------------------------------")
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
-- If the player don't move then try to place the shadow next to
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
