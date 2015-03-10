player = {}

function player.load()
	player.width = 50
	player.height = 50
	player.x = screenWidth / 2
	player.y = ground - 50
	player.xvel = 0
	player.yvel = 0
	player.friction = 9.5
	player.speed = 2250
	player.color = black
	player.health = 150
	player.jump = 500

end

function player:paint(color)
	player.color = color
end

function player.draw()
	if player.health > 0 then
		rectangle(player)
	end
end

function player.physics(dt)
	gravity(dt, player)
end

function player.boundary()

	--colision for shadows
	for i,v in ipairs(shadow) do
		if(colision(player,v))then
			if player.y == v.y then
				if player.x < v.x then --left
					player.x = (v.x - v.width)
				end
				if player.x > v.x then --right
					player.x = (v.x + v.width)
				end
			elseif player.y > (v.y - v.height) then
				player.y = (v.y - v.height)
			end
		end
	end

	--Screen limits for x and y
	if player.x < 0 then
		player.x = 0
		player.xvel = 0
	end
	if player.y < 0 then
		player.y = 0
		-- player.yvel = 0
	end
	if player.x + player.width > screenWidth then
		player.x = screenWidth - player.width
	end
	if player.y + player.height > screenHeight then
		player.y = screenHeight- player.height
	end
end

function player.move(dt)
	--eje x
	if love.keyboard.isDown('d') and player.xvel < player.speed then
		player.xvel = player.xvel + player.speed * dt
	end
	if love.keyboard.isDown('a') and player.xvel > -player.speed then
		player.xvel = player.xvel - player.speed * dt
	end

	if love.keyboard.isDown(' ') and player.yvel == 0 then
		player.yvel = player.jump
	end
end

function player.life(dt)
	if player.health < 100 then
		player:paint(red)
	end

	if player.health == 0 then
		love.quit()
	end
end

function player.shadow(key)
	if key == 's' then
		--check if there is a shadow there or near
		shadow:spawn(player.x,player.y,player.color)
		player.health = player.health - 10
	end
end


--PARENT FUNCTIONS
function DRAW_PLAYER()
	player.draw()
	player:paint(blue)
end

function UPDATE_PLAYER(dt)
	player.physics(dt)
	player.boundary()
	player.move(dt)
	player.life(dt)
end
