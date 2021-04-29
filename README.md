`**elite**` is just a simple class module for the LÖVE2D game framework.

## Instructions
- copy `elite` folder inside your project directory

From `love.load()`
```lua
function love.load()
  elite = require("elite")
  ...
```
Proceeding inside `love.load()` function

## Functions
- use `elite.setImageDir(path)` to set the image source directory
  ```lua
    elite.setImageDir("images")
  ```
- use `elite.extend(self, object)` to extend a new object table (returns the object)
  ```lua
    player = elite.extend(elite, {})  -- accessing via property
    player = elite:extend({})         -- accessing via method
  ```
- use `elite.setMode(self, mode)` to set the default drawing mode of the object instanced
  ```lua
  player:setMode("quad")  -- set "quad" drawing mode to player object
  ```
  **NOTE**: All the following functions will depend on the mode you selected

  Available drawing modes are: `norm`, `quad`

  Additional fields are required to execute properly the extension:
    - `filename` *(string)(required)* the image name of the object including its format
    - `scale` *(table)(required)* a table containing the object's scale factors
      - `x` *(number)(required)* the x scale factor (set 1 for default value)
      - `y` *(number)(required)* the y scale factor (set 1 for default value)
    - `speed` *(table)(required)* a table containing the object's speed values
      - `x` *(number)(required)* the horizontal speed
      - `y` *(number)(required)* the vertical speed
      **NOTE**: The above listed properties are suitable for all objects that use *"norm"* as their drawing mode

    If you're using a sprite-sheet image, include the following properties
    - `sheets` *(table)(required)* a table to store quad pieces of image
    - `frame` *(table)(required)* a table to store the following properties
      - `current` *(number)(required)* the current frame (set to 1)
      - `rows` *(number)(required)* the number of sprites in the image's row
      - `cols` *(number)(required)* the number of sprites in the image's column
      - `width` *(number)(optional)* the width of one piece of sprite image (can be omitted or set to 1)
      - `height` *(number)(optional)* the height of one piece of sprite image (can be omitted or set to 1)
    - `button` *(table)(required)* a table containing buttons to move the object when keyboard button is down
      - `top` *(string)(required)* moves the object to the top
      - `bottom` *(string)(required)* moves the object to the bottom
      - `right` *(string)(required)* moves the object to the right
      - `left` *(string)(required)* moves the object to the left
    - `sequence` *(table)(required)* a table containing the draw sequence of quads to use
      - `idle` *(table)(require)* a table containing object's idle sequence
      - `top` *(table)(required)* a table containing object's top sequence
      - `bottom` *(table)(required)* a table containing object's bottom sequence
      - `right` *(table)(required)* a table containing object's right sequence
      - `left` *(table)(required)* a table containing object's left sequence
      **NOTE**: The above listed properties are suitable for all object that use *"quad"* as their drawing mode

Once the object is instantiated the latter can benefit from the following functions
- use `elite.load(self, value)` to load the given image's width and height
  - this function provides an additional parameter
    - `value` *(number)(otional)* this value will act based on the object's mode (range=?-?)
      - if mode is `norm` then the image will be scaled based on the scale factors (range=1-1)
        ```lua
        player:load(1)  -- the player's image will be scaled
        ```
      - if mode is `quad` then the image will apply a value to each frame to prevent bleeding (range=1-5)
        ```lua
        player:load(3)  -- a value of 3 will be applied to each frame
        ```

From `love.update(delta)`
- use `elite.update(self, delta, velocity)` to update the object's frames (only if using "quad" mode)
  - this function provides some additional parameters
    - `delta` *(number)(required)* the delta time value provided by love
    - `velocity` *(number)(optional)* the velocity value to be applied on the animation (range=1-(-1))
    ```lua
    function love.update(delta)
      player:update(delta, 30)  -- delta will be multiplied by 30
    end
    ```
    Once this function is implemented inside your `main.lua` file, you'll be able to move the object by pressing the appropriate buttons

From `love.draw()`
- use `elite.draw(self, debug)` to draw the object
  - this function provides and additional parameter
    - `debug` *(number)(optional)* if set to 1 it activates debugging (range=1-1)
  ```lua
  function love.draw()
    player:draw()   -- debug disabled (default)
    player:draw(1)  -- debug enabled
  end
  ```
