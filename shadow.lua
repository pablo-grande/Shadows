shadow = {}
shadow.width = 50
shadow.height = 50
shadow.speed = 500
-- shadow.color = blue
-- shadow.x = 0
-- shadow.y = 0

function shadow:spawn(paramx,paramy,paramcolor)
	table.insert(shadow,{
			x=paramx,
			y=paramy,
			width=shadow.width,
			height=shadow.height,
			color=paramcolor
		})
end

function shadow.draw()
	for i,v in ipairs(shadow) do
		rectangle(v)
	end
end



--PARENT FUNCTIONS
function DRAW_SHADOW()
	shadow.draw()
end
-- function UPDATE_shadow(dt)
-- 	shadow.move(dt)
-- end
