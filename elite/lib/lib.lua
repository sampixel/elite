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

local graphics = love.graphics
local cw = graphics.getWidth()
local ch = graphics.getHeight()

local lib = {}

lib.list = {}
lib.list.mode = {"norm", "quad"}
lib.list.format = {"png", "jpg", "bmp", "tga", "hdr", "pic", "exr"}

function lib.mode(m) -- check if self.mode is in array
  for i = 1, #lib.list.mode do
    if (m == lib.list.mode[i]) then
      return true
    end
  end
end

function lib.format(f) -- check if format image is in array
  for i = 1, #lib.list.format do
    if (f == lib.list.format[i] or f == "jpeg") then
      return true
    end
  end
end

function lib.line(s)
  graphics.setColor(1, 1, 1, 1)
  graphics.line(
    s.x, s.y,
    s.x + (s.mode == "quad" and s.frame.width or s.width), s.y,
    s.x + (s.mode == "quad" and s.frame.width or s.width), s.y + (s.mode == "quad" and s.frame.height or s.height),
    s.x, s.y + (s.mode == "quad" and s.frame.height or s.height),
    s.x, s.y
  )
end

return lib
