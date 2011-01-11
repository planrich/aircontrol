require 'aircraft.lua'

function love.load()
    --init random seed
    math.randomseed(os.time())

    background = love.graphics.newImage("img/background/background1.jpg")
    playButton = love.graphics.newImage("img/play.png")

    planes = {}

    planes[0] = Aircraft:new()
    planes[0].img = love.graphics.newImage("img/aircraft/small_aircraft.png")
end

function love.keypressed(key, unicode)
   if key == "escape" then
      love.event.push('q')
   end
end

function love.draw()
    love.graphics.draw(background,0,0)
    for i,v in pairs(planes) do
        v.draw()
    end


    love.graphics.draw(playButton,0,0)


end

function love.quit()
  print("quiting")
end
