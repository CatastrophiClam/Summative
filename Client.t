%Super Crash Pros Client--------------------------------> By: Bowen and Max

View.Set ("graphics:max;max,position:center;center")

%NOTES
% 1). IMPORTANT: 0,0 IS THE BOTTOM LEFT POINT OF THE WORLD
% 2). Any coordinates that are "IN THE WORLD" must be converted to on-screen coordinates before being displayed

const FILLER_VARIABLE := 2 %if you see this, it means theres some value we haven't decided on yet and we need it declared for the program to run

%---------------------------------WORLD/GLOBAL STUFF-----------------------------------%

var worldLength, worldHeight : int  %actual width and height of world
worldLength := 1920 %3840
worldHeight := 1080 %2160

%platform
var platY := 717
var platX1 := 465
var platX2 := 1418

%character type
type Character :
    record

	x : int
	y : int
	h : int
	w : int
	pic : int
	sprite : int
    end record

%mouse buttons
var x, y, button : int


%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                                    VARIABLES                                                              %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%

var chars, charsLast : array char of boolean
var startStr : string  %prompt by server to start
var endGame := false %should we stop the program?

%Timer stuff
var gameTime := 0 %time passed
var timeString := ""  %display time
var font : int
font := Font.New ("Arial:20")

var font1 : int
font1 := Font.New ("sans serif:100")

%--------------------------------NETWORK STUFF----------------------------------%
var netStream : int
var serverAddress : string := "10.174.28.204"%"192.168.5.60"
var serverPort : int
var playerNum : int

%---------------------------------SCREEN STUFF----------------------------------%

var screenX, screenY : int %location of BOTTOM LEFT of screen IN THE WORLD

%------------------BACKGROUND------------------%

%original picture of bacground
var backgroundPic : int
backgroundPic := Pic.FileNew ("Background.jpg")
var backgroundSprite : int
backgroundSprite := Sprite.New (backgroundPic)

%----------------SOUNDS STUFF-------------------%
var buttonSound := "Sounds/Button.mp3"
var gruntSound := "Sounds/Grunt.mp3"
var fightMusic := "Sounds/FightMusic.mp3"
var youWin := "Win_Sound_Effect.mp3"
var youLose := "Lose_Sound_Effect.mp3"


%---------------------------------PLAYER STUFF----------------------------------%

%---------------------PLAYER PICTURES--------------------%

%THE FIRST INDEX OF PICTURES IS THE MOVE TYPE:
%1 - idle  2 - move  3 - kneel  4 - jump  5 - roundhouse  6 - punch  7 - kick  8 - tatsumaki  9 - hadoken  10 - shoryuken
%THE SECOND INDEX OF PICTURES IS THE FRAME WITHIN THE MOVE
%THE THIRD INDEX OF PICTURES IS THE SIDE PLAYER IS FACING: 1 - left  2 - right

var pictures : array 1 .. 10, 1 .. 13, 1 .. 2 of int

% Idle
for i : 1 .. 4
    pictures (1, i, 2) := Pic.FileNew ("Ken/Idle" + intstr (i) + ".gif")
    pictures (1, i, 1) := Pic.Mirror (pictures (1, i, 2))
end for

% Move
for i : 1 .. 5
    pictures (2, i, 2) := Pic.FileNew ("Ken/Walk" + intstr (i) + ".gif")
    pictures (2, i, 1) := Pic.Mirror (pictures (2, i, 2))
end for

% Kneel
pictures (3, 1, 2) := Pic.FileNew ("Ken/Crouch1.gif")
pictures (3, 1, 1) := Pic.Mirror (pictures (3, 1, 2))

% Jump
for i : 1 .. 7
    pictures (4, i, 2) := Pic.FileNew ("Ken/Jump" + intstr (i) + ".gif")
    pictures (4, i, 1) := Pic.Mirror (pictures (4, i, 2))
end for

% Roundhouse - side kick
for i : 1 .. 5
    pictures (5, i, 2) := Pic.FileNew ("Ken/HardKick" + intstr (i) + ".gif")
    pictures (5, i, 1) := Pic.Mirror (pictures (5, i, 2))
end for

%Punch - punch
for i : 1 .. 3
    pictures (6, i, 2) := Pic.FileNew ("Ken/LightPunch" + intstr (i) + ".gif")
    pictures (6, i, 1) := Pic.Mirror (pictures (6, i, 2))
end for

% Kick - kick
for i : 1 .. 5
    pictures (7, i, 2) := Pic.FileNew ("Ken/LightMediumKick" + intstr (i) + ".gif")
    pictures (7, i, 1) := Pic.Mirror (pictures (7, i, 2))
end for

% Tatsumaki  - up kick
for i : 1 .. 13
    pictures (8, i, 2) := Pic.FileNew ("Ken/Tatsumaki" + intstr (i) + ".gif")
    pictures (8, i, 1) := Pic.Mirror (pictures (8, i, 2))
end for

% Hadoken - side punch
for i : 1 .. 4
    pictures (9, i, 2) := Pic.FileNew ("Ken/Hadoken" + intstr (i) + ".gif")
    pictures (9, i, 1) := Pic.Mirror (pictures (9, i, 2))
end for

% Shoryuken - up punch
for i : 1 .. 7
    pictures (10, i, 2) := Pic.FileNew ("Ken/FieryShoryuken" + intstr (i) + ".gif")
    pictures (10, i, 1) := Pic.Mirror (pictures (10, i, 2))
end for

var selfPlayer, otherPlayer : Character

var animationCounter : int

%--------------------PLAYER STATUS DISPLAYS------------------------%

var numLives1 : int
var numLives2 : int
var damage1 : int
var damage2 : int
var damageString1 := "" %display players damage
var damageString2 := "" %display opponents damage

var livesPic1, livesPic2 : array 1 .. 5 of int
for i : 1 .. 5
    livesPic1 (i) := Pic.FileNew ("Pictures/Lives" + intstr (i) + ".gif")
    livesPic2 (i) := Pic.Mirror (livesPic1(i))
end for

var percentSymbol : int
percentSymbol := Pic.FileNew ("Pictures/PercentSign.gif")

var youText : int
youText := Pic.FileNew ("Pictures/you.gif")

var challengerText : int
challengerText := Pic.FileNew ("Pictures/challenger.gif")

var youIndicator : int
youIndicator := Sprite.New (youText)
var challengerIndicator : int
challengerIndicator := Sprite.New (challengerText)

var percentText1, percentText2 : int
percentText1 := Sprite.New (percentSymbol)
percentText2 := Sprite.New (percentSymbol)

var kenPortrait1, kenPortrait2 : int
kenPortrait1 := Pic.FileNew ("Ken/KenPortrait.gif")
kenPortrait2 := Pic.Mirror (kenPortrait1)

var lifeIndicator1, lifeIndicator2 : int
lifeIndicator1 := Sprite.New (livesPic1 (5))
lifeIndicator2 := Sprite.New (livesPic2 (5))

var portrait1, portrait2 : int
portrait1 := Sprite.New (kenPortrait1)
portrait2 := Sprite.New (kenPortrait2)

%--------------------END SCREEN DISPLAY------------------------%

var winner : int %the winner
var playAgain : boolean %are we playing again?

%--------------------------MORE PICTURES---------------------------%
var youLosePic : int
youLosePic := Pic.FileNew ("Pictures/YouLose.bmp")
Pic.SetTransparentColor (youLosePic, 0)
var youWinPic : int

youWinPic := Pic.FileNew ("Pictures/YouWin.bmp")
Pic.SetTransparentColor (youWinPic, 0)

var playNowPic : int
playNowPic := Pic.FileNew ("Pictures/playNow.bmp")
var playAgainPic : int
playAgainPic := Pic.FileNew ("Pictures/playAgain.bmp")
Pic.SetTransparentColor (playAgainPic, 0)
var exitPic : int
exitPic := Pic.FileNew ("Pictures/Exit.bmp")
Pic.SetTransparentColor (exitPic, 0)


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
    selfPlayer.sprite := Sprite.New (pictures (1, 1, 2))
    otherPlayer.x := 1318
    otherPlayer.y := 365
    otherPlayer.h := 2
    otherPlayer.w := 2
    otherPlayer.sprite := Sprite.New (pictures (1, 1, 1))
else
    serverPort := 5605
    otherPlayer.x := 565
    otherPlayer.y := 365
    otherPlayer.h := 2
    otherPlayer.w := 2
    otherPlayer.sprite := Sprite.New (pictures (1, 1, 2))
    selfPlayer.x := 1318
    selfPlayer.y := 365
    selfPlayer.h := 2
    selfPlayer.w := 2
    selfPlayer.sprite := Sprite.New (pictures (1, 1, 1))
end if
netStream := Net.OpenConnection (serverAddress, serverPort)
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
%                                               FUNCTIONS AND PROCEDURES                                                    %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%

%updates size of background and draws it
procedure updateBackground

    Sprite.Animate (backgroundSprite, backgroundPic, round (0 - screenX), round (0 - screenY), false)
    Sprite.Show (backgroundSprite)
end updateBackground

%updates size and position of screen
procedure updateScreen
    var leftMost, rightMost, topMost, bottomMost : int %screen should encompass these points with a 60 px margin

    %find leftMost and rightMost
    if selfPlayer.x < otherPlayer.x then
	%if player 1 is to the left of player 2 and inside the world boundaries
	if selfPlayer.x - selfPlayer.w / 2 > 0 then
	    %player 1's x is leftmost
	    leftMost := round (selfPlayer.x - selfPlayer.w / 2)
	else
	    leftMost := 0
	end if

	%This means that player 2 is to the right of player 1
	if otherPlayer.x + otherPlayer.w / 2 < worldLength then
	    %player 2's x is rightmost
	    rightMost := round (otherPlayer.x + otherPlayer.w / 2)
	else
	    rightMost := worldLength
	end if
    else
	%player 2 is to the left of player 1
	if otherPlayer.x - otherPlayer.w / 2 > 0 then
	    %player 1's x is leftmost
	    leftMost := round (otherPlayer.x - otherPlayer.w / 2)
	else
	    leftMost := 0
	end if

	%This means that player 1 is to the right of player 2
	if selfPlayer.x + selfPlayer.w / 2 < worldLength then
	    %player 1's x is leftmost
	    rightMost := round (selfPlayer.x + selfPlayer.w / 2)
	else
	    rightMost := worldLength
	end if
    end if

    %find topmost and bottomMost
    if selfPlayer.y < otherPlayer.y then
	%if player 1 is under player 2 and inside the world boundaries
	if selfPlayer.y - selfPlayer.h / 2 > 0 then
	    %player 1's y is bottommost
	    bottomMost := round (selfPlayer.y - selfPlayer.h / 2)
	else
	    bottomMost := 0
	end if

	%This means that player 2 above player 1
	if otherPlayer.y + otherPlayer.h / 2 < worldHeight then
	    %player 1's x is topmost
	    topMost := round (otherPlayer.y + otherPlayer.h / 2)
	else
	    topMost := worldHeight
	end if
    else
	%if player 2 is under player 1 and inside the world boundaries
	if otherPlayer.y - otherPlayer.h / 2 > 0 then
	    %player 1's y is bottommost
	    bottomMost := round (otherPlayer.y - otherPlayer.h / 2)
	else
	    bottomMost := 0
	end if

	%This means that player 1 above player 2
	if selfPlayer.y + selfPlayer.h / 2 < worldHeight then
	    %player 1's x is topmost
	    topMost := round (selfPlayer.y + selfPlayer.h / 2)
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

end updateScreen

function split (str : string, regex : string) : array 1 .. 15 of string
    var a : array 1 .. 15 of string
    var pastSpace := 0
    var count := 0

    for i : 1 .. length (str) + 1

	if i = length (str) + 1 or str (i) = regex then

	    count += 1
	    a (count) := str (pastSpace + 1 .. i - 1)
	    pastSpace := i
	end if
    end for
    result a
end split

procedure playEndScreen
    %init sprites
    var winDisplay : int
    var chosenWinPic : int
    var playAgainButton : int
    var exitButton : int
    %choose which winning picture to display
    if winner = playerNum then
	chosenWinPic := youWinPic
    else
	chosenWinPic := youLosePic
    end if
    %make sprites
    winDisplay := Sprite.New (chosenWinPic)
    playAgainButton := Sprite.New (playAgainPic)
    exitButton := Sprite.New (exitPic)
    %show stuff

    Sprite.Animate (winDisplay, chosenWinPic, round (maxx / 2 - Pic.Width (chosenWinPic) / 2), round (maxy / 2), false)
    Sprite.Animate (playAgainButton, playAgainPic, round (maxx / 4 - Pic.Width (playAgainPic) / 2), round (maxy / 4 - Pic.Height (playAgainPic) / 2), false)
    Sprite.Animate (exitButton, exitPic, round (3 * maxx / 4 - Pic.Width (exitPic) / 2), round (maxy / 4 - Pic.Height (exitPic) / 2), false)
    Sprite.Show (winDisplay)
    Sprite.Show (playAgainButton)
    Sprite.Show (exitButton)
    loop
	%wait for player to choose option
	Mouse.Where (x, y, button)
	if button = 1 then
	    %play again is clicked
	    if x > round (maxx / 4 - Pic.Width (playAgainPic) / 2) and x < maxx / 4 + Pic.Width (playAgainPic) / 2 and y > round (maxy / 4 - Pic.Height (playAgainPic) / 2) and y < round (maxy / 4 - 
		Pic.Height (playAgainPic) / 2) + Pic.Height (playAgainPic) then
		playAgain := true
		exit
		%exit is clicked
	    elsif x > round (3 * maxx / 4 - Pic.Width (exitPic) / 2) and x < round (3 * maxx / 4 + Pic.Width (exitPic) / 2) and y > round (maxy / 4 - Pic.Height (exitPic) / 2) and y < round (maxy / 4 
		+ Pic.Height (exitPic) / 2) then
		playAgain := false
		exit
	    end if
	end if
    end loop
    Sprite.Hide (winDisplay)
    Sprite.Hide (playAgainButton)
    Sprite.Hide (exitButton)

end playEndScreen

procedure displayTime

    var minutes := floor (gameTime / 60)
    var seconds := gameTime mod 60
    timeString := intstr (minutes) + ":" + intstr (seconds)
    Font.Draw (timeString, round (maxx / 2) - Font.Width (timeString, font), maxy - 40, font, black)
end displayTime

proc displayStatus

    damageString1 := intstr (damage1)
    damageString2 := intstr (damage2)

    Font.Draw (damageString1, Pic.Width (kenPortrait1), 60, font1, black)
    Font.Draw (damageString2, maxx - Pic.Width (kenPortrait2) - Font.Width (damageString2, font1) - Pic.Width (percentSymbol), 60, font1, black)
    
    Sprite.Animate (youIndicator, youText, Pic.Width (kenPortrait1), 0, false)
    Sprite.Animate (challengerIndicator, challengerText, maxx - Pic.Width (kenPortrait2) - Pic.Width (challengerText), 0, false)
    
    Sprite.Animate (percentText1, percentSymbol, Pic.Width (kenPortrait1) + Font.Width (damageString1, font1), 60, false)
    Sprite.Animate (percentText2, percentSymbol, maxx - Pic.Width (kenPortrait2) - Pic.Width (percentSymbol), 60, false)

    Sprite.Animate (lifeIndicator1, livesPic1 (numLives1), Pic.Width (kenPortrait1), Pic.Height (kenPortrait1) - 50, false)
    Sprite.Animate (lifeIndicator2, livesPic2 (numLives2), maxx - Pic.Width (kenPortrait2) - Pic.Width (livesPic2 (numLives2)), Pic.Height (kenPortrait1) - 50, false)
    
    Sprite.Animate (portrait1, kenPortrait1, 0, 0, false)
    Sprite.Animate (portrait2, kenPortrait2, maxx - Pic.Width (kenPortrait2), 0, false)
    
    Sprite.Show (youIndicator)
    Sprite.Show (challengerIndicator)
    Sprite.Show (portrait1)
    Sprite.Show (portrait2)
    Sprite.Show (lifeIndicator1)
    Sprite.Show (lifeIndicator2)
    Sprite.Show (percentText1)
    Sprite.Show (percentText2)

end displayStatus


%For keypress detection

function KeyPushedDown (c : char) : boolean
    result not charsLast (c) and chars (c)
end KeyPushedDown

function KeyReleased (c : char) : boolean
    result not chars (c) and charsLast (c)
end KeyReleased

function KeyHeldDown (c : char) : boolean
    result charsLast (c) and chars (c)
end KeyHeldDown

proc buttonClick
    Music.PlayFile(buttonSound)
end buttonClick

proc playerSelect
    Music.PlayFile(gruntSound)
end playerSelect

proc fightSound
    Music.PlayFile(fightMusic)
end fightSound

proc loseSound
    Music.PlayFile(youLose)
end loseSound

proc winSound  
    Music.PlayFile(youWin)
end winSound

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

%KEN V.S. KEN

%-------------------------VARIABLES---------------------------%
var soundOn := false
var titlePic : int  %title screen (contains play and instructions)
var choiceScreen : int %screen with choices (player1/2, sounds on/off, play button)



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
var key : string  %useful for knowing what to add to instructions
var toDoArray : array 1..15 of string

var netLimiter := 0  %
var mostRecentKey : string := "0"

%Initialize

Input.KeyDown (charsLast)
Input.KeyDown (chars)

%INSTRUCTIONS FORMAT : ABCD
%A is either a 0,1,or 2 - 0 indicates player not moving horizontally, 1 indicates moving left, 2 indicates moving right
%B is same as A except 1 indicates moving down and 2 indicates moving up

%C and D is the attack move
%C is either 0,1,2,3 or 4 - 0 indicates no arrow, 1 indicates left, 2 indicates right, 3 indicates down, 4 indicates up
%D is either q, w, or n - kick or punch, or no action

%This loop is whole program
loop
    netLimiter := 0
    %wait for all players to be connected
    loop
	if Net.LineAvailable (netStream) then
	    get : netStream, startStr
	    if startStr = "go" then
		endGame := false
		exit
	    else
		endGame := true
		exit
	    end if
	end if
    end loop
    if endGame then
	exit
    end if
    %This loop is one game
    loop
	instructions := ""
	charsLast := chars
	Input.KeyDown (chars)
	updateScreen

	%Movement instructions
	if (chars (KEY_LEFT_ARROW)) then
	    %this is for if there is movement vertically and horizontally - attack wouldn't know which move to do
	    %chooses the last pressed key for attack
	    if KeyPushedDown (KEY_LEFT_ARROW) then
		mostRecentKey := "1"
	    elsif KeyPushedDown (KEY_RIGHT_ARROW) then
		mostRecentKey := "2"
	    end if
	elsif (chars (KEY_RIGHT_ARROW)) then
	    if KeyPushedDown (KEY_RIGHT_ARROW) then
		mostRecentKey := "2"
	    end if
	else
	    mostRecentKey := "0"
	end if
	instructions += mostRecentKey

	if (chars (KEY_UP_ARROW)) then
	    instructions += "2"
	    if KeyPushedDown (KEY_UP_ARROW) then
		mostRecentKey := "4"
	    end if
	elsif (chars (KEY_DOWN_ARROW)) then
	    instructions += "1"
	    if KeyPushedDown (KEY_DOWN_ARROW) then
		mostRecentKey := "3"
	    end if
	else
	    instructions += "0"
	end if

	instructions += mostRecentKey

	%attack instructions
	if not chars (KEY_DOWN_ARROW) then
	    if chars ('q') then
		instructions += "q"
	    elsif chars ('w') then
		instructions += "w"
	    else
		instructions += "n"
	    end if
	else
	    instructions += "n"
	end if

	if netLimiter < 10 then
	    put : netStream, instructions
	    netLimiter += 1
	end if

	if Net.LineAvailable (netStream) then
	    get : netStream, positions : *
	    %First, check if it's game over
	    if positions (1) = "G" then
		winner := strint (positions (2))
		exit
	    end if
	    %positions in in format: selfPlayerX selfPlayerY otherPlayerX otherPlayerY selfAbility selfFrame selfDirection otherAbility otherFrame otherDirection selfHealth selfLives otherHealth otherLives, time

	    toDoArray := split(positions," ")
	    Sprite.Animate(selfPlayer.sprite,pictures(strint(toDoArray(5)),strint(toDoArray(6)),strint(toDoArray(7))),strint(toDoArray(1))-screenX,strint(toDoArray(2))-screenY,false)
	    Sprite.Animate(otherPlayer.sprite,pictures(strint(toDoArray(8)),strint(toDoArray(9)),strint(toDoArray(10))),strint(toDoArray(3))-screenX,strint(toDoArray(4))-screenY,false)
	    gameTime := strint(toDoArray(15))
	    damage1 := strint(toDoArray(11))
	    damage2 := strint(toDoArray(13))
	    numLives1 :=strint(toDoArray(12))
	    numLives2 :=strint(toDoArray(14))
	    netLimiter -= 1
	end if

	updateBackground
	displayTime
	displayStatus

	Sprite.Show(otherPlayer.sprite)
	Sprite.Show(selfPlayer.sprite)
	delay(10)
    end loop
    playEndScreen
    if not playAgain then
	put : netStream, "no"
	exit
    else
	put : netStream, "yes"
    end if
end loop


%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                                   END GAME SCREEN                                                         %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%








