loadMenu

   ;   di
   ;      LD A,#C3:LD (#38),A
   ;      ld hl,restorInt+1
   ;      ld (#39),hl
   ;      ei
  
   ;DEFB #ED,#FF
   ; mode standart
   ;call modeStandart

   ; mode 0
   
   ; effacer l'écran
   LD BC,#7F10:OUT (C),C:LD C,84:OUT (C),C ; border 0

   ld hl,&C000
   ld bc,&40FF
   ld a,%00000000 ;&30
   call FillRect ; utils.asm

   ; draw logo
   ld a,11
   ld (colonne),a
   ld a,30
   ld (currentLine),a
   call calcAdr80
   ld hl,logotitle
   ld bc,&2a2d ; x ,y
   call drawWindows ; utils.asm
   
   linesDrawLogo equ 130
   ; play

   ld a,7
   ld (colonne),a
   ld a,linesDrawLogo
   ld (currentLine),a
   call calcAdr80
   ld hl,logoPlay
   ld bc,&b2a ; x ,y
   call drawWindows ; utils.asm

   ; editor

   ld a,27
   ld (colonne),a
   ld a,linesDrawLogo
   ld (currentLine),a
   call calcAdr80
   ld hl,logoEditor
   ld bc,&b2a ; x ,y
   call drawWindows ; utils.asm
   
   ; logo quit
   ld a,47
   ld (colonne),a
   ld a,linesDrawLogo
   ld (currentLine),a
   call calcAdr80
   ld hl,logoQuit
   ld bc,&b2a ; x ,y
   call drawWindows ; utils.asm

   call drawCursorMenu

   ;    ld b,40
   ; waitVBLloadMenu
   ;    push bc
   ;    call vbl
   ;    pop bc
   ;    djnz waitVBLloadMenu

   ; chargement palette
   ld hl,paletteMode0
   call loadPaletteGA ; print.asm
  
   ; border
     ;LD BC,#7F10:OUT (C),C:LD C,85:OUT (C),C
    

   
   ret
   
updateMenu:
   
   call getKeys   ; controls keys and Joystick ; keyManager.asm
   call updateKeysMenu ; update actions/keys
   ld a,(newKey) ; sauvegarde les etats des touches pour la prochaine boucle
   ld (oldKey),a
   ret
   
updateKeysMenu:

	ld a,(oldKey) : bit bitEspace,a : call nz,espaceActionMenu
	ld a,(oldKey) : bit bitLeft,a : call nz,leftActionMenu	
	ld a,(oldKey) : bit bitRight,a : call nz,rightActionMenu	
	ld a,(oldKey) : bit bitKeyE,a : call nz,ChangeToEditor
	ret
ChangeToEditor
	ld a,(newKey) : bit bitKeyE,a : ret nz
   jp menuChangeSceneEditor
   ret
leftActionMenu
   ld a,(newKey)
	bit bitLeft,a
	ret nz


   ld a,(positionCursorMenu)
   or a
   jp z,endPositionCursorMenu
   dec a
   ld (positionCursorMenu),a
   call drawCursorMenu
   ret
   endPositionCursorMenu
      ld a,maxPositionCursor
      ld (positionCursorMenu),a
      call drawCursorMenu
      ret
rightActionMenu
   ld a,(newKey)
	bit bitRight,a
	ret nz


   ld a,(positionCursorMenu)
   cp maxPositionCursor
   jp z,startPositionCursorMenu
   inc a
   ld (positionCursorMenu),a
   call drawCursorMenu
   ret
   startPositionCursorMenu
      xor a
      ld (positionCursorMenu),a
      call drawCursorMenu
      ret
   ret
drawCursorMenu
   ;DEFB #ED,#FF
   ld a,(isFistDraw)
   cp 1
   call z,eraseLastBackground

   ld a,100
   ld (currentLine),a
   ld a,(positionCursorMenu)
   ld hl,refCursor
   add l
   ld l,a
   ld a,(hl)
   ld (colonne),a

   call calcAdr80
   ;DEFB #ED,#FF
   ld (lastAdrCursor),de
   
   ld hl,cursor
   call drawSprite80
   ld a,1
   ld (isFistDraw),a
   ret   
espaceActionMenu:
   ld a,(newKey) : bit bitEspace,a : ret nz
   
   ; change la pile SP pour sortir directement du
   ; updateKeyMenu
   ; la validation etant prioritaire

   inc sp : inc sp
   ld a,(positionCursorMenu)
   cp 0 : jr z,menuChangeSceneGame ; game
   cp 1 : jr z,menuChangeSceneLevels ; editor
   cp 2 : jr z,menuChangeSceneGreeting ; editor
   
   ret

   menuChangeSceneGame
   ld e,sceneGame : call changeScene : ret

   menuChangeSceneLevels
   ld e,sceneLevels : call changeScene : ret
   menuChangeSceneGreeting
   ld e,sceneGreeting : call changeScene : ret

   menuChangeSceneEditor
   if build == 1
      ret
   endif
   ld e,sceneEditor : call changeScene : ret
   
   
drawSprite80:
   ; routine de sprite en 80 octets
       ld b,16
   loopDrawSprite80
      push bc
      ldi:ldi:ldi:ldi
      dec de : dec de : dec de : dec de ; recul de 4
      call calculLine80
      pop bc
      djnz loopDrawSprite80
   ret

calculLine80:  

	ld a,d                    ;on recopie D dans A
   add a,#08                  ;on ajoute #08 à A
   ld d,a                    ;on recopie A dans D
                        ;DE contient la nouvelle adresse
   ret nc
                ;si débordement on continue donc ici et cela signifie qu'on doit ajouter #C050 à notre adresse
   ex hl,de                  ;on a besoin que notre adresse soit dans HL pour pouvoir lui additionner quelque chose
                ;l'adresse est maintenant dans HL
   ld bc,#C040               ;on met #C050 dans BC
   add hl,bc                  ;on additionne HL et BC
                ;HL contient maintenant l'adresse de la ligne inférieure mais on la veut dans DE
   ex hl,de                  ;on refait l'échange et DE contient donc l'adr
 	       
	ret   

calcAdr80:

   
   ld h,0
   ld a,(currentLine)
   
   
   ld l,a
   ld d,0
   ld e,l
   add hl,de

   ld de,lignes
	add hl,de
	ld e,(hl)
	inc hl
	ld d,(hl)
 ;  ex hl,de
   ld a,(colonne)
   add e
   ld e,a
   ; return de = address screen
   ret
eraseLastBackground
   ld hl,(lastAdrCursor)
   ld bc,&0410
   ld a,%00000000 ;&30
   call FillRect
   ret

positionCursorMenu db 0
maxPositionCursor equ 2
refCursor db 10,30,51
lastAdrCursor dw &c000
isFistDraw db 0

tamponCursor ds 100,0
; isValidMenu db 0