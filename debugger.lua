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
    info = info .. "\nPosition:\t("..math.floor(player.getX()) .. ","..math.floor(player.getY())..")"     -- player position
    info = info .. "\nShadows:\t" .. player.shadowsCount()                                                -- player shadows count
    local c = player.contacts()                                                                           -- player contacts...
    info = info .. "\nContacts:"
    local nc = 0                                                                                          -- ... number of contacts
    for id,normalY in pairs(c) do                                                                         -- ... elements contacted
      nc = nc + 1
      info = (nc > 1) and info .. "/" or info .. "\t"
      info = info .. id
    end
    if nc == 0 then info = info .. "\t(any)" end
    info = (prepend == "") and info or prepend .. "\n" .. info
    info = (append == "") and info or info .. "\n" .. append

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

-- Append a message to debugger
-- m: message
function debugAppend(m)
  if DEBUG then
    local union = (append == "") and "" or "\n"
    append = append .. union .. m
  end
end

-- Prepend a message to debugger
-- m: message
function debugPrepend (m)
  if DEBUG then
    local union = (append == "") and "" or "\n"
    prepend = m .. union .. prepend
  end
end

-- Send new message to log file (log_file)
--  m: message
function log (m)
  -- TODO: implement
end
