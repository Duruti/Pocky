idWall equ 9

gameover:
   call clearHud
   xor A
   ld (exit),a

  
   ld hl,&0CF0;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
 	ld (adrPrint),hl ; save la position
   ;ld hl,textGameover
   ld a,TextGameover : call getAdressText
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
   
   xor A
   ld (exit),a

   call clearHud

   ld hl,&0CF0;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
 	ld (adrPrint),hl ; save la position
      ld a,TextVictory : call getAdressText

   call printText


loopVictory:
  ; call vbl

  call getKeys
   call updateKeys

 	ld a,(newKey) ; sauvegarde les etats des touches pour la prochaine boucle
 	ld (oldKey),a

 	ld a,(exit)    	; test si on quitte le programme
  	cp 1
   jr nz,loopVictory
   ; passe au level suivant
   jp addLevel1 

loopGameover:
   ;call #bb06 
   ;cp 'f'
  ; call vbl
   call getKeys
   call updateKeys

 	ld a,(newKey) ; sauvegarde les etats des touches pour la prochaine boucle
 	ld (oldKey),a

 	ld a,(exit)    	; test si on quitte le programme
  	cp 1
   jr nz,loopGameover
   
   
   jp init