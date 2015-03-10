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
		player.xvel = 0
	end
	if player.y + player.height > screenHeight then
		player.y = screenHeight- player.height
		-- player.yvel = 0
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
	if love.keyboard.isDown('d') then
		shadow:spawn(player.x,player.y)
	end

	if love.keyboard.isDown(' ') and player.yvel == 0 then
		player.yvel = player.jump
	end
end
--
-- function player.shoot(key)
-- 	if key == 'up' then
-- 		bullet.spawn(player.x + player.width / 2 - bullet.width / 2, player.y - bullet.height, 'up')
-- 	end
-- 	if key == 'down' then
-- 		bullet.spawn(player.x + player.width / 2 - bullet.width / 2, player.y + player.height, 'down')
-- 	end
--
-- 	if key == 'left' then
-- 		bullet.spawn(player.x - bullet.width, player.y + player.height / 2 - bullet.height / 2, 'left')
-- 	end
--
-- 	if key == 'right' then
-- 		bullet.spawn(player.x + player.width, player.y + player.height / 2 - bullet.height / 2, 'right')
-- 	end
-- end

-- function player.life(dt)
-- 	for i,v in ipairs(enemy) do
-- 		if(colision(player,v))then
-- 			player.health = player.health - 1
-- 			if player.health == 75 then
-- 				player.color = red
-- 			end
-- 			if player.health == 100 then
-- 				player.color = yellow
-- 			end
-- 			if player.health == 50 then
-- 				player.color = blue
-- 			end
-- 		end
-- 		if player.health == 0 then
-- 			song:stop()
-- 			dead:play()
-- 			love.quit()
-- 		end
-- 	end
-- end




--PARENT FUNCTIONS
function DRAW_PLAYER()
	player.draw()
	player:paint(blue)
end

function UPDATE_PLAYER(dt)
	player.physics(dt)
	-- player.boundary()
	player.move(dt)
	-- player.life(dt)
end
