pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- fireworks
-- by jonic

--[[
  this is a port of a html canvas
  experiment i made, which you
  can see here:

  https://fireworks.100yen.co.uk

  full code is on github here:

  https://github.com/jonic/pico-8-fireworks
]]

-->8
-- global vars

flash     = false
particles = {}
timeout   = 0

-->8
-- helpers

function rndangle()
  r = rnd(1)

  if r < .25 then
    a = .075 + rnd(.025)
  elseif r < .5 then
    a = .425 - rnd(.025)
  elseif r < .75 then
    a = .575 + rnd(.025)
  else
    a = .925 - rnd(.025)
  end

  return a + 0.5
end

function rndcol()
  local colors = { 2, 3, 4, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 }
  local index  = rndint(1, #colors)
  return colors[index]
end

function rndint(min, max)
  return flr(rnd(max)) + min
end

function tlen(t)
  local count = 0
  for i in all(t) do count += 1 end
  return count
end

-->8
-- particle

local particle = {}
particle.__index = particle

function particle.new(x, y)
  local self = setmetatable({}, particle)

  self.angle    = rndangle()
  self.color    = rndcol()
  self.friction = 0.97
  self.gravity  = 4
  self.x        = x
  self.y        = y
  self.size     = rndint(1, 2)
  self.velocity = rndint(2, 5)

  return self
end

function particle.is_outside_screen(self)
  return self.x < 0 or self.x > 138 or self.y > 128
end

function particle.draw(self)
  rectfill(self.x, self.y, self.x + self.size, self.y + self.size, self.color)
end

function particle.update(self, index)
  self.x        += cos(self.angle) * self.velocity
  self.y        += sin(self.angle) * self.velocity + self.gravity
  self.velocity *= self.friction

  if (self:is_outside_screen()) then
    particles[index] = nil
  end
end

-- firework

function create_firework()
  printh(time() .. ': FIREWORK')
  local i = 0
  local n = rndint(10, 20)
  local x = rndint(32, 64)
  local y = rndint(8,  32)

  flash     = true
  particles = {}

  while i < n do
    p = particle.new(x, y)
    add(particles, p)
    i += 1
  end

  sfx(0)
end

-- game loop

function _update()
  for i, p in pairs(particles) do
    p:update(i)
  end

  if (timeout <= 0) then
    create_firework()
    timeout = rndint(30, 60)
  end

  timeout -= 1
end

function _draw()
  local bg_color = flash and 7 or 0
  rectfill(0, 0, 128, 128, bg_color)
  flash = false

  for p in all(particles) do
    p:draw()
  end
end
__sfx__
000100000000000000300503005030050300500000000000210502105021050210502105000000000000000000000010500105001050010500105001050010500105000000000000000000000000000000000000
