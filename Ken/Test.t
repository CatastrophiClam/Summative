View.Set ("graphics")

%Character movement

var characterX, characterY : int := 0
var chars, charsLast : array char of boolean 
var moveSpeed : int := 10
var characterState : string := "R"

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
    kenIdleR (i) := Pic.FileNew ("idle" + intstr(i) + ".jpeg")
    kenIdleL (i) := Pic.Mirror (kenIdleR (i))
end for
    
% Move
var kenMoveR, kenMoveL : array 1 .. 5 of int 
for i : 1 .. 5
    kenMoveR (i) := Pic.FileNew ("move" + intstr(i) + ".jpeg")
    kenMoveL (i) := Pic.Mirror (kenMoveR (i))
end for
    
% Kneel
var kenKneelR := Pic.FileNew ("kneel.jpeg")
var kenKneelL := Pic.Mirror (kenKneelR)

% Jump
var kenJumpR, kenJumpL : array 1 .. 7 of int
for i : 1 .. 7
    kenJumpR (i) := Pic.FileNew ("jump" + intstr(i) + ".jpeg")
    kenJumpL (i) := Pic.Mirror (kenJumpR (i))
end for
    
% Roundhouse
var kenRoundhouseR, kenRoundhouseL : array 1 .. 5 of int
for i : 1 .. 5
    kenRoundhouseR (i) := Pic.FileNew ("roundhouse" + intstr(i) + ".jpeg")
    kenRoundhouseL (i) := Pic.Mirror (kenRoundhouseR (i))
end for
    
%Punch
var kenPunchR, kenPunchL : array 1 .. 3 of int
for i : 1 .. 3
    kenPunchR (i) := Pic.FileNew ("punch" + intstr(i) + ".jpeg")
    kenPunchL (i) := Pic.Mirror (kenPunchR (i))
end for
    
% Kick
var kenKickR, kenKickL : array 1 .. 5 of int
for i : 1 .. 5
    kenKickR (i) := Pic.FileNew ("kick" + intstr(i) + ".jpeg")
    kenKickL (i) := Pic.Mirror (kenKickR (i))
end for
    
% Tatsumaki
var kenTatsumakiR, kenTatsumakiL : array 1 .. 13 of int
for i : 1 .. 13
    kenTatsumakiR (i) := Pic.FileNew ("tatsumaki" + intstr(i) + ".jpeg")
    kenTatsumakiL (i) := Pic.Mirror (kenTatsumakiR (i))
end for
    
% Hadoken
var kenHadokenR, kenHadokenL : array 1 .. 4 of int
for i : 1 .. 4
    kenHadokenR (i) := Pic.FileNew ("hadoken" + intstr(i) + ".jpeg")
    kenHadokenL (i) := Pic.Mirror (kenHadokenR (i))
end for
    
% Shoryuken
var kenShoryukenR, kenShoryukenL : array 1 .. 7 of int
for i : 1 .. 7
    kenShoryukenR (i) := Pic.FileNew ("shoryuken" + intstr(i) + ".jpeg")
    kenShoryukenL (i) := Pic.Mirror (kenShoryukenR (i))
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
            
            for i : 1 .. 7
                Sprite.Animate (sprite, kenJumpL (i), characterX, characterY, false)
                delay (80)
                characterY -= 10
            end for
                
        elsif characterState = "R" then
            
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
        
        for i : 1 .. 5
            Sprite.Animate (sprite, kenMoveL (i), characterX, characterY, false)
            delay (50)
        end for
            
        
    elsif KeyHeldDown (KEY_RIGHT_ARROW) then 
        characterX += moveSpeed
        characterState := "R"
        
        for i : 1 .. 5
            Sprite.Animate (sprite, kenMoveR (i), characterX, characterY, false)
            delay (50)
        end for
            
    elsif KeyHeldDown ("e") then
        
        if characterState = "L" then
            
            for i : 1 .. 5
                Sprite.Animate(sprite, kenRoundhouseL(i), characterX, characterY, false)
                delay (50)
            end for
                
        elsif characterState = "R" then
            
            for i : 1 .. 5
                Sprite.Animate(sprite, kenRoundhouseR(i), characterX, characterY, false)
                delay (50)
            end for
        end if
        
    elsif KeyHeldDown ("z") then
        
        if characterState = "L" then
            
            for i : 1 .. 5
                Sprite.Animate(sprite, kenKickL(i), characterX, characterY, false)
                delay (50)
            end for
                
        elsif characterState = "R" then
            
            for i : 1 .. 5
                Sprite.Animate(sprite, kenKickR(i), characterX, characterY, false)
                delay (50)
            end for
        end if
        
    elsif KeyHeldDown ("a") then
        
        if characterState = "L" then
            
            for i : 1 .. 3
                Sprite.Animate(sprite, kenPunchL(i), characterX, characterY, false)
                delay (50)
            end for
                
        elsif characterState = "R" then
            
            for i : 1 .. 3
                Sprite.Animate(sprite, kenPunchR(i), characterX, characterY, false)
                delay (50)
            end for
        end if
        
    elsif KeyPushedDown ("s") then
        
        if characterState = "L" then
            
            for i : 1 .. 4
                Sprite.Animate(sprite, kenHadokenL(i), characterX, characterY, false)
                delay (100)
            end for
                
        elsif characterState = "R" then
            
            for i : 1 .. 4
                Sprite.Animate(sprite, kenHadokenR(i), characterX, characterY, false)
                delay (100)
            end for
        end if
        
    elsif KeyPushedDown ("d") then
        characterY += 91
        
        if characterState = "L" then
            for i : 1 .. 7
                characterY -= 13
                Sprite.Animate(sprite, kenShoryukenL(i), characterX, characterY, false)
                delay (100)
            end for
                
        elsif characterState = "R" then
            
            for i : 1 .. 7
                characterY -= 13
                Sprite.Animate(sprite, kenShoryukenR(i), characterX, characterY, false)
                delay (100)
            end for
        end if
        
    elsif KeyHeldDown ("q") then
        characterY += 78
        if characterState = "L" then
            
            for i : 1 .. 13
                characterY -= 6
                Sprite.Animate(sprite, kenTatsumakiL(i), characterX, characterY, false)
                delay (50)
            end for
                
        elsif characterState = "R" then
            
            for i : 1 .. 13
                characterY -= 6
                Sprite.Animate(sprite, kenTatsumakiR(i), characterX, characterY, false)
                delay (50)
            end for
        end if
        
    else
        if characterState = "L" then
            
            for i : 1 .. 4 
                Sprite.Animate (sprite, kenIdleL (i), characterX, characterY, false)
                delay (80)
            end for
                
        elsif characterState = "R" then
            
            for i : 1 .. 4
                Sprite.Animate (sprite, kenIdleR (i), characterX, characterY, false)
                delay (80)
            end for
        end if
    end if
    Sprite.Show(sprite)
end loop 
