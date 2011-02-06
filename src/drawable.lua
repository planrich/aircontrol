
Drawable = class('Drawable')

function Drawable:initialize()
    self.visible = true
    self.img = nil
    self.rect = nil
    self.x = 0
    self.y = 0
    self.w = 0
    self.h = 0
    self.angle = 0
    self.scale = 1
end

function Drawable:draw()   
    if self.visible then
        if self.img ~= nil then
            love.graphics.draw(self.img,self.x + self.w / 2, self.y + self.h / 2, self.angle, self.scale, self.scale, self.w / 2, self.h / 2)
        end
    end
end

function Drawable:update(dt)
    --do nothing
end

function Drawable:center()
    return self.x + self.w / 2, self.y + self.h / 2
end