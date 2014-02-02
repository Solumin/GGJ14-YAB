vector = require 'src/hump.vector'

-- Most of the following is also set by ship:init
ship = {
    normalImg = love.graphics.newImage("resources/battleship.png"),
    firingImg = love.graphics.newImage("resources/battleshipshoot.png"),
    position = vector(50,300),
    velocity = vector(0,0),
    acceleration = 100,
    max_backward = -4,
    max_forward = 8,
    max_yvel = 5,
    lives = 3,
    isDead = false
}

ship.img = ship.normalImg
ship.width = ship.img:getWidth()
ship.height = ship.img:getHeight()
local firing_cooldown = 1 --second
local firing_cooldown_limit = 1 -- constant! for restoring cooldown
local firing = false
local shots = {}
ship.shots = shots
-- cannon is +60, +11 pixels
local shot_offset = vector(60,11)

function ship:init()
    ship.position = vector(50,300)
    ship.velocity = vector(0,0)
    ship.lives = 3
    ship.isDead = false
    ship.img = ship.normalImg

    firing = false
    shots = {}
    ship.shots = shots
end

function ship:bounds()
    return {ship.position.x, ship.position.y, ship.width, ship.height}
end

function ship:damage(dam)
    ship.lives = ship.lives - dam
    if ship.lives <= 0 then
        ship.isDead = true
    end
end

function ship:update(dt)
    -- In what direction should the ship move?
    local delta = vector(0,0)
    if love.keyboard.isDown('left') then
        delta.x = -1
    elseif love.keyboard.isDown('right') then
        delta.x =  1
    end
    if love.keyboard.isDown('up') then
        delta.y = -0.5
    elseif love.keyboard.isDown('down') then
        delta.y =  0.5
    end
    -- If no delta, then slow the ship down
    if delta == vector(0,0) then
        ship.velocity = ship.velocity * 0.75
        ship.position = ship.position + ship.velocity
    end
    -- If no delta in a particular direction, stop that movement
    if delta.x == 0 then
        ship.velocity.x = 0
    end
    if delta.y == 0 then
        ship.velocity.y = 0
    end
    delta:normalize_inplace()

    ship.velocity = ship.velocity + delta * ship.acceleration * dt

    -- check max velocities
    local vel_x = ship.velocity.x
    if vel_x > ship.max_forward then
        ship.velocity.x = ship.max_forward
    elseif vel_x < ship.max_backward then
        ship.velocity.x = ship.max_backward
    end

    local vel_y = ship.velocity.y
    if math.abs(vel_y) > ship.max_yvel then
        ship.velocity.y = (vel_y < 0 and -ship.max_yvel or ship.max_yvel)
    end

    -- update position
    ship.position = ship.position + ship.velocity --* dt

    -- Make sure the ship stays within the level bounding box
    if ship.position.x > 700 then
        ship.position.x = 700
    elseif ship.position.x < 5 then
        ship.position.x = 5
    end
    if ship.position.y > 560 then
        ship.position.y = 560
    elseif ship.position.y < 65 then
        ship.position.y = 65
    end

    ship:update_firing(dt)
    ship:update_shots(dt)
end

function ship:draw()
    love.graphics.draw(ship.img, ship.position.x, ship.position.y)
    ship:draw_shots()
end

function ship:fire()
    if not firing then
        firing = true
        firing_cooldown = firing_cooldown_limit
        ship.img = ship.firingImg
        table.insert(shots, {pos = ship.position + shot_offset, del = 0})
    end
end

function ship:update_firing(dt)
    if not firing then return end

    firing_cooldown = firing_cooldown - dt
    
    -- only show the firing image for a frame or two
    if firing_cooldown < 0.75 then
        ship.img = ship.normalImg
    end
    if firing_cooldown <= 0 then
        firing = false
    end
end

function ship:update_shots(dt)
    local speed = vector(20, 0)
    for i,s in pairs(shots) do
        shots[i].pos = s.pos + speed
    end
end

function ship:draw_shots(dt)
    local r,g,b,a =  love.graphics.getColor()
    love.graphics.setColor(255, 170, 0)
    for i,s in pairs(shots) do
        love.graphics.circle('fill', s.pos.x, s.pos.y, 2, 6)
    end
    love.graphics.setColor(r,g,b,a)
end

function ship:remove_shots()
    if #shots == 0 then return end
    -- put all shots to be deleted at end of list
    table.sort(shots, function(a,b)
        return a.del < b.del
    end)
    -- find first shot to be deleted
    local idx = 0
    for i,shot in pairs(shots) do
        if shot.del == 1 then
            idx = i
            break
        end
    end
    if idx == 0 then return end
    local last = #shots
    -- remove the last n (= last - idx + 1) shots, which should be deleted
    for i = idx, last do
        assert(shots[i].del == 1, "Tried to unnecessarily delete a shot!")
        table.remove(shots)
    end
end

function ship:iterate_shots()
    local i = 0
    local n = #shots
    return function()
        i = i+1
        if i <= n then return shots[i] end
    end
end

function ship:clear()
    for i in pairs(ship.shots) do
        ship.shots[i] = nil
    end
end

return ship
