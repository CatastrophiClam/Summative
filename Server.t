%Super Crash Pros Server --------------------------------> By: Bowen and Max

%NOTES
% 1). IMPORTANT: 0,0 IS THE BOTTOM LEFT POINT OF THE WORLD
% 2). Any coordinates that are "IN THE WORLD" must be converted to on-screen coordinates before being displayed

const FILLER_VARIABLE : int := 2 %if you see this, it means theres some value we haven't decided on yet and we need it declared for the program to run

%DECLARE TYPES

%THIS IS ONE FRAME OF FIGHTER
type position :
record
    pic : int   %this is the picture
    hitX : int  %this is the point that can hit the other player
    hitY : int
    hBX1 : int  %hitbox for the position
    hBX2 : int
    hBY1 : int
    hBY2 : int
end record

%This contains relevant movement info for each ability

type Ability:
record
    speed : int  %character moves 1/speed of the distance between him and his destination each update
    xIncrement : int
    yIncrement : int
    frames : int  %number of frames ability lasts for
end record

%--------------------------------------------------------%
%                DECLARE GLOBAL VARIABLES                %
%--------------------------------------------------------%

var gameOver := false
var winner : int %the winner

%---------------------PLAYER PICTURES--------------------%

var hitFile,boxFile:int %hitcoords and hitboxes files
open:hitFile,"HitCoords.txt",get
open:boxFile,"HitBoxes.txt",get

%THE FIRST INDEX OF PICTURES IS THE MOVE TYPE:
%1 - idle  2 - move  3 - kneel  4 - jump  5 - roundhouse  6 - punch  7 - kick  8 - tatsumaki  9 - hadoken  10 - shoryuken
%THE SECOND INDEX OF PICTURES IS THE FRAME WITHIN THE MOVE
%THE THIRD INDEX OF PICTURES IS THE SIDE PLAYER IS FACING: 1 - left  2 - right
%NOTE WE'RE PROBABLY GONNA HAVE TO READ THE FILLER_VARIABLES FROM A FILE

%FILE STUFF
%NOTE HITCOORDS FILE GOES:
%hitX
%hitY
%...
%HITBOXES FILE GOES:
%X1
%Y1
%X2
%Y2

var pictures : array 1 .. 10, 1 .. 13, 1 .. 2 of position

% Idle
for i : 1 .. 4
    pictures (1, i, 2).pic := Pic.FileNew ("Ken/Idle" + intstr (i) + ".gif")
    get: hitFile, pictures (1, i, 2).hitX
    get: hitFile, pictures (1, i, 2).hitY
    pictures (1, i, 1).pic := Pic.Mirror (pictures (1, i, 2).pic)
    pictures (1, i, 1).hitX := 70 - pictures (1, i, 2).hitX
    pictures (1, i, 1).hitY := pictures (1, i, 2).hitY
    
    %hitboxes
    get:boxFile, pictures (1, i, 2).hBX1
    get:boxFile, pictures (1, i, 2).hBY1
    get:boxFile, pictures (1, i, 2).hBX2
    get:boxFile, pictures (1, i, 2).hBY2
    pictures (1, i, 1).hBX2 := 70-pictures (1, i, 2).hBX1
    pictures (1, i, 1).hBY1 := pictures (1, i, 2).hBY1
    pictures (1, i, 1).hBX1 := 70-pictures (1, i, 2).hBX2
    pictures (1, i, 1).hBY2 := pictures (1, i, 2).hBY2
end for
    
% Move
for i : 1 .. 5
    pictures (2, i, 2).pic := Pic.FileNew ("Ken/Walk" + intstr (i) + ".gif")
    get: hitFile, pictures (2, i, 2).hitX
    get: hitFile, pictures (2, i, 2).hitY
    pictures (2, i, 1).pic := Pic.Mirror (pictures (2, i, 2).pic)
    pictures (2, i, 1).hitX := 70 - pictures (2, i, 2).hitX
    pictures (2, i, 1).hitY := pictures (2, i, 2).hitY
    
    %hitboxes
    get:boxFile, pictures (2, i, 2).hBX1
    get:boxFile, pictures (2, i, 2).hBY1
    get:boxFile, pictures (2, i, 2).hBX2
    get:boxFile, pictures (2, i, 2).hBY2
    pictures (2, i, 1).hBX2 := 70-pictures (2, i, 2).hBX1
    pictures (2, i, 1).hBY1 := pictures (2, i, 2).hBY1
    pictures (2, i, 1).hBX1 := 70-pictures (2, i, 2).hBX2
    pictures (2, i, 1).hBY2 := pictures (2, i, 2).hBY2
end for
    
% Kneel
pictures (3, 1, 2).pic := Pic.FileNew ("Ken/Crouch1.gif")
get: hitFile, pictures (3, 1, 2).hitX
get: hitFile, pictures (3, 1, 2).hitY
pictures (3, 1, 1).pic := Pic.Mirror (pictures (3, 1, 2).pic)
pictures (3, 1, 1).hitX := 70 - pictures (3, 1, 2).hitX
pictures (3, 1, 1).hitY := pictures (3, 1, 2).hitY

%hitboxes
get:boxFile, pictures (3, 1, 2).hBX1
get:boxFile, pictures (3, 1, 2).hBY1
get:boxFile, pictures (3, 1, 2).hBX2
get:boxFile, pictures (3, 1, 2).hBY2
pictures (3, 1, 1).hBX2 := 70-pictures (3, 1, 2).hBX1
pictures (3, 1, 1).hBY1 := pictures (3, 1, 2).hBY1
pictures (3, 1, 1).hBX1 := 70-pictures (3, 1, 2).hBX2
pictures (3, 1, 1).hBY2 := pictures (3, 1, 2).hBY2

% Jump
for i : 1 .. 7
    pictures (4, i, 2).pic := Pic.FileNew ("Ken/Jump" + intstr (i) + ".gif")
    get: hitFile, pictures (4, i, 2).hitX
    get: hitFile, pictures (4, i, 2).hitY
    pictures (4, i, 1).pic := Pic.Mirror (pictures (4, i, 2).pic)
    pictures (4, i, 1).hitX := 70 - pictures (4, i, 2).hitX
    pictures (4, i, 1).hitY := pictures (4, i, 2).hitY
    
    %hitboxes
    get:boxFile, pictures (4, i, 2).hBX1
    get:boxFile, pictures (4, i, 2).hBY1
    get:boxFile, pictures (4, i, 2).hBX2
    get:boxFile, pictures (4, i, 2).hBY2
    pictures (4, i, 1).hBX2 := 70-pictures (4, i, 2).hBX1
    pictures (4, i, 1).hBY1 := pictures (4, i, 2).hBY1
    pictures (4, i, 1).hBX1 := 70-pictures (4, i, 2).hBX2
    pictures (4, i, 1).hBY2 := pictures (4, i, 2).hBY2
end for
    
% Roundhouse
for i : 1 .. 5
    pictures (5, i, 2).pic := Pic.FileNew ("Ken/HardKick" + intstr (i) + ".gif")
    get: hitFile, pictures (5, i, 2).hitX
    get: hitFile, pictures (5, i, 2).hitY
    pictures (5, i, 1).pic := Pic.Mirror (pictures (5, i, 2).pic)
    pictures (5, i, 1).hitX := 70 - pictures (5, i, 2).hitX
    pictures (5, i, 1).hitY := pictures (5, i, 2).hitY
    
    %hitboxes
    get:boxFile, pictures (5, i, 2).hBX1
    get:boxFile, pictures (5, i, 2).hBY1
    get:boxFile, pictures (5, i, 2).hBX2
    get:boxFile, pictures (5, i, 2).hBY2
    pictures (5, i, 1).hBX2 := 70-pictures (5, i, 2).hBX1
    pictures (5, i, 1).hBY1 := pictures (5, i, 2).hBY1
    pictures (5, i, 1).hBX1 := 70-pictures (5, i, 2).hBX2
    pictures (5, i, 1).hBY2 := pictures (5, i, 2).hBY2
end for
    
%Punch
for i : 1 .. 3
    pictures (6, i, 2).pic := Pic.FileNew ("Ken/LightPunch" + intstr (i) + ".gif")
    get: hitFile, pictures (6, i, 2).hitX
    get: hitFile, pictures (6, i, 2).hitY
    pictures (6, i, 1).pic := Pic.Mirror (pictures (6, i, 2).pic)
    pictures (6, i, 1).hitX := 70 - pictures (6, i, 2).hitX
    pictures (6, i, 1).hitY := pictures (6, i, 2).hitY
    
    %hitboxes
    get:boxFile, pictures (6, i, 2).hBX1
    get:boxFile, pictures (6, i, 2).hBY1
    get:boxFile, pictures (6, i, 2).hBX2
    get:boxFile, pictures (6, i, 2).hBY2
    pictures (6, i, 1).hBX2 := 70-pictures (6, i, 2).hBX1
    pictures (6, i, 1).hBY1 := pictures (6, i, 2).hBY1
    pictures (6, i, 1).hBX1 := 70-pictures (6, i, 2).hBX2
    pictures (6, i, 1).hBY2 := pictures (6, i, 2).hBY2
end for
    
% Kick
for i : 1 .. 5
    pictures (7, i, 2).pic := Pic.FileNew ("Ken/LightMediumKick" + intstr (i) + ".gif")
    get: hitFile, pictures (7, i, 2).hitX
    get: hitFile, pictures (7, i, 2).hitY
    pictures (7, i, 1).pic := Pic.Mirror (pictures (7, i, 2).pic)
    pictures (7, i, 1).hitX := 70 - pictures (7, i, 2).hitX
    pictures (7, i, 1).hitY := pictures (7, i, 2).hitY
    
    %hitboxes
    get:boxFile, pictures (7, i, 2).hBX1
    get:boxFile, pictures (7, i, 2).hBY1
    get:boxFile, pictures (7, i, 2).hBX2
    get:boxFile, pictures (7, i, 2).hBY2
    pictures (7, i, 1).hBX2 := 70-pictures (7, i, 2).hBX1
    pictures (7, i, 1).hBY1 := pictures (7, i, 2).hBY1
    pictures (7, i, 1).hBX1 := 70-pictures (7, i, 2).hBX2
    pictures (7, i, 1).hBY2 := pictures (7, i, 2).hBY2
end for
    
% Tatsumaki
for i : 1 .. 13
    pictures (8, i, 2).pic := Pic.FileNew ("Ken/Tatsumaki" + intstr (i) + ".gif")
    get: hitFile, pictures (8, i, 2).hitX
    get: hitFile, pictures (8, i, 2).hitY
    pictures (8, i, 1).pic := Pic.Mirror (pictures (8, i, 2).pic)
    pictures (8, i, 1).hitX := 70 - pictures (8, i, 2).hitX
    pictures (8, i, 1).hitY := pictures (8, i, 2).hitY
    
    %hitboxes
    get:boxFile, pictures (8, i, 2).hBX1
    get:boxFile, pictures (8, i, 2).hBY1
    get:boxFile, pictures (8, i, 2).hBX2
    get:boxFile, pictures (8, i, 2).hBY2
    pictures (8, i, 1).hBX2 := 70-pictures (8, i, 2).hBX1
    pictures (8, i, 1).hBY1 := pictures (8, i, 2).hBY1
    pictures (8, i, 1).hBX1 := 70-pictures (8, i, 2).hBX2
    pictures (8, i, 1).hBY2 := pictures (8, i, 2).hBY2
end for
    
% Hadoken
for i : 1 .. 4
    pictures (9, i, 2).pic := Pic.FileNew ("Ken/Hadoken" + intstr (i) + ".gif")
    get: hitFile, pictures (9, i, 2).hitX
    get: hitFile, pictures (9, i, 2).hitY
    pictures (9, i, 1).pic := Pic.Mirror (pictures (9, i, 2).pic)
    pictures (9, i, 1).hitX := 70 - pictures (9, i, 2).hitX
    pictures (9, i, 1).hitY := pictures (9, i, 2).hitY
    
    %hitboxes
    get:boxFile, pictures (9, i, 2).hBX1
    get:boxFile, pictures (9, i, 2).hBY1
    get:boxFile, pictures (9, i, 2).hBX2
    get:boxFile, pictures (9, i, 2).hBY2
    pictures (9, i, 1).hBX2 := 70-pictures (9, i, 2).hBX1
    pictures (9, i, 1).hBY1 := pictures (9, i, 2).hBY1
    pictures (9, i, 1).hBX1 := 70-pictures (9, i, 2).hBX2
    pictures (9, i, 1).hBY2 := pictures (9, i, 2).hBY2
end for
    
% Shoryuken
for i : 1 .. 7
    pictures (10, i, 2).pic := Pic.FileNew ("Ken/FieryShoryuken" + intstr (i) + ".gif")
    get: hitFile, pictures (10, i, 2).hitX
    get: hitFile, pictures (10, i, 2).hitY
    pictures (10, i, 1).pic := Pic.Mirror (pictures (10, i, 2).pic)
    pictures (10, i, 1).hitX := 70 - pictures (10, i, 2).hitX
    pictures (10, i, 1).hitY := pictures (10, i, 2).hitY
    
    %hitboxes
    get:boxFile, pictures (10, i, 2).hBX1
    get:boxFile, pictures (10, i, 2).hBY1
    get:boxFile, pictures (10, i, 2).hBX2
    get:boxFile, pictures (10, i, 2).hBY2
    pictures (10, i, 1).hBX2 := 70-pictures (10, i, 2).hBX1
    pictures (10, i, 1).hBY1 := pictures (10, i, 2).hBY1
    pictures (10, i, 1).hBX1 := 70-pictures (10, i, 2).hBX1
    pictures (10, i, 1).hBY2 := pictures (10, i, 2).hBY1
end for
    
%---------------------------------WORLD STUFF-----------------------------------%

var worldLength, worldHeight : int  %actual width and height of world
worldLength := 1920 
worldHeight := 1080 

%platform
var platY := 363
var platX1 := 465
var platX2 := 1418

%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                                  NETWORK STUFF                                                            %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%

%--------------------------------------------------------%
%                   DECLARE VARIABLES                    %
%--------------------------------------------------------%

var port1 := 5600
var port2 := 5605

var stream1, stream2 : int

var address1, address2 : string

stream1 := Net.WaitForConnection (port1, address1)
put "Player 1 Connected"
stream2 := Net.WaitForConnection (port1, address2)
put "Player 2 Connected"
put : stream1, "go"
put : stream2, "go"

%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                                END NETWORK STUFF                                                          %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%


%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                                     CLASSES                                                               %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%

%Display thingy at bottom of screen with character lives and damage
class PlayerStatusDisplay
    
    import Pic, Sprite
    
    export var numLives, var damage, display, _init
    
    %stats
    var numLives : int
    var damage : int := 0
    
    %picture stuff
    %bascically, in order for the display to be drawn over the background, it has to be a sprite
    %to make the picture for the sprite, we draw everything that is needed outside of the display, and
	%we take a picture of that and put it into the sprite
    var picSprite : int
    var spritePic : int
    var offScreenX := 0
    var offScreenY := -600
    spritePic := Pic.New (offScreenX, offScreenY, offScreenX + 150, offScreenY + 250)
    picSprite := Sprite.New (spritePic)
    
    proc _init (lives : int)
	numLives := lives
    end _init
    
    proc updatePic ()
	
    end updatePic
    
    proc display ()
	
    end display
    
end PlayerStatusDisplay

%NOTE HERE'S HOW CHARACTER MOVEMENT WORKS: character has a destination: this is the point his center is moving towards. moving the character with
%the keyboard changes the destination, and he moves towards it with his movement speed
%represents a character in the game
class Character
    
    import PlayerStatusDisplay, platX1, platX2, platY, FILLER_VARIABLE, Ability, pictures, gameOver, worldLength, worldHeight
    
    export var x, var y, var xDestination, var yDestination, var h, var w, var dir, var lives, var damage, var charType, update, getHit %exported variables
    
    %Character attributes
    var charType : int  %which character does this class represent?
    var lives : int := 5 %how many lives does this character have?
    var damage : int := 0%how much damage has the character taken? (damage determines how much the character flies)
    var damageArray : array 1..10 of int %how much damage does each ability deal?
    damageArray(1) :=1
    damageArray(2) :=2
    damageArray(3) :=4
    damageArray(4) :=4
    damageArray(5) :=20
    damageArray(6) :=10
    damageArray(7) :=15
    damageArray(8) :=35
    damageArray(9) :=30
    damageArray(10) :=30
    var powerArray : array 1..10 of real %involved in knockback calculation
    powerArray(1) := 0.03
    powerArray(2) := 0.03
    powerArray(3) := 0.03
    powerArray(4) := 0.075
    powerArray(5) := 0.4
    powerArray(6) := 0.25
    powerArray(7) := 0.3
    powerArray(8) := 0.6
    powerArray(9) := 0.45
    powerArray(10) := 0.5
    var x, y : real %coordinates of CENTER of character IN THE WORLD
    var h, w : int %current height and width of character
    var dir : int %the way the character is facing - 1 indicates left, 2 indicates right
    var kbDistance : int := 700 %base distance character gets knocked back
    var knockedBack := false %is player traveling because he got knocked back?
    var abilityLock := false % is the player currently performing an action that can't be switched until its finished?
    var canDoAction := true % can the player perform an ability?
    var doingAction := false % is the player already performing an action?
    var canJump := true %can player jump?
    var jumping := false %is player jumping
    var atDestination := true %is player at his destination
    var moveStuff : array 1..10 of Ability %player moves at 1/moveStuff(i) of the distance between him and destination every update
    var hitX, hitY : int %point IN THE WORLD that can hit the other player
    var hitBoxX1, hitBoxX2, hitBoxY1, hitBoxY2 : int %box IN THE WORLD that can be hit by the other player
    hitBoxX1 := pictures(1,1,1).hBX1
    hitBoxY1 := pictures(1,1,1).hBY1
    hitBoxX2 := pictures(1,1,1).hBX2
    hitBoxY2 := pictures(1,1,1).hBY2
    
    var cX, cY : int %center of hitbox/player
    moveStuff(1).speed := 1
    moveStuff(1).xIncrement := 0
    moveStuff(1).yIncrement := 0
    moveStuff(1).frames := 4
    moveStuff(2).speed := 1
    moveStuff(2).xIncrement :=7
    moveStuff(2).yIncrement :=0
    moveStuff(2).frames :=5
    moveStuff(3).speed := 1
    moveStuff(3).xIncrement :=1
    moveStuff(3).yIncrement :=0
    moveStuff(3).frames :=1
    moveStuff(4).speed := 15
    moveStuff(4).xIncrement :=0
    moveStuff(4).yIncrement :=300
    moveStuff(4).frames :=7
    moveStuff(5).speed := 10
    moveStuff(5).xIncrement :=-5
    moveStuff(5).yIncrement :=0
    moveStuff(5).frames :=5
    moveStuff(6).speed := 1
    moveStuff(6).xIncrement :=0
    moveStuff(6).yIncrement :=0
    moveStuff(6).frames :=3
    moveStuff(7).speed := 1
    moveStuff(7).xIncrement :=0
    moveStuff(7).yIncrement :=0
    moveStuff(7).frames :=5
    moveStuff(8).speed := 20
    moveStuff(8).xIncrement :=10
    moveStuff(8).yIncrement :=200
    moveStuff(8).frames :=13
    moveStuff(9).speed := 17
    moveStuff(9).xIncrement :=100
    moveStuff(9).yIncrement :=0
    moveStuff(9).frames :=4
    moveStuff(10).speed := 18
    moveStuff(10).xIncrement :=0
    moveStuff(10).yIncrement :=150
    moveStuff(10).frames :=7
    
    var fallSpeed : int := 10
    
    var isHit := false %did the character get hit?
    
    %different skills deal different amounts of damage
    var upOD, downOD, sideOD, upPD, downPD, sidePD : int
    
    %Character abilities stuff
    var ability : int := 1%current ability player is performing
    var frameNums : int := 0 %frame number in an ability
    %var abilXIncr : int %how much does the character move horizontally each frame during the ability?
    %var abilYIncr : int %same for vertically
    var staticAction := false %is there an action being done that doesn't require movement?
    var moveableAction := true %can the player move?
    var canCycle := true
    
    %Character movement stuff
    var xDir := 0  %-1 indicates to the left, 0 indicates stopped, 1 indicates to the right
    var yDir := 0  %-1 indicates down, " , 1 indicates up
    
    var xDestination, yDestination : int %coordinates of where character is moving towards
    var bounceX, bounceY : int %coords of where character will bounce (if character is hit towards ground)
    var bounces := false %does the character bounce?
    
    %Character picture stuff
    var bodyPic, bodyFPic : int
    
    %converts world coordinates to screen coordintes
    %screenX is the location of the BOTTOM LEFT of the screen IN THE WORLD
    function convertX (x_, screenX : real) : int
	result round (x_ - screenX)
    end convertX
    
    %converts world coordinates to screen coordintes
    %screenX is the location of the BOTTOM LEFT of the screen IN THE WORLD
    function convertY (y_, screenY : real) : int
	result round (y_ - screenY)
    end convertY
    
    proc knockBack (cX, cY, pX, pY : int, power: real) %cX,cY is center of other player, pX, pY is where character was hit
	var kbD : real := kbDistance * damage / 100 * power %distance character gets knocked back
	%calculate new destination
	%ABRUPT CHANGE OF DIRECTION VERSION
	if pX-cX > 0 then
	    xDestination := round (x + (pX - cX) * kbD / sqrt ((pX - cX) ** 2 + (pY - cY) ** 2))
	else
	    xDestination := round (x + (pX - cX) * kbD / sqrt ((pX - cX) ** 2 + (pY - cY) ** 2))
	end if
	yDestination := round (y + (pY - cY) * kbD / sqrt ((pX - cX) ** 2 + (pY - cY) ** 2))
	%KEEPS MOMENTUM VERSION
	%xDestination += (pX-cX)*kbD/sqrt( (pX-cX)**2 + (pY-cY)**2)
	%yDestination += (pY-cY)*kbD/sqrt( (pX-cX)**2 + (pY-cY)**2)
	
	%check if character bounces
	if yDestination < platY then
	    %character bounces
	    bounces := true
	    bounceX := xDestination
	    bounceY := platY + (platY - yDestination)
	end if
    end knockBack
    
    %did current character get hit?
    proc getHit(hX,hY,cX,cY,damageType:int) %hX,hY is point that got hit, cX,cY is center of other player, damageType is abiliy that caused the damage
	var damageTaken := damageArray(damageType)
	%if player did get hit
	if hX > x and hX < x+Pic.Width(pictures(ability,frameNums,dir).pic) and hY > y and hY < y+Pic.Height(pictures(ability,frameNums,dir).pic) then
	    damage += Rand.Int(damageTaken-6, damageTaken+6)
	    abilityLock := false
	    knockedBack := true
	    knockBack(cX,cY,hX,hY,powerArray(damageType))
	end if
    end getHit
    
    function update (instructions : string, oP:pointer to Character) : string
	var moveSpeed := moveStuff(ability)
	
	%update doingAction
	doingAction := not(not abilityLock and instructions = "000n")
	
	%PLAYER BASIC MOVEMENT
	%if we can perform an action, look at instructions sent by client
	
	    if (instructions (1) = "2") then  %going right
		%actually moving
		if not abilityLock then
		    %are we crouching?
		    if instructions(2) = "1" then
			ability := 3
		    else
			ability := 2
		    end if
		    xDestination += moveStuff(ability).xIncrement
		    if knockedBack then 
			x+= moveStuff(ability).xIncrement
		    end if
		    staticAction := true
		    canCycle := true
		%shifting    
		elsif not ability = 9 then
		    xDestination += moveStuff(2).xIncrement
		    x+= moveStuff(2).xIncrement
		end if
		doingAction := true
		dir := 2
	    end if
	    if (instructions (1) = "1") then %go left
		if not abilityLock then
		%are we crouching?
		    if instructions(2) = "1" then
			ability := 3
		    else
			ability := 2
		    end if
		    xDestination -= moveStuff(ability).xIncrement
		    if knockedBack then 
			x-= moveStuff(ability).xIncrement
		    end if
		    staticAction := true
		    canCycle := true
		elsif not ability = 9 then
		    xDestination -= moveStuff(2).xIncrement
		    x-= moveStuff(2).xIncrement
		end if
		doingAction := true
		
		dir := 1
	    end if
	
	if not abilityLock then
	    if (instructions (2) = "1") then %crouch
		ability := 3
		%player falls faster if he isn't on the ground
		if yDestination-5 < platY and x > platX1 and x < platX2 then
		    yDestination := platY
		else
		    yDestination -= moveStuff(ability).yIncrement
		    if knockedBack then 
			y-= moveStuff(ability).yIncrement
		    end if
		end if
		doingAction := true
		staticAction := true
	    elsif (instructions (2) = "2") then %jump
		if canJump then
		    ability := 4
		    canJump := false  %can't jump after jumping once
		    doingAction := true
		    jumping := true
		    yDestination += moveStuff(ability).yIncrement
		    staticAction := false
		    canCycle := false
		end if
	    end if
	end if
	
	%if player is doing nothing he is idle
	if doingAction = false then
	    ability := 1
	    staticAction := true
	end if    
	%UPDATE PLAYER ABILITIES
	if not abilityLock and canDoAction then
	    if instructions (4) = "q" then   
		if instructions (3) = "1" then %left q
		    ability := 9
		    xDestination -= moveStuff(ability).xIncrement
		    yDestination += moveStuff(ability).yIncrement
		    abilityLock := true
		    staticAction := false
		    canDoAction := false
		    canCycle := false
		elsif instructions (3) = "2" then  %right q
		    ability := 9
		    xDestination += moveStuff(ability).xIncrement
		    yDestination += moveStuff(ability).yIncrement
		    abilityLock := true
		    staticAction := false
		    canDoAction := false
		    canCycle := false
		elsif instructions (3) = "4" then
		    ability := 10
		    xDestination += moveStuff(ability).xIncrement
		    yDestination += moveStuff(ability).yIncrement
		    abilityLock := true
		    staticAction := false
		    canDoAction := false
		    canCycle := false
		else
		    ability := 6
		    xDestination += moveStuff(ability).xIncrement
		    yDestination += moveStuff(ability).yIncrement
		    abilityLock := false
		    canDoAction := false
		    staticAction := true
		    canCycle := true
		end if
	    elsif instructions (4) = "w" then
		if instructions (3) = "1" then
		    ability := 5
		    xDestination -= moveStuff(ability).xIncrement
		    yDestination += moveStuff(ability).yIncrement
		    abilityLock := true
		    staticAction := false
		    canDoAction := false
		    canCycle := true
		elsif instructions (3) = "2" then
		    ability := 5
		    xDestination += moveStuff(ability).xIncrement
		    yDestination += moveStuff(ability).yIncrement
		    abilityLock := true
		    staticAction := false
		    canDoAction := false
		    canCycle := true
		elsif instructions (3) = "4" then
		    ability := 8
		    xDestination += moveStuff(ability).xIncrement
		    yDestination += moveStuff(ability).yIncrement
		    abilityLock := true
		    staticAction := false
		    staticAction := false
		    canDoAction := false
		    canCycle := false
		else
		    ability := 7
		    xDestination += moveStuff(ability).xIncrement
		    yDestination += moveStuff(ability).yIncrement
		    abilityLock := false
		    canDoAction := false
		    staticAction := true
		    canCycle := true
		    %put "KICK"
		end if
	    end if
	end if
	
	%update player position
	%move x and y towards xDestination and yDestination
	%character moves differently when he is knocked back than when he is just moving
	if knockedBack then
	    x += 1/9*(xDestination-x)
	    y += 1/9*(yDestination-y)
	    %if character is knocked into the ground, he bounces
	    if bounces then
		if x > platX1 and x < platX2 and y < platY then
		    xDestination := bounceX
		    yDestination := bounceY
		    bounces := false
		    canDoAction := true
		end if
	    end if
	    %see if knocked back is finished
	    if abs(xDestination-x) < 10 and abs(yDestination-y) < 10 then
		knockedBack := false
	    end if
	else
	    %put moveStuff(ability).speed
	    x += 1/moveStuff(ability).speed*(xDestination-x)
	    y += 1/moveStuff(ability).speed*(yDestination-y)
	    
	    %GRAVITY
	    %If player isn't performing an uninteruptable action, he falls if he isn't on the ground
	    %Player is over/under platform
	    if x > platX1 and x < platX2 then
		if yDestination > platY then
		    yDestination -= fallSpeed
		else
		    %player is on the ground
		    canJump := true
		    jumping := false
		    canDoAction := true
		    yDestination := platY
		end if
		%Player isn't over platform, make him fall
	    else
		yDestination -= fallSpeed
	    end if
	end if
	
	%determine if current action ends
	%if player has arrived at destination
	if abs(xDestination-x) < 5 and abs(yDestination-y) < 5 then
	    if not staticAction then
		%action ended
		doingAction := false
		abilityLock := false
		ability := 1
		frameNums := 1
	    end if
	end if
	
	%update how player looks
	frameNums += 1
	if frameNums > moveStuff(ability).frames then
	    frameNums := moveStuff(ability).frames
	    if not doingAction then 
		frameNums := 1
	    end if
	    if canCycle then
		frameNums := 1
	    end if
	end if
	
	%update player hit stuff
	hitX := round(x+pictures(ability,frameNums,dir).hitX)
	hitY := round(y+pictures(ability,frameNums,dir).hitY)
	hitBoxX1 := round(x+pictures(ability,frameNums,dir).hBX1)
	hitBoxY1 := round(y+pictures(ability,frameNums,dir).hBY1)
	hitBoxX2 := round(x+pictures(ability,frameNums,dir).hBX2)
	hitBoxY2 := round(y+pictures(ability,frameNums,dir).hBY2)
	cX := round((x+x+Pic.Width(pictures(ability,frameNums,dir).pic))/2)
	cY := round((y+y+Pic.Height(pictures(ability,frameNums,dir).pic))/2)
	
	%see if player died
	if x < 0 or x > worldLength or y < 0 or y > worldHeight then
	    %if player dies, reset stuff and deduct a life
	    lives -= 1
	    damage := 0
	    abilityLock := false
	    canJump := true
	    doingAction := false
	    
	    %respawn
	    x := round((platX1+platX2)/2)
	    y := platY + 500
	    xDestination := round(x)
	    yDestination := round(y)
	end if
	
	%check to see if player is still playing
	if lives = 0 then
	    gameOver := true
	end if
	
	%see if player hit other player
	^(oP).getHit(round(hitX),round(hitY),cX,cY,ability)
	
	result intstr(ability) + " " + intstr(frameNums) + " " + intstr(dir)
	
    end update
    
end Character

%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                                   END CLASSES                                                             %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%

%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                                    VARIABLES                                                              %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%

var chars : array char of boolean

%---------------------------------SCREEN STUFF----------------------------------%

var screenX, screenY : int %location of BOTTOM LEFT of screen IN THE WORLD

%---------------------------------PLAYER STUFF----------------------------------%

var player1, player2 : pointer to Character
new Character, player1
new Character, player2
^ (player1).x := 565
^ (player1).xDestination := 565
^ (player1).y := 365
^ (player1).yDestination := 365
^ (player1).h := 2
^ (player1).w := 2
^ (player1).dir := 2
^ (player2).x := 1318
^ (player2).xDestination := 1318
^ (player2).y := 365
^ (player2).yDestination := 365
^ (player2).h := 2
^ (player2).w := 2
^ (player2).dir := 1

%--------------------PLAYER STATUS DISPLAYS------------------------%
var pSD1, pSD2 : pointer to PlayerStatusDisplay
new PlayerStatusDisplay, pSD1
new PlayerStatusDisplay, pSD2

%---------------Time Stuff----------------%
var startTime : int  %time game started
var gameTime := 0    %time passed


%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                                  END VARIABLES                                                            %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%


%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                               FUNCTIONS AND PROCESSES                                                     %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%

%updates position of screen
procedure updateScreen
    var leftMost, rightMost, topMost, bottomMost : int %screen should encompass these points with a 60 px margin
    
    %find leftMost and rightMost
    if ^ (player1).x < ^ (player2).x then
	%if player 1 is to the left of player 2 and inside the world boundaries
	if ^ (player1).x - ^ (player1).w / 2 > 0 then
	    %player 1's x is leftmost
	    leftMost := round ( ^ (player1).x - ^ (player1).w / 2)
	else
	    leftMost := 0
	end if
	
	%This means that player 2 is to the right of player 1
	if ^ (player2).x + ^ (player2).w / 2 < worldLength then
	    %player 2's x is rightmost
	    rightMost := round ( ^ (player2).x + ^ (player2).w / 2)
	else
	    rightMost := worldLength
	end if
    else
	%player 2 is to the left of player 1
	if ^ (player2).x - ^ (player2).w / 2 > 0 then
	    %player 1's x is leftmost
	    leftMost := round ( ^ (player2).x - ^ (player2).w / 2)
	else
	    leftMost := 0
	end if
	
	%This means that player 1 is to the right of player 2
	if ^ (player1).x + ^ (player1).w / 2 < worldLength then
	    %player 1's x is leftmost
	    rightMost := round ( ^ (player1).x + ^ (player1).w / 2)
	else
	    rightMost := worldLength
	end if
    end if
    
    %find topmost and bottomMost
    if ^ (player1).y < ^ (player2).y then
	%if player 1 is under player 2 and inside the world boundaries
	if ^ (player1).y - ^ (player1).h / 2 > 0 then
	    %player 1's y is bottommost
	    bottomMost := round ( ^ (player1).y - ^ (player1).h / 2)
	else
	    bottomMost := 0
	end if
	
	%This means that player 2 above player 1
	if ^ (player2).y + ^ (player2).h / 2 < worldHeight then
	    %player 1's x is topmost
	    topMost := round ( ^ (player2).y + ^ (player2).h / 2)
	else
	    topMost := worldHeight
	end if
    else
	%if player 2 is under player 1 and inside the world boundaries
	if ^ (player2).y - ^ (player2).h / 2 > 0 then
	    %player 1's y is bottommost
	    bottomMost := round ( ^ (player2).y - ^ (player2).h / 2)
	else
	    bottomMost := 0
	end if
	
	%This means that player 1 above player 2
	if ^ (player1).y + ^ (player1).h / 2 < worldHeight then
	    %player 1's x is topmost
	    topMost := round ( ^ (player1).y + ^ (player1).h / 2)
	else
	    topMost := worldHeight
	end if
    end if
    
    
    %update screenX and screenY
    screenX := round ((rightMost + leftMost) / 2 - maxx / 2)
    if screenX < 0 then
	screenX := 0
    end if
    if screenX > worldLength - maxx then
	screenX := worldLength - maxx
    end if
    
    screenY := round ((bottomMost + topMost) / 2 - maxy / 2)
    if screenY < 0 then
	screenY := 0
    end if
    if screenY > worldHeight - maxy then
	screenY := worldHeight - maxy
    end if
    
    %put maxx
    %put maxy
    %put rightMost-leftMost
    %put topMost-bottomMost
    %put screenX
end updateScreen

%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                             END FUNCTIONS AND PROCESSES                                                   %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%


%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                                     GAME LOOP                                                             %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%
var instructions1, instructions2 : string := "000n" %instructions sent by client
var picStuff1, picStuff2 : string
var netLimiter := 1

loop
    %reset stuff for new game
    new Character, player1
    new Character, player2
    ^ (player1).x := 565
    ^ (player1).xDestination := 565
    ^ (player1).y := 365
    ^ (player1).yDestination := 365
    ^ (player1).h := 2
    ^ (player1).w := 2
    ^ (player1).lives := 5
    ^ (player1).damage := 0
    ^ (player1).dir := 2
    ^ (player2).x := 1318
    ^ (player2).xDestination := 1318
    ^ (player2).y := 365
    ^ (player2).yDestination := 365
    ^ (player2).h := 2
    ^ (player2).w := 2
    ^ (player2).dir := 1
    ^ (player2).lives := 5
    ^ (player2).damage := 0
    gameOver := false
    startTime := Time.Sec()
    netLimiter := 1
    %INSTRUCTIONS: FIRST DIGIT IS EITHER 1,0,or 2, indicating left, no, or right arrow was pressed
    %SECOND DIGIT is similar for down, no, or up arrow pressed
    loop
	%update time
	gameTime := 300-(Time.Sec()-startTime)
	
	if gameTime = 0 then 
	    gameOver := true
	end if
	if Net.LineAvailable (stream1) and Net.LineAvailable (stream2) then
	    %update player 1's stuff
	    get : stream1, instructions1
	    %put instructions1
	    %update player 2's stuff
	    get : stream2, instructions2
	    netLimiter -= 1
	    updateScreen
	elsif length(instructions1) = 4 and length(instructions2) = 4 and netLimiter < 5 then
	    netLimiter += 1
	    picStuff1 := ^ (player1).update (instructions1,player2)
	    picStuff2 := ^ (player2).update (instructions2,player1)
	    %send player info back
	    
	    %if gameOver then tell clients and exit
	    if gameOver then
            if ^(player1).lives < ^(player2).lives then
                winner := 2
            else
                winner := 1
            end if
            %game is over, flush all input from clients so the next instructions can be read
            loop
                if Net.LineAvailable (stream1) then
                get:stream1,instructions1
                else
                exit
                end if
            end loop
            loop
                if Net.LineAvailable (stream2) then
                get:stream2,instructions2
                else
                exit
                end if
            end loop
            %update clients
            put: stream1, "G"+intstr(winner)
            put: stream2, "G"+intstr(winner)
            exit
	    end if
	    
	    %PLAYER INFO FORM:
	    %PLAYER.X PLAYER.Y OTHERPLAYER.X OTHERPLAYER.Y
	    %put Time.Sec-startTime
	    put : stream1, intstr (round ( ^ (player1).x)) + " " + intstr (round ( ^ (player1).y)) + " " + intstr (round ( ^ (player2).x)) + " " + intstr (round ( ^ (player2).y))+ " "+picStuff1+" " + picStuff2 + " "+intstr(^(player1).damage) + " "+intstr(^(player1).lives) + " "+intstr(^(player2).damage) + " "+intstr(^(player2).lives) + " " + intstr(gameTime)
	    put : stream2, intstr (round ( ^ (player2).x)) + " " + intstr (round ( ^ (player2).y)) + " " + intstr (round ( ^ (player1).x)) + " " + intstr (round ( ^ (player1).y))+ " "+picStuff2+" "+picStuff1+ " "+intstr(^(player2).damage) + " "+intstr(^(player2).lives) + " "+intstr(^(player1).damage) + " "+intstr(^(player1).lives)+ " " + intstr(gameTime)
	    
	    %put  intstr (round ( ^ (player1).x)) + " " + intstr (round ( ^ (player1).y)) + " " + intstr (round ( ^ (player2).x)) + " " + intstr (round ( ^ (player2).y))+ " "+picStuff1+" " + picStuff2 + " "+intstr(^(player1).damage) + " "+intstr(^(player1).lives) + " "+intstr(^(player2).damage) + " "+intstr(^(player2).lives)
	    %put  intstr (round ( ^ (player2).x)) + " " + intstr (round ( ^ (player2).y)) + " " + intstr (round ( ^ (player1).x)) + " " + intstr (round ( ^ (player1).y))+ " "+picStuff2+" "+picStuff1+ " "+intstr(^(player2).damage) + " "+intstr(^(player2).lives) + " "+intstr(^(player1).damage) + " "+intstr(^(player1).lives)
	end if
	delay(5)
    end loop
    %check client input on playing again
    loop
	if Net.LineAvailable (stream1) then
	    get:stream1,instructions1
	    if instructions1 = "yes" or instructions1 = "no" then
		exit
	    end if
	end if
    end loop
    loop
	if Net.LineAvailable (stream2) then
	    get:stream2,instructions2
	    if instructions2 = "yes" or instructions2 = "no" then
		exit
	    end if
	end if
    end loop
    if instructions1 = "yes" and instructions2 = "yes" then
	put:stream1, "go"
	put:stream2, "go"
	put "go"
    elsif instructions1 = "no" or instructions2 = "no" then
	put:stream1, "no"
	put:stream2, "no"
	exit
    end if
end loop

%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                                   END GAME SCREEN                                                         %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%












