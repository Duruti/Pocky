loadGame:
   
   ; init

   if IsMusic
      call initMusic
   ENDIF



   call initGame ; initgame.asm
   ;call overcanVertical
   xor A
   ld (compteurAffichage),A

   ; call loadInterruption 

  
   ret


updateGame:
   

   ;touche:


      ; check is win
      call checkIsWin ;victory.asm
      ld a,(isWin)
      cp 1
      jp z,drawVictory ;victory.asm

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
