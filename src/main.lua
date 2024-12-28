-- Low Entropy Drums (LEDrums) by Joash Chee, Started on 2024
-- Drum sounds, loops, and preset kits are by Sönke Moehl / Low Entropy

require "love-ansi"

-- define global variables used in all scenes
bgart = {}
sfx = {}
help = {}

song = {}
song.tempo = 120

clock = {}
clock.tick = 1
clock.tock = 1
clock.time = love.timer.getTime()
clock.lapTock = clock.time

-- define global variables, used in input detection
triggerReport = ""
frameElapsed = 0 -- to check on love.update

-- input states [start]
dpadState = {}
fbtnState = {}
lstkState = {}
rstkState = {}
bbtnState = {}
miscState = {}
for i = 1,4 do
	dpadState[i] = ".."
	fbtnState[i] = ".."
	lstkState[i] = ".."
	rstkState[i] = ".."
	bbtnState[i] = ".."
	miscState[i] = ".."
end
-- L3 and R3 buttons added (requires manual edit on gptokeyb file on console)
miscState[5] = ".."
miscState[6] = ".."
-- input states [end]


-- load scene files here, global as the scenes use them when switching
scene = {}
scene[401] = require "scene-401" -- LEDrums (Hardcore)
scene[999] = require "scene-999" -- Exitscreen

scene.current = 401
scene.previous = 401



-- define local variables here [start]


-- define variables here [end]


-- one-time setup of game / app, loading assets
function love.load()
    gameFont = love.graphics.newFont("retro-gaming.ttf", 18)
    bigFont = love.graphics.newFont("retro-gaming.ttf", 24)
    redLed = love.graphics.newImage("pic/red-led.png")
    greenLed = love.graphics.newImage("pic/green-led.png")
    greyLed = love.graphics.newImage("pic/grey-led.png")
    -- initialise all scenes
	scene[401].init()
	scene[999].init()
end


-- load 1st scene input schema here
scene[scene.current].input()



function love.quit()
  	-- callback for graceful exit
end


-- to make game state changes frame-to-frame
function love.update(dt)
    frameElapsed = frameElapsed + 1
    
    -- get clock.tick and clock.tock to move according to tempo
    clock.time = love.timer.getTime()
	-- check ticks and tocks
    if (clock.time - clock.lapTock) >= ((60 / song.tempo)/4) then
    	clock.tock = clock.tock + 1
    	clock.lapTock = clock.time -- update lap timer for next tock
    	if clock.tock == 5 then
    		clock.tick = clock.tick + 1
    		if clock.tick == 5 then
    			clock.tick = 1
    		end    		
    		clock.tock = 1
    	end
    end

	-- run updates from scenes
	scene[401].update()

end


-- to render game state onto the screen, 60 fps
function love.draw()
	-- load scene draw state here
	if love.keyboard.isDown("escape") then
		love.graphics.draw(bgart[scene.current], 0, 0) -- draw regular scene background
	else
		love.graphics.draw(bgart[scene.current], 0, 0) -- draw regular scene background
	end
	scene[scene.current].draw()

end