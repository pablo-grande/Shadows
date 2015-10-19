------------------------------------------
-- 		GAME CONTROLS		--
------------------------------------------

--Do some keyboard checks every game update
function keyboardControls()
	-- move player to the right while pressing right arrow or "d"
	if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
		player.moveRight()
	end
	
	-- move player to the left while pressing left arrow or "a"	
	if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
		player.moveLeft()
	end

	-- make the player jump when space/up arrow/"w" is pressed
	if love.keyboard.isDown(" ")  or love.keyboard.isDown("w") or love.keyboard.isDown("up") then
		player.jump()
	end
end


-- Actions on key release event(not when update). Useful for an event that occurs only once for each keystroke
-- key:	keyboard key that has been released
function love.keyreleased(key)
	-- check wich key is
	if key == "escape" then
		love.event.quit()		-- quit game
	elseif key == "s" then
		player.createShadow()
	end
end
