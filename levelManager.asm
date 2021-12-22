loadPadlock:

   ld a,(nbBlocks)

   ld e,a
   ld hl,blocks
   loopBlock:
      ld a,(hl)
      push hl
      call drawPadlock     
      pop hl
      inc hl
      dec e
      jp nz,loopBlock

   ret

drawPadlock:
   call getAdresseCell

   ld a,10
   ld (hl),a
   ret

loadKey:
 
   
   ld a,1
   ld (nbKey),a

   ; range dans le tableau la coordonnées de la clef sur 1 octet   
   ld a,&22
   ld (keys),a

   ; *************
   ; Rajoute une clef
   ; **************

   
   ld a,(keys) ; recupere la position 
   ; recupere le X
   
   and %11110000
   srl a : srl a;  srl a ; srl a
   ld (colonne),a

   ld a,(keys) ; recupere la position 
   ; recupere la ligne
   and %1111
   ld (currentLine),a

;   ld a,4
;   ld (colonne),a
   call drawKey 

   ret

getAdresseCell:
      ; retourne l'adresse dans la grille (hl) en fonction de la position de la cellule dans A
   ld c,A ; save a

   ; recupere y
   and %00001111
   ld b,a
   ld a,(nbRows)
   ld d,a
   xor a

   addRows4:
      add d      
      dec b
      jr nz,addRows4
   
   ld b,A ; save a
   ld a,c
   and %11110000
   srl a: srl a: srl a: srl a

   add B

   ld hl,grid
   add l
   ld l,a
   ret
