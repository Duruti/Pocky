textLevelsInfo db "CHOISI TON LEVEL",0
CompteurLevel db 0
align 32
tableCursorLevel  dw &0653,&1253,&1e53,&2a53,&3653
                  dw &0685,&1285,&1e85,&2a85,&3685
oldPositionCursor dw 0
oldCurrentLevel db 0
oldCurrentLevelWorld db 0
currentLevelWorld db 0
currentWorld db 0
align 16
tableAdressImgWorld : dw 0,&300,&600,&900,&c00
isWorldSelect db 0
maxWorld equ 4
maxLevelWorld db 10 ; nb de level a afficher
maxCurrentLevelWorld db 0 ; levelWorld max
maxCurrentWorld db 0 ; world max
maxCurrentLevel db 26
loadSceneLevels
   LD BC,#7F10:OUT (C),C:LD C,88:OUT (C),C

   ld hl,Music2
   call Main_Player_Start + 0
   
   ld a,(CurrentLevel) : ld (oldCurrentLevel),a 

  ; ld a,24 : ld (currentLevel),a
   call getCurrentLevelWorld

   ld hl,&C000
   ld bc,&40FF
   ld a,%00000000 ;&30
   call FillRect ; utils.asm

  


   ld hl,&08F0;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
 	ld (adrPrint),hl ; save la position
   ld a,TextChooseLevel : call getAdressText 
   ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de : inc hl
   call printText

      ; affiche le monde courant
   call drawWorld
   
   ;/////////////////////
   ; Affiche les niveaux
   call drawLevelWorld   
 
   ;affiche le cursors
   call calcAdressCursorLevel
   ;call drawCursorLevel
   
   ; place cursor sur world
   call drawCursorWorld
   ld a,1 : ld (isWorldSelect),a
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
   ld a,(currentLevelWorld) : cp 6 : jr c,.worldGestion 
   sub 5 : ld (currentLevelWorld),a
   call drawCursorLevel
   ret
   .worldGestion
      ld a,(isWorldSelect) : cp 1 : ret z
      ld a,1 : ld (isWorldSelect),a 
      call eraseOldPositionCursor
      call drawCursorWorld
      ret
downActionLevel
	ld a,(newKey):	bit bitDown,a: ret nz
   ld a,(isWorldSelect) : cp 1 : jr z,.worldGestion
   ld a,(maxLevelWorld) : ld d,a : inc d
   ld a,(currentLevelWorld) : cp 6 : ret nc 
   add 5 : cp d : ret nc 
   ld (currentLevelWorld),a
   call drawCursorLevel
   ret   
   .worldGestion
      ld a,(maxLevelWorld) : cp 0 : ret z
      xor a : ld (isWorldSelect),a : inc a : ld (currentLevelWorld),a
      call calcAdressCursorLevel : call drawCursorLevel
      call eraseOldPositionCursorWorld
      ret
rightActionLevel
	ld a,(newKey):	bit bitRight,a: ret nz
   ld a,(isWorldSelect) : cp 1 : jr z,.worldGestion
   ld a,(maxLevelWorld) : ld d,a
   ld a,(currentLevelWorld) : cp d : ret z 
   inc a : ld (currentLevelWorld),a
   call drawCursorLevel
   ret
   .worldGestion
      ld a,(currentWorld) : cp maxWorld : ret z
      inc a : ld (currentWorld),a : call drawWorld
      call drawLevelWorld
      ret
leftActionLevel
	ld a,(newKey):	bit bitLeft,a: ret nz
   ld a,(isWorldSelect) : cp 1 : jr z,.worldGestion
   ld a,(currentLevelWorld) : cp 1 : ret z 
   dec a : ld (currentLevelWorld),a
   call drawCursorLevel
   ret
   .worldGestion
      ld a,(currentWorld) : cp 0 : ret z
      dec a : ld (currentWorld),a : call drawWorld
      call drawLevelWorld
      ret
escapeActionLevel
	ld a,(newKey):	bit bitEscape,a: ret nz
   ld a,(oldCurrentLevel) : ld (currentLevel),a 
	ld e,sceneMenu : call changeScene ; sceneManager
	ret
espaceActionLevel
	ld a,(newKey):	bit bitEspace,a: ret nz
   call getCurrentLevel : ld (currentLevel),a
	ld e,sceneGame : call changeScene ; sceneManager
	ret
drawLevelWorld   
   ;call getCurrentLevelWorld
   
   ld hl,&c300
   ld bc,&4058
   ld a,%00000000 ;&30
   call FillRect ; utils.asm


   ld a,(maxCurrentLevel) : ld d,a : ld e,10 : call div
   ;breakpoint
   cp 0 : jr z,.level10 : ld (maxCurrentLevelWorld),a : ld e,a
   ld a,d : ld (maxCurrentWorld),a 
   jr .suite   
   .level10
      ld a,10 :ld (maxCurrentLevelWorld),A : ld e,a
      dec d : ld a,d : ld (maxCurrentWorld),a
   .suite
   ;breakpoint
   ; si cuurentWorld > maxCurrentWorld alors on affiche rien
   ld a,(currentWorld) : cp d : jr c,.allLevel
   jr nz,.nolevel
   ld a,(maxCurrentLevelWorld) : ld (maxLevelWorld),a : jr .end
   .nolevel
   xor a : ld (maxLevelWorld),a : jr .end
   .suitetestworld
   .allLevel
   ld a,10 : ld (maxLevelWorld),a 
   .end
   ; test world

   ld a,0 : ld (CompteurLevel),a
   ld b,4 : ld c,100 : ld a,5
   
   .loop1
      push af : push bc
      call calcAdr64
      ld a,(maxLevelWorld) : ld l,a      
      ld a,(CompteurLevel) : cp l: jp nc,.endloop1 
      ld hl,levelImg
      add h : ld h,a
   
      ld bc,&820 ; x ,y
      call drawWindows ; utils.asm
      .endloop1
      pop bc : ld a,12 : add b : ld b,a
      ld a,(CompteurLevel) : inc a : ld (CompteurLevel),a
      pop af : dec a : jr nz,.loop1

   ld b,4 : ld c,150 : ld a,5

   .loop2
      push af : push bc
      call calcAdr64
      ld a,(maxLevelWorld) : ld l,a      
      ld a,(CompteurLevel) : cp l: jp nc,.endloop2 
      ld hl,levelImg
      add h : ld h,a
   
      ld bc,&820 ; x ,y
      call drawWindows ; utils.asm
      .endloop2
      pop bc : ld a,12 : add b : ld b,a
      ld a,(CompteurLevel) : inc a : ld (CompteurLevel),a
      pop af : dec a : jr nz,.loop2
   ret
drawCursorWorld
   ld b,30 : ld c,20 
   call calcAdr64
   ld hl,cursor
   call drawSprite  
   ret
drawWorld 
   call vbl
   ld b,20 : ld c,40 
   call calcAdr64
   ld a,(currentWorld) : sla a : ld hl,tableAdressImgWorld : add l : ld l,a : ld c,(hl) : inc l : ld b,(hl) 
   ld hl,worldImg : add hl,bc
   ld bc,&1820 ; x ,y
   call drawWindows ; utils.asm
   ret
calcAdressCursorLevel
   ld a,(currentLevelWorld) : ld (oldCurrentLevelWorld),a
   ld hl,tableCursorLevel : ld a,(currentLevelWorld) : dec a : sla a : add l : ld l,a 
   ld c,(hl) : inc hl : ld b,(hl)
   call calcAdr64
   ld (oldPositionCursor),de
   ret
drawCursorLevel
   call eraseOldPositionCursor
   ld hl,tableCursorLevel : ld a,(currentLevelWorld) : dec a : sla a : add l : ld l,a 
   ld c,(hl) : inc hl : ld b,(hl)
   call calcAdr64 : ld (oldPositionCursor),de
   ld hl,cursor
   call drawSprite  
   ret
eraseOldPositionCursorWorld
   ld b,30 : ld c,20 : 
   call calcAdr64 : ex hl,de
   ld bc,&410
   ld a,%00000000 ;&30
   call FillRect ; utils.asm
   ret
eraseOldPositionCursor
   ld hl,(oldPositionCursor)
   ld bc,&410
   ld a,%00000000 ;&30
   call FillRect ; utils.asm
   ret
getCurrentLevelWorld
   ld a,(currentLevel) : ld d,a : ld e,10 : call div
   ;breakpoint
   cp 0 : jr z,.level10 : ld (currentLevelWorld),a
   ld a,d : ld (currentWorld),a 
   ret
   .level10
      ld a,10 :ld (currentLevelWorld),A
      dec d : ld a,d : ld (currentWorld),a
   ret
getCurrentLevel   
   ld a,(currentWorld) : ld d,a
   sla a : sla a : sla a : sla d : add d ; a * 10
   ld d,a : ld a,(currentLevelWorld) : add d
   ret
