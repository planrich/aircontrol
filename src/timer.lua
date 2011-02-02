
TimerEvent = class('TimerEvent')

function TimerEvent:initialize(f,delay,c)
    self.delay = delay / 1000
    self.triggerTime = delay / 1000 + love.timer.getTime()
    self.count = c 
    self.triggered = 0 
    self.func = f 
end


Timer = class('Timer')

function Timer:initialize()
    self.events = {}
    self.count = 0
end

function Timer:add(event)
    self.events[self.count] = event;
    self.count = self.count + 1
end

function Timer:update()
    local now = love.timer.getTime()
    for i,v in pairs(self.events) do
        if v.triggerTime < now then
            v.func()
            v.triggered = v.triggered + 1
            v.triggerTime = v.delay + now

            if v.triggered >= v.count and v.count > 0 then
                table.remove(self.events,i)
            end
        end
    end
end
