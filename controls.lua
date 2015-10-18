
function keyboardControls()
	if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
		player.moveRight()
	end	
	if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
		player.moveLeft()
	end
	--if love.keyboard.isDown("s") then
	--	player.createShadow()
	--end	
	if love.keyboard.isDown(" ")  or love.keyboard.isDown("w") or love.keyboard.isDown("up") then
		player.jump()
	end
end

function love.keyreleased(key)
	if key == "escape" then
		love.event.quit()
	end
	if key == "s" then
		player.createShadow()
	end
end
