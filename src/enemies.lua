vec = require 'src/hump.vector'
timer = require 'src/hump.timer'

enemies = {}
local formations = require "src/enemy_formations"
local etypes = {}
etypes["red"] = {speed = vec(-65,0),
    img = love.graphics.newImage("resources/enemies/redship.png")}
etypes["blue"] = {speed = vec(-50,0),
    img = love.graphics.newImage("resources/enemies/blueship.png")}
etypes["green"] = {speed = vec(-40,0),
    img = love.graphics.newImage("resources/enemies/greenship.png")}
etypes["police"] = {speed = vec(80,0),
    img = love.graphics.newImage("resources/enemies/policeboat.png")}
etypes["tugboat"] = {speed = vec(-55,0),
    img = love.graphics.newImage("resources/enemies/ssdistress.png")}
local etimer = timer.new()
local spawnHandle

function enemies:init()
    enemies.list = {}
end

function enemies:addEnemy(et, pos)
    assert(vec.isvector(pos))

    table.insert(enemies.list, newEnemy(et, pos))
end

function newEnemy(et, pos)
    local enemy = {
        et = et,
        pos = pos,
        speed = etypes[et].speed,
        img = etypes[et].img,
        del = 0
    }
    enemy.width = enemy.img:getWidth()
    enemy.height = enemy.img:getHeight()
    function enemy:in_bound(x,y)
        return (x > enemy.pos.x and x < enemy.pos.x+enemy.width) and
               (y > enemy.pos.y and y < enemy.pos.y+enemy.height)
    end
    function enemy:overlap_bound(bx,by, w,h)
        local bdx, bdy = bx+w, by+h -- other rect. is (bx,by) to (bdx, bdy)
        local ax, ay = enemy.pos:unpack()
        local adx, ady = ax + enemy.width, ay + enemy.height -- our rect.
        -- proof by contradiction, essentially
        return (ax <= bdx) and (adx >= bx) and (ay <= bdy) and (ady > by)
    end
    function enemy:mark()
        enemy.del = 1
    end
    return enemy
end

function enemies:draw()
    for i,e in pairs(enemies.list) do
        love.graphics.draw(e.img, e.pos:unpack())
    end
end

function enemies:update(dt)
    etimer:update(dt)
    for i,e in pairs(enemies.list) do
        e.pos = e.pos + e.speed * dt
    end
end

function enemies:remove_enemies()
    if #enemies.list == 0 then return end
    -- put all enemies to be deleted at end of list
    table.sort(enemies.list, function(a,b)
        return a.del < b.del
    end)
    -- find first enemy to be deleted
    local idx = 0
    for i,shot in pairs(enemies.list) do
        if shot.del == 1 then
            idx = i
            break
        end
    end
    if idx == 0 then return end
    local last = #enemies.list
    -- remove the last n (= last - idx + 1) enemies
    for i = idx, last do
        --assert(enemies.list[i].del == 1, "Tried to unnecessarily delete an enemy!")
        table.remove(enemies.list)
    end
end

function enemies:iterate()
    local i = 0
    local n = #enemies.list
    return function()
        i = i + 1
        if i <= n then 
            return enemies.list[i]
        else return nil end
    end
end

function enemies:clear()
    for i in pairs(enemies.list) do
        enemies.list[i] = nil
    end
    etimer:clear()
end

function deploy_formation(idx)
    local idx = math.random(1, #formations)
    local f = formations[idx]
    local range = 0
    if f[#f].y ~= nil then
        range = math.random(0, 560-f[#f].y-30)
    end
    for i,e in pairs(f) do
        if e.y == nil then
            e.y = math.random(65, 560)
        end
        enemies:addEnemy(e.enemy, vec(e.x, e.y+range))
    end
end

function enemies:start_spawning()
    deploy_formation()
    spawnHandle = etimer:addPeriodic(6, function() deploy_formation() end)
end

function enemies:stop_spawning()
    etimer:cancel(spawnHandle)
end

return enemies
