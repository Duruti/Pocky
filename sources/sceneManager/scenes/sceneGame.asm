loadGame:
   
   ; init

   if IsMusic
    ;  call initMusic
   ENDIF



   call initGame ; initgame.asm
   LD BC,#7F10:OUT (C),C:LD C,88:OUT (C),C
   ;call overcanVertical
   xor A
   ld (compteurAffichage),A

   ; call loadInterruption 

  
   ret


updateGame:
   

   ;touche:
      ;call vbl
      ld a,(isStartingGame) : cp 1 : call z,updateTimer
      ; check is win
      call checkIsWin ;victory.asm
      ld a,(isWin)
      cp 1
      jp z,drawVictory ;victory.asm
      ;jp drawVictory ;victory.asm

      ; check is lose
      ld a,(nbTry)
      ld b,a
      ld a,(currentTry)
      cp b
      jp z,gameover ;victory.asm
   
      call getKeys   ; controls keys and Joystick
      call updateKeys ; update actions/keys
      
      ld a,(newKey) ; sauvegarde les etats des touches pour la prochaine boucle
      ld (oldKey),a
   ret
updateTimer
   time equ 13
   ld a,(timerStart) : inc a : ld (timerStart),a
   cp time : jr z,.drawCell
   cp time*2 : jr z,.drawIndicator
   ret
   .drawCell
      call drawCellPositionStart : ret
   .drawIndicator
   xor a : ld (timerStart),a
   call drawIndicator
   ld a,(nbFlashCursor) : cp 2 : jr z,.endFlash
   inc a : ld (nbFlashCursor),a
   ret
   
   .endFlash
   ld a,0 : ld (isStartingGame),a : ret