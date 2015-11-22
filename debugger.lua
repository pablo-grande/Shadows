----------------------------------------------------------------------------------------------------------
-- 		DEBUGGER										--
----------------------------------------------------------------------------------------------------------
-- Debug game.
-- It is assumed that there are (at least) two global variables						--
-- accessibles from here:										--
--			-player -> declared in main							--
----------------------------------------------------------------------------------------------------------

DEBUG = false         -- Determine if debugging is active
local WIDTH = 200     -- width of debug box in pixels

function debug ()
  if DEBUG then
    local info = ""

    -- adding output info
    info = info .. "ID:\t"..player.ID()
    info = info .. "\nLife:\t" .. math.floor(player.life())                                               -- player life
    info = info .. "\nPosition:\t("..math.floor(player.getX()) .. ","..math.floor(player.getY())..")"   -- player position

    -- draw debugging box
    local font = love.graphics.getFont()
    local width,lines = font:getWrap(info,WIDTH)
    local boxHeight = lines*font:getHeight()
    love.graphics.setColor(RGBA(black,semitransparent))
    love.graphics.rectangle("fill",0,0,WIDTH,boxHeight)

    -- print info
    love.graphics.setColor(white)
    love.graphics.printf(info,0,0, WIDTH)

  end
end