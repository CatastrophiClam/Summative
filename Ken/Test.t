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

% Idle
var kenIdleR, kenIdleL : array 1 .. 4 of int
for i : 1 .. 4
    kenIdleL (i) := Pic.FileNew ("idle" + intstr(i) + ".jpeg")
    kenIdleR (i) := Pic.Mirror (kenIdleL (i))
end for
    
% Move
var kenMoveR, kenMoveL : array 1 .. 5 of int 
for i : 1 .. 5
    kenMoveL (i) := Pic.FileNew ("move" + intstr(i) + ".jpeg")
    kenMoveR (i) := Pic.Mirror (kenMoveL (i))
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
    
% Roundhouse
var kenRoundhouseR, kenRoundhouseL : array 1 .. 5 of int
for i : 1 .. 5
    kenRoundhouseL (i) := Pic.FileNew ("roundhouse" + intstr(i) + ".jpeg")
    kenRoundhouseR (i) := Pic.Mirror (kenRoundhouseL (i))
end for
    
%Punch
var kenPunchR, kenPunchL : array 1 .. 3 of int
for i : 1 .. 3
    kenPunchL (i) := Pic.FileNew ("punch" + intstr(i) + ".jpeg")
    kenPunchR (i) := Pic.Mirror (kenPunchL (i))
end for
    
% Kick
var kenKickR, kenKickL : array 1 .. 5 of int
for i : 1 .. 5
    kenKickL (i) := Pic.FileNew ("kick" + intstr(i) + ".jpeg")
    kenKickR (i) := Pic.Mirror (kenKickL (i))
end for
    
% Tatsumaki
var kenTatsumakiR, kenTatsumakiL : array 1 .. 13 of int
for i : 1 .. 13
    kenTatsumakiL (i) := Pic.FileNew ("tatsumaki" + intstr(i) + ".jpeg")
    kenTatsumakiR (i) := Pic.Mirror (kenTatsumakiL (i))
end for
    
% Hadoken
var kenHadokenR, kenHadokenL : array 1 .. 4 of int
for i : 1 .. 4
    kenHadokenL (i) := Pic.FileNew ("hadoken" + intstr(i) + ".jpeg")
    kenHadokenR (i) := Pic.Mirror (kenHadokenL (i))
end for
    
% Shoryuken
var kenShoryukenR, kenShoryukenL : array 1 .. 7 of int
for i : 1 .. 7
    kenShoryukenL (i) := Pic.FileNew ("shoryuken" + intstr(i) + ".jpeg")
    kenShoryukenR (i) := Pic.Mirror (kenShoryukenL (i))
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
            
            Sprite.Animate(sprite,kenJumpL (1),characterX, characterY, false)
            
            for i : 1 .. 7
                Sprite.Animate (sprite, kenJumpL (i), characterX, characterY, false)
                delay (80)
                characterY -= 10
            end for
                
        elsif characterState = "R" then
            
            Sprite.Animate(sprite,kenJumpR (1),characterX, characterY, false)
            
            for i : 1 .. 7
                Sprite.Animate (sprite, kenJumpR (i), characterX, characterY, false)
                delay (80)
                characterY -= 10
            end for  
        end if
    end if
    
    %IF CHARACTER KNEELS
    if KeyHeldDown (KEY_DOWN_ARROW) then
        
        if characterState = "L" then
            
            Sprite.Animate(sprite, kenKneelL, characterX, characterY, false)
            delay (50)
            
        elsif characterState = "R" then
            
            Sprite.Animate(sprite, kenKneelR, characterX, characterY, false)
            delay (50)
            
        end if
    end if
    
    if KeyHeldDown (KEY_LEFT_ARROW) then     
        characterX -= moveSpeed
        characterState := "L"
        Sprite.Animate(sprite,kenMoveL(1),characterX, characterY, false)
        
        for i : 1 .. 5
            Sprite.Animate (sprite, kenMoveL (i), characterX, characterY, false)
            delay (50)
        end for
            
        
    elsif KeyHeldDown (KEY_RIGHT_ARROW) then 
        characterX += moveSpeed
        characterState := "R"
        Sprite.Animate(sprite, kenMoveR(1),characterX, characterY, false)
        
        for i : 1 .. 5
            Sprite.Animate (sprite, kenMoveR (i), characterX, characterY, false)
            delay (50)
        end for
            
    else
        if characterState = "L" then
            
            Sprite.Animate(sprite,kenIdleL(1),characterX, characterY, false)
            
            for i : 1 .. 4 
                Sprite.Animate (sprite, kenIdleL (i), characterX, characterY, false)
                delay (80)
            end for
                
        elsif characterState = "R" then
            
            Sprite.Animate(sprite,kenIdleR(1), characterX, characterY, false)
            
            for i : 1 .. 4
                Sprite.Animate (sprite, kenIdleR (i), characterX, characterY, false)
                delay (80)
            end for
        end if
    end if
    Sprite.Show(sprite)
end loop 
