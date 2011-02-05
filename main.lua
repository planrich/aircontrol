require 'middleclass'
require 'middleclass-extras'
HC = require 'HardonCollider'

gameWidth = 1366
gameHeight = 768

dofile 'src/util.lua'
dofile 'src/queue.lua'
dofile 'src/loader.lua'
dofile 'src/timer.lua'

dofile 'src/drawable.lua'
dofile 'src/aircraft.lua'
dofile 'src/checkpoint.lua'

dofile 'src/interface/interface.lua'

dofile 'src/game.lua'

function love.load()
    --init random seed
    math.randomseed(os.time())
    game = Game:new()
end

function love.keypressed(key, unicode)
   if key == "escape" then
      love.event.push('q')
   else
	 
   end
end

function love.mousepressed( x, y, button )
	game:mousepressed( x, y, button )
end

function love.mousereleased( x, y, button )
	game:mousereleased( x, y, button )
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end

function love.quit()
    game:quit()
end

