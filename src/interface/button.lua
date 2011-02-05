

Button = class("interface.Button",Drawable)

function Button:initialize(file)
   Drawable.inistialize(self) 
   self.img = load(file)
end
