Game = class('Game')

function Game:initialize()  
    HC.init(100, collision_start, collision_persist, collision_stop)
  
    self.background = load("img/background/background1.jpg")

    self.objects = {}
    self.objectCount = 0
    self.score = 0
    self.speed = 1.0
    self.spawnChance = 0.3
    self.timer = Timer:new()

    self.mouseCollision = nil
    self.focus = nil

    local plane = Aircraft:new(1,50,50,90 * math.pi / 180)
    self:addPlane(plane)

    local plane2 = Aircraft:new(1,500,50,270 * math.pi / 180)
    self:addPlane(plane2)
end

function Game:addPlane(p)
	p.rect.index = self.objectCount;
    self.objects[self.objectCount] = p
    self.objectCount = self.objectCount + 1
end

function Game:mousepressed( x, y, button )
  --print("down")
  self.mouseCollision = HC.addRectangle(x,y,1,1)   
end

function Game:mousereleased( x, y, button )
  if self.mouseCollision ~= nil then
    HC.remove(self.mouseCollision)
  end
  
  if self.focus ~= nil then
    --print("stop dragging")
  end

  self.focus = nil
end

function Game:update(dt)  
  self.timer:update()
  
  -- we have focus and well drag plane
  if self.focus then
	local x = love.mouse:getX()
	local y = love.mouse:getY()
	
	self.focus:drag(x,y)
  end
  
  HC.update(dt)
  
  for k,v in pairs(self.objects) do
     v:update(dt)
  end
end

function Game:draw()
    love.graphics.draw(self.background,0,35)
    
    for k,v in pairs(self.objects) do
        v:draw()
    end
end

function Game:quit()

end

function spawn()
  if 1.0 <= 1.0 then
    local x,y,angle = randomSpawnPoint()
    local plane = Aircraft:new(1)   
    game:addPlane(plane)
  end
end

function randomSpawnPoint()
    local x = 0
    local y = 0
    local rot = 0
    local windowWidth = gameWidth
    local windowHeight = gameHeight
    local h = 52
    local w = 52

    local side = math.random(0,3); --0 top 1 right 2 bottom 3 left

    if side == 0 then
        y = -h;
        x = 50 + math.random() * (windowWidth - 100);
        rot = math.random(180 - 45, 180 + 45);
    elseif side == 1 then
        y = 50 + math.random() * (windowHeight - 100);
        x = windowWidth;
        rot = math.random(270 - 45, 270 + 45);
    elseif side == 2 then
        y = windowHeight;
        x = 50 + math.random() * (windowWidth - 100);
        rot = math.random(-45, 45);
    elseif side == 3 then
        y = 50 + math.random() * (windowHeight - 100);
        x = -w;
        rot = math.random(90 - 45, 90 + 45);
    end

    rot = rot % 360;
    
    angle = rot * math.pi / 180

    return x,y,angle
end

function collision_start(dt, shape_a, shape_b, mtv_x, mtv_y)
  
  if shape_a == game.mouseCollision or shape_b == game.mouseCollision then
	if shape_a == game.mouseCollision then
	  game.focus = game.objects[shape_b.index]
	else
	  game.focus = game.objects[shape_a.index]
	end
	game.focus:clearCheckpoints()
	HC.remove(game.mouseCollision)
	game.mouseCollision = nil
  else
	local p1 = game.objects[shape_a.index]
	local p2 = game.objects[shape_b.index]
	
	game.objects[shape_a.index] = nil
	game.objects[shape_b.index] = nil
	
	HC.remove(p1.rect) 
	HC.remove(p2.rect)
  end
end

-- this is called when two shapes continue colliding
function collision_persist(dt, shape_a, shape_b, mtv_x, mtv_y)

end

-- this is called when two shapes stop colliding
function collision_stop(dt, shape_a, shape_b)

end

