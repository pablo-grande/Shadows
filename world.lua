
local gravity = 9.81
local meter = 50 --px

love.physics.setMeter(meter)
world = love.physics.newWorld(0, gravity*meter, true)

function beginContact(a, b, coll)
    	x,y = coll:getNormal()
	text = text.."\n"..a:getUserData().." colliding with "..b:getUserData().." with a vector normal of: "..x..", "..y
	if isPlayer(a) then
		player.addContact(b,y)
		--text=text.."(a)"
	elseif isPlayer(b) then
		player.addContact(a,-y)
		--text=text.."(b)"
	end
end
 
function endContact(a, b, coll)
    	persisting = 0
	x,y = coll:getNormal()
	text = text.."\n"..a:getUserData().." uncolliding with "..b:getUserData()
	if isPlayer(a) then
		player.removeContact(b:getUserData())
	elseif isPlayer(b) then
		player.removeContact(a:getUserData())
	end
end
 
function preSolve(a, b, coll)
    if persisting == 0 then    -- only say when they first start touching
        --text = a:getUserData().." touching "..b:getUserData()
    elseif persisting < 20 then    -- then just start counting
        --text = text.." "..persisting
    end
    persisting = persisting + 1    -- keep track of how many updates they've been touching for
end
 
function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
end

