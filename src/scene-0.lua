-- scene-0
-- scene name : Boot Screen
-- scene functions are :
-- .input() for all the key mapping
-- .draw() for the draw state


local sceneNumber = 0
local autosavedScene = 0

-- graphical overlay for this scene's help
local helpTextOverlay = love.graphics.newImage("bgart/bootscreen.png")

-- Scene's entry SFX
local sceneStartSFX = love.audio.newSource("sfx/SMBootSound.ogg", "static")

-- Reset All Data warning
local resetAllData = love.graphics.newImage("pic/reset-all-data.png")
local resetChargeTime = 0 -- counter to detect 3 seconds hold
local resetDone = false -- state of reset

local K = {} -- for return functions to main.lua

local helpText = ""



-- K.init is for loading assets for the scene (done only once at game load)
function K.init()
	-- background to display
	bgart[sceneNumber] = love.graphics.newImage("bgart/bootscreen.png")
	-- help text to appear
	help[sceneNumber] = ""
	game.tooltip = ""
	
	-- load autosaved scene (last scene before quit)
	local f = io.input (love.filesystem.getSaveDirectory().."//autosaves/currentscene.txt")
	autosavedScene = tonumber(f:read())
	game.tooltip = ""
	f:close()
end



-- K.start is to init anything when scene starts, can be reloaded multiple times
function K.start()
	love.audio.play(sceneStartSFX)
end




-- K.input is for keymapping
function K.input()


	-- detecting key pressed
function love.keypressed( key, scancode, isrepeat )


   if scancode == "w" then
      -- D-Pad UP pressed
   elseif scancode == "a" then
      -- D-Pad LEFT pressed
   elseif scancode == "s" then
      -- D-Pad DOWN pressed
   elseif scancode == "d" then
      -- D-Pad RIGHT pressed
   elseif scancode == "space" then
      -- Button X pressed
   elseif scancode == "b" then
      -- Button Y pressed
   elseif scancode == "lshift" then
      -- Button B pressed
   elseif scancode == "z" then
      -- Button A pressed
   elseif scancode == "escape" then
      -- SELECT pressed
   elseif scancode == "return" then
      -- START pressed
   elseif scancode == "volumeup" then
      -- VOLUME UP pressed
   elseif scancode == "volumedown" then
      -- VOLUME DOWN pressed
   elseif scancode == "up" then
      -- L-Stick UP
   elseif scancode == "left" then
      -- L-Stick LEFT
   elseif scancode == "down" then
      -- L-Stick DOWN
   elseif scancode == "right" then
      -- L-Stick RIGHT
   elseif scancode == "l" then
      -- Back L1 pressed
   elseif scancode == "x" then
      -- Back L2 pressed
   elseif scancode == "r" then
      -- Right R1 pressed
   elseif scancode == "y" then
      -- Right R2 pressed
   elseif scancode == "1" then
      -- L-Stick L3 pressed, edit gptokeyb for L3 = "1"
   elseif scancode == "2" then
      -- R-Stick R3 pressed, edit gptokeyb for R3 = "2"
   end
end

-- detecting key released
function love.keyreleased( key, scancode )

   if scancode == "w" then
      -- D-Pad UP released
   elseif scancode == "a" then
      -- D-Pad LEFT released
   elseif scancode == "s" then
      -- D-Pad DOWN released
   elseif scancode == "d" then
      -- D-Pad RIGHT released
   elseif scancode == "space" then
      -- Button X released
		scene[autosavedScene].input() -- change input key-map to autosaved scene
    	scene[autosavedScene].start() -- kickstart the scene
    	scene.current = autosavedScene -- change to autosaved scene
		scene.previous = sceneNumber -- put current scene into scene history
   elseif scancode == "b" then
      -- Button Y released
		scene[autosavedScene].input() -- change input key-map to autosaved scene
    	scene[autosavedScene].start() -- kickstart the scene
    	scene.current = autosavedScene -- change to autosaved scene
		scene.previous = sceneNumber -- put current scene into scene history
   elseif scancode == "lshift" then
      -- Button B released
		scene[autosavedScene].input() -- change input key-map to autosaved scene
    	scene[autosavedScene].start() -- kickstart the scene
    	scene.current = autosavedScene -- change to autosaved scene
		scene.previous = sceneNumber -- put current scene into scene history
   elseif scancode == "z" then
      -- Button A released
		scene[autosavedScene].input() -- change input key-map to autosaved scene
    	scene[autosavedScene].start() -- kickstart the scene
    	scene.current = autosavedScene -- change to autosaved scene
		scene.previous = sceneNumber -- put current scene into scene history
   elseif scancode == "escape" then
      -- SELECT released
   elseif scancode == "return" then
      -- START released
   elseif scancode == "volumeup" then
      -- VOLUME UP released
   elseif scancode == "volumedown" then
      -- VOLUME DOWN released
   elseif scancode == "up" then
      -- L-Stick UP released
   elseif scancode == "left" then
      -- L-Stick LEFT released
   elseif scancode == "down" then
      -- L-Stick DOWN released
   elseif scancode == "right" then
      -- L-Stick RIGHT released
   elseif scancode == "l" then
      -- Back L1 released
   elseif scancode == "x" then
      -- Back L2 released
   elseif scancode == "r" then
      -- Right R1 released
   elseif scancode == "y" then
      -- Right R2 released
    elseif scancode == "1" then
      -- L-Stick L3 released, edit gptokeyb for L3 = "1"
   elseif scancode == "2" then
      -- R-Stick R3 released, edit gptokeyb for R3 = "2"
  end
end

-- R36S default for R-Stick (mouse) 
function love.mousemoved( x, y, dx, dy, istouch )

	triggerReport = "x:" .. x .. " y:" .. y .. " dx:" .. dx .. " dy:" .. dy
	if dy < -1 and (mouseCooldown == 0)then
		mouseCooldown = 15 -- 1/4 second for 60 fps
	end
	if dx < -1 and (mouseCooldown == 0) then
		mouseCooldown = 15 -- 1/4 second for 60 fps
	end
	if dy > 1 and (mouseCooldown == 0) then
		mouseCooldown = 15 -- 1/4 second for 60 fps
	end
	if dx > 1 and (mouseCooldown == 0) then
		mouseCooldown = 15 -- 1/4 second for 60 fps
	end
end

end -- for function K.input





-- this scene's update for each frame
function K.update()

	-- detecting L1 + R1 for Reset All Data
	if love.keyboard.isScancodeDown("l") and love.keyboard.isScancodeDown("r") and resetDone == false then  -- L1 + R1 detected
		resetChargeTime = resetChargeTime + 2.7 -- adjust to change required charge time
		game.tooltip = "L1+R1 pressed: Hold 3 secs to reset all data ... "..resetChargeTime

		if resetChargeTime > 500 then
			game.tooltip = "Reset all data - activated. Default files written."
			restoreDefaults()
			resetDone = true
		end

	else
		resetChargeTime = 0
	end

	-- detecting end of audio logo playback
	if not sceneStartSFX:isPlaying( ) then
		scene[autosavedScene].input() -- change input key-map to autosaved scene
    	scene[autosavedScene].start() -- kickstart the scene
    	scene.current = autosavedScene -- change to autosaved scene
		scene.previous = sceneNumber -- put current scene into scene history
	end

end




-- this scene's screen draws go here
function K.draw()

	-- display Reset All Data warning if resetChargeTime is charging
	if resetChargeTime > 0 and resetDone == false then
		love.graphics.draw(resetAllData, 70, 354)
		love.graphics.line(72, 396, 72+resetChargeTime, 396)
	end
	
	-- display game tooltip
	love.graphics.printf(game.tooltip, smallFont, 0, 458, 640, "left")

	-- display power
	game.power.state, game.power.percent, game.power.timeleft = love.system.getPowerInfo( )
	if game.system == "R36S" then
		love.graphics.printf(game.power.state .. " " .. game.power.percent .. "%", smallFont, 0, 458, 640, "right") -- show game power
	end
end



return K
