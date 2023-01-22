idBorderLeftUp equ 13
idBorderLeftDown equ 15
idBorderRightUp equ 14
idBorderRightDown equ 16
idBorderHorizontal equ 17
idBorderVerticalLeft equ 18
idBorderVerticalRight equ 19



drawBorder:

   ; first Line
   ld a,-1
   ld (currentLine),a
   ld a,-4
   ld (colonne),a
   ld a,(nbRows)
   add 2
   ld b,a
   ld c,a
   loopLineBorderUp:
   push bc
   ld a,b
   cp 1 ; derniere colonne
   jp z,setRightUp
   cp c ; premiere colonne
   jp z,setLeftUp

   ld a,idBorderHorizontal
   
   drawCellBorderUp:
   
   ld (currentSprite),a
   call drawcells
   ld a,(colonne)
   add 4
   ld (colonne),a
   pop bc
   djnz loopLineBorderUp


   ; last line
   ld a,(nbLines)
   ld (currentLine),a
   ld a,-4
   ld (colonne),a
   ld a,(nbRows)
   add 2
   ld b,a
   ld c,a
   loopLineBorderDown:
      push bc
      ld a,b
      cp 1 ; derniere colonne
      jp z,setRightDown
      cp c ; premiere colonne
      jp z,setLeftDown

      ld a,idBorderHorizontal
      
      drawCellBorderDown:
      
      ld (currentSprite),a
      call drawcells
      ld a,(colonne)
      add 4
      ld (colonne),a
      pop bc
      djnz loopLineBorderDown



   ; ----------------------
   ; vertical left

   xor a
   ld (currentLine),a
   ld a,(nbLines)
   ld b,a
   ld a,-4
   ld (colonne),a

   loopRowLeft:
      push bc

      ld a,idBorderVerticalLeft
                  
      ld (currentSprite),a
      call drawcells
      ld a,(currentLine)
      inc a
      ld (currentLine),a
      pop bc
      djnz loopRowLeft

   ; ----------------------
   ; vertical Right

   xor a
   ld (currentLine),a
   ld a,(nbLines)
   ld b,a
   ld a,(nbRows)
   sla a: sla a
   ld (colonne),a

   loopRowRight:
      push bc

      ld a,idBorderVerticalRight
                  
      ld (currentSprite),a
      call drawcells
      ld a,(currentLine)
      inc a
      ld (currentLine),a
      pop bc
      djnz loopRowRight


   xor a 
   ld (colonne),a
   ld (currentLine),A
   ret

; ----------------------------------------

setLeftUp:
   ld a,idBorderLeftUp
   jp drawCellBorderUp
setRightUp:
   ld a,idBorderRightUp
   jp drawCellBorderUp

setLeftDown:
   ld a,idBorderLeftDown
   jp drawCellBorderDown
setRightDown:
   ld a,idBorderRightDown
   jp drawCellBorderDown