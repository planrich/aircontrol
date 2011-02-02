
Drawable = class('Drawable')
function Drawable:initialize(world,x,y,w,h,angle)
    self.img = nil 
	self.x = 0
	self.y = 0
	self.w = 0
	self.h = 0
	self.angle = 0
    self.scaleX = 1
    self.scaleY = 1
end

function Drawable:setShape(shape)
  self.shape = shape
end

function Drawable:draw()
    if self.img ~= nil then
      
	  self.rect:draw('line')
	  --love.graphics.draw(self.img,self.x + self.w / 2,self.y + self.h / 2,self.angle,self.scaleX,self.scaleY, self.w / 2, self.h / 2)
    end
end

function Drawable:update(dt)
    --do nothing
end