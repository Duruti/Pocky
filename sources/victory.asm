idWall equ 9
startLineBoxDialog equ 95
countLineUp db 0
countLineDown db 0
isDialog db 0

gameover:
  ; call clearHud
   xor A
   ld (exit),a
   ld a,startLineBoxDialog : ld (countLineDown),a : ld (countLineUp),a
   ld hl,musicGameover
   call Main_Player_Start + 0

   call drawBoxDialog
   ;   ld hl,&0C5a;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
   ; 	ld (adrPrint),hl ; save la position
   ;ld hl,textGameover
   ld a,TextGameover : call getAdressText
   ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de : inc hl

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
   ld a,startLineBoxDialog : ld (countLineDown),a : ld (countLineUp),a

   ld hl,MusicWinner
   call Main_Player_Start + 0

   ;call clearHud
   call drawBoxDialog

   ;   ld hl,&0C5A;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
   ; 	ld (adrPrint),hl ; save la position
   ld a,TextVictory : call getAdressText
   ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de : inc hl
   call printText 
   ld a,TextNewCode : call getAdressText
   ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de : inc hl
   call printText 
loopVictory:
   call getKeys
   call updateKeys

 	ld a,(newKey) ; sauvegarde les etats des touches pour la prochaine boucle
 	ld (oldKey),a

 	ld a,(exit)    	; test si on quitte le programme
  	cp 1
   jr nz,loopVictory
   ; passe au level suivant
   call eraseBoxDialog
   ld a,0 : ld (isDialog),a
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
   call eraseBoxDialog
   ld a,0 : ld (isDialog),a

   jp init
drawLine
   ;DEFB #ED,#FF
   ld l,a: ld h,0 : add hl,hl
   ld bc,lignes : add hl,bc : ld e,(hl) : inc hl : ld d,(hl)
   ex hl,de
   ld b,&40
   bcl
      ld (hl),&0 : inc hl : djnz bcl
   ret

drawBoxDialog 

   
   ld a,(countLineUp) : call drawLine  
   .loop
      call vbl
      ld a,(countLineUp) : dec a : ld (countLineUp),a : call drawLine  
      ld a,(countLineDown) : inc a : ld (countLineDown),a : call drawLine
      ld a,(countLineDown) : cp 119 : jp z,.endloop
     jp .loop
   .endLoop
   call vbl
   ld a,1 : ld (isDialog),a
   ret
eraseBoxDialog
   ld l,(startLineBoxDialog-24): ld h,0 : add hl,hl
   ld bc,lignes : add hl,bc : ld e,(hl) : inc hl : ld d,(hl) : ex hl,de
   ld bc,&4031 : ld a,%0000000 ;&30
   call FillRect ; utils.asm
   ret