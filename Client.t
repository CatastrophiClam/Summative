%Super Crash Pros Client--------------------------------> By: Bowen and Max

View.Set("graphics:max;max,position:center;center")

%NOTES
% 1). IMPORTANT: 0,0 IS THE BOTTOM LEFT POINT OF THE WORLD
% 2). Any coordinates that are "IN THE WORLD" must be converted to on-screen coordinates before being displayed

const FILLER_VARIABLE := 2 %if you see this, it means theres some value we haven't decided on yet and we need it declared for the program to run

%---------------------------------WORLD STUFF-----------------------------------%

var worldLength, worldHeight : int  %actual width and height of world
worldLength := 1920%3840
worldHeight := 1080%2160

%platform
var platY := 717
var platX1 := 465
var platX2 := 1418

%character type
type Character:
    record

        x:int
        y:int
        h:int
        w:int
        pic:int
        sprite:int
    end record

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
    spritePic := Pic.New(offScreenX,offScreenY,offScreenX+150,offScreenY+250)
    picSprite := Sprite.New(spritePic)
    
    proc _init(lives:int)
	numLives := lives
    end _init
    
    proc updatePic()
    
    end updatePic
    
    proc display()
    
    end display
    
end PlayerStatusDisplay

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

var chars, charsLast : array char of boolean 

%--------------------------------NETWORK STUFF----------------------------------%
var netStream : int
var serverAddress : string := "10.174.28.204"
var serverPort : int
var playerNum : int

%---------------------------------SCREEN STUFF----------------------------------%

var screenX, screenY : int %location of BOTTOM LEFT of screen IN THE WORLD

%------------------BACKGROUND------------------%

%original picture of bacground
var backgroundPic : int
backgroundPic := Pic.FileNew("Background.jpg")
var backgroundSprite : int
backgroundSprite := Sprite.New(backgroundPic)

%---------------------------------PLAYER STUFF----------------------------------%

%---------------------PLAYER PICTURES--------------------%

%THE FIRST INDEX OF PICTURES IS THE MOVE TYPE:
%1 - idle  2 - move  3 - kneel  4 - jump  5 - roundhouse  6 - punch  7 - kick  8 - tatsumaki  9 - hadoken  10 - shoryuken
%THE SECOND INDEX OF PICTURES IS THE FRAME WITHIN THE MOVE
%THE THIRD INDEX OF PICTURES IS THE SIDE PLAYER IS FACING: 1 - left  2 - right
var pictures : array 1..10,1..13,1..2 of int

% Idle
for i : 1 .. 4
    pictures (1,i,2) := Pic.FileNew ("idle" + intstr(i) + ".jpeg")
    pictures (1,i,1) := Pic.Mirror (kenIdleR (i))
end for

% Move
for i : 1 .. 5
    pictures (2,i,2) := Pic.FileNew ("move" + intstr(i) + ".jpeg")
    pictures (2,i,1) := Pic.Mirror (kenMoveL (i))
end for

% Kneel
pictures(3,1,2) := Pic.FileNew ("kneel.jpeg")
pictures(3,1,1) := Pic.Mirror (kenKneelL)

% Jump
for i : 1 .. 7
    pictures (4,i,2) := Pic.FileNew ("move" + intstr(i) + ".jpeg")
    pictures (4,i,1) := Pic.Mirror (kenMoveR (i))
end for

% Roundhouse
for i : 1 .. 5
    pictures (5,i,2) := Pic.FileNew ("roundhouse" + intstr(i) + ".jpeg")
    pictures (5,i,1) := Pic.Mirror (kenRoundhouseR (i))
end for
    
%Punch
for i : 1 .. 3
    pictures (6,i,2) := Pic.FileNew ("punch" + intstr(i) + ".jpeg")
    pictures (7,i,1) := Pic.Mirror (kenPunchR (i))
end for
    
% Kick
for i : 1 .. 5
    pictures (7,i,2) := Pic.FileNew ("kick" + intstr(i) + ".jpeg")
    pictures (7,i,1) := Pic.Mirror (kenKickL (i))
end for
    
% Tatsumaki
for i : 1 .. 13
    pictures (8,i,2) := Pic.FileNew ("tatsumaki" + intstr(i) + ".jpeg")
    pictures (8,i,1) := Pic.Mirror (kenTatsumakiL (i))
end for
    
% Hadoken
for i : 1 .. 4
    pictures (9,i,2) := Pic.FileNew ("hadoken" + intstr(i) + ".jpeg")
    pictures (9,i,1) := Pic.Mirror (kenHadokenL (i))
end for
    
% Shoryuken
for i : 1 .. 7    
    pictures (10,i,2) := Pic.FileNew ("shoryuken" + intstr(i) + ".jpeg")
    pictures (10,i,1) := Pic.Mirror (kenShoryukenL (i))
end for

var selfPlayer, otherPlayer : Character

var animationCounter : int

%--------------------PLAYER STATUS DISPLAYS------------------------%
var pSD1, pSD2 : pointer to PlayerStatusDisplay
new PlayerStatusDisplay,pSD1
new PlayerStatusDisplay,pSD2



%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                                  END VARIABLES                                                            %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%


%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                                  NETWORK STUFF                                                            %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%

put "Enter player number: "
get playerNum
if playerNum = 1 then
    serverPort := 5600
    selfPlayer.x := 565
    selfPlayer.y := 365
    selfPlayer.h := 2
    selfPlayer.w := 2
    otherPlayer.x := 1318
    otherPlayer.y := 365
    otherPlayer.h := 2
    otherPlayer.w := 2
else
    serverPort := 5605
    otherPlayer.x := 565
    otherPlayer.y := 365
    otherPlayer.h := 2
    otherPlayer.w := 2
    selfPlayer.x := 1318
    selfPlayer.y := 365
    selfPlayer.h := 2
    selfPlayer.w := 2
end if
netStream := Net.OpenConnection(serverAddress,serverPort)
if not netStream <= 0 then
    put "connected"
else
    put "not connected"
end if

%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                                END NETWORK STUFF                                                          %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%


%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                               FUNCTIONS AND PROCESSES                                                     %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%

%updates size of background and draws it
procedure updateBackground
    
    Sprite.Animate(backgroundSprite, backgroundPic, round(0-screenX), round(0-screenY), false)
    Sprite.Show(backgroundSprite)
end updateBackground

%updates size and position of screen
procedure updateScreen
    var leftMost, rightMost, topMost, bottomMost : int %screen should encompass these points with a 60 px margin
    
    %find leftMost and rightMost
    if selfPlayer.x < otherPlayer.x then
	%if player 1 is to the left of player 2 and inside the world boundaries
	if selfPlayer.x - selfPlayer.w/2 > 0 then
	    %player 1's x is leftmost
	    leftMost := round(selfPlayer.x-selfPlayer.w/2)
	else
	    leftMost := 0
	end if
	
	%This means that player 2 is to the right of player 1
	if otherPlayer.x + otherPlayer.w/2 < worldLength then
	    %player 2's x is rightmost
	    rightMost := round(otherPlayer.x + otherPlayer.w/2)
	else
	    rightMost := worldLength
	end if
    else
	%player 2 is to the left of player 1
	if otherPlayer.x - otherPlayer.w/2 > 0 then
	    %player 1's x is leftmost
	    leftMost := round(otherPlayer.x-otherPlayer.w/2)
	else
	    leftMost := 0
	end if
	
	%This means that player 1 is to the right of player 2
	if selfPlayer.x + selfPlayer.w/2 < worldLength then
	    %player 1's x is leftmost
	    rightMost := round(selfPlayer.x + selfPlayer.w/2)
	else
	    rightMost := worldLength
	end if
    end if
    
    %find topmost and bottomMost
    if selfPlayer.y < otherPlayer.y then
	%if player 1 is under player 2 and inside the world boundaries
	if selfPlayer.y - selfPlayer.h/2 > 0 then
	    %player 1's y is bottommost
	    bottomMost := round(selfPlayer.y-selfPlayer.h/2)
	else
	    bottomMost := 0
	end if
	
	%This means that player 2 above player 1
	if otherPlayer.y + otherPlayer.h/2 < worldHeight then
	    %player 1's x is topmost
	    topMost := round(otherPlayer.y + otherPlayer.h/2)
	else
	    topMost := worldHeight
	end if
    else
	%if player 2 is under player 1 and inside the world boundaries
	if otherPlayer.y - otherPlayer.h/2 > 0 then
	    %player 1's y is bottommost
	    bottomMost := round(otherPlayer.y-otherPlayer.h/2)
	else
	    bottomMost := 0
	end if
	
	%This means that player 1 above player 2
	if selfPlayer.y + selfPlayer.h/2 < worldHeight then
	    %player 1's x is topmost
	    topMost := round(selfPlayer.y + selfPlayer.h/2)
	else
	    topMost := worldHeight
	end if
    end if
    
    
    %update screenX and screenY
    screenX := round((rightMost+leftMost)/2-maxx/2)
    if screenX < 0 then 
	screenX := 0
    end if
    if screenX > worldLength-maxx then
	screenX := worldLength - maxx
    end if
    
    screenY := round((bottomMost+topMost)/2-maxy/2)
    if screenY < 0 then
	screenY := 0
    end if
    if screenY > worldHeight - maxy then
	screenY := worldHeight - maxy
    end if
    
end updateScreen

function split(str:string, regex:string):array 1..4 of string
    var a : array 1..4 of string
    var pastSpace := 0
    var count := 0
    for i:1..length(str)+1
	if i = length(str)+1 or str(i) = " " then
	    count += 1
	    a(count) := str(pastSpace+1..i-1)
	    pastSpace := i
	end if
    end for
    result a
end split

%For keypress detection

function KeyPushedDown (c : char) : boolean
    result not charsLast (c) and chars (c)
end KeyPushedDown

function KeyReleased (c : char) : boolean
    result not chars (c) and charsLast(c)
end KeyReleased

function KeyHeldDown (c : char) : boolean
    result charsLast (c) and chars (c)
end KeyHeldDown

%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                             END FUNCTIONS AND PROCESSES                                                   %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%


%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                                   TITLE SCREEN                                                            %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%



%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                                 END TITLE SCREEN                                                          %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%

%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                                    GAME SCREEN                                                            %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%
var instructions, positions:string
var toDoArray : array 1..4 of string

%Initialize

Input.KeyDown (charsLast)
Input.KeyDown (chars)

loop
    instructions := ""
    charsLast := chars
    Input.KeyDown(chars)
    updateScreen
    
    if (chars(KEY_LEFT_ARROW)) then
	instructions += "1"
    elsif (chars(KEY_RIGHT_ARROW)) then
	instructions += "2"
    else
	instructions += "0"
    end if
    
    if (chars(KEY_UP_ARROW)) then
	instructions += "2"
    elsif (chars(KEY_DOWN_ARROW)) then
	instructions += "1"
    else
	instructions += "0"
    end if
    
    put:netStream,instructions
    
	if Net.LineAvailable(netStream) then
	    get:netStream, positions:*
	    toDoArray := split(positions," ")
	    Draw.FillOval(strint(toDoArray(1))+screenX,strint(toDoArray(2))+screenY,5,5,black)
	    Draw.FillOval(strint(toDoArray(3))+screenX,strint(toDoArray(4))+screenY,5,5,black)
	end if
    
    updateBackground
    
    delay(5)
end loop

%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                                   END GAME SCREEN                                                         %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%






