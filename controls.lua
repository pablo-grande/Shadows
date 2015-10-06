function keyboardControls()
	if love.keyboard.isDown("right") then
		player.body:applyForce(200, 0)
	elseif love.keyboard.isDown("left") then
		player.body:applyForce(-200, 0)
	elseif love.keyboard.isDown(" ") then
		player.body:applyLinearImpulse(0, 400)
	end
end
