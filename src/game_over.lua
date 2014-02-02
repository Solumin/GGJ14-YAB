gs = require 'src/hump.gamestate'
timer = require 'src/hump.timer'

local gameOver = {}

local goFont
local cond
local score
local goTimer
local goHandle

local losepic1, losepic2
local winpic1, winpic2
local pic1, pic2
local currpic

function gameOver:init()
    goFont = love.graphics.newFont(44)
    goTimer = timer.new()

    losepic1 = love.graphics.newImage("resources/endlose1.png")
    losepic2 = love.graphics.newImage("resources/endlose2.png")

    winpic1 = love.graphics.newImage("resources/endwin1.png")
    winpic2 = love.graphics.newImage("resources/endwin2.png")
end

function gameOver:enter(prev, pcond, pscore)
    love.graphics.setBackgroundColor(0,0,0)
    cond = pcond
    score = pscore
    if cond == "time_out" then
        pic1, pic2 = winpic1, winpic2
    elseif cond == "no_lives" then
        pic1, pic2 = losepic1, losepic2
    end
    currpic = pic1
    goHandle = goTimer:add(13, function() gs.switch(gs.states["credits"]) end)
    goHandle = goTimer:add(3, function() currpic = pic2 end)
end

function gameOver:leave()
    goTimer:clear()
end

function gameOver:update(dt)
    goTimer:update(dt)
end

function gameOver:draw()
    love.graphics.draw(currpic, 0,0)
    love.graphics.print("Score: "..score, 0,0)
end

function gameOver:keyreleased(k)
    if k == ' ' then
        gs.switch(gs.states["credits"])
    end
end

return gameOver
