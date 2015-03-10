require "libs/graphics"
require "libs/physics"
require "libs/sounds"

require "player"
require "shadow"

function love.focus(f) gameIsPaused = not f end

function love.load()
	LOAD_SCREEN()
	player.load()
	-- song:play()
end

function love.keypressed(key)
-- 	player.shoot(key)
end

function love.update(dt)
if gameIsPaused then return end
	if player.health > 0 then
	 UPDATE_PLAYER(dt)
	--  UPDATE_BULLET(dt)
	else
	love.graphics.setColor(0, 255, 0, 255)
		love.graphics.print("GAME OVER!!", 10, 250, 0, 2, 2)
	end
end


function love.draw()
 DRAW_PLAYER()
-- DRAW_SHADOW()
end

function love.quit()
	print("Thanks for playing ^^")
return end
