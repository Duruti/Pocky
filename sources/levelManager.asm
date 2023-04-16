posStart equ 0
posColor equ 1
posMaxTry equ 2
posLine equ 3
posRow equ 4
posSeed equ 5
posKey equ 7
posNbBlocks equ 8
posNbWall equ posNbBlocks+maxNbBlock+1

maxNbBlock equ 30
maxNbWall equ 30
idPadlock equ 19 ; first padlock (17 - 22)

lenghtLevel equ posNbWall+maxNbWall+1 ;40 taille en octet d'un level

maxLevel equ 50


loadPadlock:
   if build == 0
   
   ld a,(modeEditor) : cp 1 : ret z ; rustine pour eviter conflit avec editeur
   ENDif 

   ld a,(nbBlocks)
   ;DEFB #ED,#FF 
  

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

   ld a,idPadlock
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
   ;   breakpoint
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
   ; charge le level avec ses carateristiques
   call getAddressLevel
  ; ld ix,levels

   ld a,(ix)      ; position de depart
   ld (positionStart),a

   ld a,(ix+posColor)      ;max color
   ld (maxColor),a
 ; DEFB #ED,#FF
   ld a,(ix+posMaxTry)    ; nb essais
   ld (currentTry),a
   call convertTry
   ld (maxTry),a
   ld a,(ix+posLine)    ; nb lignes
   ld (nbLines),a
   ld a,(ix+posRow)    ; nb colonne
   ld (nbRows),a
      ;seed +5,+6
   push hl
   ld h,(ix+posSeed)
   ld l,(ix+posSeed+1)
   ld  (rndseed+1),hl   ; la seed

   ld hl,&c0de
   ld  (rndseed+4),hl   
   
   pop hl

   ld a,(ix+posKey)          ; clef
   ld (keys),a
   ld a,(ix+posNbBlocks)          ; nb block
   ld (nbBlocks),a
   cp 0
   call nz,loadBlocks
   ld bc,posNbWall ; decalle ix de 19 
   add ix,bc
   ld a,(ix)
   ld (nbWalls),a
   cp 0
   call nz,loadWalls
   ; charge les walls

  
   ret
initWalls:
   if build == 0
      ld a,(modeEditor) : cp 1 : ret z ; rustine pour eviter conflit avec editeur
   endif
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
  ;DEFB #ED,#FF 
  ; ld hl,levels
   ld de,9
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
