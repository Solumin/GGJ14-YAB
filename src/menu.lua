timer = require 'src/hump.timer'
gs = require 'src/hump.gamestate'

local menu = {}

local blinkColor = {81, 178, 214}
local blinkRect = {345, 360, 130, 35}
local blinkVisible = false -- true = can see "START"
local menuImg
local menuTimer = timer.new()
local blinkHandler
local menuMusic
function menu:init() 
    -- load menu graphic
    menuImg = love.graphics.newImage("resources/titlescreen.png")
    menuMusic = love.audio.newSource("resources/music/YOU ARE A BATTLESHIP theme.wav")
    menuMusic:setLooping(true)
end

function menu:draw()
    love.graphics.draw(menuImg, 0,0) 
    if blinkVisible then
        love.graphics.setColor(unpack(blinkColor))
        love.graphics.rectangle('fill', unpack(blinkRect))
        love.graphics.setColor(255,255,255)
    end
end

function menu:update(dt)
    menuTimer:update(dt)
end

function menu:keyreleased(k)
    if k == 'return' then -- also known as 'enter'
        gs.switch(gs.states["game"])
    elseif k == 'c' then -- credits
        gs.switch(gs.states["credits"])
    end
end

function menu:enter()
    love.graphics.setBackgroundColor(0,0,0)
    blinkHandler = menuTimer:addPeriodic(0.8, function()
        blinkVisible = not blinkVisible
    end)
    menuMusic:play()
end

function menu:leave()
    menuMusic:stop()
    menuTimer:clear()
end

return menu
