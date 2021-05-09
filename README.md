`elite` is just a simple class module for the LÖVE2D game framework.

## Disclaimer

This module was created with the only purpose to improve my programming skills and prevent coding several times the same thing.
A way to gain time was to create a class module that provides functions for loading sprite-sheets and animate them, basic physics simulation, 
collision detection and movements with keyboard buttons.


## Instructions
- copy `elite` folder inside your project directory

From `love.load()`
```lua
function love.load()
  elite = require("elite")
  ...
```
Proceeding inside `love.load()` function

- use `elite.setImageDir(path)` to set the image source directory
  - `path` *(string)(required)* the image folder path
  ```lua
  elite.setImageDir("images")
  ```
- use `elite.extend(self, object)` to extend a new object table (returns the object)
  - `object` *(table)(optional)* a table with necessary fields (default is an empty table)
  ```lua
  player = elite.extend(elite, {})  -- accessing via property
  player = elite:extend({})         -- accessing via method
  ```
- use `elite.setMode(self, mode)` to set the default drawing mode of the object
  - `mode` *(string)(required)* the drawing mode to apply to the object, available are `norm`, `quad`
  ```lua
  elite.setMode(player, "quad") -- or
  player:setMode("quad")        -- set "quad" drawing mode to player object
  ```

- use `elite.setGravity(self, gravity, increment)` to set a gravity to the object
  - `gravity` *(number)(required)* the gravity value to apply to the object
  - `increment` *(number)(required)* the increment value to apply to the gravity 
  ```lua
  elite.setGravity(player, 200, 30) -- or
  player:setGravity(200, 30)        -- set player as a "dynamic" body
  ```
- use `elite.jump(self, value)` to apply a vertical force to the object
  - `value` *(number)(required)* the value to apply to the object

  From `love.keypressed(key)`
  ```lua
  function love.keypressed(key)
    if (key == player.button.top) then
      elite.jump(player, 200)   -- or
      player:jump(200)          -- jump!
    end
  end
  ```
  **NOTE** the *"jump"* function will only be applied if the gravity is set with `elite.setGravity()`

  **NOTE**: All the following functions will depend on the mode you selected

  Additional fields are required to execute properly the extension:
    - `filename` *(string)(required)* the image name of the object including its format
    - `rotation` *(number)(optional)* the image rotation parameter
    - `scale` *(table)(optional)* a table containing the object's scale factors
      - `x` *(number)(required)* the x scale factor (set 1 for default value)
      - `y` *(number)(required)* the y scale factor (set 1 for default value)
    - `speed` *(table)(optional)* a table containing the object's speed values
      - `x` *(number)(required)* the horizontal speed
      - `y` *(number)(required)* the vertical speed

      **NOTE**: The above listed properties are suitable for all objects that use *"norm"* as their drawing mode

    If you're using a sprite-sheet image, include the following properties
    - `sheets` *(table)(optional)* a table to store quad pieces of image
    - `frame` *(table)(required)* a table to store the following properties
      - `current` *(number)(optional)* the current frame (set to 1)
      - `first` *(number)(optional)* the first frame of the active sequence
      - `last` *(number)(optional)* the last frame of the active sequence
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
      - `top` *(table)(required)* a table containing object's top sequence
      - `bottom` *(table)(required)* a table containing object's bottom sequence
      - `right` *(table)(required)* a table containing object's right sequence
      - `left` *(table)(required)* a table containing object's left sequence

      **NOTE**: Each field in the `sequence` table must have 2 tables with 2 properties:
        - `idle` *(table)(required)* a table containing idle frame sequence to animate
          - `from` *(number)(required)* where the frame should start
          - `to` *(number)(required)* where the frame should end
        - `walk` * (table)(required)* a table containing walk frame sequence to animate
          - `from` *(number)(required)* where the frame should start
          - `to` *(number)(required)* where the frame should end

      **NOTE**: The above listed properties are suitable for all object that use *"quad"* as their drawing mode

Once the object is instantiated the latter can benefit from the following functions
- use `elite.load(self, value)` to load the given image's width and height
  - `value` *(number)(optional)* this value will act based on the object's mode (range=?-?)
    - if mode is `norm` then the image will be scaled based on the scale factors (range=1-1)
    ```lua
      elite.load(player, 1) -- or
      player:load(1)        -- the player's image will be scaled
    ```
    - if mode is `quad` then the image will apply a value to each frame to prevent bleeding (range=1-5)
    ```lua
      elite.load(player, 3) -- or
      player:load(3)        -- a value of 3 will be applied to each frame
    end
    ```

From `love.update(delta)`
- use `elite.update(self, delta, velocity)` to update the object's frames (only if using "quad" mode)
  - `delta` *(number)(required)* the delta time value provided by love
  - `velocity` *(number)(optional)* the velocity value to be applied on the animation (range=1-(-1))
  ```lua
  function love.update(delta)
    elite.update(player, delta, 30) -- or
    player:update(delta, 30)        -- delta will be multiplied by 30
  end
  ```
  Once this function is implemented inside your `main.lua` file, you'll be able to move the object by pressing the appropriate buttons

From `love.draw()`
- use `elite.draw(self, debug)` to draw the object
  - `debug` *(number)(optional)* if set to 1 it activates debugging (range=1-1)
  ```lua
  function love.draw()
    elite.draw(player)  -- or
    player:draw()       -- debug disabled (default)

    elite.draw(1)   -- or
    player:draw(1)  -- debug enabled
  end
  ```

## Animation
- use `elite.animate(self, execute, direction)` to set the animation sequence and its direction
  - `execute` *(string)(required)* sets the sequence to display, available are `walk` or `idle`
  - `direction` *(string)(required)* sets the direction movement, available are `top`, `bottom`, `right` or `left`

  From `love.keypressed(key)`
  ```lua
  function love.keypressed(key)
    if (key == player.button.top) then
      elite.animate(player, "walk", "top")  -- or
      player:animte("walk", "top")          -- animate walk sequence moving the player to the top
    end
  end
  ```
  From `love.keyreleased(key)`
  ```lua
  function love.keyreleased(key)
    if (key == player.button.top) then
      player:animate("idle", "top")
    end
  end
  ```
  **NOTE**: An internal function uses `love.keyboard.isDown` after the key is pressed and held down, so you don't need to introduce a movement control code chunk

  **NOTE**: Use *"walk"* execute parameter each time the key is pressed and *"idle"* each time the key is released

## Collision
- use `elite.collision(self, target)` to detect intersections and collisions
  - `target` the target which the player will collide with

  From `love.update(delta)`
  ```lua
  function love.update(delta)
    player:collision(enemy)
  end
  ```
