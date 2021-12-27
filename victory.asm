idWall equ 9

gameover:
   ld a,5
   call  &BB96
   ld hl,&000A
   call locate
   ld hl,textGameover
   call printText
   
   jp loopGameover


checkIsWin:
   ; parcours la grille 
   ; si une des cases est differente de la couleur de la celulle 0,0
   ; alors pas de victoire

   xor A ; initialise a false
   ld (isWin),a

   ld hl,grid
   call getLenghtGrid ; recupere la longueur de la grille
   ld b,A

   ld a,(hl) ; recupere le numero de la cellule 0,0
   ld c,a
   bclCheckGrid:
      ld a,(hl)
      cp idWall
      jr z,next
      cp c
      ret nz ; on sort si different
      next:
      inc hl
      djnz bclCheckGrid
   
  
   ld a,1 ; si on arrive ici alors toutes les cellules sont identique et on a gagner
   ld (isWin),a
   
   ret

getLenghtGrid:
   ld a,(nbLines)
   ld b,a
   ld a,(nbRows)
   ld c,a 
   xor a
   bclAddRows:
      add c  
      djnz bclAddRows
   
   ret

drawVictory:

   ld a,5
   call  &BB96
   ld hl,&000A
   call locate
   ld hl,textWin
   call printText


loopVictory:
   call #bb06 
   cp ' '
   jr nz,loopVictory
   ; passe au level suivant
   jp addLevel1 

loopGameover:
   call #bb06 
   cp ' '
   jr nz,loopGameover
   jp init