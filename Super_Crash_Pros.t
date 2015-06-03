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

    export x,y,h,w,dmg,charType,scale  %exported variables
    export update    %exported procedures
    
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
    proc convertX(x_ , screenX: real): int
        result screenX + round((x_-screenX)/scale)
    end convertX
    
    %converts world coordinates to screen coordintes
    %screenX is the location of the BOTTOM LEFT of the screen IN THE WORLD
    proc convertY(y_ , screenY: real): int
        result screenY + round((y_-screenY)/scale)
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

var worldLength, worldHeight : int  %actual width and height of world

%---------------------------------SCREEN STUFF----------------------------------%

var screenScale : real %ratio of screen pixel to world pixel - one screen pixel = how many world pixels?
var screenX, screenY : int %location of BOTTOM LEFT of screen IN THE WORLD

%------------------BACKGROUND------------------%
var backgroundPicOriginal : int
%backgroundPicOriginal := Pic.FileNew("")
%backgroundPicOriginal := 

var backgroundPic := backgroundPicOriginal

%---------------------------------PLAYER STUFF----------------------------------%
var player1, player2 : pointer to Character

%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                                    VARIABLES                                                              %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%


%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                               FUNCTIONS AND PROCESSES                                                     %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%

procedure updateBackground (scale : real)
    backgroundPic := Pic.Scale(backgroundPicOriginal, round(worldLength*scale), round(worldHeight * scale))
end resizeBackground

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
            %player 1's x is leftmost
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
    
    %update screenX and screenY
    screenX := leftMost - 50
    if screenX < 0 then 
        screenX := 0
    end if
    
    screenY := bottomMost - 50
    if screenY < 0 then
        screenY := 0
    end if
    
    %update screen scale
    screenScale := max( (rightMost-leftMost)/maxx, (topMost-bottomMost)/maxy) )
    
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

end loop

%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                                   END GAME SCREEN                                                         %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%























