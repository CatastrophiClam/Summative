%Super Crash Pros --------------------------------> By: Bowen and Max

View.Set("graphics:max;max,position:center;center")

%NOTES
% 1). IMPORTANT: 0,0 IS THE BOTTOM LEFT POINT OF THE WORLD
% 2). Any coordinates that are "IN THE WORLD" must be converted to on-screen coordinates before being displayed

%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                                     CLASSES                                                               %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%

%represents a character in the game
class Character

    export var x,var y,var h,var w,var dmg,var charType,var scale, update  %exported variables
    
    var charType : int  %which character does this class represent?
    var dmg : int %how much damage is on the character? (damage determines how much the character flies)
    var x, y : real %coordinates of CENTER of character IN THE WORLD
    var h, w : int %current height and width of character
    var scale : real %ratio of screen pixel to world pixel - one screen pixel = how many world pixels?
    
    %Character movement stuff
    var xDir := 0  %-1 indicates to the left, 0 indicates stopped, 1 indicates to the right
    var yDir := 0  %-1 indicates down, " , 1 indicates up
    
    %Character picture stuff
    var bodyPic, bodyFPic: int
    
    
    %converts world coordinates to screen coordintes
    %screenX is the location of the BOTTOM LEFT of the screen IN THE WORLD
    function convertX(x_ , screenX: real): int
        result round(screenX + (x_-screenX)/scale)
    end convertX
    
    %converts world coordinates to screen coordintes
    %screenX is the location of the BOTTOM LEFT of the screen IN THE WORLD
    function convertY(y_ , screenY: real): int
        result round(screenY + (y_-screenY)/scale)
    end convertY
    
    proc update()
        
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

var worldLength, worldHeight : int  %actual width and height of world
worldLength := 1920%3840
worldHeight := 1080%2160

%---------------------------------SCREEN STUFF----------------------------------%

var screenScale : real %ratio of screen pixel to world pixel - one screen pixel = how many world pixels?
var pastScale : real := 0 %don't update size of screen if scale is the same
var screenX, screenY : int %location of BOTTOM LEFT of screen IN THE WORLD

%------------------BACKGROUND------------------%
var backgroundPicOriginal : int
backgroundPicOriginal := Pic.FileNew("Background.jpg")

var backgroundPic := backgroundPicOriginal

%---------------------------------PLAYER STUFF----------------------------------%
var player1, player2 : pointer to Character
new Character, player1
new Character, player2
^(player1).x := 300
^(player1).y := 300
^(player1).h := 2
^(player1).w := 2
^(player2).x := 600
^(player2).y := 300
^(player2).h := 2
^(player2).w := 2


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

%updates size of background and draws it
procedure updateBackground 
    var scale : real
    scale := screenScale
    if scale not = pastScale then
        %Pic.Free(backgroundPic)
        backgroundPic := Pic.Scale(backgroundPicOriginal, round(worldLength/scale), round(worldHeight / scale))
        pastScale := scale
    end if
    Pic.Draw(backgroundPic, round(0-screenX/screenScale), round(0-screenY/screenScale), picMerge)
end updateBackground

%updates size and position of screen
procedure updateScreen
    var leftMost, rightMost, topMost, bottomMost : int %screen should encompass these points with a 60 px margin
    
    %find leftMost and rightMost
    if ^(player1).x < ^(player2).x then
        %if player 1 is to the left of player 2 and inside the world boundaries
        if ^(player1).x - ^(player1).w/2 > 0 then
            %player 1's x is leftmost
            leftMost := round(^(player1).x-^(player1).w/2)
        else
            leftMost := 0
        end if
        
        %This means that player 2 is to the right of player 1
        if ^(player2).x + ^(player2).w/2 < worldLength then
            %player 2's x is rightmost
            rightMost := round(^(player2).x + ^(player2).w/2)
        else
            rightMost := worldLength
        end if
    else
        %player 2 is to the left of player 1
        if ^(player2).x - ^(player2).w/2 > 0 then
            %player 1's x is leftmost
            leftMost := round(^(player2).x-^(player2).w/2)
        else
            leftMost := 0
        end if
        
        %This means that player 1 is to the right of player 2
        if ^(player1).x + ^(player1).w/2 < worldLength then
            %player 1's x is leftmost
            rightMost := round(^(player1).x + ^(player1).w/2)
        else
            rightMost := worldLength
        end if
    end if
    
    %find topmost and bottomMost
    if ^(player1).y < ^(player2).y then
        %if player 1 is under player 2 and inside the world boundaries
        if ^(player1).y - ^(player1).h/2 > 0 then
            %player 1's y is bottommost
            bottomMost := round(^(player1).y-^(player1).h/2)
        else
            bottomMost := 0
        end if
        
        %This means that player 2 above player 1
        if ^(player2).y + ^(player2).h/2 < worldHeight then
            %player 1's x is topmost
            topMost := round(^(player2).y + ^(player2).h/2)
        else
            topMost := worldHeight
        end if
    else
        %if player 2 is under player 1 and inside the world boundaries
        if ^(player2).y - ^(player2).h/2 > 0 then
            %player 1's y is bottommost
            bottomMost := round(^(player2).y-^(player2).h/2)
        else
            bottomMost := 0
        end if
        
        %This means that player 1 above player 2
        if ^(player1).y + ^(player1).h/2 < worldHeight then
            %player 1's x is topmost
            topMost := round(^(player1).y + ^(player1).h/2)
        else
            topMost := worldHeight
        end if
    end if
    
    %update screen scale
    screenScale := max( (rightMost-leftMost)/maxx, (topMost-bottomMost)/maxy )
    if screenScale < 1 then
        screenScale := 1
    end if
    
    %update screenX and screenY
    screenX := round((rightMost+leftMost)/2-maxx*screenScale/2)
    if screenX < 0 then 
        screenX := 0
    end if
    
    screenY := round((bottomMost+topMost)/2-maxy*screenScale/2)
    if screenY < 0 then
        screenY := 0
    end if
    
    %put maxx
    %put maxy
    %put rightMost-leftMost
    %put topMost-bottomMost
    %put screenScale
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
    if (chars('w')) then
        ^(player1).y += 4
    end if
    if (chars('s')) then
        ^(player1).y -= 4
    end if
    if (chars('a')) then
        ^(player1).x -= 4
    end if
    if (chars('d')) then
        ^(player1).x += 4
    end if
    if (chars(KEY_UP_ARROW)) then
        ^(player2).y += 4
    end if
    if (chars(KEY_DOWN_ARROW)) then
        ^(player2).y -= 4
    end if
    if (chars(KEY_LEFT_ARROW)) then
        ^(player2).x -= 4
    end if
    if (chars(KEY_RIGHT_ARROW)) then
        ^(player2).x += 4
    end if
    updateScreen
    updateBackground
    Draw.FillOval(round(^(player1).x),round(^(player1).y),5,5,black)
    Draw.FillOval(round(^(player2).x),round(^(player2).y),5,5,black)
    %Pic.Draw(backgroundPic, 0,0,picMerge)
    %delay(5)
end loop

%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                                   END GAME SCREEN                                                         %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%























