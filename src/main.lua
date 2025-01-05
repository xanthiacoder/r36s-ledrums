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


-- check for ArkOS / R36S and set game.system, create directories
game = {} -- table for game data

if love.filesystem.getUserDirectory( ) == "/home/ark/" then
	game.system = "R36S"
	-- user LUA I/O to write
	os.execute("mkdir " .. love.filesystem.getSaveDirectory()) -- OS creation
	os.execute("mkdir " .. love.filesystem.getSaveDirectory() .. "//samples")
	os.execute("mkdir " .. love.filesystem.getSaveDirectory() .. "//seqs")

else
	game.system = "Others"
	love.filesystem.createDirectory("samples")
	love.filesystem.createDirectory("seqs")	
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
mouseCooldown = 0 -- to prevent mouse input during cooldown period

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



	-- load autosaves
	if love.filesystem.getInfo( "game-time.txt" ) == nil then -- first run of game
		-- create files for the first time
		game.time = 0

		if game.system == "Others" then
		-- use love2d filesystem write
			local success, message =love.filesystem.write( "game-time.txt", game.time)
			if success then 
				game.tooltip = "Files created on non-ArkOS system"
				love.filesystem.write( "/samples/lovefs-io.txt", "file write using love2d fs")
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
			f = io.open(love.filesystem.getSaveDirectory().."//samples/lua-io.txt", "w")
			f:write("file write using lua io")
			f:close()			
		end

		-- create scene 401 default files for all system types
		local f = io.open(love.filesystem.getSaveDirectory().."//seqs/401-autosave-tempo.txt", "w")
		f:write(120, "\n")
		f:write(120, "\n")
		f:write(120, "\n")
		f:write(120)
		f:close()

	else
		-- read existing files
		game.time = love.filesystem.read("game-time.txt")
	end




-- load scene files here, global as the scenes use them when switching
scene = {}
scene[401] = require "scene-401" -- LEDrums (Hardcore)
scene[999] = require "scene-999" -- Exitscreen

-- set the 1st scene
scene.current = 401
scene.previous = 401




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
	scene[401].init()
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
    frameElapsed = frameElapsed + 1

	-- cooldown when mousemoved
    if mouseCooldown > 0 then
    	mouseCooldown = mouseCooldown - 1
    end

	-- toggle between playing and not playing
	if song.playing == true then
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

	-- display game tooltip
	love.graphics.printf(game.tooltip, smallFont, 0, 458, 640, "left")

	-- display power
	game.power.state, game.power.percent, game.power.timeleft = love.system.getPowerInfo( )
	love.graphics.printf(game.power.state .. " " .. game.power.percent .. "%", smallFont, 0, 458, 640, "right") -- show game power

	-- debug printscreen
	-- display game.system
	love.graphics.printf(game.system, monoFont, 0, 280, 640, "center") -- show game power
	love.graphics.printf(math.floor(game.time + love.timer.getTime()), monoFont, 0, 290, 640, "center") -- show game time

end