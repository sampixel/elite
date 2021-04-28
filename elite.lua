local graphics = love.graphics
local cw = graphics.getWidth()
local ch = graphics.getHeight()
local directory

local elite = {}

function elite.setImageDir(dirname)
  directory = (dirname:sub(#dirname, #dirname ~= "/") and dirname .. "/" or dirname)
end

function elite.extend(self, object)
  local object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

function elite.load(self)
  assert(type(directory) == "string", "Could not find image directory")
  self.image = graphics.newImage(directory .. self.filename)
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
end

function elite.draw(self, mode, debug)
  assert(mode and type(mode) == "string", "Missing mode parameter")
  assert(debug and type(debug) == "boolean", "Missing debug parameter")

  local function check()
    local list_mode = {"normal", "quad"}
    for i = 1, #list_mode do
      if (mode == list_mode[i]) then
        return true
      end
    end
    assert(v:find(mode), "Could not load drawing function due to its wrong mode: \"" .. mode .. "\"")
  end

  local function line()
    graphics.setColor(1, 1, 1, 1)
    graphics.line(
      self.x, self.y,
      self.x + self.width, self.y,
      self.x + self.width, self.y + self.height,
      self.x, self.y + self.height,
      self.x, self.y
    )
  end

  if (check()) then
    if (mode == "normal") then
      graphics.draw(
        self.image, self.x, self.y,
        self.angle or 0, self.scale.x or 1, self.scale.y or 1
      )

      if (debug) then
        line()
      end
    elseif (mode == "quad") then
      assert(self.frame, "Missing frame table")
      assert(self.frame.current, "Missing frame.current")
      assert(self.frame.num_width, "Missing frame.num_width")
      assert(self.frame.num_height, "Missing frame.num_height")
      assert(self.frame.size, "Missing frame.size table")
      assert(self.frame.size.width, "Missing frame.size.width")
      assert(self.frame.size.height, "Missing frame.size.height")
      assert(self.sheets, "Missing sheets table")

      assert(type(self.frame) == "table", "Wrong type in frame field: table expected")
      assert(type(self.frame.current) == "number", "Wrong type in frame.current: number expected")
      assert(type(self.frame.num_width) == "number", "Wrong type in frame.num_width: number expected")
      assert(type(self.frame.num_height) == "number", "Wrong type in frame.num_height: number expected")
      assert(type(self.frame.size) == "table", "Wrong type in frame.size field: table expected")
      assert(type(self.frame.size.width) == "number", "Wrong type in frame.size.width: number expected")
      assert(type(self.frame.size.height) == "number", "Wrong type in frame.size.height: number expected")

      for i = 0, self.frame.num_height - 1 do
        for j = 0, self.frame.num_width - 1 do
          table.insert(self.sheets, graphics.newQuad(
            j * self.frame.size.width, i * self.frame.size.height,
            self.frame.size.width, self.frame.size.height,
            self.width, self.height
          ))
        end
      end

      if (debug) then
        line()
      end
    end
  end
end

function elite.rescale(self)
  self.width = self.width * self.scale.x
  self.height = self.height * self.scale.y
end

return elite
