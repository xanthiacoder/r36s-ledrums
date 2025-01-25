-- scene-401
-- scene name : LEDrums (Hardcore)
-- scene functions are :
-- .init() for one-time initialization of stuff
-- .input() for all the key mapping
-- .start() to kickstart the scene
-- .update() for frame by frame activity
-- .draw() for the draw state



local sceneNumber = 401

-- music data for this scene

-- filenames of samples to load
local sample = {
	[1] = "Hardcore-NoizeHit.wav",
	[2] = "Hardcore-Snare.wav",
	[3] = "Hardcore-Drum1.wav",
	[4] = "Hardcore-Zap.wav",
	[5] = "Hardcore-Hihat.wav",
	[6] = "Hardcore-Drum2.wav",
	[7] = "Hardcore-Drum3.wav",
	[8] = "Hardcore-Cymbal.wav",
	}

	

local seq = {}
-- define 4 loops
seq.loop = {
	[1] = {},
	[2] = {},
	[3] = {},
	[4] = {},
	}
-- define 8 tracks
for i = 1,4 do	
seq.loop[i].track = {
	[1] = {},
	[2] = {},
	[3] = {},
	[4] = {},
	[5] = {},
	[6] = {},
	[7] = {},
	[8] = {},
	}
-- define default tempo for each of the 4 loops
seq.loop[i].tempo = 120
end
-- define 4 ticks
for i = 1,4 do
for j = 1,8 do
seq.loop[i].track[j].tick = {
	[1] = {},
	[2] = {},
	[3] = {},
	[4] = {},
	}
end
end
-- define 4 tocks
for i = 1,4 do
for j = 1,8 do
for k = 1,4 do
seq.loop[i].track[j].tick[k].tock = {
	[1] = "-",
	[2] = "-",
	[3] = "-",
	[4] = "-",
	}
end
end
end


local ledAlpha = {}
ledAlpha[1] = 1 -- the transparency of 1st led
ledAlpha[2] = 0 -- the transparency of 2st led
ledAlpha[3] = 0 -- the transparency of 3st led
ledAlpha[4] = 0 -- the transparency of 4st led

local currentLoop = 1 -- currently selected loop
song.tempo = seq.loop[currentLoop].tempo

local trackVolumeMeter = {} -- the volume meter for each track, range 0 .. 100
for i = 1,8 do
	trackVolumeMeter[i] = 0
end

local tickChange = clock.tick -- to tell when the tick has changed
local tockChange = clock.tock -- to tell when the tock has changed
local tapTempo = love.timer.getTime() -- init to detect delta to change tempo



-- graphical overlay for this scene's help
local helpTextOverlay = love.graphics.newImage("bgart/transparent-black-50.png")


-- graphic highlight for beat editor
local beatHighlight = love.graphics.newImage("pic/beat-highlight.png")

-- graphics for samples triggered display
local orangeBar = love.graphics.newImage("pic/orange-bar.png")

-- LEDs for indicators
local greenLED = love.graphics.newImage("pic/green-led.png")
local greyLED = love.graphics.newImage("pic/grey-led.png")

-- other indicators
local indicatorHalfTime = love.graphics.newImage("pic/halftime.png")
local indicatorRec = love.graphics.newImage("pic/rec.png")
local indicatorPlay = love.graphics.newImage("pic/play.png")

local K = {}

local helpText = ""




local function clearLoop(loop)

local j = 1
local k = 1

for j = 1,8 do
for k = 1,4 do
seq.loop[loop].track[j].tick[k].tock = {
	[1] = "-",
	[2] = "-",
	[3] = "-",
	[4] = "-",
	}
end
end

game.tooltip = "Current loop data cleared."
end


local function saveData()

	local i = 1
	local j = 1
	local tick = 1
	local tock = 1
	
	-- using LUA IO to write data for universal compatibility
	local f = io.open(love.filesystem.getSaveDirectory().."//seqs/"..sceneNumber.."-autosave-tempo.txt", "w")
	f:write(seq.loop[1].tempo, "\n")
	f:write(seq.loop[2].tempo, "\n")
	f:write(seq.loop[3].tempo, "\n")
	f:write(seq.loop[4].tempo)
	f:close()

	-- save sceneNumber
	f = io.open(love.filesystem.getSaveDirectory().."//autosaves/currentscene.txt", "w")
	f:write(sceneNumber)
	f:close()

	-- save loop1 data
	f = io.open(love.filesystem.getSaveDirectory().."//seqs/"..sceneNumber.."-autosave-loop1.txt", "w")
	for j = 1,8 do
	tick = 1
	tock = 1
	for i = 1,16 do
		f:write(seq.loop[1].track[j].tick[tick].tock[tock])
		tock = tock + 1
		if tock == 5 then
			tick = tick + 1
			tock = 1
		end		
	end -- end writing single track
	if j < 8 then -- if not the last track
		f:write("\n") -- go to next line for next track
	end
	end -- end writing all tracks
	f:close()

	-- save loop2 data
	f = io.open(love.filesystem.getSaveDirectory().."//seqs/"..sceneNumber.."-autosave-loop2.txt", "w")
	for j = 1,8 do
	tick = 1
	tock = 1
	for i = 1,16 do
		f:write(seq.loop[2].track[j].tick[tick].tock[tock])
		tock = tock + 1
		if tock == 5 then
			tick = tick + 1
			tock = 1
		end		
	end -- end writing single track
	if j < 8 then -- if not the last track
		f:write("\n") -- go to next line for next track
	end
	end -- end writing all tracks
	f:close()

	-- save loop3 data
	f = io.open(love.filesystem.getSaveDirectory().."//seqs/"..sceneNumber.."-autosave-loop3.txt", "w")
	for j = 1,8 do
	tick = 1
	tock = 1
	for i = 1,16 do
		f:write(seq.loop[3].track[j].tick[tick].tock[tock])
		tock = tock + 1
		if tock == 5 then
			tick = tick + 1
			tock = 1
		end		
	end -- end writing single track
	if j < 8 then -- if not the last track
		f:write("\n") -- go to next line for next track
	end
	end -- end writing all tracks
	f:close()

	-- save loop4 data
	f = io.open(love.filesystem.getSaveDirectory().."//seqs/"..sceneNumber.."-autosave-loop4.txt", "w")
	for j = 1,8 do
	tick = 1
	tock = 1
	for i = 1,16 do
		f:write(seq.loop[4].track[j].tick[tick].tock[tock])
		tock = tock + 1
		if tock == 5 then
			tick = tick + 1
			tock = 1
		end		
	end -- end writing single track
	if j < 8 then -- if not the last track
		f:write("\n") -- go to next line for next track
	end
	end -- end writing all tracks
	f:close()

	game.tooltip = "Scene "..sceneNumber.." data saved at " .. math.floor(game.time + love.timer.getTime())

end




-- K.init is for loading assets for the scene (done only once at game load)
function K.init()
	-- background to display
	bgart[sceneNumber] = love.graphics.newImage("bgart/"..sceneNumber..".jpg")
	-- help text to appear
	help[sceneNumber] = ""
	
end



-- K.start is to init anything when scene starts, can be reloaded multiple times
function K.start()

	-- load scene-specific sounds
	sfx[1] = love.audio.newSource("sfx/"..sample[1], "static")
	sfx[2] = love.audio.newSource("sfx/"..sample[2], "static")
	sfx[3] = love.audio.newSource("sfx/"..sample[3], "static")
	sfx[4] = love.audio.newSource("sfx/"..sample[4], "static")
	sfx[5] = love.audio.newSource("sfx/"..sample[5], "static")
	sfx[6] = love.audio.newSource("sfx/"..sample[6], "static")
	sfx[7] = love.audio.newSource("sfx/"..sample[7], "static")
	sfx[8] = love.audio.newSource("sfx/"..sample[8], "static")


	local i = 1
	local j = 1
	local h = 1
	local tick = 1
	local tock = 1
	local track = {}
	-- read all autosave tempo data
	local f = io.input (love.filesystem.getSaveDirectory().."//seqs/"..sceneNumber.."-autosave-tempo.txt")
	i = 1
	for line in f:lines() do
		seq.loop[i].tempo = line
		i = i + 1
	end
	f:close()
	-- set tempo according to loaded values
	song.tempo = seq.loop[currentLoop].tempo

	-- read all autosave loop data
	f = io.input (love.filesystem.getSaveDirectory().."//seqs/"..sceneNumber.."-autosave-loop1.txt")
	i = 1
	for line in f:lines() do
		track[i] = line
		i = i + 1
	end
	f:close()

	for j = 1,8 do -- read 8 tracks
	tick = 1
	tock = 1
	for h = 1,16 do -- read 16 sub-beats
		seq.loop[1].track[j].tick[tick].tock[tock] = string.sub(track[j], h, h)
		tock = tock + 1
		if tock == 5 then
			tick = tick + 1
			tock = 1
		end
	end -- end read of 16 sub-beats
	end -- end read of 8 tracks

	f = io.input (love.filesystem.getSaveDirectory().."//seqs/"..sceneNumber.."-autosave-loop2.txt")
	i = 1
	for line in f:lines() do
		track[i] = line
		i = i + 1
	end
	f:close()

	for j = 1,8 do -- read 8 tracks
	tick = 1
	tock = 1
	for h = 1,16 do -- read 16 sub-beats
		seq.loop[2].track[j].tick[tick].tock[tock] = string.sub(track[j], h, h)
		tock = tock + 1
		if tock == 5 then
			tick = tick + 1
			tock = 1
		end
	end -- end read of 16 sub-beats
	end -- end read of 8 tracks

	f = io.input (love.filesystem.getSaveDirectory().."//seqs/"..sceneNumber.."-autosave-loop3.txt")
	i = 1
	for line in f:lines() do
		track[i] = line
		i = i + 1
	end
	f:close()

	for j = 1,8 do -- read 8 tracks
	tick = 1
	tock = 1
	for h = 1,16 do -- read 16 sub-beats
		seq.loop[3].track[j].tick[tick].tock[tock] = string.sub(track[j], h, h)
		tock = tock + 1
		if tock == 5 then
			tick = tick + 1
			tock = 1
		end
	end -- end read of 16 sub-beats
	end -- end read of 8 tracks

	f = io.input (love.filesystem.getSaveDirectory().."//seqs/"..sceneNumber.."-autosave-loop4.txt")
	i = 1
	for line in f:lines() do
		track[i] = line
		i = i + 1
	end
	f:close()

	for j = 1,8 do -- read 8 tracks
	tick = 1
	tock = 1
	for h = 1,16 do -- read 16 sub-beats
		seq.loop[4].track[j].tick[tick].tock[tock] = string.sub(track[j], h, h)
		tock = tock + 1
		if tock == 5 then
			tick = tick + 1
			tock = 1
		end
	end -- end read of 16 sub-beats
	end -- end read of 8 tracks

end




-- K.input is for keymapping
function K.input()
	-- detecting key pressed
function love.keypressed( key, scancode, isrepeat )

   if scancode == "w" then
      -- D-Pad UP pressed
      triggerReport = "D-Pad UP pressed"
      dpadState[1] = "dn"
      love.audio.stop(sfx[1])
      love.audio.play(sfx[1])
	  trackVolumeMeter[1] = 50
	  if song.recording then -- write data only if recording mode
	    if seq.loop[currentLoop].track[1].tick[clock.tick].tock[clock.tock] == "-" then
			seq.loop[currentLoop].track[1].tick[clock.tick].tock[clock.tock] = 7
	  	else
      		seq.loop[currentLoop].track[1].tick[clock.tick].tock[clock.tock] = "-"
      	end
      end
   elseif scancode == "a" then
      -- D-Pad LEFT pressed
      triggerReport = "D-Pad LEFT pressed"
      dpadState[2] = "dn"
      love.audio.stop(sfx[2])
      love.audio.play(sfx[2])
	  trackVolumeMeter[2] = 50
	  if song.recording then -- write data only if recording mode
	      if seq.loop[currentLoop].track[2].tick[clock.tick].tock[clock.tock] == "-" then
	      	seq.loop[currentLoop].track[2].tick[clock.tick].tock[clock.tock] = 7
		  else
	      	seq.loop[currentLoop].track[2].tick[clock.tick].tock[clock.tock] = "-"
	      end
	  end
   elseif scancode == "s" then
      -- D-Pad DOWN pressed
      triggerReport = "D-Pad DOWN pressed"
      dpadState[3] = "dn"
      love.audio.stop(sfx[3])
      love.audio.play(sfx[3])
	  trackVolumeMeter[3] = 50
	  if song.recording then -- write data only if recording mode
	      if seq.loop[currentLoop].track[3].tick[clock.tick].tock[clock.tock] == "-" then
	      	seq.loop[currentLoop].track[3].tick[clock.tick].tock[clock.tock] = 7
		  else
	      	seq.loop[currentLoop].track[3].tick[clock.tick].tock[clock.tock] = "-"
	      end
	  end
   elseif scancode == "d" then
      -- D-Pad RIGHT pressed
      triggerReport = "D-Pad RIGHT pressed"
      dpadState[4] = "dn"
      love.audio.stop(sfx[4])
      love.audio.play(sfx[4])
	  trackVolumeMeter[4] = 50
	  if song.recording then -- write data only if recording mode
	      if seq.loop[currentLoop].track[4].tick[clock.tick].tock[clock.tock] == "-" then
	      	seq.loop[currentLoop].track[4].tick[clock.tick].tock[clock.tock] = 7
		  else
	      	seq.loop[currentLoop].track[4].tick[clock.tick].tock[clock.tock] = "-"
	      end
	  end
   elseif scancode == "space" then
      -- Button X pressed
      triggerReport = "Button X pressed"
      fbtnState[1] = "dn"
      love.audio.stop(sfx[8])
      love.audio.play(sfx[8])
	  trackVolumeMeter[8] = 50
	  if song.recording then -- write data only if recording mode
	      if seq.loop[currentLoop].track[8].tick[clock.tick].tock[clock.tock] == "-" then
	      	seq.loop[currentLoop].track[8].tick[clock.tick].tock[clock.tock] = 7
		  else
	      	seq.loop[currentLoop].track[8].tick[clock.tick].tock[clock.tock] = "-"
	      end
	  end
   elseif scancode == "b" then
      -- Button Y pressed
      triggerReport = "Button Y pressed"
      fbtnState[2] = "dn"
      love.audio.stop(sfx[5])
      love.audio.play(sfx[5])
	  trackVolumeMeter[5] = 50
	  if song.recording then -- write data only if recording mode
	      if seq.loop[currentLoop].track[5].tick[clock.tick].tock[clock.tock] == "-" then
	      	seq.loop[currentLoop].track[5].tick[clock.tick].tock[clock.tock] = 7
		  else
	      	seq.loop[currentLoop].track[5].tick[clock.tick].tock[clock.tock] = "-"
	      end
	  end
   elseif scancode == "lshift" then
      -- Button B pressed
      triggerReport = "Button B pressed"
      fbtnState[3] = "dn"
      love.audio.stop(sfx[6])
      love.audio.play(sfx[6])
	  trackVolumeMeter[6] = 50
	  if song.recording then -- write data only if recording mode
	      if seq.loop[currentLoop].track[6].tick[clock.tick].tock[clock.tock] == "-" then
	      	seq.loop[currentLoop].track[6].tick[clock.tick].tock[clock.tock] = 7
		  else
	      	seq.loop[currentLoop].track[6].tick[clock.tick].tock[clock.tock] = "-"
	      end
	  end
   elseif scancode == "z" then
      -- Button A pressed
      triggerReport = "Button A pressed"
      fbtnState[4] = "dn"
      love.audio.stop(sfx[7])
      love.audio.play(sfx[7])
	  trackVolumeMeter[7] = 50
	  if song.recording then -- write data only if recording mode
	      if seq.loop[currentLoop].track[7].tick[clock.tick].tock[clock.tock] == "-" then
	      	seq.loop[currentLoop].track[7].tick[clock.tick].tock[clock.tock] = 7
		  else
	      	seq.loop[currentLoop].track[7].tick[clock.tick].tock[clock.tock] = "-"
	      end
	  end
   elseif scancode == "escape" then
      -- SELECT pressed
      triggerReport = "SELECT pressed"
      miscState[1] = "dn"
   elseif scancode == "return" then
      -- START pressed
      triggerReport = "START pressed"
      miscState[2] = "dn"
      clock.tick = 1
      clock.tock = 1
      clock.time = love.timer.getTime()
	  clock.lapTock = clock.time
      if song.playing == false then
      	song.playing = true
      	-- start playing tracks
		for i = 1,8 do
			if seq.loop[currentLoop].track[i].tick[clock.tick].tock[clock.tock] ~= "-" then
		      love.audio.stop(sfx[i])
		      love.audio.play(sfx[i])
			end
		end
      else
      	song.playing = false
      end
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
	  if song.halfTime then
	  	song.halfTime = false
	  else
	  	song.halfTime = true
	  end
   elseif scancode == "left" then
      -- L-Stick LEFT
      triggerReport = "L-Stick LEFT pressed"
      lstkState[2] = "dn"
            
      -- skip to exitscreen scene
      if love.keyboard.isScancodeDown("escape") then  -- SELECT + Lstk-LEFT detected
      	saveData() -- force scene autosave
      	scene[999].input() -- change input key-map to 999's
      	scene[999].start() -- change input key-map to 999's
      	scene.current = 999 -- change to exitscreen scene
		scene.previous = sceneNumber -- put current scene into scene history
      else
		  -- reduce song's tempo
		seq.loop[currentLoop].tempo = seq.loop[currentLoop].tempo - 1
		song.tempo = seq.loop[currentLoop].tempo      	
      end

   elseif scancode == "down" then
      -- L-Stick DOWN
      triggerReport = "L-Stick DOWN pressed"
      lstkState[3] = "dn"
      -- tapTempo detection
	  if (love.timer.getTime() - tapTempo) > 2 then
		 -- new attempt to tap tempo detected, recalibrate
	     tapTempo = love.timer.getTime()
	  else
		seq.loop[currentLoop].tempo = math.floor(60 / (love.timer.getTime() - tapTempo))
		song.tempo = seq.loop[currentLoop].tempo
	    tapTempo = love.timer.getTime() -- init for the next detection
	  end
   elseif scancode == "right" then
      -- L-Stick RIGHT
      triggerReport = "L-Stick RIGHT pressed"
      lstkState[4] = "dn"

	  -- increase song's tempo
	seq.loop[currentLoop].tempo = seq.loop[currentLoop].tempo + 1
	song.tempo = seq.loop[currentLoop].tempo


   elseif scancode == "l" then
      -- Back L1 pressed
		if not love.keyboard.isScancodeDown("escape") then -- SELECT not pressed
			saveData()
			currentLoop = 1
			song.tempo = seq.loop[currentLoop].tempo
		end
   elseif scancode == "x" then
      -- Back L2 pressed
      triggerReport = "Back L2 pressed"
      bbtnState[2] = "dn"
      saveData()
      currentLoop = 2
	  song.tempo = seq.loop[currentLoop].tempo
   elseif scancode == "r" then
      -- Right R1 pressed
		if not love.keyboard.isScancodeDown("escape") then -- SELECT not pressed
			saveData()
			currentLoop = 4
			song.tempo = seq.loop[currentLoop].tempo
		end
   elseif scancode == "y" then
      -- Right R2 pressed
      triggerReport = "Back R2 pressed"
      bbtnState[4] = "dn"
      saveData()
      currentLoop = 3
      song.tempo = seq.loop[currentLoop].tempo
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
    	-- move to previous scene 499
      if love.keyboard.isScancodeDown("escape") then  -- SELECT + L1 release detected
      	saveData() -- force scene autosave
      	scene[499].input() -- change input key-map to 499's
      	scene[499].start() -- run 499 start process
      	scene.current = 499 -- change to 499 scene
		scene.previous = sceneNumber -- put current scene into scene history
      end

   elseif scancode == "x" then
      -- Back L2 released
      triggerReport = "Back L2 released"
      bbtnState[2] = "up"
   elseif scancode == "r" then
      -- Right R1 released
    	-- move to next scene 402
      if love.keyboard.isScancodeDown("escape") then  -- SELECT + R1 release detected
      	saveData() -- force scene autosave
      	scene[402].input() -- change input key-map to 402's
      	scene[402].start() -- run 402 start process
      	scene.current = 402 -- change to 402 scene
		scene.previous = sceneNumber -- put current scene into scene history
      end
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
	if dy < -1 and (mouseCooldown == 0)then
		rstkState[1] = "ok" -- R-Stick UP
		mouseCooldown = 15 -- 1/4 second for 60 fps
	  -- clear currentLoop
      if love.keyboard.isScancodeDown("escape") then  -- SELECT + Rstk-UP detected
			clearLoop(currentLoop)
      else
		  -- display instruction for CLEAR
		  game.tooltip = "Hold SELECT and Right-Stick UP to clear loop"
      end

	end
	if dx < -1 and (mouseCooldown == 0) then
		rstkState[2] = "ok" -- R-Stick LEFT
		mouseCooldown = 15 -- 1/4 second for 60 fps
		-- Move Track beat selection backwards
		if (clock.tick * clock.tock) > 1 then
			clock.tock = clock.tock - 1
			if clock.tock == 0 then
				clock.tick = clock.tick - 1
				clock.tock = 4
			end
		else
			-- do this when at 1.1, cycle to the end
			clock.tick = 4
			clock.tock = 4
		end
	end
	if dy > 1 and (mouseCooldown == 0) then
		rstkState[3] = "ok" -- R-Stick DOWN
		mouseCooldown = 15 -- 1/4 second for 60 fps
		-- toggle Play/Rec mode
		if song.recording then
			song.recording = false
		else
			song.recording = true
		end
	end
	if dx > 1 and (mouseCooldown == 0) then
		rstkState[4] = "ok" -- R-Stick RIGHT
		mouseCooldown = 15 -- 1/4 second for 60 fps
		-- Move Track beat selection forwards
		if (clock.tick * clock.tock) < 16 then
			clock.tock = clock.tock + 1
			if clock.tock == 5 then
				clock.tick = clock.tick + 1
				clock.tock = 1
			end
		else
			-- do this when at 4.4, cycle back to the beginning
			clock.tick = 1
			clock.tock = 1
		end
	end
end

end






-- this scene's update for each frame
function K.update()

	-- make LED fade
	if ledAlpha[1] > 0 then
		ledAlpha[1] = ledAlpha[1] - 0.05
	end

	-- make trackVolumeMeters fade
	for i = 1,8 do
		if trackVolumeMeter[i] > 0 then
			trackVolumeMeter[i] = trackVolumeMeter[i] - 1
		end
	end

	-- do when tick changes
	if tickChange ~= clock.tick then
		tickChange = clock.tick -- reset for next change to be detected
		ledAlpha[1] = 1 -- pulse 1st LED
	end

	-- do when tock changes
	if tockChange ~= clock.tock then
		tockChange = clock.tock -- reset for next change to be detected
		for i = 1,8 do
			if seq.loop[currentLoop].track[i].tick[clock.tick].tock[clock.tock] ~= "-" then
		      love.audio.stop(sfx[i])
		      love.audio.play(sfx[i])
		      trackVolumeMeter[i] = 50
			end
		end
	end


end






-- this scene's screen draws go here
function K.draw()
	love.graphics.setFont(gameFont)
    if love.keyboard.isScancodeDown("escape") then
    	helpText = help[sceneNumber]
		love.graphics.draw(helpTextOverlay, 0, 0) -- draw this scene's helpTextOverlay
	    love.graphics.printf(helpText, gameFont, 50, 80, 540, "left") -- display help text
	else
		helpText = ""
	    love.graphics.setFont(bigFont)
		love.graphics.printf(song.tempo, bigFont, 196, 380, 100, "center") -- show tempo

		-- pulse red LED based on tempo
		love.graphics.setColor(1, 1, 1, ledAlpha[1]) -- test alpha
		love.graphics.draw(redLed, 75, 380) -- 1st led, red
--		love.graphics.draw(redLed, 280, 236) -- 2nd led, red
--		love.graphics.draw(redLed, 340, 236) -- 3rd led, red
--		love.graphics.draw(redLed, 400, 236) -- 4th led, red
		love.graphics.setColor(1, 1, 1, 1) -- reset alpha


		-- display seq data
		-- seq in graphics bar display
		for j = 1,8 do -- loop for 8 samples
		tick = 1
		tock = 1
		for i = 1,16 do
			if (seq.loop[currentLoop].track[j].tick[tick].tock[tock]) ~= "-" then
				love.graphics.draw(orangeBar, 16 + ((i-1)*38), 72 + ((j-1)*10))
			end
			tock = tock + 1
			if tock == 5 then
				tick = tick + 1
				tock = 1
			end		
		end
		end	
		-- draw dividing lines for bars
		love.graphics.line(16+(38*4) , 72 , 16+(38*4),72+80)
		love.graphics.line(16+(38*8) , 72 , 16+(38*8),72+80)
		love.graphics.line(16+(38*12), 72 , 16+(38*12),72+80)

		-- draw leds for current loop
		-- draw the grey LEDs first
		for i = 1,4 do
			love.graphics.draw(greyLED, 138 + ((i-1)*152), 45)	
		end
		-- draw the currentLoop's green LED
		love.graphics.draw(greenLED, 138 + ((currentLoop-1)*152), 45)	



		-- seq in text display
		love.graphics.setFont(monoFont)
		local loopCount = 0
    
		for i = 1,4 do
		for j = 1,4 do
			love.graphics.print(seq.loop[currentLoop].track[1].tick[i].tock[j], 334 + (loopCount*8),170) -- draw beat highlight according to tick.tock
			love.graphics.print(seq.loop[currentLoop].track[2].tick[i].tock[j], 334 + (loopCount*8),180) -- draw beat highlight according to tick.tock
			love.graphics.print(seq.loop[currentLoop].track[3].tick[i].tock[j], 334 + (loopCount*8),190) -- draw beat highlight according to tick.tock
			love.graphics.print(seq.loop[currentLoop].track[4].tick[i].tock[j], 334 + (loopCount*8),200) -- draw beat highlight according to tick.tock
			love.graphics.print(seq.loop[currentLoop].track[5].tick[i].tock[j], 334 + (loopCount*8),210) -- draw beat highlight according to tick.tock
			love.graphics.print(seq.loop[currentLoop].track[6].tick[i].tock[j], 334 + (loopCount*8),220) -- draw beat highlight according to tick.tock
			love.graphics.print(seq.loop[currentLoop].track[7].tick[i].tock[j], 334 + (loopCount*8),230) -- draw beat highlight according to tick.tock
			love.graphics.print(seq.loop[currentLoop].track[8].tick[i].tock[j], 334 + (loopCount*8),240) -- draw beat highlight according to tick.tock
			loopCount = loopCount + 1
		end
		end	

		-- display halfTime toggle
		love.graphics.print("1/2 Time: " .. tostring(song.halfTime), 334, 250)
		if song.halfTime then
			love.graphics.draw(indicatorHalfTime, 210, 340)
		end

		-- display Play / Rec toggle
		if song.recording then
			love.graphics.draw(indicatorRec, 360, 340)
		else
			love.graphics.draw(indicatorPlay, 360, 340)
		end
		

		-- draw samples loaded
		love.graphics.print(string.sub(sample[1],1,22), 192, 173)
		love.graphics.print(string.sub(sample[2],1,22), 192, 190)
		love.graphics.print(string.sub(sample[3],1,22), 192, 207)
		love.graphics.print(string.sub(sample[4],1,22), 192, 224)
		love.graphics.print(string.sub(sample[5],1,22), 192, 241)
		love.graphics.print(string.sub(sample[6],1,22), 192, 258)
		love.graphics.print(string.sub(sample[7],1,22), 192, 275)
		love.graphics.print(string.sub(sample[8],1,22), 192, 292)

		-- draw track volume meters
		love.graphics.line(430,300, 430,300-trackVolumeMeter[1])
		love.graphics.line(434,300, 434,300-trackVolumeMeter[2])
		love.graphics.line(438,300, 438,300-trackVolumeMeter[3])
		love.graphics.line(442,300, 442,300-trackVolumeMeter[4])
		love.graphics.line(446,300, 446,300-trackVolumeMeter[5])
		love.graphics.line(450,300, 450,300-trackVolumeMeter[6])
		love.graphics.line(454,300, 454,300-trackVolumeMeter[7])
		love.graphics.line(458,300, 458,300-trackVolumeMeter[8])



	    -- sub-beat = ((clock.tick-1)*4) + clock.tock
	    -- sub-beat - 1 = (((clock.tick-1)*4) + clock.tock) - 1
	    -- spacing = ((((clock.tick-1)*4) + clock.tock) - 1 ) * 38
	    -- padding = (((((clock.tick-1)*4) + clock.tock) - 1 ) * 38 ) + 13
		love.graphics.draw(beatHighlight, (((((clock.tick-1)*4) + clock.tock) - 1 ) * 38 ) + 16, 72) -- draw beat highlight according to tick.tock

		-- checking on ticks and tocks, to match tempo
		love.graphics.printf(clock.tick .. "." .. clock.tock, bigFont, 346, 380, 100, "center") -- show ticks



		-- debug printscreen
		-- display game.system
		love.graphics.setFont(monoFont)
		love.graphics.print("System: "..game.system, 334, 280) -- show game system
		love.graphics.print("Used: "..math.floor(game.time + love.timer.getTime()), 334, 290) -- show game time


		-- display game tooltip
		love.graphics.printf(game.tooltip, smallFont, 0, 458, 640, "left")

		-- display power
		game.power.state, game.power.percent, game.power.timeleft = love.system.getPowerInfo( )
	if game.system == "R36S" then
		love.graphics.printf(game.power.state .. " " .. game.power.percent .. "%", smallFont, 0, 458, 640, "right") -- show game power
	end



    end

end

return K
