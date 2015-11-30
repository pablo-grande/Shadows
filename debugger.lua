----------------------------------------------------------------------------------------------------------
-- 		DEBUGGER										--
----------------------------------------------------------------------------------------------------------
-- Debug game. Access elements to retrieve relevant info and/or get debugging messages generated
-- and sent from
-- It is assumed that there is (at least) one global variable						--
-- accessible from here:										--
--			-player -> declared in main							--
----------------------------------------------------------------------------------------------------------

DEBUG = false         -- Determine if debugging is active
local WIDTH = 200     -- width of debug box in pixels
local info = ""       -- info captured from debug
local prepend = ""    -- info sent from somewhere in the code, attached to the start
local append = ""     -- info sent from somewhere in the code, attached to the end
local log_file = ""   -- TODO: define file

-- Main function, access public variables/elements with relevant
-- data(info string) to display. Also links this data with the
-- received messages such that: [debug_result] = prepend + info + append
function debug ()
  if DEBUG then

    -- adding output info
    info = info .. "ID:\t"..player.ID()
    info = info .. "\nLife:\t" .. math.floor(player.life())                                               -- player life
    local vx,vy = player.getLinearVelocity()
    info = info .. "\nLin.vel.:\t("..math.floor(vx) .. ","..math.floor(vy)..")"                           -- player linear velocity
    info = info .. "\nPosition:\t("..math.floor(player.getX()) .. ","..math.floor(player.getY())..")"     -- player position
    info = info .. "\nShadows:\t" .. player.shadowsCount()                                                -- player shadows count
    local c = player.contacts()                                                                           -- player contacts list
    info = info .. "\nContacts:"
    local nc = 0                                                                                          -- contacts count
    for id,normalY in pairs(c) do                                                                         -- for each element contacted
      nc = nc + 1                                               -- increase contacts count
      info = (nc > 1) and info .. "/" or info .. "\t"           -- add a tab indent if first element, else add a "/" as separator
      info = info .. id                                         -- insert object id
    end
    if nc == 0 then info = info .. "\t(any)" end                -- if any contact add the text "(any)"
    info = (prepend == "") and info or prepend .. "\n" .. info  -- add prepend block: info = prepend+info
    info = (append == "") and info or info .. "\n" .. append    -- add append block: info = info+append (actually prepend+info+append)

    -- draw debugging box
    local font = love.graphics.getFont()
    local width,lines = font:getWrap(info,WIDTH)
    local boxHeight = lines*font:getHeight()
    love.graphics.setColor(RGBA(black,semitransparent))
    love.graphics.rectangle("fill",0,0,WIDTH,boxHeight)

    -- print info
    love.graphics.setColor(white)
    love.graphics.printf(info,0,0, WIDTH)

    --reset
    info,prepend,append = "","",""

  end
end

-- Insert a message to the end of the append block so append=new_message+append
-- m: message to insert
function debugAppend(m)
  if DEBUG then                                     -- check if debugging activated
    local union = (append == "") and "" or "\n"     -- define string connector as union=(append block empty)? "" : new_line
    append = append .. union .. m                   -- insert message at the end
  end
end

-- Insert a message to the begining of the prepend block so prepend=prepend+new_message
-- m: message to insert
function debugPrepend (m)
  if DEBUG then                                     -- check if debugging activated
    local union = (append == "") and "" or "\n"     -- define string connector as union=(prepend block empty)? "" : new_line
    prepend = m .. union .. prepend                 -- insert message at the begining
  end
end

-- Send new message to log file (log_file)
--  m: message
function log (m)
  -- TODO: implement
end
