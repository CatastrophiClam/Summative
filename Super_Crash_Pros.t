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

%NOTE HERE'S HOW CHARACTER MOVEMENT WORKS: character has a destination: this is the point his center is moving towards. moving the character with
%the keyboard changes the destination, and he moves towards it with his movement speed
%represents a character in the game
class Character

    import PlayerStatusDisplay, platX1, platX2, platY, FILLER_VARIABLE

    export var x,var y,var h,var w,var damage,var charType, update  %exported variables
    
    %Character attributes
    var charType : int  %which character does this class represent?
    var lives : int := 5 %how many lives does this character have?
    var damage : int %how much damage has the character taken? (damage determines how much the character flies)
    var hitDamage : int %how much damage does this character deal?
    var x, y : real %coordinates of CENTER of character IN THE WORLD
    var h, w : int %current height and width of character
    var dir : int %the way the character is facing - 0 indicates left, 1 indicates right
    var kbDistance : int := 700 %base distance character gets knocked back
    var knockedBack := false %is player traveling because he got knocked back?
    
    var jumpSpeed :int := 9
    var fallSpeed : int := 1
    var moveSpeed : int := 5
    
    var isHit := false %did the character get hit?
    
    %different skills deal different amounts of damage
    var upOD, downOD, sideOD, upPD, downPD, sidePD : int
    
    %status display stuff
    var pSD : pointer to PlayerStatusDisplay
    %^(pSD)._init(lives)
    
    %Character abilities stuff
    var doingAbility : boolean %is character currently performing an ability?
    var numFrames : int %number of frames an ability lasts for
    var abilXIncr : int %how much does the character move horizontally each frame during the ability?
    var abilYIncr : int %same for vertically
    
    %Character movement stuff
    var xDir := 0  %-1 indicates to the left, 0 indicates stopped, 1 indicates to the right
    var yDir := 0  %-1 indicates down, " , 1 indicates up
    
    var xDestination,yDestination : int %coordinates of where character is moving towards
    var bounceX, bounceY : int %coords of where character will bounce (if character is hit towards ground)
    var bounces := false %does the character bounce?
    
    %Character picture stuff
    var bodyPic, bodyFPic: int
    
    %initialize damages
    proc initDamage(uO,dO,sO,uP,dP,sP:int)
        upOD := uO
        downOD := dO
        sideOD := sO
        upPD := uP
        downPD := dP
        sidePD := sP
    end initDamage
    
    %converts world coordinates to screen coordintes
    %screenX is the location of the BOTTOM LEFT of the screen IN THE WORLD
    function convertX(x_ , screenX: real): int
        result round(x_-screenX)
    end convertX
    
    %converts world coordinates to screen coordintes
    %screenX is the location of the BOTTOM LEFT of the screen IN THE WORLD
    function convertY(y_ , screenY: real): int
        result round(y_-screenY)
    end convertY
    
    %ABILITIES
    proc upO
        numFrames :=  FILLER_VARIABLE
        if not doingAbility then
            hitDamage := upOD
        end if
    end upO
    
    proc downO
        numFrames :=  FILLER_VARIABLE
        if not doingAbility then
            hitDamage := downOD
        end if
    end downO
    
    proc rightO
        numFrames :=  FILLER_VARIABLE
        if not doingAbility then
            hitDamage := sideOD
        end if
    end rightO
    
    proc leftO
        numFrames :=  FILLER_VARIABLE
        if not doingAbility then
            hitDamage := sideOD
        end if
    end leftO
    
    proc upP
        numFrames :=  FILLER_VARIABLE
        if not doingAbility then
            hitDamage := upPD
        end if
    end upP
    
    proc downP
        numFrames :=  FILLER_VARIABLE
        if not doingAbility then
            hitDamage := downPD
        end if
    end downP
    
    proc rightP
        numFrames :=  FILLER_VARIABLE
        if not doingAbility then
            hitDamage := sidePD
        end if
    end rightP
    
    proc leftP
        numFrames :=  FILLER_VARIABLE
        if not doingAbility then
            hitDamage := sidePD
        end if
    end leftP
    
    proc knockBack(cX,cY,pX,pY:int) %cX,cY is center of other player, pX, pY is where character was hit
        var kbD : real := kbDistance*damage/100  %distance character gets knocked back
        %calculate new destination
        %ABRUPT CHANGE OF DIRECTION VERSION
        xDestination := round(x+(pX-cX)*kbD/sqrt( (pX-cX)**2 + (pY-cY)**2))
        yDestination := round(y+(pY-cY)*kbD/sqrt( (pX-cX)**2 + (pY-cY)**2))
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
    
    proc update(screenX, screenY: int)%, instructions : string)
        %if we're performing an ability
        if doingAbility then
            %do the ability
            x += abilXIncr
            y += abilYIncr
            %update number of frames done
            numFrames -= 1
            %did the ability end yet?
            if numFrames = 0 then
                %if yes then revert everything
                doingAbility := false
            end if
        end if
        x := convertX(x,screenX)
        y := convertY(y,screenY)
        %display status display
        ^(pSD).display
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

%------------------BACKGROUND------------------%

%original picture of bacground
var backgroundPic : int
backgroundPic := Pic.FileNew("Background.jpg")
var backgroundSprite : int
backgroundSprite := Sprite.New(backgroundPic)

%---------------------------------PLAYER STUFF----------------------------------%
var player1, player2 : pointer to Character
new Character, player1
new Character, player2
^(player1).x := 565
^(player1).y := 365
^(player1).h := 2
^(player1).w := 2
^(player2).x := 1318
^(player2).y := 365
^(player2).h := 2
^(player2).w := 2

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
    
    updateBackground
    %^(player1).update(screenX,screenY)
    %^(player2).update(screenX,screenY)
    Draw.FillOval(round((^(player1).x-screenX)),round((^(player1).y-screenY)),5,5,black)
    Draw.FillOval(round((^(player2).x-screenX)),round((^(player2).y-screenY)),5,5,black)
    delay(5)
end loop

%---------------------------------------------------------------------------------------------------------------------------%
%                                                                                                                           %
%                                                   END GAME SCREEN                                                         %
%                                                                                                                           %
%---------------------------------------------------------------------------------------------------------------------------%























