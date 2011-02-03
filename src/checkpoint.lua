

Checkpoint = class("Checkpoint",Drawable)

function Checkpoint:initialize(parent,x,y,w,h)
    Drawable.initialize(self)
	self.parent = parent
	self.x = x - w / 2
	self.y = y - h / 2
	self.w = w
	self.h = h
end

function Checkpoint:draw()
	love.graphics.setColor({red=200,green=200,blue=200,alpha=0.5})
	love.graphics.draw("fill",self.x,self.y,self.w,self.h)
end
