
Aircraft = class('Aircraft',Drawable)

function Aircraft:initialize(type,x,y,angle)
    super.initialize(self)
  
    self.checkpoints = List.new()
    self.speed = 35.0
    self.img = load("img/aircraft/aircraft".. type ..".png")
	self.rect = HC.addRectangle(x,y,self.img:getWidth(),self.img:getHeight())
	self.rect:rotate(angle)
	self.angle = angle
end

function Aircraft:update(dt)
  super.update(self,dt)
 
  local cp = List.peekleft(self.checkpoints)
  
  if cp ~= nil then
    
  else
	-- rotate vec(0,1) by angle
	local vx = math.sin(self.angle)
	local vy = -math.cos(self.angle)

	--self.rect:move(vx * self.speed * dt ,vy * self.speed * dt)
  end
end

function Aircraft:drag(x,y)
  
end
