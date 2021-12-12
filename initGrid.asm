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
   cp 14
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
