-- Low Entropy Drums (LEDrums) by Joash Chee, Started on 2024
-- Drum sounds, loops, and preset kits are by Sönke Moehl / Low Entropy

require "love-ansi"

love.filesystem.setIdentity("LEDrums") -- for R36S file system compatibility


-- define global variables used in all scenes
bgart = {}
sfx = {}
help = {}

song = {}
song.tempo = 120

song.playing = false
song.halfTime = false -- toggle for half tempo
song.recording = false -- toggle for play/rec mode

-- check for ArkOS / R36S and set game.system, create directories
game = {} -- table for game data

if love.filesystem.getUserDirectory( ) == "/home/ark/" then
	game.system = "R36S"
	-- user LUA I/O to write
	os.execute("mkdir " .. love.filesystem.getSaveDirectory()) -- OS creation
	os.execute("mkdir " .. love.filesystem.getSaveDirectory() .. "//samples")
	os.execute("mkdir " .. love.filesystem.getSaveDirectory() .. "//samples/wav")
	os.execute("mkdir " .. love.filesystem.getSaveDirectory() .. "//samples/ogg")
	os.execute("mkdir " .. love.filesystem.getSaveDirectory() .. "//seqs")
	os.execute("mkdir " .. love.filesystem.getSaveDirectory() .. "//autosaves")

else
	game.system = "Others"
	love.filesystem.createDirectory("samples")
	love.filesystem.createDirectory("samples/wav")
	love.filesystem.createDirectory("samples/ogg")
	love.filesystem.createDirectory("seqs")	
	love.filesystem.createDirectory("autosaves")	
end

game.tooltip = "SELECT + LEFT (left stick) : Save and Quit" -- contextual tip at bottom bar

game.time = {} -- table for total time played
game.time.hours = 0
game.time.minutes = 0
game.time.seconds = 0

game.power = {} -- table for game power state
game.power.state, game.power.percent, game.power.timeleft = love.system.getPowerInfo( )



-- global clock sync
clock = {}
clock.tick = 1
clock.tock = 1
clock.time = love.timer.getTime()
clock.lapTock = clock.time

-- define global variables, used in input detection
triggerReport = ""
frameElapsed = 0 -- to check on love.update
mouseCooldown = 0 -- to prevent mouse input during cooldown period (right-stick)

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


-- use this to write blank data for scenes
function resetData(scene)
	local f = f
	f = io.open(love.filesystem.getSaveDirectory().."//seqs/"..scene.."-autosave-tempo.txt", "w")
	f:write(120, "\n")
	f:write(120, "\n")
	f:write(120, "\n")
	f:write(120)
	f:close()
	f = io.open(love.filesystem.getSaveDirectory().."//seqs/"..scene.."-autosave-loop1.txt", "w")
	f:write("----------------\n----------------\n----------------\n----------------\n----------------\n----------------\n----------------\n----------------")
	f:close()	
	f = io.open(love.filesystem.getSaveDirectory().."//seqs/"..scene.."-autosave-loop2.txt", "w")
	f:write("----------------\n----------------\n----------------\n----------------\n----------------\n----------------\n----------------\n----------------")
	f:close()	
	f = io.open(love.filesystem.getSaveDirectory().."//seqs/"..scene.."-autosave-loop3.txt", "w")
	f:write("----------------\n----------------\n----------------\n----------------\n----------------\n----------------\n----------------\n----------------")
	f:close()	
	f = io.open(love.filesystem.getSaveDirectory().."//seqs/"..scene.."-autosave-loop4.txt", "w")
	f:write("----------------\n----------------\n----------------\n----------------\n----------------\n----------------\n----------------\n----------------")
	f:close()	
end

function restoreDefaults()
	local f = f -- used for LUA I/O
	local i = i
	
	-- create autosave files	
	-- current scene (last scene that was autosaved)
	f = io.open(love.filesystem.getSaveDirectory().."//autosaves/currentscene.txt", "w")
	f:write(401)
	f:close()

	-- create defaults for all scenes
	resetData(401)
	resetData(402)
	resetData(403)
	resetData(404)
	resetData(405)
	resetData(406)
	resetData(407)
	resetData(408)
	resetData(409)
	resetData(498)
	resetData(499)

	-- populate samples directory
	local data = love.filesystem.read("sfx/Speedcore-Drum1.wav")
	for i = 1,8 do
		local file = io.open(love.filesystem.getSaveDirectory().."//samples/wav/user"..i..".wav", "w+")
		file:write(data)
		file:close()
	end

	local data = love.filesystem.read("sfx/Speedcore-Drum1.ogg")
	for i = 1,8 do
		local file = io.open(love.filesystem.getSaveDirectory().."//samples/ogg/user"..i..".ogg", "w+")
		file:write(data)
		file:close()
	end


end



	-- load autosaves
	if love.filesystem.getInfo( "game-time.txt" ) == nil then -- first run of game
		-- create files for the first time
		game.time = 0
		f = io.open(love.filesystem.getSaveDirectory().."//game-time.txt", "w+")
		f:write(game.time)
		f:close()
	
		if game.system == "Others" then
		-- use love2d filesystem write
			local success, message =love.filesystem.write( "game-time.txt", game.time)
			if success then 
				game.tooltip = "Files created on non-ArkOS system"
--				love.filesystem.write( "/samples/lovefs-io.txt", "file write using love2d fs")
			else 
				game.tooltip = "File not created: " .. message
			end
		end

		if game.system == "R36S" then
			local f = io.open(love.filesystem.getSaveDirectory().."//game-time.txt", "w")
			f:write(game.time)
			f:close()
			game.tooltip = "Files created on ArkOS system"
			-- test writing into sub-directories
--			f = io.open(love.filesystem.getSaveDirectory().."//samples/lua-io.txt", "w")
--			f:write("file write using lua io")
--			f:close()			
		end

		restoreDefaults() -- create defaults for the first time
		
	else
		-- read existing files
		game.time = love.filesystem.read("game-time.txt")
	end




-- load scene files here, global as the scenes use them when switching
scene = {}
scene[0]   = require "scene-0"   -- Boot Screen
scene[401] = require "scene-401" -- LEDrums (Hardcore)
scene[402] = require "scene-402" -- LEDrums (Techno)
scene[403] = require "scene-403" -- LEDrums (Gabber)
scene[404] = require "scene-404" -- LEDrums (Acid)
scene[405] = require "scene-405" -- LEDrums (Doomcore)
scene[406] = require "scene-406" -- LEDrums (Speedcore)
scene[407] = require "scene-407" -- LEDrums (Slowcore)
scene[408] = require "scene-408" -- LEDrums (Industrial Madness)
scene[409] = require "scene-409" -- LEDrums (Drum Jam)
scene[498] = require "scene-498" -- LEDrums (User - OGG)
scene[499] = require "scene-499" -- LEDrums (User - WAV)
scene[999] = require "scene-999" -- Exitscreen

-- set the 1st scene
scene.current = 0
scene.previous = 0




-- one-time setup of game / app, loading assets
function love.load()
	-- load fonts
	monoFont = love.graphics.newFont("JetBrainsMonoNL-Regular.ttf", 10)
    gameFont = love.graphics.newFont("retro-gaming.ttf", 18)
    bigFont = love.graphics.newFont("retro-gaming.ttf", 24)
    smallFont = love.graphics.newFont("retro-gaming.ttf", 12)
	-- load global graphics
    redLed = love.graphics.newImage("pic/red-led.png")
    greenLed = love.graphics.newImage("pic/green-led.png")
    greyLed = love.graphics.newImage("pic/grey-led.png")
    


    -- initialise all scenes (does only once at the start)
    scene[0].init()
	scene[401].init()
	scene[402].init()
	scene[403].init()
	scene[404].init()
	scene[405].init()
	scene[406].init()
	scene[407].init()
	scene[408].init()
	scene[409].init()
	scene[498].init()
	scene[499].init()
	scene[999].init()
end


-- load 1st scene input schema here
scene[scene.current].input()
-- start 1st scene
scene[scene.current].start()


-- callback for graceful exit
function love.quit()
  	-- autosave all data
  	
  	-- save total time played
  	game.time = math.floor(game.time + love.timer.getTime())
	if game.system == "Others" then
		love.filesystem.write( "game-time.txt", game.time )  	
	end
	if game.system == "R36S" then
		f = io.open(love.filesystem.getSaveDirectory().."//game-time.txt", "w")
		f:write(game.time)
		f:close()	
	end
	
end


-- to make game state changes frame-to-frame
function love.update(dt)

local tempoMultiplier = 1

    frameElapsed = frameElapsed + 1

	-- cooldown when mousemoved
    if mouseCooldown > 0 then
    	mouseCooldown = mouseCooldown - 1
    end

	-- toggle between playing and not playing
	if song.playing == true then
	    -- get clock.tick and clock.tock to move according to tempo
	    clock.time = love.timer.getTime()
	    -- set tempoMultiplier to 1/2 time toggle
	    if song.halfTime then
	    	tempoMultiplier = 0.5
	    else
	    	tempoMultiplier = 1
	    end
		-- check ticks and tocks
	    if (clock.time - clock.lapTock) >= ((60 / (song.tempo * tempoMultiplier))/4) then
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
	else
		-- do this when song.playing == false
	end

	-- run updates from current scene
	scene[scene.current].update()

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