%Super Crash Pros --------------------------------> By: Bowen and Max

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

var chars : array char of boolean

%---------------------------------SCREEN STUFF----------------------------------%

var screenX, screenY : int %location of BOTTOM LEFT of screen IN THE WORLD

%------------------BACKGROUND------------------%

%original picture of bacground
var backgroundPic : int
backgroundPic := Pic.FileNew("Background.jpg")
var backgroundSprite : int
backgroundSprite := Sprite.New(backgroundPic)

%---------------------------------PLAYER STUFF----------------------------------%
var selfPlayer, otherPlayer : Character
selfPlayer.x := 565
selfPlayer.y := 365
selfPlayer.h := 2
selfPlayer.w := 2
otherPlayer.x := 1318
otherPlayer.y := 365
otherPlayer.h := 2
otherPlayer.w := 2

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

loop
    Input.KeyDown(chars)
    updateScreen
    
    if (chars(KEY_UP_ARROW)) then
        otherPlayer.y += 4
    end if
    if (chars(KEY_DOWN_ARROW)) then
        otherPlayer.y -= 4
    end if
    if (chars(KEY_LEFT_ARROW)) then
        otherPlayer.x -= 4
    end if
    if (chars(KEY_RIGHT_ARROW)) then
        otherPlayer.x += 4
    end if
    
    updateBackground
    %selfPlayer.update(screenX,screenY)
    %otherPlayer.update(screenX,screenY)
    Draw.FillOval(round((selfPlayer.x-screenX)),round((selfPlayer.y-screenY)),5,5,black)
    Draw.FillOval(round((otherPlayer.x-screenX)),round((otherPlayer.y-screenY)),5,5,black)
    delay(5)
end loop

%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                                   END GAME SCREEN                                                         %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%






