-- scene-999
-- scene name : Exit Screen
-- scene functions are :
-- .init() for one-time initialization of stuff
-- .input() for all the key mapping
-- .start() to kickstart the scene
-- .update() for frame by frame activity
-- .draw() for the draw state


local K = {}

local helpText = ""


-- Scene's entry SFX
local sceneStartSFX = love.audio.newSource("music/LowEntropy-ExitLoop.ogg", "stream")

-- K.init is for loading assets for the scene
function K.init()
	bgart[999] = love.graphics.newImage("bgart/exitscreen.jpg")
	help[999] = ""
end




function K.input()
	-- R36S default Love2d keymapping [start]
	-- detecting key pressed
function love.keypressed( key, scancode, isrepeat )

   if scancode == "w" then
      -- D-Pad UP pressed
      triggerReport = "D-Pad UP pressed"
      dpadState[1] = "dn"
   elseif scancode == "a" then
      -- D-Pad LEFT pressed
      triggerReport = "D-Pad LEFT pressed"
      dpadState[2] = "dn"
   elseif scancode == "s" then
      -- D-Pad DOWN pressed
      triggerReport = "D-Pad DOWN pressed"
      dpadState[3] = "dn"
   elseif scancode == "d" then
      -- D-Pad RIGHT pressed
      triggerReport = "D-Pad RIGHT pressed"
      dpadState[4] = "dn"
   elseif scancode == "space" then
      -- Button X pressed
		love.event.quit()
   elseif scancode == "b" then
      -- Button Y pressed
		love.event.quit()
   elseif scancode == "lshift" then
      -- Button B pressed
		love.event.quit()
   elseif scancode == "z" then
      -- Button A pressed
		love.event.quit()
   elseif scancode == "escape" then
      -- SELECT pressed
      triggerReport = "SELECT pressed"
      miscState[1] = "dn"
   elseif scancode == "return" then
      -- START pressed
      triggerReport = "START pressed"
      miscState[2] = "dn"
   elseif scancode == "volumeup" then
      -- VOLUME UP pressed
      triggerReport = "Volume UP pressed"
      miscState[3] = "dn"
   elseif scancode == "volumedown" then
      -- VOLUME DOWN pressed
      triggerReport = "Volume DOWN pressed"
      miscState[4] = "dn"
   elseif scancode == "up" then
      -- L-Stick UP
      triggerReport = "L-Stick UP pressed"
      lstkState[1] = "dn"
   elseif scancode == "left" then
      -- L-Stick LEFT
      triggerReport = "L-Stick LEFT pressed"
      lstkState[2] = "dn"
   elseif scancode == "down" then
      -- L-Stick DOWN
      triggerReport = "L-Stick DOWN pressed"
      lstkState[3] = "dn"
   elseif scancode == "right" then
      -- L-Stick RIGHT
      triggerReport = "L-Stick RIGHT pressed"
      lstkState[4] = "dn"
   elseif scancode == "l" then
      -- Back L1 pressed
      triggerReport = "Back L1 pressed"
      bbtnState[1] = "dn"
   elseif scancode == "x" then
      -- Back L2 pressed
      triggerReport = "Back L2 pressed"
      bbtnState[2] = "dn"
   elseif scancode == "r" then
      -- Right R1 pressed
      triggerReport = "Back R1 pressed"
      bbtnState[3] = "dn"
   elseif scancode == "y" then
      -- Right R2 pressed
      triggerReport = "Back R2 pressed"
      bbtnState[4] = "dn"
   elseif scancode == "1" then
      -- L-Stick L3 pressed, edit gptokeyb for L3 = "1"
      triggerReport = "L-Stick L3 pressed"
      miscState[5] = "dn"
   elseif scancode == "2" then
      -- R-Stick R3 pressed, edit gptokeyb for R3 = "2"
      triggerReport = "R-Stick R3 pressed"
      miscState[6] = "dn"
   end
end

-- detecting key released
function love.keyreleased( key, scancode )

   if scancode == "w" then
      -- D-Pad UP released
      triggerReport = "D-Pad UP released"
      dpadState[1] = "up"
   elseif scancode == "a" then
      -- D-Pad LEFT released
      triggerReport = "D-Pad LEFT released"
      dpadState[2] = "up"
   elseif scancode == "s" then
      -- D-Pad DOWN released
      triggerReport = "D-Pad DOWN released"
      dpadState[3] = "up"
   elseif scancode == "d" then
      -- D-Pad RIGHT released
      triggerReport = "D-Pad RIGHT released"
      dpadState[4] = "up"
   elseif scancode == "space" then
      -- Button X released
      triggerReport = "Button X released"
      fbtnState[1] = "up"
   elseif scancode == "b" then
      -- Button Y released
      triggerReport = "Button Y released"
      fbtnState[2] = "up"
   elseif scancode == "lshift" then
      -- Button B released
      triggerReport = "Button B released"
      fbtnState[3] = "up"
   elseif scancode == "z" then
      -- Button A released
      triggerReport = "Button A released"
      fbtnState[4] = "up"
   elseif scancode == "escape" then
      -- SELECT released
      triggerReport = "SELECT released"
      miscState[1] = "up"
   elseif scancode == "return" then
      -- START released
      triggerReport = "START released"
      miscState[2] = "up"
   elseif scancode == "volumeup" then
      -- VOLUME UP released
      triggerReport = "Volume UP released"
      miscState[3] = "up"
   elseif scancode == "volumedown" then
      -- VOLUME DOWN released
      triggerReport = "Volume DOWN released"
      miscState[4] = "up"
   elseif scancode == "up" then
      -- L-Stick UP released
      triggerReport = "L-Stick UP released"
      lstkState[1] = "up"
   elseif scancode == "left" then
      -- L-Stick LEFT released
      triggerReport = "L-Stick LEFT released"
      lstkState[2] = "up"
   elseif scancode == "down" then
      -- L-Stick DOWN released
      triggerReport = "L-Stick DOWN released"
      lstkState[3] = "up"
   elseif scancode == "right" then
      -- L-Stick RIGHT released
      triggerReport = "L-Stick RIGHT released"
      lstkState[4] = "up"
   elseif scancode == "l" then
      -- Back L1 released
      triggerReport = "Back L1 released"
      bbtnState[1] = "up"
   elseif scancode == "x" then
      -- Back L2 released
      triggerReport = "Back L2 released"
      bbtnState[2] = "up"
   elseif scancode == "r" then
      -- Right R1 released
      triggerReport = "Back R1 released"
      bbtnState[3] = "up"
   elseif scancode == "y" then
      -- Right R2 released
      triggerReport = "Back R2 released"
      bbtnState[4] = "up"
    elseif scancode == "1" then
      -- L-Stick L3 released, edit gptokeyb for L3 = "1"
      triggerReport = "L-Stick L3 released"
      miscState[5] = "up"
   elseif scancode == "2" then
      -- R-Stick R3 released, edit gptokeyb for R3 = "2"
      triggerReport = "R-Stick R3 released"
      miscState[6] = "up"
  end
end


-- R36S default for R-Stick (mouse) 
function love.mousemoved( x, y, dx, dy, istouch )
	triggerReport = "x:" .. x .. " y:" .. y .. " dx:" .. dx .. " dy:" .. dy
	if dy < -1 then
		rstkState[1] = "ok"
	end
	if dx < -1 then
		rstkState[2] = "ok"
	end
	if dy > 1 then
		rstkState[3] = "ok"
	end
	if dx > 1 then
		rstkState[4] = "ok"
	end
end

end



-- K.start is to init anything when scene starts, can be reloaded multiple times
function K.start()
	sceneStartSFX:setLooping(true)
	sceneStartSFX:play()
end






-- this scene's update for each frame
function K.update()

end









-- this scene's screen draws go here
function K.draw()
	love.graphics.setFont(gameFont)
	if love.keyboard.isScancodeDown("escape") then
    	helpText = help[999]
	else
		helpText = ""
    end
    love.graphics.printf(helpText, gameFont, 50, 80, 540, "left")
end


return K
-- R36S default Love2d keymapping [end]