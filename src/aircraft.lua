
Aircraft = class('Aircraft',Drawable)

function Aircraft:initialize(type,x,y,angle)
    Drawable.initialize(self)
  
    self.checkpoints = List.new()
    self.speed = 35.0
    self.img = load("img/aircraft/aircraft".. type ..".png")
	self.rect = HC.addRectangle(x,y,self.img:getWidth(),self.img:getHeight())
	self.rect:rotate(angle)
	self.angle = angle
end

function Aircraft:update(dt)
  Drawable.update(self,dt)
 
  local cp = List.peekleft(self.checkpoints)
  
  if cp ~= nil then
    
  else
	-- rotate vec(0,1) by angle
	local vx = math.sin(self.angle)
	local vy = -math.cos(self.angle)

	--self.rect:move(vx * self.speed * dt ,vy * self.speed * dt)
  end
end

function Aircraft:draw()
  for k,v in pairs(self.checkpoints) do
	--v:draw()
  end
    
  Drawable.draw(self)
end

function Aircraft:drag(x,y)
  local cp = List.peekright(self.checkpoints)
  local cx = 0
  local cy = 0
  local mindist = 50
  if cp == nil then
	cx, cy = self.rect:center()
  else
	cx = cp.x + cp.w / 2
	cy = cp.y + cp.h / 2
	mindist = 30
  end
  
  if (distance(cx,cy,x,y) > mindist) then
	  --create new cp
	print("new CP")
	  local newcp = Checkpoint:new(self,x,y,3,3)
	  List.pushright(self.checkpoints,newcp)
  end
end
