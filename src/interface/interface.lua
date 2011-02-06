Interface = class('interface.Interface')

function Interface:initialize()  
    self.background = load("img/interface/background.png")

    self.objects = {}
    self.objectCount = 0
    
    local x = 0
    local y = 0
    local b = Button:new("play","pause")
    b:setCallback(onPlay)
    b.x = x
    b.y = y
    self:addAt(b,x,y)
    x = x + 35
    
    b = Button:new("speed","speed2")
    b:setCallback(onSpeed)
    b.x = x
    b.y = y
    self:addAt(b)
    x = x + 35
    
    b = Button:new("settings")
    b:setCallback(onSettings)
    b.x = x
    b.y = y
    self:addAt(b)
    x = x + 35
    
    b = Button:new("scores")
    b:setCallback(onScores)
    b.x = x
    b.y = y
    self:addAt(b)
    x = x + 35
    
    b = Button:new("info")
    b:setCallback(onInfo)
    b.x = x
    b.y = y
    self:addAt(b)
    
    b = Button:new("quit")
    b:setCallback(onQuit)
    b.x = gameWidth - b.img:getWidth()
    b.y = y
    self:addAt(b)
    
    love.graphics.setFont(25)
end

function Interface:addAt(widget)
    widget.index = self.objectCount;
    self.objects[self.objectCount] = widget
    self.objectCount = self.objectCount + 1
end

function Interface:mousepressed( x, y, button )
    
end

function Interface:mousereleased( x, y, button )
    for k,v in pairs(self.objects) do
        if isin(x,y,v.x,v.y,v.w,v.h) then
            v:clicked(x,y,button)
            break
        end
    end
end

function Interface:update(dt)  

end

function Interface:draw()
    love.graphics.draw(self.background,0,0)
    
    for k,v in pairs(self.objects) do
        v:draw()
    end
    
    love.graphics.setColor({0,0,0,255})
    love.graphics.print(game.score .. " landed", 250, 3)
    love.graphics.setColor({255,255,255,255})
end