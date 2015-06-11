%Super Crash Pros Server --------------------------------> By: Bowen and Max

%NOTES
% 1). IMPORTANT: 0,0 IS THE BOTTOM LEFT POINT OF THE WORLD
% 2). Any coordinates that are "IN THE WORLD" must be converted to on-screen coordinates before being displayed

const FILLER_VARIABLE := 2 %if you see this, it means theres some value we haven't decided on yet and we need it declared for the program to run


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
stream2 := Net.WaitForConnection (port2, address2)
put "Player 2 Connected"
put : stream1, "go"
put : stream2, "go"

%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                                END NETWORK STUFF                                                          %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%



%---------------------------------WORLD STUFF-----------------------------------%

var worldLength, worldHeight : int  %actual width and height of world
worldLength := 1920 %3840
worldHeight := 1080 %2160

%platform
var platY := 717
var platX1 := 465
var platX2 := 1418

%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                                 CLASSES AND TYPES                                                         %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%

%THIS IS ONE FRAME OF FIGHTER
type position :
record
    pic : int   %this is the picture
    hitX : int  %this is the point that can hit the other player
    hitY : int
end record

%This contains relevant movement info for each ability

type Ability:
record
    speed : int  %character moves 1/speed of the distance between him and his destination each update
    xIncrement : int
    yIncrement : int
    frames : int  %number of frames ability lasts for
end record

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

%---------------------PLAYER PICTURES--------------------%

%THE FIRST INDEX OF PICTURES IS THE MOVE TYPE:
%1 - idle  2 - move  3 - kneel  4 - jump  5 - roundhouse  6 - punch  7 - kick  8 - tatsumaki  9 - hadoken  10 - shoryuken
%THE SECOND INDEX OF PICTURES IS THE FRAME WITHIN THE MOVE
%THE THIRD INDEX OF PICTURES IS THE SIDE PLAYER IS FACING: 1 - left  2 - right
%NOTE WE'RE PROBABLY GONNA HAVE TO READ THE FILLER_VARIABLES FROM A FILE
var pictures : array 1 .. 10, 1 .. 13, 1 .. 2 of position

% Idle
for i : 1 .. 4
    pictures (1, i, 2).pic := Pic.FileNew ("Ken/idle" + intstr (i) + ".jpeg")
    pictures (1, i, 2).hitX := FILLER_VARIABLE
    pictures (1, i, 2).hitY := FILLER_VARIABLE
    pictures (1, i, 1).pic := Pic.Mirror (pictures (1, i, 2).pic)
    pictures (1, i, 1).hitX := 70 - pictures (1, i, 2).hitX
    pictures (1, i, 1).hitY := pictures (1, i, 2).hitY
end for
    
% Move
for i : 1 .. 5
    pictures (2, i, 2).pic := Pic.FileNew ("Ken/move" + intstr (i) + ".jpeg")
    pictures (2, i, 2).hitX := FILLER_VARIABLE
    pictures (2, i, 2).hitY := FILLER_VARIABLE
    pictures (2, i, 1).pic := Pic.Mirror (pictures (2, i, 2).pic)
    pictures (2, i, 1).hitX := 70 - pictures (2, i, 2).hitX
    pictures (2, i, 1).hitY := pictures (2, i, 2).hitY
end for
    
% Kneel
pictures (3, 1, 2).pic := Pic.FileNew ("Ken/kneel.jpeg")
pictures (3, 1, 2).hitX := FILLER_VARIABLE
pictures (3, 1, 2).hitY := FILLER_VARIABLE
pictures (3, 1, 1).pic := Pic.Mirror (pictures (3, 1, 2).pic)
pictures (3, 1, 1).hitX := 70 - pictures (3, 1, 2).hitX
pictures (3, 1, 1).hitY := pictures (3, 1, 2).hitY

% Jump
for i : 1 .. 7
    pictures (4, i, 2).pic := Pic.FileNew ("Ken/jump" + intstr (i) + ".jpeg")
    pictures (4, i, 2).hitX := FILLER_VARIABLE
    pictures (4, i, 2).hitY := FILLER_VARIABLE
    pictures (4, i, 1).pic := Pic.Mirror (pictures (4, i, 2).pic)
    pictures (4, i, 1).hitX := 70 - pictures (4, i, 2).hitX
    pictures (4, i, 1).hitY := pictures (4, i, 2).hitY
end for
    
% Roundhouse
for i : 1 .. 5
    pictures (5, i, 2).pic := Pic.FileNew ("Ken/roundhouse" + intstr (i) + ".jpeg")
    pictures (5, i, 2).hitX := FILLER_VARIABLE
    pictures (5, i, 2).hitY := FILLER_VARIABLE
    pictures (5, i, 1).pic := Pic.Mirror (pictures (5, i, 2).pic)
    pictures (5, i, 1).hitX := 70 - pictures (5, i, 2).hitX
    pictures (5, i, 1).hitY := pictures (5, i, 2).hitY
end for
    
%Punch
for i : 1 .. 3
    pictures (6, i, 2).pic := Pic.FileNew ("Ken/punch" + intstr (i) + ".jpeg")
    pictures (6, i, 2).hitX := FILLER_VARIABLE
    pictures (6, i, 2).hitY := FILLER_VARIABLE
    pictures (6, i, 1).pic := Pic.Mirror (pictures (6, i, 2).pic)
    pictures (6, i, 1).hitX := 70 - pictures (6, i, 2).hitX
    pictures (6, i, 1).hitY := pictures (6, i, 2).hitY
end for
    
% Kick
for i : 1 .. 5
    pictures (7, i, 2).pic := Pic.FileNew ("Ken/kick" + intstr (i) + ".jpeg")
    pictures (7, i, 2).hitX := FILLER_VARIABLE
    pictures (7, i, 2).hitY := FILLER_VARIABLE
    pictures (7, i, 1).pic := Pic.Mirror (pictures (7, i, 2).pic)
    pictures (7, i, 1).hitX := 70 - pictures (7, i, 2).hitX
    pictures (7, i, 1).hitY := pictures (7, i, 2).hitY
end for
    
% Tatsumaki
for i : 1 .. 13
    pictures (8, i, 2).pic := Pic.FileNew ("Ken/tatsumaki" + intstr (i) + ".jpeg")
    pictures (8, i, 2).hitX := FILLER_VARIABLE
    pictures (8, i, 2).hitY := FILLER_VARIABLE
    pictures (8, i, 1).pic := Pic.Mirror (pictures (8, i, 2).pic)
    pictures (8, i, 1).hitX := 70 - pictures (8, i, 2).hitX
    pictures (8, i, 1).hitY := pictures (8, i, 2).hitY
end for
    
% Hadoken
for i : 1 .. 4
    pictures (9, i, 2).pic := Pic.FileNew ("Ken/hadoken" + intstr (i) + ".jpeg")
    pictures (9, i, 2).hitX := FILLER_VARIABLE
    pictures (9, i, 2).hitY := FILLER_VARIABLE
    pictures (9, i, 1).pic := Pic.Mirror (pictures (9, i, 2).pic)
    pictures (9, i, 1).hitX := 70 - pictures (9, i, 2).hitX
    pictures (9, i, 1).hitY := pictures (9, i, 2).hitY
end for
    
% Shoryuken
for i : 1 .. 7
    pictures (10, i, 2).pic := Pic.FileNew ("Ken/shoryuken" + intstr (i) + ".jpeg")
    pictures (10, i, 2).hitX := FILLER_VARIABLE
    pictures (10, i, 2).hitY := FILLER_VARIABLE
    pictures (10, i, 1).pic := Pic.Mirror (pictures (10, i, 2).pic)
    pictures (10, i, 1).hitX := 70 - pictures (10, i, 2).hitX
    pictures (10, i, 1).hitY := pictures (10, i, 2).hitY
end for
    
%NOTE HERE'S HOW CHARACTER MOVEMENT WORKS: character has a destination: this is the point his center is moving towards. moving the character with
%the keyboard changes the destination, and he moves towards it with his movement speed
%represents a character in the game
class Character
    
    import PlayerStatusDisplay, platX1, platX2, platY, FILLER_VARIABLE, Ability, pictures
    
    export var x, var y, var xDestination, var yDestination, var h, var w, var damage, var charType, update, getHit %exported variables
    
    %Character attributes
    var charType : int  %which character does this class represent?
    var lives : int := 5 %how many lives does this character have?
    var damage : int %how much damage has the character taken? (damage determines how much the character flies)
    var hitDamage : int %how much damage does this character deal?
    var x, y : real %coordinates of CENTER of character IN THE WORLD
    var h, w : int %current height and width of character
    var dir : int %the way the character is facing - 1 indicates left, 2 indicates right
    var kbDistance : int := 700 %base distance character gets knocked back
    var knockedBack := false %is player traveling because he got knocked back?
    var actionLock := false % is the player currently performing an action that can't be switched until its finished?
    var canDoAction := true % can the player perform an ability?
    var doingAction := false % is the player already performing an action?
    var canJump := true %can player jump?
    var jumping := false %is player jumping
    var atDestination := true %is player at his destination
    var moveStuff : array 1..10 of Ability %player moves at 1/moveStuff(i) of the distance between him and destination every update
    var hitX, hitY : int %point relative to bottom left of character that can hit the other player
    var hitBoxX1, hitBoxX2, hitBoxY1, hitBoxY2 : int
    moveStuff(1).speed := 1
    moveStuff(1).xIncrement := 0
    moveStuff(1).yIncrement := 0
    moveStuff(1).frames := 4
    moveStuff(2).speed := 1
    moveStuff(2).xIncrement :=10
    moveStuff(2).yIncrement :=0
    moveStuff(2).frames :=5
    moveStuff(3).speed := 1
    moveStuff(3).xIncrement :=4
    moveStuff(3).yIncrement :=0
    moveStuff(3).frames :=1
    moveStuff(4).speed := 15
    moveStuff(4).xIncrement :=0
    moveStuff(4).yIncrement :=200
    moveStuff(4).frames :=7
    moveStuff(5).speed := 10
    moveStuff(5).xIncrement :=0
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
    moveStuff(8).speed := 17
    moveStuff(8).xIncrement :=20
    moveStuff(8).yIncrement :=140
    moveStuff(8).frames :=13
    moveStuff(9).speed := 1
    moveStuff(9).xIncrement :=10
    moveStuff(9).yIncrement :=0
    moveStuff(9).frames :=4
    moveStuff(10).speed := 14
    moveStuff(10).xIncrement :=0
    moveStuff(10).yIncrement :=170
    moveStuff(10).frames :=7
    
    var fallSpeed : int := 2
    
    var isHit := false %did the character get hit?
    
    %different skills deal different amounts of damage
    var upOD, downOD, sideOD, upPD, downPD, sidePD : int
    
    %status display stuff
    var pSD : pointer to PlayerStatusDisplay
    %^(pSD)._init(lives)
    
    %Character abilities stuff
    var ability : int := 1%current ability player is performing
    var frameNums : int %number of frames an ability lasts for
    var abilXIncr : int %how much does the character move horizontally each frame during the ability?
    var abilYIncr : int %same for vertically
    
    %Character movement stuff
    var xDir := 0  %-1 indicates to the left, 0 indicates stopped, 1 indicates to the right
    var yDir := 0  %-1 indicates down, " , 1 indicates up
    
    var xDestination, yDestination : int %coordinates of where character is moving towards
    var bounceX, bounceY : int %coords of where character will bounce (if character is hit towards ground)
    var bounces := false %does the character bounce?
    
    %Character picture stuff
    var bodyPic, bodyFPic : int
    
    %initialize damages
    proc initDamage (uO, dO, sO, uP, dP, sP : int)
	upOD := uO
	downOD := dO
	sideOD := sO
	upPD := uP
	downPD := dP
	sidePD := sP
    end initDamage
    
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
    
    proc knockBack (cX, cY, pX, pY : int) %cX,cY is center of other player, pX, pY is where character was hit
	var kbD : real := kbDistance * damage / 100 %distance character gets knocked back
	%calculate new destination
	%ABRUPT CHANGE OF DIRECTION VERSION
	xDestination := round (x + (pX - cX) * kbD / sqrt ((pX - cX) ** 2 + (pY - cY) ** 2))
	yDestination := round (y + (pY - cY) * kbD / sqrt ((pX - cX) ** 2 + (pY - cY) ** 2))
	%KEEPS MOMENTUM VERSION
	%xDestination += (pX-cX)*kbD/sqrt( (pX-cX)**2 + (pY-cY)**2)
	%yDestination += (pY-cY)*kbD/sqrt( (pX-cX)**2 + (pY-cY)**2)
	
	%check if character bounces
	if xDestination > platX1 and xDestination < platX2 and yDestination < platY then
	    %character bounces
	    bounces := true
	    bounceX := xDestination
	    bounceY := platY + (platY - yDestination)
	end if
    end knockBack
    
    %did current character get hit?
    proc getHit(hX,hY:int)
	
    end getHit
    
    proc update (instructions : string, oP:pointer to Character)
	var moveSpeed := moveStuff(ability)
	if not actionLock then
	    if (instructions (1) = "2") then
		xDestination += moveSpeeds(ability).xIncrement
		if instructions(2) = "1" then
		    ability := 3
		else
		    ability := 2
		end if
		doingAction := true
		dir := 2
	    end if
	    if (instructions (1) = "1") then
		xDestination -= moveSpeeds(ability).xIncrement
		if instructions(2) = "1" then
		    ability := 3
		else
		    ability := 2
		end if
		doingAction := true
		dir := 1
	    end if
	    if (instructions (2) = "1") then
		yDestination -= 10
		ability := 3
		doingAction := true
	    end if
	    if (instructions (2) = "2") then
		if not actionLock and canJump then
		    ability := 4
		    canJump := false  %can't jump after jumping once
		    doingAction := true
		    jumping := true
		end if
	    end if
	end if
	
	if doingAction = false then
	    ability := 1
	    
	elsif doingAction = true and actionLock = false then
	    if instructions (4) = "q" then
		if instructions (3) = "0" then
		    ability := 6
		    xDestination += moveStuff(ability).xIncrement
		    yDestination += moveStuff(ability).yIncrement
		    %actionLock := true
		elsif instructions (3) = "1" then
		    ability := 9
		    xDestination -= moveStuff(ability).xIncrement
		    yDestination += moveStuff(ability).yIncrement
		    %actionLock := true
		elsif instructions (3) = "2" then
		    ability := 9
		    xDestination += moveStuff(ability).xIncrement
		    yDestination += moveStuff(ability).yIncrement
		    %actionLock := true
		elsif instructions (3) = "4" then
		    ability := 10
		    xDestination += moveStuff(ability).xIncrement
		    yDestination += moveStuff(ability).yIncrement
		    %actionLock := true
		end if
	    end if
	    
	    if instructions (4) = "w" then
		if instructions (3) = "0" then
		    ability := 7
		    xDestination += moveStuff(ability).xIncrement
		    yDestination += moveStuff(ability).yIncrement
		    %actionLock := true
		elsif instructions (3) = "1" then
		    ability := 5
		    xDestination -= moveStuff(ability).xIncrement
		    yDestination += moveStuff(ability).yIncrement
		    %actionLock := true
		elsif instructions (3) = "2" then
		    ability := 5
		    xDestination += moveStuff(ability).xIncrement
		    yDestination += moveStuff(ability).yIncrement
		    %actionLock := true
		elsif instructions (3) = "4" then
		    ability := 8
		    xDestination += moveStuff(ability).xIncrement
		    yDestination += moveStuff(ability).yIncrement
		    %actionLock := true
		end if
	    end if
	end if
	
	%see if player hit other player
	%^(oP).getHit(round(x+hitX),round(y+hitY))
	
	%move x and y towards xDestination and yDestination
	%character moves differently when he is knocked back than when he is just moving
	if knockedBack then
	    x += 1/20*(xDestination-x)
	    y += 1/20*(yDestination-y)
	    %if character is knocked into the ground, he bounces
	    if bounces then
		if x > platX1 and x < platX2 and y < platY then
		    xDestination := bounceX
		    yDestination := bounceY
		    bounces := false
		end if
	    end if
	else
	    x += 1/moveStuff(ability).speed*(xDestination-x)
	    y += 1/moveStuff(ability).speed*(yDestination-y)
	    
	    %If player isn't performing an uninteruptable action, he falls if he isn't on the ground
	    if not actionLock and not jumping then
		if x > platX1 and x < platX2 then
		    if y > platY then
			y -= fallSpeed
			yDestination -= fallSpeed
		    else
			%player is on the ground
			canJump := true
			jumping := false
			canDoAction := true
			y := platY
		    end if
		else
		    y -= fallSpeed
		    yDestination -= fallSpeed
		end if
	    end if
	end if
	
	%check to see if player was hit by other player
	
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
^ (player2).x := 1318
^ (player2).xDestination := 1318
^ (player2).y := 365
^ (player2).yDestination := 365
^ (player2).h := 2
^ (player2).w := 2

%--------------------PLAYER STATUS DISPLAYS------------------------%
var pSD1, pSD2 : pointer to PlayerStatusDisplay
new PlayerStatusDisplay, pSD1
new PlayerStatusDisplay, pSD2



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
var instructions1, instructions2 : string := "00n" %instructions sent by client
var picStuff1, picStuff2 : string

loop

    %INSTRUCTIONS: FIRST DIGIT IS EITHER 1,0,or 2, indicating left, no, or right arrow was pressed
    %SECOND DIGIT is similar for down, no, or up arrow pressed
    loop
	if Net.LineAvailable (stream1) and Net.LineAvailable (stream2) then
	    
	    %update player 1's stuff
	    get : stream1, instructions1
	    
	    
	    
	    %update player 2's stuff
	    get : stream2, instructions2
	    
	    updateScreen
	    
	else
	    put instructions1
	    put instructions2
	    picStuff1 := ^ (player1).update (instructions1,player2)
	    picStuff2 := ^ (player2).update (instructions2,player1)
	    %send player info back
	    %PLAYER INFO FORM:
	    %PLAYER.X PLAYER.Y OTHERPLAYER.X OTHERPLAYER.Y
	    
	    put : stream1, intstr (round ( ^ (player1).x)) + " " + intstr (round ( ^ (player1).y)) + " " + intstr (round ( ^ (player2).x)) + " " + intstr (round ( ^ (player2).y))+ " "+picStuff1
	    put : stream2, intstr (round ( ^ (player2).x)) + " " + intstr (round ( ^ (player2).y)) + " " + intstr (round ( ^ (player1).x)) + " " + intstr (round ( ^ (player1).y))+ " "+picStuff2
	    
	    %put intstr (round ( ^ (player1).x)) + " " + intstr (round ( ^ (player1).y)) + " " + intstr (round ( ^ (player2).x)) + " " + intstr (round ( ^ (player2).y))
	    %put intstr (round ( ^ (player2).x)) + " " + intstr (round ( ^ (player2).y)) + " " + intstr (round ( ^ (player1).x)) + " " + intstr (round ( ^ (player1).y))
	    
	    exit
	end if
    end loop
    
end loop

%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                                   END GAME SCREEN                                                         %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%










