

Button = class("interface.Button",Drawable)

function Button:initialize(file,file_pressed)
   Drawable.initialize(self) 
   self.img = load("img/interface/"..file..".png")
   self.w = self.img:getWidth()
   self.h = self.img:getHeight()
   self.pressed = false
   
   if file_pressed ~= nil then
        self.img_pressed = load("img/interface/"..file_pressed..".png")
   end
end

function Button:setCallback(cb)
   self.callback = cb 
end

function Button:clicked(x,y,button)
    --print("clicked")
    if self.callback ~= nil and type(self.callback) == "function" then
        if self.img_pressed ~= nil then
            local i = self.img
            self.img = self.img_pressed
            self.img_pressed = i
        end
        
        
        self.callback()
    end
end