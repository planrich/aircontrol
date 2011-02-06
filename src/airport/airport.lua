

Airport = class('airport.Airport',Drawable)

function Airport:initialize(type,x,y,w,h,landrotation,endx,endy)
    self.type = type
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.landingrotation = landrotation
    self.endx = endx
    self.endy = endy
end

function Airport:draw()
    love.graphics.setColor({255,0,0,100})
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor({255,255,255,255})
end

function Airport:canLand(type,x,y)
   return isin(x,y,self.x,self.y,self.w,self.h) and type == self.type 
end