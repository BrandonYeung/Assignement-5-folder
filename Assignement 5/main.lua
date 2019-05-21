--Brandon Yeung
---------------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

display.setStatusBar( display.HiddenStatusBar )

local physics = require("physics")
local gameUI = require("gameUI")
local easingx  = require("easingx")

physics.start()
physics.setGravity( 0, 0 ) -- no gravity in any direction
local score =  display.newText (tonumber"0" , display.contentCenterX , display.contentCenterY , native.systemFont, 10)


popSound = audio.loadSound ("pop2_wav.wav")
labelFont = gameUI.newFontXP{ ios="native.systemFont", android=native.systemFont }

system.activate( "multitouch" )


local bkg = display.newImageRect( "paper_bkg.png" , 800, 1400)
bkg.x = display.contentCenterX
bkg.y = display.contentCenterY
bkg.id = "bkg"
local myLabel = display.newText( "Touch screen to create pucks", centerX, 200, labelFont, 34 )
myLabel:setFillColor( 1, 1, 1, 180/250 )

local diskGfx = { "puck_yellow.png", "puck_green.png", "puck_red.png" }

local allDisks = {} -- empty table for storing objects

local net = display.newImageRect( "net.png", 500, 700 )
net.x = 400
net.y = -50
net.id = "net"
score = 0
--print(NumString)

local playerScore = display.newText ("Score " ..score , display.contentCenterX , display.contentCenterY , native.systemFont, 90)
playerScore.text = "Score " ..score

-- Automatic culling of offscreen objects
local function removeOffscreenItems()
	for i = 1, #allDisks do
		local oneDisk = allDisks[i]
		if (oneDisk and oneDisk.x) then
			if oneDisk.x < -100 or oneDisk.x > display.contentWidth + 100 or oneDisk.y < -100 or oneDisk.y > display.contentHeight + 100 then
				oneDisk:removeSelf()
                table.remove( allDisks, i ) 
                --print ("done_removeoffscreen")


 			end	
		end
	end
end

local function dragBody( event )
	return gameUI.dragBody( event )
	
	
end

local function spawnDisk( event )
	local phase = event.phase
	
	if "ended" == phase then
		audio.play( popSound )
		myLabel.isVisible = false


		randImage = diskGfx[ math.random( 1, 3 ) ]
		allDisks[#allDisks + 1] = display.newImage( randImage )
		local disk = allDisks[#allDisks]
		disk.x = event.x; disk.y = event.y
		disk.rotation = math.random( 1, 360 )
		disk.xScale = 0.8; disk.yScale = 0.8
		
		transition.to(disk, { time = 500, xScale = 1.0, yScale = 1.0, transition = easingx.easeOutElastic }) -- "pop" animation
		
		physics.addBody( disk, { density=0.3, friction=0.6, radius=66.0 } )
		disk.linearDamping = 0.4
		disk.angularDamping = 0.6
		
		disk:addEventListener( "touch", dragBody ) -- make object draggable
	end
	
	return true
end
local function checkdiskGfxPosition()
	for j = 1, #allDisks do
		local oneDisk = allDisks[j]
		
		if (oneDisk and oneDisk.x) then
			--print ("done_onediskcheck")
			--print(oneDisk)
			--print(oneDisk.x)
			if (oneDisk.x < 590 and oneDisk.x >  290) and (oneDisk.y < -100) then
			  score = score + 1
			  oneDisk:removeSelf()
              table.remove( allDisks, i )
			  print(score)
              playerScore.text = "Score: " .. score
 			end	
		end
	end
end


bkg:addEventListener( "touch", spawnDisk ) -- touch the screen to create disks
--Runtime:addEventListener( "enterFrame", removeOffscreenItems ) -- clean up offscreen disks
Runtime:addEventListener( "enterFrame", checkdiskGfxPosition )
