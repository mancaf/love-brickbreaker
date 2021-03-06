local lume = require 'lib.lume'

local Entity = require 'core.Entity'

local particleImage = love.graphics.newImage('assets/img/particle_circle.png')

local Ball = Entity:extend()

local init = Ball.init
function Ball:init(t)
    init(self, t)
    assert(type(t.radius) == 'number', 'Ball requires number radius')
    assert(type(t.x) == 'number', 'Ball requires number x')
    assert(type(t.y) == 'number', 'Ball requires number y')
    assert(type(t.speed) == 'number', 'Ball requires number speed')
    assert(type(t.angle) == 'number', 'Ball requires number angle')
    assert(type(t.color) == 'table', 'Ball requires table color')
    assert(type(t.particleColor) == 'table', 'Ball requires table particleColor')
    self.x = t.x
    self.y = t.y
    self.vx = t.speed * math.cos(t.angle)
    self.vy = t.speed * math.sin(t.angle)
    self.radius = t.radius
    self.color = t.color
    self.particleColor = t.particleColor
    self:set{
        speed = {
            value = t.speed,
            get = function(self, value) return value end,
            set = function(self, speed)
                speed = speed or 0
                if speed < 0 then speed = 0 end
                if self.speed > 0 then
                    self.vx = self.vx * speed / self.speed
                    self.vy = self.vy * speed / self.speed
                end
                return speed
            end,
        },
        angle = {
            value = t.angle,
            get = function(self, value) return value end,
            set = function(self, angle)
                self.vx = self.speed * math.cos(angle)
                self.vy = self.speed * math.sin(angle)
                return angle
            end,
        }
    }
    self.ps = love.graphics.newParticleSystem(particleImage, 10)
    self.ps:setParticleLifetime(.2, .7)
    self.ps:setEmissionRate(20)
    self.ps:setSpeed(40)
    self.ps:setSpread(2*math.pi)
    self.ps:setTangentialAcceleration(-400, 400)
    self.ps:setSizes(.3, .2, 0)
    self.ps:setSizeVariation(.1)
    self.ps:setColors(
        self.color,
        self.particleColor
    )
end

function Ball:update(dt)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
    self.ps:setPosition(self.x, self.y)
    self.ps:update(dt)
end

function Ball:draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(self.ps)
    love.graphics.setColor(self.color)
    love.graphics.circle('fill', self.x, self.y, self.radius, 20)
end

return Ball
