-----------------------
-- PREDEFINED COLORS --
-----------------------

white = {255,255,255}
black = {0,0,0}
red = {255,0,0}
green = {0,255,0}
blue = {0,0,255}
yellow = {255,255,0}

-------------------------------
-- PREDEFINED ALPHA LEVELS   --
-------------------------------
transparent,invisible,alpha0 = 0,0,0							-- 0%
alpha10 = 24.6																		-- 10%
alpha20 = 50.2																		-- 20%
nearlytransparent,almostclear,alpha25 = 63,63,63	-- 25%
alpha30 = 75.8																		-- 30%
alpha40 = 101.4																		-- 40%
semitransparent,translucent,alpha50 = 127,127,127	-- 50%
alpha60 = 152.6																		-- 60%
alpha70 = 178.2																		-- 70%
nearlyopaque,almostdark,alpha75 = 191,191,191			-- 75%
alpha80 = 203.8																		-- 80%
alpha90 = 229.4																		-- 90%
opaque,visible,alpha1 = 255,255,255								-- 100%

----------------------------------
--	 COLOR METHODS		--
----------------------------------

-- Calculate a random RGB color
-- returns color
function randomColor()
	math.randomseed(os.clock())	-- set random seed with timestamp

	R=math.random(0,255)		-- random R component
	G=math.random(0,255)		-- random G component
	B=math.random(0,255)		-- random B component

	return {R,G,B}			-- return color object
end

-- Calculate the negative of a given RGB color
-- c:	color to invert
-- returns inverted color or nil if color not specified
function invertColor(c)
	if not c then return nil end	-- color not defined

	R=255-c[1]			-- inverted R
	G=255-c[2]			-- inverted G
	B=255-c[3]			-- inverted B

	return {R,G,B}			-- return inverted color
end

-- Linear color interpolation between two RGB colors
-- p:	% amount of first color
-- c1:	first color
-- c2:	second color
-- return =>	interpolated color
function linearColorInterpolation(p,c1,c2)
	R = c1[1] * p + c2[1] * (1 - p)		-- calculate R component
	G = c1[2] * p + c2[2] * (1 - p)		-- calculate G component
	B = c1[3] * p + c2[3] * (1 - p)		-- calculate B component
	return {R,G,B}
end

-- Construct RGBA color from simple RGB
-- color:	RGB color
-- alpha:	alpha level {0-255}
-- return =>	RGBA color
function RGBA (color,alpha)
	return color[1],color[2],color[3],alpha
end
