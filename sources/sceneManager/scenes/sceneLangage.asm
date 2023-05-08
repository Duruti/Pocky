isDrawFunny db 0
xFlagFrench equ 10
xFlagEnglish equ xFlagFrench+30
align 2
positionCursorLangage db xFlagFrench+5,xFlagEnglish+5
oldCurrentLangage db 0
lineFlag equ 100
loadSceneLangage:
   ld bc,&7f8d
   out (c),c
  ; LD BC,#7F10:OUT (C),C:LD C,84:OUT (C),C

   DI
	LD	HL,#C9FB	;il sera remplacé par un EI RET
	LD	(#38),HL
	EI

   ; copie dans un buffer les deux dialogues pour le choix du texte 
   ; permet d'optimiser l'affichage et etre synchro avec les rasters
   ld a,fr : ld (currentLangage),a
   ld a,TextChooseLangage : call getAdressText : 
   ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de : inc hl
   
   call printText
   ; copie le texte en memoire
   ld de,bufferLangage : call copyData
  ; draw
   ;call drawFunny
   
   
   ld a,en : ld (currentLangage),a
   ld a,TextChooseLangage : call getAdressText : 
   ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de : inc hl
   
   call printText
   ; copie le texte en memoire
   ld de,bufferLangage+64*8 : call copyData
   
   
   ;ld hl,&c800 : ld bc,&4001 : ld a,&10: call FillRect
   ; cls en noir avec la couleur 3
   ld hl,#c000 : ld de,#c001 : ld a,&0 : ld (hl),a : Ld bc,#4000 : ldir

   ;   affiche les drapeaux
   ld b,xFlagFrench : ld c,lineFlag
   call calcAdr64 : ld hl,flagFrench : ld bc,&101E; x ,y
   call drawWindows ; utils.asm

   ld b,xFlagEnglish : ld c,lineFlag 
   call calcAdr64 : ld hl,flagEnglish : ld bc,&101E; x ,y
   call drawWindows ; utils.asm





   ld a,en : ld (currentLangage),a : ld (oldCurrentLangage),a
   call drawCursorLangage

   call drawFunny

   ld hl,paletteFlag
   call loadPaletteGA
   ret
drawFunny
   ld a,(currentLangage) : cp 0 : jr nz,.english
   ld hl,bufferLangage : jr .suite
   .english
   ld hl,bufferLangage+64*8
   .suite
   ld de,&c600 : 
   ld a,8
   .loopCopyDraw 
   ;breakpoint
   ld bc,64 : ldir
   push af :
   ld a,d : add 8 : ld d,a : ld e,0
   pop af
   dec a : jp nz,.loopCopyDraw
   ret
copyData
   ld ix,dataLineCopy : 
   ld a,8
   .loopCopy 
   ld l,0 : ld h,(ix) : inc ix
   ld bc,64 : ldir
   dec a : jp nz,.loopCopy
   ret
updateSceneLangage
   ld a,0 : ld (isDrawFunny),a
  LD BC,#7F10:OUT (C),C:LD C,84:OUT (C),C ; place l'encre 4 en noir pour pas voir le trait
   
   call getKeys   ; controls keys and Joystick ; keyManager.asm
 ld hl,paletteFlag : call loadPaletteGA
   ld bc,&7f8c : out (c),c
 ;  LD BC,#7F10:OUT (C),C:LD C,76:OUT (C),C
   call updateKeySceneLangage ; update actions/keys
   ld a,(newKey) ; sauvegarde les etats des touches pour la prochaine boucle
   ld (oldKey),a
  

  halt : halt : halt : halt 

   ld bc,&7f8d :  out (c),c
   ld hl,paletteGA2 :  call loadPaletteGA

   ld a,(isDrawFunny) : cp 1 : call z,drawFunny
  LD BC,#7F00:OUT (C),C:LD C,84:OUT (C),C ; place l'encre 4 en noir pour pas voir le trait

   ret
   ret
updateKeySceneLangage
  	ld a,(oldKey) : bit bitEspace,a : call nz,valideActionLangage
	ld a,(oldKey) : bit bitLeft,a : call nz,leftActionlangage	
	ld a,(oldKey) : bit bitRight,a : call nz,rightActionLangage
   ret
rightActionLangage
   ld a,(newKey) : bit bitRight,a : ret nz
   ld a,(currentLangage) : ld (oldCurrentLangage),a : cp 1 : jr nz,.init
   xor a : ld (currentLangage),a : jr .draw   
   .init
      ld a,1 : ld (currentLangage),a
   .draw
   call drawCursorLangage
   ret
leftActionlangage
   ld a,(newKey) : bit bitLeft,a : ret nz
   ld a,(currentLangage) : ld (oldCurrentLangage),a :cp 0 : jr z,.init
   xor a : ld (currentLangage),a : jr .draw    
   .init
      ld a,1 : ld (currentLangage),a
   .draw
   call drawCursorLangage
   ret
valideActionLangage
   ld a,(newKey) : bit bitEspace,a : ret nz
   ; palette noir
   ld hl,paletteBlack : call loadPaletteGA
  ; LD BC,#7F10:OUT (C),C:LD C,84:OUT (C),C ; place l'encre 4 en noir pour pas voir le trait
   ld hl,#c000 : ld de,#c001 : ld (hl),%00000000 : Ld bc,#4000 : ldir
   ei

   ld e,sceneMenu : call changeScene : ret
   ret
drawCursorLangage
   ;place holder avec un carré
   call eraseOldCursorLangage
   ld a,(currentLangage)
   ld hl,positionCursorLangage : add l : ld l,a : ld b,(hl) ; recupere la position x   
   ld c,lineFlag-20
   call calcAdr64 : ex hl,de
   ld bc,&0509
   ld a,%11110000 ;&30
   call FillRect ; utils.asm
   ; pour rire
   ld a,1 : ld (isDrawFunny),a
   ;call drawFunny
   ret
eraseOldCursorLangage
   ld a,(oldCurrentLangage)
   ld hl,positionCursorLangage : add l : ld l,a : ld b,(hl) ; recupere la position x   
   ld c,lineFlag-20
   call calcAdr64 : ex hl,de
   ld bc,&0509
   ld a,&ff ;&30
   call FillRect ; utils.asm
   ret
