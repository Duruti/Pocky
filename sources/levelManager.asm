


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

   ;call drawPadlock

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
getAddressLevel
   ; retourne l'adresse du level courant dans ix
   ld hl,levels
   ld de,lenghtLevel
   ld a,(currentLevel)
   dec a
   jr z,suite
   ld b,A
   bclAddAdrLevel:
      add hl,de
      djnz bclAddAdrLevel
   suite:
   push hl ;transfert hl dans ix
   pop ix
   ret


loadLevel:
   call getAddressLevel
  ; ld ix,levels

   ld a,(ix)      ;max color
   ld (maxColor),a
 ; DEFB #ED,#FF
   ld a,(ix+1)    ; nb essais
   ld (currentTry),a
   call convertTry
   ld (maxTry),a
   ld a,(ix+2)    ; nb lignes
   ld (nbLines),a
   ld a,(ix+3)    ; nb colonne
   ld (nbRows),a
      ;seed +4,+5
   push hl
   ld h,(ix+4)
   ld l,(ix+5)
   ld  (rndseed+1),hl   ; la seed

   ld hl,&c0de
   ld  (rndseed+4),hl   
   
   pop hl

   ld a,(ix+6)          ; clef
   ld (keys),a
   ld a,(ix+7)          ; nb block
   ld (nbBlocks),a
   cp 0
   call nz,loadBlocks
   
   ld bc,18 ; decalle ix de 18 
   add ix,bc
   ld a,(ix)
   ld (nbWalls),a
   cp 0
   call nz,loadWalls
   ; charge les walls

  
   ret
initWalls:
   ld a,(nbWalls)

  

   ld e,a
   ld hl,walls
   loopDrawWalls:
      ld a,(hl)
      push hl
      call drawWalls     
      pop hl
      inc hl
      dec e
      jp nz,loopDrawWalls

   ;call drawPadlock

   ret
drawWalls:
   call getAdresseCell

   ld a,idWall
   ld (hl),a
   ret

loadWalls:
   ld c,a
   ld b,0

   push ix
   pop hl 
   inc hl
   ld de,walls
   ldir
   ret

loadBlocks:
   ld c,a
   ld b,0

  ; ld hl,levels
   ld de,8
   add hl,de
;;;   inc hl : inc hl : inc hl : inc hl : inc hl : inc hl ; positionne la pile +6
   ld de,blocks
   ldir   

   ret
addLevel1:
    

   ld a,(currentLevel)
   cp maxLevel ; maxlevel
   jr z,endAddLevel
   ;DEFB #ED,#FF
   inc A
   ld (currentLevel),A
   ;jp init
   call init
   ret

   endAddLevel:
   ld a,1
   ld (currentLevel),A
   ;jp init
   call init
   ret
   
decLevel
   ld a,(currentLevel)
   cp 1 ; maxlevel
   jr z,endDecLevel
 ;  DEFB #ED,#FF
   dec A
   ld (currentLevel),A
   ;jp init
   call init
   ret
   
   endDecLevel:
   ld a,maxLevel
   ld (currentLevel),A
   ;jp init
   call init
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
