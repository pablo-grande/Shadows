require "libs/colors"

screenWidth = love.graphics.getWidth()
screenHeight = love.graphics.getHeight()

function LOAD_SCREEN()
	love.graphics.setBackgroundColor(white)
end

function rectangle(v)
	love.graphics.setColor(v.color)
	love.graphics.rectangle('fill',v.x,v.y,v.width,v.height)
end
