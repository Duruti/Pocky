
changeColors:
   ; dans A on à le numero de couleurRemplissage

   ;ld hl,grid
   ;ld (hl),a
   ld de,Colors
   add a,e
   ld e,a
   ld a,(de)
   ld (currentColor),a
   
   call getLine
   ld (currentLine),A

   call getColonne
   ld (colonne),A ; multiple de 4 colonne 1 => 4

   call drawcells

ret

getLine : 
   ld a,(currentPosition)
   ; recupere y
   and %00001111
  
   ret

getColonne:
   ld a,(currentPosition)
   and %11110000
   srl a : srl a 
      
   ret
