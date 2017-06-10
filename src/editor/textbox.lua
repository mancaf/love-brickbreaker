local w, h = love.graphics.getDimensions()

-- textbox for text input
local textBox = {
    x = 0,
    y = h - 50,
    width = w,
    height = 50,
    rawText = '',
    text = love.graphics.newText(love.graphics.getFont()),
    active = false,
    colors = {
        background = {255, 255, 255},
        text = {0, 0, 0}
    },
}

function textBox:draw()
    love.graphics.setColor(unpack(self.colors.background))
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.setColor(unpack(self.colors.text))
    love.graphics.draw(self.text, self.x, self.y)
end

function textBox:mousepressed(x, y, button)
    if button == 1 then
        if x >= self.x
        and x <= self.x + self.width
        and y >= self.y
        and y <= self.y + self.height then
            self.active = true
            print('textbox:active')
        elseif self.active then
            self.active = false
            print('textbox:inactive')
        end
    end
end

function textBox:textinput(text)
    if self.active then
        self.rawText = self.rawText .. text
        self.text:set(self.rawText)
    end
end

return textBox
