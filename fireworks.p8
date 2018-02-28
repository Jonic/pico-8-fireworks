pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- fireworks
-- by jonic
-- v1.1.0

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
  diff = rnd(.025)
  r    = rnd(1)

  if     r < .25 then a = .075 + diff
  elseif r < .5  then a = .425 - diff
  elseif r < .75 then a = .575 + diff
  else                a = .925 - diff
  end

  return a
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

function particle(x, y)
  return {
    angle    = rndangle(),
    color    = rndcol(),
    friction = 0.97,
    gravity  = 4,
    x        = x,
    y        = y,
    size     = rndint(1, 2),
    velocity = rndint(2, 5),
    _update = function(p, index)
      p.x        += cos(p.angle) * p.velocity
      p.y        += sin(p.angle) * p.velocity + p.gravity
      p.velocity *= p.friction
    end,
    _draw = function(p)
      rectfill(p.x, p.y, p.x + p.size, p.y + p.size, p.color)
    end,
  }
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
    p = particle(x, y)
    add(particles, p)
    i += 1
  end

  sfx(0)
end

-- game loop

function _update()
  for i, p in pairs(particles) do
    p:_update(i)
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
    p:_draw()
  end
end
__sfx__
000100000000000000300503005030050300500000000000210502105021050210502105000000000000000000000010500105001050010500105001050010500105000000000000000000000000000000000000
