shadow = {}
shadow.width = 50
shadow.height = 50
shadow.speed = 500
shadow.color = blue
shadow.x = 0
shadow.y = 0

function shadow:spawn(x,y)
	table.insert(shadow,{x=x,y=y,width=shadow.width,height=shadow.height,color=shadow.color})
end

function shadow.draw()
		rectangle(shadow)
end



--PARENT FUNCTIONS
function DRAW_SHADOW()
	shadow.draw()
end
-- function UPDATE_shadow(dt)
-- 	shadow.move(dt)
-- end
