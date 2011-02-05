

Checkpoint = class("Checkpoint",Drawable)

function Checkpoint:initialize(parent,x,y,w,h)
    Drawable.initialize(self)
	self.parent = parent
	self.x = x - w / 2
	self.y = y - h / 2
	self.w = w
	self.h = h
    self.landingPoint = false
end

function Checkpoint:draw()
    Drawable.draw(self)
    
    if self.visible then
        --love.graphics.setColor({red=200,green=200,blue=200,alpha=0.5})
        love.graphics.rectangle("fill",self.x,self.y,self.w,self.h)
    end
end