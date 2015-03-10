--This file contains all physics works
local g = 1000 --gravity
ground = screenHeight

function gravity(dt, e)
	e.x = e.x + e.xvel * dt
	--Friction
	e.xvel = e.xvel * (1 - math.min(dt*e.friction, 1))
	if e.yvel ~= 0 then -- we're probably jumping
				e.y = e.y - e.yvel * dt -- dt means we wont move at
				-- different speeds if the game lags
				e.yvel = e.yvel - g * dt
        if e.y > (ground - 50) then -- we hit the ground again
            e.yvel = 0
						e.y = ground - 50
        end
    end
end

function colision(w,v)
	if w.x + w.width > v.x and w.x < v.x + v.width and--horizontal
		w.y + w.height > v.y and w.y < v.y + v.height --vertical
	then
		return true
	else
		return false
	end
end
