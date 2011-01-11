Aircraft = {
    type = 0,
    x = 0,
    y = 0,
    width = 0,
    height = 0,
    radius = 0,
    scale = 1,
    img = nil,

    checkpoints = {}
}

function Aircraft:new (o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function Aircraft:draw ()
    love.graphics.draw(self.img,self.x,self.y,self.rotation,self.scale,self.scale)
end
