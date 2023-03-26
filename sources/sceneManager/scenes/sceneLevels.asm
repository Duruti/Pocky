textLevelsInfo db "CHOISI TON LEVEL",0
CompteurLevel db 0
align 32
tableCursorLevel  dw &0653,&1253,&1e53,&2a53,&3653
                  dw &0685,&1285,&1e85,&2a85,&3685
oldPositionCursor dw 0
oldCurrentLevel db 0


loadSceneLevels

   ld a,(currentLevel) : ld (oldCurrentLevel),a
   ld hl,tableCursorLevel : ld a,(currentLevel) : dec a : sla a : add l : ld l,a 
   ld c,(hl) : inc hl : ld b,(hl)
   call calcAdr64
   ld (oldPositionCursor),de
  
   ld hl,&C000
   ld bc,&40FF
   ld a,%00000000 ;&30
   call FillRect ; utils.asm

   ld hl,&08F0;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
 	ld (adrPrint),hl ; save la position
   ld a,TextChooseLevel : call getAdressText 
   ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de : inc hl
   call printText

   ;///////////////
   ; Affiche world 1
   ld b,20 : ld c,40 
   call calcAdr64
   ;ld de,&c000
   ld hl,worldImg
   ld bc,&1820 ; x ,y
   call drawWindows ; utils.asm

   ;/////////////////////
   ; Affiche les niveaux
   ld a,0 : ld (CompteurLevel),a
   ld b,4 : ld c,100 : ld a,5
   
   .loop1
      push af : push bc
      call calcAdr64
      
      ld a,(CompteurLevel)
      ld hl,levelImg
      add h : ld h,a
   
      ld bc,&820 ; x ,y
      call drawWindows ; utils.asm
      pop bc : ld a,12 : add b : ld b,a
      ld a,(CompteurLevel) : inc a : ld (CompteurLevel),a
      pop af : dec a : jr nz,.loop1

   ld b,4 : ld c,150 : ld a,5

   .loop2
      push af : push bc
      call calcAdr64
      
      ld a,(CompteurLevel)
      ld hl,levelImg
      add h : ld h,a
   
      ld bc,&820 ; x ,y
      call drawWindows ; utils.asm
      pop bc : ld a,12 : add b : ld b,a
      ld a,(CompteurLevel) : inc a : ld (CompteurLevel),a
      pop af : dec a : jr nz,.loop2

   call drawCursorLevel
   
   ret
updateSceneLevels
   call getKeys   ; controls keys and Joystick ; keyManager.asm
   call updateKeysLevels ; update actions/keys
   ld a,(newKey) ; sauvegarde les etats des touches pour la prochaine boucle
   ld (oldKey),a
   ret
updateKeysLevels
	ld a,(oldKey) : bit bitEscape,a : call nz,escapeActionLevel

   ld a,(oldKey) : bit bitEspace,a : call nz,espaceActionLevel
	ld a,(oldKey) : bit bitLeft,a : call nz,leftActionLevel	
	ld a,(oldKey) : bit bitRight,a : call nz,rightActionLevel	
	ld a,(oldKey) : bit bitUp,a : call nz,upActionLevel	
	ld a,(oldKey) : bit bitDown,a : call nz,downActionLevel	
   ret
upActionLevel
	ld a,(newKey):	bit bitUp,a: ret nz
   ld a,(currentLevel) : cp 6 : ret c 
   sub 5 : ld (currentLevel),a
   call drawCursorLevel
   ret
downActionLevel
	ld a,(newKey):	bit bitDown,a: ret nz
   ld a,(currentLevel) : cp 6 : ret nc 
   add 5 : ld (currentLevel),a
   call drawCursorLevel
   ret   
rightActionLevel
	ld a,(newKey):	bit bitRight,a: ret nz
   ld a,(currentLevel) : cp 10 : ret z 
   inc a : ld (currentLevel),a
   call drawCursorLevel
   ret
leftActionLevel
	ld a,(newKey):	bit bitLeft,a: ret nz
   ld a,(currentLevel) : cp 1 : ret z 
   dec a : ld (currentLevel),a
   call drawCursorLevel
   ret

escapeActionLevel
	ld a,(newKey):	bit bitEscape,a: ret nz
   ld a,(oldCurrentLevel) : ld (currentLevel),a 
	ld e,sceneMenu : call changeScene ; sceneManager
	ret
espaceActionLevel
	ld a,(newKey):	bit bitEspace,a: ret nz
	ld e,sceneMenu : call changeScene ; sceneManager
	ret

drawCursorLevel
   call eraseOldPositionCursor
   ld hl,tableCursorLevel : ld a,(currentLevel) : dec a : sla a : add l : ld l,a 
   ld c,(hl) : inc hl : ld b,(hl)
   call calcAdr64 : ld (oldPositionCursor),de
   ld hl,cursor
   call drawSprite  
   ret
eraseOldPositionCursor
   ld hl,(oldPositionCursor)
   ld bc,&810
   ld a,%00000000 ;&30
   call FillRect ; utils.asm
   ret
