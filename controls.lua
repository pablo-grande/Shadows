
function keyboardControls()
	if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
		player.moveRight()
	end	
	if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
		player.moveLeft()
	end	
	if love.keyboard.isDown(" ")  or love.keyboard.isDown("w") or love.keyboard.isDown("up") then
		player.jump()
	end
end
