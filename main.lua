vector = require 'src/hump.vector'
gs = require 'src/hump.gamestate'
gs.states = {}
gs.states["game"] = require 'src/game'
gs.states["menu"] = require 'src/menu'
gs.states["game_over"] = require 'src/game_over'
gs.states["credits"] = require 'src/credits'

function love.load()
    gs.registerEvents()
    gs.switch(gs.states["menu"])
end

function love.keyreleased(k)
    if k == 'escape' then
        love.event.quit()
    end
end


