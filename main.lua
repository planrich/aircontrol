require 'middleclass.init'
require 'middleclass-extras.init'

require 'aircraft.lua'

function love.load()
    --init random seed
    math.randomseed(os.time())

    background = love.graphics.newImage("img/background/background1.jpg")
    playButton = love.graphics.newImage("img/play.png")

    aircraft1 = Aircraft:new(1)
    planes = {}
    planes[0] = aircraft1;
end

function love.keypressed(key, unicode)
   if key == "escape" then
      love.event.push('q')
   end
end

function love.draw()
    love.graphics.draw(background,0,0)
    for i,v in pairs(planes) do
        love.graphics.draw(v.img,0,0)
    end


    love.graphics.draw(playButton,0,0)


end

function love.quit()
  print("quiting")
end
