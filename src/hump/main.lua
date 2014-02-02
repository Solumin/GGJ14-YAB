Timer = require 'hump.timer'
function love.load()
    methods = {'linear', 'quad', 'cubic', 'quart', 'quint', 'sine', 'expo', 'circ', 'back', 'bounce', 'elastic'}
    method = methods[#methods]

    next_method = {} -- next_method.linear = 'quad', etc
    for i = 1,#methods do
        next_method[methods[i]] = methods[(i%#methods)+1]
    end

    target = {x = 700, brightness = 200, radius = 50}
    local function reset()
        circle = {
            {x = 100, y = 100, brightness = 100, radius = 20},
            {x = 100, y = 233, brightness = 100, radius = 20},
            {x = 100, y = 367, brightness = 100, radius = 20},
            {x = 100, y = 500, brightness = 100, radius = 20},
        }

        method = next_method[method]

        Timer.tween(3, circle[1], target, 'in-'..method)
        Timer.tween(3, circle[2], target, 'out-'..method)
        Timer.tween(3, circle[3], target, 'in-out-'..method)
        Timer.tween(3, circle[4], target, 'out-in-'..method,
            function() Timer.add(.5, reset) end)
    end

    reset()
end

function love.update(dt)
    Timer.update(dt)
end

function love.draw()
    love.graphics.setColor(255,255,255)
    love.graphics.print('in-' .. method, 50, 100-50)
    love.graphics.print('out-' .. method, 50, 233-50)
    love.graphics.print('in-out-' .. method, 50, 367-50)
    love.graphics.print('out-in-' .. method, 50, 500-50)

    for i = 1,#circle do
        love.graphics.setColor(255,255,255, circle[i].brightness)
        love.graphics.circle('fill', circle[i].x, circle[i].y,
            circle[i].radius)
    end
end
