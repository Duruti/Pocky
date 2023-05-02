xFlagFrench equ 10
xFlagEnglish equ xFlagFrench+30
align 2
positionCursorLangage db xFlagFrench+5,xFlagEnglish+5
oldCurrentLangage db 0
lineFlag equ 100
loadSceneLangage:
   ld bc,&7f8c
   out (c),c
   LD BC,#7F10:OUT (C),C:LD C,84:OUT (C),C
   di
   ; cls en noir avec la couleur 3
   ld hl,#c000 : ld de,#c001 : ld a,&ff : ld (hl),a : Ld bc,#4000 : ldir

   ;   affiche les drapeaux
   ld b,xFlagFrench : ld c,lineFlag
   call calcAdr64 : ld hl,flagFrench : ld bc,&101E; x ,y
   call drawWindows ; utils.asm

   ld b,xFlagEnglish : ld c,lineFlag 
   call calcAdr64 : ld hl,flagEnglish : ld bc,&101E; x ,y
   call drawWindows ; utils.asm


   ld a,fr : ld (currentLangage),a : ld (oldCurrentLangage),a
   call drawCursorLangage

   ld hl,paletteFlag
   call loadPaletteGA
   ret
updateSceneLangage
   call getKeys   ; controls keys and Joystick ; keyManager.asm
   call updateKeySceneLangage ; update actions/keys
   ld a,(newKey) ; sauvegarde les etats des touches pour la prochaine boucle
   ld (oldKey),a
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
   ei
      ld hl,#c000 : ld de,#c001 : ld a,%00000000 : ld (hl),a : Ld bc,#4000 : ldir

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
   ld a,TextChooseLangage : call getAdressText 
   ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de : inc hl
   call printText
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
