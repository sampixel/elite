--[[
MIT License

Copyright (c) 2021 sampixel

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]

local path = ... .. "."
local lib = require(path .. "lib.lib")

local graphics = love.graphics
local keyboard = love.keyboard
local cw = graphics.getWidth()
local ch = graphics.getHeight()
local directory

local elite = {}

function elite.setImageDir(dirname)
  directory = (dirname:sub(#dirname, #dirname) ~= "/" and dirname .. "/" or dirname)
end

function elite.setMode(self, mode)
  assert(lib.mode(mode), "Could not load drawing function due to its wrong mode: \"" .. mode .. "\"")
  self.mode = mode
end

function elite.extend(self, object)
  local object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end 

function elite.load(self, value)
  lib.load(self, value, directory)

  self.image = graphics.newImage(directory .. self.filename)  -- norm/global section
  self.width = self.image:getWidth() * ((self.mode == "norm" and value == 1) and self.scale.x or 1)
  self.height = self.image:getHeight() * ((self.mode == "norm" and value == 1) and self.scale.y or 1)

  if (self.mode == "quad") then -- quad section
    self.frame.width = self.width / self.frame.rows
    self.frame.height = self.height / self.frame.cols
    self.frame.current = (not self.frame.current and 1 or self.frame.current)

    self.sheets = {}  -- declare table to store sprite sheets
    for col = 0, self.frame.cols - 1 do -- load image quad
      for row = 0, self.frame.rows - 1 do
        table.insert(self.sheets, graphics.newQuad(
          self.frame.width * row + (value or 0), self.frame.height * col + (value or 0),
          self.frame.width - (value or 0), self.frame.height - (value or 0),
          self.width, self.height
        ))
      end
    end
  end
end

function elite.update(self, delta, velocity)
  if (self.mode == "quad") then
    self.frame.current = (self.frame.current > self.frame.last and self.frame.first or self.frame.current + (delta * (velocity or 1)))  -- update current frame

    if (keyboard.isDown(self.button.top)) then -- movements
      self.y = self.y - (self.speed.y * delta)
    elseif (keyboard.isDown(self.button.bottom)) then
      self.y = self.y + (self.speed.y * delta)
    elseif (keyboard.isDown(self.button.right)) then
      self.x = self.x + (self.speed.x * delta)
    elseif (keyboard.isDown(self.button.left)) then
      self.x = self.x - (self.speed.x * delta)
    end
  end
end

function elite.draw(self, debug)
  if (debug) then
    assert(type(debug) == "number", "Wrong type of debug: number expected")
    lib.line(self)
  end

  if (self.mode == "norm") then
    graphics.draw(
      self.image, self.x, self.y,
      self.rotation or 0, self.scale.x or 1, self.scale.y or 1
    )
  elseif (self.mode == "quad") then
    graphics.draw(
      self.image, self.sheets[math.floor(self.frame.current)], self.x, self.y,
      self.rotation or 0, self.scale.x or 1, self.scale.y or 1
    )
  end
end

function elite.animate(self, execute, direction)
  lib.animate(self, execute, direction)

  self.frame.current = self.sequence[direction][execute].start
  self.frame.first = self.sequence[direction][execute].start
  self.frame.last = self.sequence[direction][execute].count
end

function elite.collision(self, target)
  if (self.x < target.x + target.width or target.x < self.x + (self.mode == "quad" and self.frame.width or self.width)) then
    self.x = target.x + target.width
  elseif (self.y < target.y + target.height or target.y < self.y + (self.mode == "quad" and self.frame.height or self.height)) then
    self.y = target.y + target.height
  end
end

return elite
