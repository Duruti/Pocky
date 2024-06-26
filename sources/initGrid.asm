initCell:
   ld c,A ; save a
   ; recupere la tuile
   ;breakpoint
   ld a,(nbRows) : ld d,0 : ld e,a 
   ld a,c : and %11110000 : srl a : srl a : srl a : srl a : ld b,a 
	ld a,c : and %1111 
   push bc : call DE_Mul_A : pop bc : ld a,b : add l : ld l,a 
   ld de,gridInit : add hl,de : ld a,(hl)
   ret

   ; recupere y
   and %00001111
   ld b,a
   ld a,(nbRows)
   ld d,a
   xor a

   addRowsInit:
      add d      
      dec b
      jr nz,addRowsInit
   
   ld b,A ; save a
   ld a,c
   and %11110000
   srl a: srl a: srl a: srl a

   add B

   ld hl,grid
   add l
   ld l,a

   ld b,1
   jp loopInitGrid
   
   ret


initGrid:
   ld hl,grid
   call getNbCells
   ld b,a
   loopInitGrid:
      ld a,(maxColor)
      cp 2
      jp z,calcRnd2
      cp 3
      jp z,calcRnd3
      cp 4
      jp z,calcRnd4
      cp 5
      jp z,calcRnd5
      cp 6
      jp z,calcRnd6
      
     
      endTestRnd:
         ld (hl),A
         inc hl
         dec B
         jp nz,loopInitGrid
   ret


rnd2: ; entre 0 et 1
   call random
    ;  DEFB #ED,#FF
   cp 128
   jr c,zeroRnd
   ld a,1
   ret
   zeroRnd:
      xor a
      ret

rnd4:
   call random
   srl a : srl a : srl a : srl a
   srl a : srl a
   
   ret


calcRnd2:
      call rnd2
      jp endTestRnd
   
calcRnd3:
   call rnd2
   ld d,a
   call rnd2
   add d
   jp endTestRnd 

   
calcRnd4:
   call rnd4
   jp endTestRnd

calcRnd5:
   call rnd4
   ld d,a
   call rnd2
   add d
   jp endTestRnd

calcRnd6:
   call rnd4
   ld d,a
   call rnd2
   add d
   ld d,a
   call rnd2
   add d
   jp endTestRnd




getNbCells:
   ; retourne le nombre de cellules de la grille en fonction de la taille
   ld a,(nbRows)
   ld d,A
   ld a,(nbLines)
   ld b,a
   xor a
   addNbCells:
      add d
      dec b
      jr nz,addNbCells

   ret
addLevel:
   ; Change la taille de la grille max 13 et mini 4
   ld a,(nbRows)
   inc a
   cp 13
   jr z,initAddLevel
   ld (nbRows),a
   ld (nbLines),a
   jp init

   initAddLevel:
      ld a,4
      ld (nbRows),a
      ld (nbLines),a
      call cls
      jp init

addColor:
   ld a,(maxColor)
   cp 6
   jr z,initMaxcolor
   inc a 
   ld (maxColor),a 
   jp init

   initMaxcolor:
      ld a,2
      ld (maxColor),a 
      jp init
