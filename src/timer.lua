
TimerEvent = class('TimerEvent')

function TimerEvent:initialize(f,delay,c)
    self.delay = delay / 1000
    self.count = c 
    self.func = f 
    
    self.triggered = 0 
    self.triggerTime = love.timer.getTime()
end


Timer = class('Timer')

function Timer:initialize()
    self.events = {}
    self.count = 0
end

function Timer:add(event)
    if type(event.func) == "function" then   
        event.index = self.count
        self.events[self.count] = event;
        self.count = self.count + 1
    else
        print("error: added TimerEvent without a callback function as param.")
    end
end

function Timer:update()
    local now = love.timer.getTime()
    for i,v in pairs(self.events) do
        local triggerTime = (v.triggerTime + (v.delay / game.speed))
        if triggerTime < now then
            v.func()
            v.triggered = v.triggered + 1
            v.triggerTime = now

            if v.triggered >= v.count and v.count > 0 then
                table.remove(self.events,i)
            end
        end
    end
end
