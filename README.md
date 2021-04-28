elite.lua
=========

`elite.lua` is a simple class module for the LOVE2D game framework.
Actually it cannot be applied for the best perfomarce.

### Instructions
- copy `elite.lua` inside your project directory

From `love.load()`
```lua
function love.load()
  elite = require("elite")
  ...
```
Proceeding inside `love.load()` function

### Functions
- use `elite.setImageDir(path)` to set the image source directory
  ```lua
    elite.setImageDir("images")
  ```
- use `elite.extend(self, object)` to extend a new object table (returns the object)
  ```lua
    player = elite.extend(elite, {})  -- accessing via property
    player= elite:extend({})          -- accessing via method
    -- DO NOT USE BOTH OF THEM --
  ```
  Additional fields are required to execute properly the extension:
    - `filename` the image name of the object including its format
    - `scale` a table with the following fields
      - `x` the x scale factor for the image (set 1 for default value)
      - `y` the y scale factor for the image (set 1 for default value)
    if your are using a sprite-sheet image, include the following properties
    - `frame` a table with the following fields
      - `current` the current frame (set to 1)
      - `rows` the number of frames in the image's row
      - `cols` the number of frames in the image's column
    - `sheets` a table to store quad pieces of image

Once the object is instanced the latter can benefit from the following functions
- use `elite.load(self)` to load the given image and its width and height
  ```lua
    player:load()
  ```
- use `elite.rescale()` to rescale the object's width and height based on the appropriate scale factors value
  ```lua
    player:rescale()
  end
  ```

From `love.draw()`
- use `elite.draw(self, mode, debug)` to draw the object
  - this function provides some additional parameters
    - `mode`  (string)(required) set to "normal", "quad" based on image
    - `debug` (boolean)(optional) if set to true it activates debugging
  ```lua
  function love.draw()
    player:draw("normal")       -- debug is disable
    player:draw("normal", true) -- debug is enable
  end
  ```
