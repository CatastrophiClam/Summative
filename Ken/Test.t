View.Set ("graphics")

%Character movement

var characterX, characterY : int := 0
var chars, charsLast : array char of boolean 
var moveSpeed : int := 10
var characterState : string := "L"

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

%Create arrays of frames for animations

% Move
var kenMoveR, kenMoveL : array 1 .. 5 of int 
for i : 1 .. 5
    kenMoveL (i) := Pic.FileNew ("move" + intstr(i) + ".jpeg")
    kenMoveR (i) := Pic.Mirror (kenMoveL (i))
end for
    
% Idle
var kenIdleR, kenIdleL : array 1 .. 4 of int
for i : 1 .. 4
    kenIdleL (i) := Pic.FileNew ("idle" + intstr(i) + ".jpeg")
    kenIdleR (i) := Pic.Mirror (kenIdleL (i))
end for
    
% Kneel
var kenKneelL := Pic.FileNew ("kneel.jpeg")
var kenKneelR := Pic.Mirror (kenKneelL)

% Jump
var kenJumpR, kenJumpL : array 1 .. 7 of int
for i : 1 .. 7
    kenJumpL (i) := Pic.FileNew ("jump" + intstr(i) + ".jpeg")
    kenJumpR (i) := Pic.Mirror (kenJumpL (i))
end for
    
% Tatsumaki
var kenTatsumakiR, kenTatsumakiL : array 1 .. 13 of int
for i : 1 .. 13
    kenTatsumakiR (i) := Pic.FileNew ("tatsumaki" + intstr(i) + ".jpeg")
    kenTatsumakiL (i) := Pic.Mirror (kenTatsumakiR(i))
end for

%Character sprite
var sprite : int
sprite := Sprite.New(kenIdleR(1))

%Initialize

Input.KeyDown (charsLast)
Input.KeyDown (chars)

loop
    %update last chars
    charsLast := chars
    Input.KeyDown (chars)
    
    %IF CHARACTER IS JUMPING UP
    if chars (KEY_UP_ARROW) then 
        characterY += 70
        if characterState = "L" then
            
            %var jumpL := Sprite.New (kenJumpL (1))
            %Sprite.SetPosition (jumpL, characterX, characterY, false)
            Sprite.Animate(sprite,kenJumpL (1),characterX, characterY, false)
            %Sprite.Show (jumpL)
            
            for i : 1 .. 7
                Sprite.Animate (sprite, kenJumpL (i), characterX, characterY, false)
                delay (80)
                characterY -= 10
            end for
                
            %Sprite.Free (jumpL)
            
        elsif characterState = "R" then
            
            %var jumpR := Sprite.New (kenJumpR (1))
            %Sprite.SetPosition (jumpR, characterX, characterY, false)
            Sprite.Animate(sprite,kenJumpR (1),characterX, characterY, false)
            %Sprite.Show (jumpR)
            
            for i : 1 .. 7
                Sprite.Animate (sprite, kenJumpR (i), characterX, characterY, false)
                delay (80)
                characterY -= 10
            end for
                
            %Sprite.Free (jumpR)
            
        end if
        
        
        
    end if
    
    %IF CHARACTER KNEELS
    if KeyHeldDown (KEY_DOWN_ARROW) then
        
        if characterState = "L" then
            
            %var kneelL := Sprite.New (kenKneelL)
            %Sprite.SetPosition (kneelL, characterX, characterY, false)
            Sprite.Animate(sprite, kenKneelL, characterX, characterY, false)
            %Sprite.Show (kneelL)
            delay (50)
            %Sprite.Free (kneelL)
            
        elsif characterState = "R" then
            
            %var kneelR := Sprite.New (kenKneelR)
            %Sprite.SetPosition (kneelR, characterX, characterY, false)
            %Sprite.Show (kneelR)
            Sprite.Animate(sprite, kenKneelR, characterX, characterY, false)
            delay (50)
            %Sprite.Free (kneelR)
            
        end if
        
    end if
    
    if KeyHeldDown (KEY_LEFT_ARROW) then     
        characterX -= moveSpeed
        characterState := "L"
        %var moveL := Sprite.New (kenMoveL (1))
        %Sprite.SetPosition (moveL, characterX, characterY, false)
        Sprite.Animate(sprite,kenMoveL(1),characterX, characterY, false)
        %Sprite.Show (moveL)
        
        for i : 1 .. 5
            Sprite.Animate (sprite, kenMoveL (i), characterX, characterY, false)
            delay (50)
        end for
            
        %Sprite.Free (moveL)
        
    elsif KeyHeldDown (KEY_RIGHT_ARROW) then 
        characterX += moveSpeed
        characterState := "R"
        %var moveR := Sprite.New (kenMoveR (1))
        %Sprite.SetPosition (moveR, characterX, characterY, false)
        Sprite.Animate(sprite, kenMoveR(1),characterX, characterY, false)
        %Sprite.Show (moveR)
        
        for i : 1 .. 5
            Sprite.Animate (sprite, kenMoveR (i), characterX, characterY, false)
            delay (50)
        end for
            
        %Sprite.Free (moveR)
        
    else
        if characterState = "L" then
            %var idleL := Sprite.New (kenIdleL (1))
            %Sprite.SetPosition (idleL, characterX, characterY, false)
            Sprite.Animate(sprite,kenIdleL(1),characterX, characterY, false)
            %Sprite.Show (idleL)
            
            for i : 1 .. 4 
                
                Sprite.Animate (sprite, kenIdleL (i), characterX, characterY, false)
                delay (80)
                
            end for
                
            %Sprite.Free (idleL)
            
            elsif characterState = "R" then
            
            %var idleR := Sprite.New (kenIdleR (1))
            %Sprite.SetPosition (idleR, characterX, characterY, false)
            Sprite.Animate(sprite,kenIdleR(1), characterX, characterY, false)
            %Sprite.Show (idleR)
            for i : 1 .. 4
            Sprite.Animate (sprite, kenIdleR (i), characterX, characterY, false)
            delay (80)
            end for
                
            %Sprite.Free (idleR)
        end if
        
        
    end if
    Sprite.Show(sprite)
end loop 
