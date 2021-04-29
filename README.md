`elite` is just a simple class module for the LÖVE2D game framework.

Actually it cannot be applied for the best perfomarce.

## Instructions
===============

- copy `elite.lua` inside your project directory

From `love.load()`
```lua
function love.load()
  elite = require("elite")
  ...
```
Proceeding inside `love.load()` function

## Functions
============

- use `elite.setImageDir(path)` to set the image source directory
  ```lua
    elite.setImageDir("images")
  ```
- use `elite.extend(self, object)` to extend a new object table (returns the object)
  ```lua
    player = elite.extend(elite, {})  -- accessing via property
    player = elite:extend({})         -- accessing via method
    -- DO NOT USE BOTH OF THEM --
  ```
- use `elite.setMode(self, mode)` to set the default drawing mode of the object instanced
  ```lua
  player:setMode("quad")  -- set "quad" drawing mode to player object
  ```

  Available mode are: `norm`, `quad`

  Additional fields are required to execute properly the extension:
    - `filename` the image name of the object including its format
    - `scale` a table with the following fields
      - `x` the x scale factor for the image (set 1 for default value)
      - `y` the y scale factor for the image (set 1 for default value)

    If you're using a sprite-sheet image, include the following properties
    - `sheets` a table to store quad pieces of image
    - `frame` a table to store the following properties
      - `current` the current frame (set to 1)
      - `rows` the number of frames in the image's row
      - `cols` the number of frames in the image's column
      - `size` a table to store the following properties
        - `width` the width of one piece of frame image (can be omitted or set to 1)
        - `height` the height of one piece of frame image (can be omitted or set to 1)

Once the object is instanced the latter can benefit from the following functions
- use `elite.load(self, value)` to load the given image's width and height
  - this function provides an additional parameter
    - `value` (number)(otional) this value will act based on the object's mode
      - if mode is `norm` then the image will be scaled based on the scale factors (range=1)
        ```lua
        player:load(1)  -- the player's image will be scaled
        ```
      - if mode is `quad` then the image will apply a value to each frame to prevent bleeding (range=5)
        ```lua
        player:load(3)  -- a value of 3 will be applied to each frame
        ```

From `love.draw()`
- use `elite.draw(self, debug)` to draw the object
  - this function provides and additional parameter
    - `debug` (number)(optional) if set to 1 it activates debugging
  ```lua
  function love.draw()
    player:draw()   -- disable debug (default)
    player:draw(1)  -- enable debug
  end
  ```
