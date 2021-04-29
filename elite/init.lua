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
  assert(directory, "Could not find image directory")
  assert(self.mode, "Could not find mode")
  assert(lib.format(self.filename:sub(-3, #self.filename)), "Missing image format from filename: \"" .. self.filename .. "\"")

  if (value) then
    assert(type(value) == "number", "Wrong type of value parameter: number expected")
    if (self.mode == "norm") then
      assert(value == 1, "Wrong value parameter: range=1")
    elseif (self.mode == "quad") then
      assert(value > 0 and value < 6, "Wrong value parameter: range=5")
    end
  end

  self.image = graphics.newImage(directory .. self.filename)
  self.width = self.image:getWidth() * ((self.mode == "norm" and value == 1) and self.scale.x or 1)
  self.height = self.image:getHeight() * ((self.mode == "norm" and value == 1) and self.scale.y or 1)

  if (self.mode == "quad") then
    self.frame.width = self.width * self.scale.x / self.frame.rows
    self.frame.height = self.height * self.scale.y / self.frame.cols

    for i = 0, self.frame.cols - 1 do
      for j = 0, self.frame.rows - 1 do
        table.insert(self.sheets, graphics.newQuad(
          (value or 0) + (j * self.frame.size.width), (value or 0) + (i * self.frame.size.height),
          self.frame.size.width - (value or 0), self.frame.size.height - (value or 0),
          self.width, self.height
        ))
      end
    end
  end
end

function elite.draw(self, debug)
  if (debug) then
    assert(type(debug) == "number", "Wrong type of debug: number expected")
    lib.line(self)
  end

  if (lib.mode(self.mode)) then
    if (mode == "norm") then
      graphics.draw(
        self.image, self.x, self.y,
        self.angle or 0, self.scale.x or 1, self.scale.y or 1
      )

    elseif (mode == "quad") then
      assert(self.frame,            "Missing frame table")
      assert(self.frame.current,    "Missing frame.current")
      assert(self.frame.num_width,  "Missing frame.num_width")
      assert(self.frame.num_height, "Missing frame.num_height")
      assert(self.frame.size,       "Missing frame.size table")
      assert(self.frame.size.width, "Missing frame.size.width")
      assert(self.frame.size.height,"Missing frame.size.height")
      assert(self.sheets,           "Missing sheets table")

      assert(type(self.frame) == "table",             "Wrong type in frame field: table expected")
      assert(type(self.frame.current) == "number",    "Wrong type in frame.current: number expected")
      assert(type(self.frame.num_width) == "number",  "Wrong type in frame.num_width: number expected")
      assert(type(self.frame.num_height) == "number", "Wrong type in frame.num_height: number expected")
      assert(type(self.frame.size) == "table",        "Wrong type in frame.size field: table expected")
      assert(type(self.frame.size.width) == "number", "Wrong type in frame.size.width: number expected")
      assert(type(self.frame.size.height) == "number","Wrong type in frame.size.height: number expected")
    end
  end
end

return elite
