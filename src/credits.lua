gs = require 'src/hump.gamestate'
timer = require 'src/hump.timer'

local credits = {}
local creditsFont
local ctimer, chandle
local words = [[
YOU ARE A BATTLESHIP

-- Design --
Alexa Cain
Teddy Sudol

-- Art --
Alexa Cain 

-- Programming --
Teddy Sudol

-- Music --
Alex Cap
Martin Bayer

-- Consulting --
Jonathan Sterman
]]

function credits:init()
    creditsFont = love.graphics.newFont(20)
    ctimer = timer.new()
end

function credits:enter()
    love.graphics.setBackgroundColor(0,0,0)
    chandle = ctimer:add(15, function() gs.switch(gs.states["menu"]) end)
end

function credits:leave()
    ctimer:clear()
end

function credits:update(dt)
    ctimer:update(dt)
end

function credits:draw()
    love.graphics.setFont(creditsFont)
    love.graphics.setColor(255,255,255)
    love.graphics.printf(words, 0, 100, 800, "center")
end

function credits:keyreleased(k)
    if k == ' ' then
        gs.switch(gs.states["menu"])
    end
end

return credits
