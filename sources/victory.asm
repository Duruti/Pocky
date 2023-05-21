idWall equ 9
startLineBoxDialog equ 96
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
   ld a,(positionStart)
   call getAdresseCell
   ld a,(hl) ; recupere le numero de la cellule 0,0
   ld c,a
   push bc

   ld hl,grid
   call getLenghtGrid ; recupere la longueur de la grille
   pop bc
   ld b,A
 ;breakpoint
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

drawBestTry

   ; nettoyage
   ld a,TextCodeTrack : call getAdressText
   inc hl : inc hl : inc hl : ld b,32
   .erase ; vide la chaine text sur toute la ligne
      ld (hl),&20 : inc hl : djnz .erase

   ld hl,tamponLeveltrack : call encode


   call ConvertCodeToText

   ld a,TextTrack : call getAdressText
   ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de : inc hl
   call printText 

   ld a,TextCodeTrack : call getAdressText
   ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de : inc hl
   call printText 
  ;  LD BC,#7F00:OUT (C),C:LD C,88:OUT (C),C

   .loop
      call getKeys
      ld a,(oldKey) : bit bitEspace,a : call nz,espaceAction
      ld a,(newKey) : ld (oldKey),a

      ld a,(exit) : cp 1 : jr nz,.loop
   
   xor a : ld (exit),a 
   ; vide la boite de dialogue
    ld a,(countLineUp)
    ld b,0 : ld c,a : call calcAdr64 : ex hl,de
    ld bc,&402D
    ld a,00000000 ;&30
    call FillRect ; utils.asm 
   ret
drawVictory:
   
   
   xor a
   ld (exit),a
   ld a,startLineBoxDialog : ld (countLineDown),a : ld (countLineUp),a

   ; test si le joueur a fait un parcours avec moins d'essais que le max
   ld a,(maxTry) : ld b,a : ld a,(indexTamponLevelTrack)
   ;cp b : call c,drawBestTry

   ld hl,MusicWinner
   call Main_Player_Start + 0

   ;call clearHud
   call drawBoxDialog
    ; test si le joueur a fait un parcours avec moins d'essais que le max
   ld a,(maxTry) : ld b,a : ld a,(indexTamponLevelTrack)
   cp b : call c,drawBestTry

   call calcNewCode
   call updateMaxLevel
   
   ;   ld hl,&0C5A;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
   ; 	ld (adrPrint),hl ; save la position
   ld a,TextVictory : call getAdressText
   ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de : inc hl
   call printText 
   ;LD BC,#7F00:OUT (C),C:LD C,88:OUT (C),C

   ld a,TextNewLevel : call getAdressText
   ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de : inc hl
   call printText 
   ;LD BC,#7F00:OUT (C),C:LD C,88:OUT (C),C

   ld a,TextNewWorld : call getAdressText
   ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de : inc hl
   call printText 
  ; LD BC,#7F00:OUT (C),C:LD C,88:OUT (C),C
   
   ld a,TextNewCode : call getAdressText
   ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de : inc hl
   call printText 
loopVictory:
   ;  LD BC,#7F00:OUT (C),C:LD C,88:OUT (C),C

   call getKeys
   ;   LD BC,#7F00:OUT (C),C:LD C,88:OUT (C),C
   ld a,(oldKey) : bit bitEspace,a : call nz,espaceAction
   ;call updateKeys
   ;LD BC,#7F00:OUT (C),C:LD C,88:OUT (C),C

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
  ; call updateKeys
   ld a,(oldKey) : bit bitEspace,a : call nz,espaceAction
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
      ld (hl),0 : inc hl : djnz bcl

   ret

drawBoxDialog 

   
   ld a,(countLineUp) : call drawLine  
   .loop
      call vbl
      ld a,(countLineDown) : inc a : ld (countLineDown),a : call drawLine
      ld a,(countLineDown) : cp 119 : jp z,.endloop
      ld a,(countLineUp) : dec a : ld (countLineUp),a : call drawLine  
     jp .loop
   .endLoop
      ; ld a,(countLineUp) : dec a : ld (countLineUp),a : call drawLine  
      ; ld a,(countLineDown) : inc a : ld (countLineDown),a : call drawLine
      ; ld a,(countLineDown) : inc a : ld (countLineDown),a : call drawLine
      ; ld a,(countLineDown) : inc a : ld (countLineDown),a : call drawLine
      ; ld a,(countLineDown) : inc a : ld (countLineDown),a : call drawLine
   ; call vbl
   ; halt : halt : halt : halt :halt :
   ; ld a,(countLineUp)
   ; ld b,0 : ld c,a : call calcAdr64 : ex hl,de
   ; ld bc,&402D
   ; ld a,00000000 ;&30
   ; call FillRect ; utils.asm
   ; LD BC,#7F00:OUT (C),C:LD C,88:OUT (C),C
   ld a,1 : ld (isDialog),a
   ret
eraseBoxDialog

   ld l,(startLineBoxDialog-24): ld h,0 : add hl,hl
   ld bc,lignes : add hl,bc : ld e,(hl) : inc hl : ld d,(hl) : ex hl,de
   ld bc,&4031 : ld a,%0000000 ;&30
   call FillRect ; utils.asm
   ret

calcNewCode
   ; test si on est au dernier level
   ; A finir
   ld a,(currentLevel) : inc a : ld b,a ; : ld a,(maxLevel) : cp b : call z,finalGame

   ; position le pointeur sur le texte dans ix
   ld a,TextNewCode : call getAdressText 
   inc hl: inc hl 
   ld e,(hl) : ld d,0 : add hl,de : push hl : pop ix 
   ; Sinon on récupere le code du prochaine level
   ld a,(currentLevel)
   ld hl,tableCodeHex : sla a : add l : ld l,a 
   ld e,(hl) : inc hl : ld d,(hl)

   ld a,d : and %11110000 : srl a : srl a : srl a :srl a
   call adjustNumber : ld (ix),a
   ld a,d : and %1111
   call adjustNumber : ld (ix+1),a
   ld a,e : and %11110000 : srl a : srl a : srl a :srl a
   call adjustNumber : ld (ix+2),a
   ld a,e : and %1111
   call adjustNumber : ld (ix+3),a


   ; pour le world

   ; pour le level

   call calcLevelAndWorld
   ret
adjustNumber
   cp 10 : jr c,.addNumber ; si a<10 alors c'est des chiffres
   add 7 ; sinon c'est des lettres, on décalle pour avoir &11+&30 sur les premiere lettre de l'alphabet 
   .addNumber
      add &30
   ret
calcLevelAndWorld:

  call getLevelWorld

  ld a,TextNewLevel : call getAdressText :
  ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de
  ld c,(hl) : inc c : inc hl : ld b,0
  push hl: add hl,bc : push hl

  ld a,(currentLevelWorld)
  ld d,a
  ld e,10
  call div
  ; update unité
  add &30
  ;ld ix,textLevel
  pop hl
  ld (hl),a
  ld a,d
  add &30
  dec hl
  ld (hl),a

  ;ld hl,&01F0;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
 	;ld (adrPrint),hl ; save la position
  pop hl :  call printText

  ld a,TextNewWorld : call getAdressText 
  ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de : inc hl : push hl
  dec hl : ld c,(hl) : inc hl : ld b,0 : add hl,bc : ld a,(currentWorld): inc a : add &30 : ld (hl),a
  pop hl : call printText

  ret

getLevelWorld
   ld a,(currentLevel) : inc a : ld d,a : ld e,10 : call div
   ;breakpoint
   cp 0 : jr z,.level10 : ld (currentLevelWorld),a
   ld a,d : ld (currentWorld),a 
   ret
   .level10
      ld a,10 :ld (currentLevelWorld),A
      dec d : ld a,d : ld (currentWorld),a
   ret
updateMaxLevel
   breakpoint
   ld a,(maxCurrentLevel) : ld b,a
   ld a,(currentLevel): inc a : cp b : ret c 
   ld (maxCurrentLevel),a
   ret 