

Aircraft = class('Aircraft')
function Aircraft:initialize(type)
    self.img = love.graphics.newImage("img/aircraft/aircraft1.png")
    self.rotation = 0
    self.x = 0
    self.y = 0
    self.scaleX = 1
    self.scaleY = 1
end



