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

   call drawPadlock

   ret

drawPadlock:
   call getAdresseCell

   ld a,10
   ld (hl),a
   ret

loadKey:
 
   ld a,(keys)
   cp &FF
   ret z  

   ld a,1   
   ld (nbKey),a

   ; range dans le tableau la coordonnées de la clef sur 1 octet   
  ; ld a,&22
  ; ld (keys),a

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
loadLevel:
   ld hl,levels
   ld de,10
   ld a,(currentLevel)
   dec a
   jr z,suite
   ld b,A
   bclAddAdrLevel:
      add hl,de
      djnz bclAddAdrLevel
   suite:
   push hl
   pop ix

  ; ld ix,levels
   ld a,(ix)
   ld (maxColor),a
   ld a,(ix+1)
   ld (nbLines),a
   ld a,(ix+2)
   ld (nbRows),a
   ld a,(ix+3)
   ld (keys),a
   ld a,(ix+4)
   ld (nbBlocks),a
   cp 0
   call nz,loadBlocks
   
  
   ret

loadBlocks:
   ld c,a
   ld b,0

  ; ld hl,levels

   inc hl : inc hl : inc hl : inc hl : inc hl
   ld de,blocks
   ldir   

   ret
addLevel1:
   ld a,(currentLevel)
   cp 5 ; maxlevel
   jr z,endAddLevel
   DEFB #ED,#FF
   inc A
   ld (currentLevel),A
   jp init

   endAddLevel:
   ld a,1
   ld (currentLevel),A
   jp init

decLevel
   ld a,(currentLevel)
   cp 1 ; maxlevel
   jr z,endDecLevel
   DEFB #ED,#FF
   dec A
   ld (currentLevel),A
   jp init

   endDecLevel:
   ld a,5
   ld (currentLevel),A
   jp init


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
