gs = require 'src/hump.gamestate'
timer = require 'src/hump.timer'

local game = {}

local ship
local enemies
local fringe = {}
local score = 0
local leveltimer
local leveltimer_default = 60
local hudFont = love.graphics.setNewFont(30)
local battleIn, battleLoop
local gameTimer

function game:init()
    ship = require 'src/ship'
    enemies = require 'src/enemies'
    gameTimer = timer.new()
    fringe.img = love.graphics.newImage("resources/ocean.png")

    fringe.x, fringe.y = 0,0
    fringe.w, fringe.h = fringe.img:getWidth(), fringe.img:getHeight()

    battleIn = love.audio.newSource("resources/music/Battle! - intro.wav")
    battleLoop = love.audio.newSource("resources/music/Battle! - loop.wav")
    battleLoop:setLooping(true)
end

function game:enter()
    love.graphics.setBackgroundColor(67, 96, 144)
    fringe.x = 0

    ship.init()
    enemies.init()

    leveltimer = leveltimer_default
    score = 0

    battleIn:rewind()
    battleLoop:rewind()
    battleIn:play()

    gameTimer:add(5, function() enemies:start_spawning() end)
end

function game:leave()
    enemies:stop_spawning()
    enemies:clear()
    ship:clear()

    gameTimer:clear()

    battleIn:stop()
    battleLoop:stop()
end

function game:draw()
    drawFringe()
    ship:draw()
    enemies:draw()

    print_hud()
end

function game:update(dt)
    if battleIn:isStopped() then
        battleLoop:play()
    end

    gameTimer:update(dt)

    leveltimer = leveltimer - dt
    if leveltimer <= 0 then
        -- handle "out of time" condition
        gs.switch(gs.states["game_over"], "time_out", score)
    end
    if ship.isDead then
        gs.switch(gs.states["game_over"], "no_lives", score)
    end

    ship:update(dt)
    enemies:update(dt)

    -- collision detection: enemies over bullets.
    for e in enemies:iterate() do
        if e.del == 1 then break end
        for s in ship:iterate_shots() do
            if s.del == 1 then break end
            if e:in_bound(s.pos:unpack()) then
                s.del = 1
                e:mark()
                if e.et == "tugboat" then
                    score = score - 10
                else
                    score = score + 5
                end
            end
        end
        if e.del ~= 1 and e:overlap_bound(unpack(ship.bounds())) then
            if e.et ~= "tugboat" then
                ship:damage(1)
            else
                score = score - 10
            end
            e:mark()
        end
    end
    ship:remove_shots()
    enemies:remove_enemies()
end

function game:keypressed(k)
    if k == ' ' then
        ship:fire()
    end
end

function drawFringe()
    love.graphics.draw(fringe.img, fringe.x, 0)
    love.graphics.draw(fringe.img, fringe.x+fringe.w, 0)
    fringe.x = fringe.x - 4
    if fringe.x <= -fringe.w then fringe.x = 0 end
end

function print_hud()
    r,g,b,a = love.graphics.getColor()
    m = love.graphics.getColorMode()
    love.graphics.setColorMode('modulate')
    love.graphics.setFont(hudFont)
    love.graphics.setColor(200, 0, 75)

    love.graphics.print("Score: "..score, 0,0)

    str = string.format("%2.0f", leveltimer)
    love.graphics.printf(str, 0, 0, 800, "center")

    love.graphics.printf("Lives: " .. ship.lives, 0, 0, 800, "right")
    love.graphics.setColor(r,g,b,a)
    love.graphics.setColorMode(m)
end

return game
