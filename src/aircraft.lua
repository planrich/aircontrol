
Aircraft = class('Aircraft',Drawable)

function Aircraft:initialize(typus,x,y,angle)
    Drawable.initialize(self)

    self.x = x
    self.y = y
    
    self.speed = 10.0
    self.img = load("img/aircraft/aircraft".. typus ..".png")
    self.rect = HC.addRectangle(x,y,self.img:getWidth(),self.img:getHeight())
    self:rotateTo(angle)
    
    self.checkpoints = List.new()
end

function Aircraft:rotateTo(angle)
    self.rect:rotate(-self.angle)
    self.rect:rotate(angle)
    self.angle = angle    
end

function Aircraft:update(dt)
    Drawable.update(self,dt)
 
    --check for checkpoint and rotate towards it
    local cp = List.peekleft(self.checkpoints)
    if cp ~= nil then
        local cx,cy = self.rect:center()

        local v_1_x = 0;
        local v_1_y = 1;

        local v_2_x = cx - cp.x
        local v_2_y = cy - cp.y

        local angle = calcAngle(v_1_x,v_1_y,v_2_x,v_2_y)

        --TODO do not turn immediatly
        --turn smoothly
        if 0 < v_2_x then
            self:rotateTo(2 * math.pi - angle);
        else
            self:rotateTo(angle);
        end

        if distance(cp.x,cp.y,cx,cy) < 5 then
            List.popleft(self.checkpoints) 
        end
    end

    --always keep going
    local vx = math.sin(self.angle)
    local vy = -math.cos(self.angle)
    
    self.rect:move(vx * self.speed * dt ,vy * self.speed * dt)
end

-- draw all checkpoints and draw in baseclass
function Aircraft:draw()
   for k,v in pairs(self.checkpoints) do
        if type(k) == "number" then
            v:draw()
        end
   end
   
   self.rect:draw("line")
end

--the plane has been clicked and wants to be dragged along this line
function Aircraft:drag(x,y)
    local cp = List.peekright(self.checkpoints)
    local cx = 0
    local cy = 0
    local mindist = 64
    if cp == nil then
        cx, cy = self.rect:center()
    else
        cx, cy = cp:center()
        mindist = 40
    end
    
    if (distance(cx,cy,x,y) > mindist) then
        --create new cp
        
        --keep checkpoints distance exactly the same
        local vx = x - cx
        local vy = y - cy
        
        local len = math.sqrt(scalar(vx,vy,vx,vy))
        
        vx = vx / len
        vy = vy / len
        
        vx = vx * mindist
        vy = vy * mindist
        
        x = vx + cx
        y = vy + cy	  
        
        --now create the checkpoint
        local newcp = Checkpoint:new(self,x,y,3,3)
        List.pushright(self.checkpoints,newcp)
    end
end

-- clear all checkpoints
function Aircraft:clearCheckpoints()
  while List.popleft(self.checkpoints) ~= nil do end
end
