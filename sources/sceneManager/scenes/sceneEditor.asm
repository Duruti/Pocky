modeEditor db 0
textEditorInfo db "LEVEL   EDITOR",0
textRandom db "SEED:     ",0
textMaxTry db "MAXTRY:   ",0
textColors db "COLORS:   ",0
textModeKey db "MODEKEY: ",0
currentMode db 0
currentModeKey db 1
textMode: 
	;   12345678
	db "SIZE   ",0  	; 1 --
	db "RANDOM ",0		; 2 --	
	db "KEY    ",0		; 3
	db "PADLOCK",0		; 4
	db "START  ",0		; 5 --
	db "COLORS ",0		; 6 --
	db "WALL   ",0		; 7 
	db "MAX TRY",0		; 8 --

newMode db 0 ; pour choisir le mode dans l'editor
oldMode db &0
bitMode1 equ 0
bitMode2 equ 1
bitMode3 equ 2
bitMode4 equ 3
bitMode5 equ 4
bitMode6 equ 5
bitMode7 equ 6
bitMode8 equ 7


loadEditor:
   ;DEFB #ED,#FF
	ld a,1
   ld (modeEditor),a

   call initKeyboard ; keyManager.asm
	ld a,&ff
	ld (oldMode),a
	
	;di
   call clearHud	;	hub.asm
	ld hl,&C000
	ld bc,&40E0-1
	ld a,%11000000 ;&30
	call FillRect ; fillrect.asm
   ;call vbl
   ld hl,&0aF0;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
 	ld (adrPrint),hl ; save la position
   ld hl,textEditorInfo
   ;call printText ; print.asm

	; affiche le current Level
  ld hl,&00E0;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)

  	call drawLevelInfoHub
	call drawModeEditor
	call DrawInfoRandom
	call DrawMaxTry
	;ei
	;call overcanVertical
	;call loadInterruption

	call drawLevel ; initGame.asm
	call drawIndicator

	ld hl,paletteMode0
   call loadPaletteGA ; print.asm
	call drawListPadlock
	call drawListWall
   ret


updateEditor:
	;DEFB #ED,#FF
   call getKeysEditor   ; controls keys and Joystick  keyManager.asm
   call updateKeysEditor ; update actions/keys
   ld a,(newKey) ; sauvegarde les etats des touches pour la prochaine boucle
   ld (oldKey),a

   ld a,(newMode) ; idem pour les modes
	ld (oldMode),a

	ret
   

getKeysEditor:
	
	call vbl

	; ///////////////////
	; Gestion des touches pour les modes
	
	ld e,&0

	
	ld d,8 ; touche 1
   call TestKeyboard ; a contient le test
	;DEFB #ED,#FF
	and %00000001 ; ne garde que le bit 0    	
	or e 
	ld e,a

	ld d,8 ; touche 2
   call TestKeyboard ; a contient le test
	and %00000010 ; ne garde que le bit 1    	
	or e 
	ld e,a	

	ld d,7 ; touche 3
   call TestKeyboard ; a contient le test
	and %00000010 ; ne garde que le bit 1    	
	sla a
	or e 
	ld e,a	

	ld d,7 ; touche 4
   call TestKeyboard ; a contient le test
	and %00000001 ; ne garde que le bit 0
	sla a:sla a: sla a    	
	or e 
	ld e,a	

	ld d,6 ; touche 5
   call TestKeyboard ; a contient le test
	and %00000010 ; ne garde que le bit 1    	
	sla a: sla a : sla a
	or e 
	ld e,a	

	ld d,6 ; touche 6
   call TestKeyboard ; a contient le test
	and %00000001 ; ne garde que le bit 0
	sla a:sla a: sla a : sla a :sla a    	
	or e 
	ld e,a	

	ld d,5 ; touche 7
   call TestKeyboard ; a contient le test
	and %00000010 ; ne garde que le bit 1    	
	sla a: sla a : sla a : sla a : sla a
	or e 
	ld e,a	

	ld d,5 ; touche 8
   call TestKeyboard ; a contient le test
	and %00000001 ; ne garde que le bit 0
	sla a:sla a: sla a : sla a :sla a: sla a :sla a  	
	or e 
	ld e,a	


	ld (newMode),a	; save le clavier

	
	; //////////////////////////

	ld e,&0

	; bit 7
	ld d,5 ; espace
   call TestKeyboard ; a contient le test
	and %10000000 ; ne garde que le bit 7    	
	or e 
	ld e,a


	;bit 0 
	ld d,1 ; left
   call TestKeyboard ; a contient le test
	and %00000001 ; ne garde que le bit 0    	
	or e
	ld e,a

	;Right bit 1
	ld d,0 
   call TestKeyboard ; a contient le test
	and %00000010 ; ne garde que le bit 7    	
	or e
	ld e,a

	;Up 
	ld d,0 ; bit 4
   call TestKeyboard ; a contient le test
	and %00000001     	
	sla a : sla a:sla a: sla a
	or e
	ld e,a

	;down 
	ld d,0 ; bit 3
   call TestKeyboard ; a contient le test
	and %00000100   	
	sla a 
	or e
	ld e,a

	;esc bit 2
	ld d,8 
   call TestKeyboard ; a contient le test
	and %00000100 ; ne garde que le bit 2    	
	or e
	ld e,a

	;key R bit 5
	ld d,6 ; 5 
   call TestKeyboard ; a contient le test
	and %00000100 ; ne garde que le bit 2    	
	sla a : sla a : sla a   
	or e
	ld e,a

	;key E bit 6
	ld d,7 ;  
   call TestKeyboard ; a contient le test
	and %00000100 ; ne garde que le bit 2    	
	sla a : sla a : sla a : sla a   
	or e
	ld e,a

	ld (newKey),a	; save le clavier

	
	;DEFB #ED,#FF
	ret


updateKeysEditor:
   ;DEFB #ED,#FF

	ld a,(oldMode)
	bit bitMode1,a
	call nz,modeSizeEditor	

	ld a,(oldMode)
	bit bitMode2,a
	call nz,modeRandomEditor	

	ld a,(oldMode)
	bit bitMode3,a
	call nz,modeKeyEditor	

	ld a,(oldMode)
	bit bitMode4,a
	call nz,mode4Editor	

	ld a,(oldMode)
	bit bitMode5,a
	call nz,mode5Editor	

	ld a,(oldMode)
	bit bitMode6,a
	call nz,mode6Editor	

	ld a,(oldMode)
	bit bitMode7,a
	call nz,mode7Editor	

	ld a,(oldMode)
	bit bitMode8,a
	call nz,mode8Editor	


	; *******   KEY ***********
	ld a,(oldKey) : bit bitEscape,a : call nz,escapeAction

	ld a,(oldKey)
	bit bitKeyR,a
	call nz,levelUp

	ld a,(oldKey)
	bit bitKeyE,a
	call nz,levelDown

	; selectionne les update en fonction des modes

	ld a,(currentMode)
	cp 1-1 : jp z,updateSize 
	cp 2-1 : jp z,updateRandom
	cp 3-1 : jp z,updateKeyPosition 
	cp 4-1 : jp z,updatePositionPadlock 
	cp 5-1 : jp z,updateCursorStart 
	cp 6-1 : jp z,updateColors 
	cp 7-1 : jp z,updatePositionWall 
	cp 8-1 : jp z,updateMaxTry 


	endUpadteKeysEditor


	ret

updateSize 
	; ld a,(oldKey)
	; bit bitEspace,a
	; call nz,espaceActionEditor	
	

	ld a,(oldKey)
	bit bitLeft,a
	call nz,leftActionSize	

	ld a,(oldKey)
	bit bitRight,a
	call nz,rightActionSize	
   ;DEFB #ED,#FF
		
	ld a,(oldKey)
	bit bitUp,a
	call nz,upActionSize

	ld a,(oldKey)
	bit bitDown,a
	call nz,downActionSize

	jp endUpadteKeysEditor

updateRandom

	ld a,(oldKey)
	bit bitUp,a
	call nz,upActionRandom

	ld a,(oldKey)
	bit bitDown,a
	call nz,downActionRandom

	jp endUpadteKeysEditor

modeSizeEditor:
	ld a,(newMode)
	bit bitMode1,a
	ret nz
	ld a,0
	ld (currentMode),A

	call drawModeEditor

	ret
modeRandomEditor:
	ld a,(newMode)
	bit bitMode2,a
	ret nz
	ld a,2-1
	ld (currentMode),A
	call drawModeEditor
	
	ret
modeKeyEditor:
	ld a,(newMode)
	bit bitMode3,a
	ret nz
	ld a,3-1
	ld (currentMode),A
	call drawModeEditor
	call drawModeKey
	call showKeyPosition
	
	ret
mode4Editor:
	ld a,(newMode)
	bit bitMode4,a
	ret nz
	ld a,4-1
	ld (currentMode),A
	call drawModeEditor
	
	ret
mode5Editor:
	ld a,(newMode)
	bit bitMode5,a
	ret nz
	
	ld a,5-1
	ld (currentMode),A
	call drawModeEditor

	; affiche le cursor
	ret

mode6Editor:
	ld a,(newMode)
	bit bitMode6,a
	ret nz
	ld a,6-1
	ld (currentMode),A
	call drawModeEditor
	
	ret

mode7Editor:
	ld a,(newMode)
	bit bitMode7,a
	ret nz
	ld a,7-1
	ld (currentMode),A
	call drawModeEditor
	
	ret
mode8Editor:
	ld a,(newMode)
	bit bitMode8,a
	ret nz
	ld a,8-1
	ld (currentMode),A
	call drawModeEditor
	
	ret

; *****************************
; *   POSITION PADLOCK  			*
; *****************************

updatePositionPadlock
	ld a,(oldKey) : bit bitEspace,a : call nz,switchPadlock
	;ld a,(currentModeKey) : cp 0 : ret z
	ld a,(oldKey) : bit bitUp,a : call nz,upPosition
	ld a,(oldKey) : bit bitRight,a : call nz,rightPosition
	ld a,(oldKey) : bit bitDown,a : call nz,downPosition
	ld a,(oldKey) : bit bitLeft,a : call nz,leftPosition
	ret
switchPadlock
	ld a,(newKey) : bit bitEspace,a :	ret nz
	call checkIfPadlockExist
	
	ret
checkIfPadlockExist
	; parcours la liste des blocks et regarde si on a un block sous le cursor
	call getAddressLevel : 
	ld a,(ix+posNbBlocks) : ld l,a : cp 0 : jp z,addPadlock ; si la liste est vierge alors on ajoute un block
	;BREAKPOINT
	ld b,a : ld de,posNbBlocks+1 : add ix,de : ld d,ixh : ld e,ixl: dec de : ld iyh,d : ld iyl,e; repositionne ix
	ld a,(positionStart) : ld c,a
	.bcl
		ld a,(ix) : cp c : jp z,erasePadlock
		inc ix : djnz .bcl
	call addPadlock	
	ret
erasePadlock
	
	; ix est l'adresse a effacer , d nombre de blocks ; l-b = nombre de block a décaler 
	
	;;ld a,l : sub b : jp z,.eraseFirstWall 
	ld c,b : ld b,0 : 
	ld d,ixh : ld e,ixl : ex hl,de : ld d,h : ld e,l : inc hl: ldir ; decale les donnees
	ld (hl),0
	ld a,(iy) : dec a : ld (iy),a ; change le nbBlock
	call replaceCell
	;BREAKPOINT
	ret
	; .eraseFirstWall
	; BREAKPOINT
	; 	xor a : dec ix : ld (ix),a 
	; 	call replaceCell ; affiche la tile
	; ret 
addPadlock
	call getAddressLevel : ld a,(ix+posNbBlocks) : cp maxNbBlock : ret z
	inc a : ld (ix+posNbBlocks),a 
	;BREAKPOINT

	ld de,posNbBlocks : add e : ld e,a : add ix,de 
	ld a,(positionStart) : ld (ix),a
	call drawPadlockEditor
	ret
drawPadlockEditor
	;BREAKPOINT
	ld a,(positionStart) : and %11110000 : srl a : srl a : ld (colonne),a 
	ld a,(positionStart) : and %1111 : ld (currentLine),a 
	ld a,10 : ld (currentSprite),a : call drawcells

	ret
drawListPadlock
	call getAddressLevel : ld a,(ix+posNbBlocks) : cp 0 : ret z ; recupere le nb de block
	ld b,a : ld de,posNbBlocks+1 : add ix,de : ; repositionne ix
	.draw ; affiche chaque block
		push bc
		ld a,(ix) : and %11110000 : srl a : srl a : ld (colonne),a 
		ld a,(ix) : and %1111 : ld (currentLine),a 
		ld a,10 : ld (currentSprite),a : call drawcells
		inc ix : pop bc: djnz .draw

	ret
; *****************************
; *   POSITION WALL	 			*
; *****************************

updatePositionWall
	ld a,(oldKey) : bit bitEspace,a : call nz,switchWall
	;ld a,(currentModeKey) : cp 0 : ret z
	ld a,(oldKey) : bit bitUp,a : call nz,upPosition
	ld a,(oldKey) : bit bitRight,a : call nz,rightPosition
	ld a,(oldKey) : bit bitDown,a : call nz,downPosition
	ld a,(oldKey) : bit bitLeft,a : call nz,leftPosition
	ret
checkIfWallExist
	; parcours la liste des blocks et regarde si on a un block sous le cursor
	call getAddressLevel : 
	ld a,(ix+posNbWall) : ld l,a : cp 0 : jp z,addWall ; si la liste est vierge alors on ajoute un block
	;BREAKPOINT
	ld b,a : ld de,posNbWall+1 : add ix,de : ld d,ixh : ld e,ixl: dec de : ld iyh,d : ld iyl,e; repositionne ix
	ld a,(positionStart) : ld c,a
	.bcl
		ld a,(ix) : cp c : jp z,eraseWall
		inc ix : djnz .bcl
	call addWall	
	ret
eraseWall
	
	; ix est l'adresse a effacer , d nombre de blocks ; l-b = nombre de block a décaler 
	
	;;ld a,l : sub b : jp z,.eraseFirstWall 
	ld c,b : ld b,0 : 
	ld d,ixh : ld e,ixl : ex hl,de : ld d,h : ld e,l : inc hl: ldir ; decale les donnees
	ld (hl),0
	ld a,(iy) : dec a : ld (iy),a ; change le nbBlock
	call replaceCell
	;BREAKPOINT
	ret
	; .eraseFirstWall
	; BREAKPOINT
	; 	xor a : dec ix : ld (ix),a 
	; 	call replaceCell ; affiche la tile
	; ret 
addWall
	call getAddressLevel : ld a,(ix+posNbWall) : cp maxNbWall : ret z
	inc a : ld (ix+posNbWall),a 
	;BREAKPOINT

	ld de,posNbWall : add e : ld e,a : add ix,de 
	ld a,(positionStart) : ld (ix),a
	call drawWall
	ret

switchWall
	ld a,(newKey) : bit bitEspace,a :	ret nz
	call checkIfWallExist

	ret
drawWall
	;BREAKPOINT
	ld a,(positionStart) : and %11110000 : srl a : srl a : ld (colonne),a 
	ld a,(positionStart) : and %1111 : ld (currentLine),a 
	ld a,9 : ld (currentSprite),a : call drawcells

	ret
drawListWall
	call getAddressLevel : ld a,(ix+posNbWall) : cp 0 : ret z
	ld b,a : ld de,posNbWall+1 : add ix,de
	.draw
		push bc
		ld a,(ix) : and %11110000 : srl a : srl a : ld (colonne),a 
		ld a,(ix) : and %1111 : ld (currentLine),a 
		ld a,9 : ld (currentSprite),a : call drawcells
		inc ix : pop bc: djnz .draw
	ret
; **************************************
; *  GESTION POSITION WALL & PADLOCK	*
; **************************************
checkObjet
	call drawListPadlock
	call drawListWall
	; cherche s'il y a un start sous le curseur
	call getAddressLevel : ld a,(ix) : ld b,a : ld a,(positionStart)
	cp b : jp nz,.suite : call drawIndicator

	.suite ; on test s'il y a une clef sous le curseur
	ld a,(ix+7) : ld b,a : ld a,(positionStart)
	cp b : ret nz 
   ld (keys),a
   and %11110000
   srl a : srl a;  srl a ; srl a
   ld (colonne),a

   ld a,(keys) ; recupere la position 
   ; recupere la ligne
   and %1111
   ld (currentLine),a

   call drawKey 

   ret

	ret

upPosition
	ld a,(newKey) : bit bitUp,a :	ret nz
	;call getAddressLevel : ld a,(ix+3)    ; nb colonne
   ;ld (nbLines),a 
	;DEFB #ED,#FF
	ld a,(positionStart) : and %1111
	cp 0 : ret z
	call replaceCell : call checkObjet
   
	ld a,(positionStart) : dec a : ld (positionStart),a ; incremente x
	call drawIndicator
	ret
rightPosition
	ld a,(newKey) : bit bitRight,a :	ret nz
	call getAddressLevel : ld a,(ix+4)    ; nb colonne
   ld (nbRows),a :dec a : ld b,a
	ld a,(positionStart) : and %11110000 : srl a : srl a : srl a : srl a : cp b : ret nc
	call replaceCell: call checkObjet
   
	ld a,(positionStart) : add 16 : ld (positionStart),a ; incremente x
	call drawIndicator
	ret
downPosition
	ld a,(newKey) : bit bitDown,a :	ret nz
	call getAddressLevel : ld a,(ix+3) : ld (nbLines),a :dec a : ld b,a
	ld a,(positionStart) : and %1111 : cp b : ret nc

	call replaceCell : call checkObjet
   
	ld a,(positionStart) : add 1 : ld (positionStart),a 
	call drawIndicator

	ret
leftPosition
	ld a,(newKey) : bit bitLeft,a :	ret nz
	ld a,(positionStart): and %11110000 : srl a : srl a : srl a : srl a : cp 0 : ret z

	call replaceCell : call checkObjet
	ld a,(positionStart) : sub 16 : ld (positionStart),a
	call drawIndicator

	ret



; *****************************
; *      KEY POSITION		 	*
; *****************************
updateKeyPosition
	ld a,(oldKey) : bit bitEspace,a : call nz,switchModeKey
	ld a,(currentModeKey) : cp 0 : ret z
	ld a,(oldKey) : bit bitUp,a : call nz,upKeyPosition
	ld a,(oldKey) : bit bitRight,a : call nz,rightKeyPosition
	ld a,(oldKey) : bit bitDown,a : call nz,downKeyPosition
	ld a,(oldKey) : bit bitLeft,a : call nz,leftKeyPosition
	ret

switchModeKey
	; mode 1 cle active
	; mode 0 pas de clef
	
	ld a,(newKey) : bit bitEspace,a :	ret nz
	ld a,(currentModeKey) : cp 1 : jp z,.reset
	inc a : ld (currentModeKey),a : call showKeyPosition : call drawModeKey : ret
	.reset
	xor a : ld (currentModeKey),a 
	; enleve la clef du level
	call getAddressLevel : ld a,&ff : ld (ix+7),a
	call loadEditor : call drawModeKey
	ret
upKeyPosition
	ld a,(newKey) : bit bitUp,a :	ret nz
	call getAddressLevel
   ld a,(ix+3)    ; nb colonne
   ld (nbLines),a :dec a : ld b,a
	;DEFB #ED,#FF
	ld a,(ix+7) : call checkPositionKey : ld (positionStart),a : and %1111
	cp 0 : ret z
	call replaceCell
   
	ld a,(positionStart) : dec a : ld (ix+7),a : ld (positionStart),a ; incremente x
	call drawKeyPosition
	ret
rightKeyPosition
	ld a,(newKey) : bit bitRight,a :	ret nz
	call getAddressLevel
   ld a,(ix+4)    ; nb colonne
   ld (nbRows),a :dec a : ld b,a
	ld a,(ix+7) : call checkPositionKey : ld (positionStart),a
	and %11110000 : srl a : srl a : srl a : srl a
	cp b : ret nc
	call replaceCell
   
	ld a,(positionStart) : add 16 : ld (ix+7),a : ld (positionStart),a ; incremente x
	call drawKeyPosition
	ret
downKeyPosition
	ld a,(newKey) : bit bitDown,a :	ret nz
	call getAddressLevel
   ld a,(ix+3)    ; nb colonne
   ld (nbLines),a :dec a : ld b,a
	;DEFB #ED,#FF
	ld a,(ix+7) : call checkPositionKey : ld (positionStart),a
	and %1111
	cp b : ret nc

	call replaceCell
   
	ld a,(positionStart) : add 1 : ld (ix+7),a : ld (positionStart),a ; incremente x
	call drawKeyPosition
	ret
leftKeyPosition
	ld a,(newKey) : bit bitLeft,a :	ret nz
	call getAddressLevel
	;DEFB #ED,#FF
	ld a,(ix+7) : call checkPositionKey : ld (positionStart),a
	and %11110000 : srl a : srl a : srl a : srl a
	cp 0 : ret z


	call replaceCell
	ld a,(positionStart) : sub 16 : ld (ix+7),a : ld (positionStart),a ; incremente x
	call drawKeyPosition
	ret
showKeyPosition
	ld a,(currentModeKey) : cp 0 : ret z
	call getAddressLevel
	ld a,(ix+7) : call checkPositionKey : ld (positionStart),a
	call drawKeyPosition
	ret
checkPositionKey
	cp &FF : ret nz : xor a
	ret	
drawKeyPosition
	ld a,(positionStart) : ld (oldPositionStart),a : call getColor : ld (oldColor),a
	ld a,(oldPositionStart) : and %11110000 : srl a : srl a : ld (colonne),a 
	ld a,(oldPositionStart) : and %1111 : ld (currentLine),a 
	ld a,12 : ld (currentSprite),a : call drawcells

	ret
drawModeKey
	ld hl,&00F8;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
 	ld (adrPrint),hl ; save la position
	ld ix,textModeKey : ld a,(currentModeKey) : add &30 : ld (ix+8),a

	ld hl,textModeKey
   call printText ; print.asm
	ret

	ret
; *****************************
; *      CURSOR START		 	*
; *****************************

updateCursorStart
	ld a,(oldKey) : bit bitUp,a : call nz,upCursorStart
	ld a,(oldKey) : bit bitRight,a : call nz,rightCursorStart
	ld a,(oldKey) : bit bitDown,a : call nz,downCursorStart
	ld a,(oldKey) : bit bitLeft,a : call nz,leftCursorStart
	
	ret

upCursorStart
	ld a,(newKey) : bit bitUp,a :	ret nz
	call getAddressLevel
   ld a,(ix+3)    ; nb colonne
   ld (nbLines),a :dec a : ld b,a
	;DEFB #ED,#FF
	ld a,(ix) : ld (positionStart),a : and %1111
	cp 0 : ret z
	call replaceCell
   
	ld a,(positionStart) : dec a : ld (ix),a : ld (positionStart),a ; incremente x
	call drawIndicator
	ret


rightCursorStart
	ld a,(newKey) : bit bitRight,a :	ret nz
	call getAddressLevel
   ld a,(ix+4)    ; nb colonne
   ld (nbRows),a :dec a : ld b,a
	ld a,(ix) : ld (positionStart),a
	and %11110000 : srl a : srl a : srl a : srl a
	cp b : ret nc
	call replaceCell
   
	ld a,(positionStart) : add 16 : ld (ix),a : ld (positionStart),a ; incremente x
	call drawIndicator
	ret
downCursorStart
	ld a,(newKey) : bit bitDown,a :	ret nz
	call getAddressLevel
   ld a,(ix+3)    ; nb colonne
   ld (nbLines),a :dec a : ld b,a
	;DEFB #ED,#FF
	ld a,(ix) : ld (positionStart),a
	and %1111
	cp b : ret nc

	call replaceCell
   
	ld a,(positionStart) : add 1 : ld (ix),a : ld (positionStart),a ; incremente x
	call drawIndicator
	ret
leftCursorStart
	ld a,(newKey) : bit bitLeft,a :	ret nz
	call getAddressLevel
	;DEFB #ED,#FF
	ld a,(ix) : ld (positionStart),a
	and %11110000 : srl a : srl a : srl a : srl a
	cp 0 : ret z


	call replaceCell
	ld a,(positionStart) : sub 16 : ld (ix),a : ld (positionStart),a ; incremente x
	call drawIndicator
	ret
replaceCell
	
	ld a,(positionStart) : ld (oldPositionStart),a : call getColor : ld (oldColor),a
	ld a,(oldPositionStart) : and %11110000 : srl a : srl a : ld (colonne),a 
	ld a,(oldPositionStart) : and %1111 : ld (currentLine),a 
	ld a,(oldColor) 
	ld (currentSprite),a : call drawcells
	ret
; *****************************
; *       	LEVEL 			 	*
; *****************************

levelDown:
	ld a,(newKey) : bit bitKeyE,a : ret nz
	
	ld a,(currentLevel)
   cp 1 ; maxlevel
   jr z,.endSubLevel
   ;DEFB #ED,#FF
   dec A
   ld (currentLevel),A
   ;jp init
   call loadEditor
   ret

   .endSubLevel:
   ld a,maxLevel
   ld (currentLevel),A
	call loadEditor
	ret

levelUp:
	ld a,(newKey) : bit bitKeyR,a : ret nz
	
	ld a,(currentLevel)
   cp maxLevel ; maxlevel
   jr z,.endAddLevel
   ;DEFB #ED,#FF
   inc A
   ld (currentLevel),A
   ;jp init
   call loadEditor
   ret

   .endAddLevel:
   ld a,1
   ld (currentLevel),A
	call loadEditor
	ret

; *****************************
; *       	COLORS			 	*
; *****************************
updateColors

	ld a,(oldKey) : bit bitUp,a : call nz,upColors

	ld a,(oldKey)
	bit bitDown,a
	call nz,downColors

	jp endUpadteKeysEditor

upColors:
	ld a,(newKey) : bit bitUp,a : ret nz
	call getAddressLevel
	ld a,(ix+1)
   cp 6 ; maxlevel
   ret z 
   ;DEFB #ED,#FF
   inc a
   ld (ix+1),a
	ld (maxColor),a
	call loadEditor

   ret

downColors:
	ld a,(newKey) : bit bitDown,a : ret nz
	
	call getAddressLevel
	ld a,(ix+1)
   cp 2 ; maxlevel
   ret z 
   dec a
   ld (ix+1),a
   ld (maxColor),a
	call loadEditor
	ret
DrawColors
	xor a
	ld (offsetX),a
	; nettoyage du hub en affichant un rectangle remplis
	ld hl,&C680
	ld bc,&4010
	ld a,%11000000
	call FillRect
	call DrawHub

	ret

; *****************************
; *       	NB ESSAIS		 	*
; *****************************
updateMaxTry

	ld a,(oldKey)
	bit bitUp,a
	call nz,upMaxTry

	ld a,(oldKey)
	bit bitDown,a
	call nz,downMaxTry

	jp endUpadteKeysEditor

upMaxTry:
	ld a,(newKey) : bit bitUp,a : ret nz
  ; DEFB #ED,#FF

	call getAddressLevel
	ld a,(ix+2)
   cp 28 ; maxlevel
   ret z 
   inc a
   ld (ix+2),a
   call DrawMaxTry
   ret

downMaxTry:
	ld a,(newKey) : bit bitDown,a : ret nz
	
	call getAddressLevel
	ld a,(ix+2)
   cp 1 ; maxlevel
   ret z 
   ;DEFB #ED,#FF
   dec a
   ld (ix+2),a
   call DrawMaxTry
   ret
DrawMaxTry
	; recupere le poids fort
	ld iy,textMaxTry
	call getAddressLevel ; ix = adresse du level courant
	ld a,(ix+2)
	ld d,a
	ld e,10
	call div
	; update unité
	add &30
	ld (iy+8),a
	ld a,d
	add &30
	ld (iy+7),a


	ld hl,&12E0;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
	ld (adrPrint),hl ; save la position
	ld hl,textMaxTry
	call printText
	
	ret
; *****************************
; *       	RANDOM			 	*
; *****************************

upActionRandom
	
	ld a,(newKey)
	bit bitUp,a
	ret nz
	;DEFB #ED,#FF
	call getAddressLevel
	ld h,(ix+5) ; recupere poids faible de la seed
	ld l,(ix+6) ; recupere poids faible de la seed
	ld de,&f 
	add hl,de
	ld (ix+5),h
	ld (ix+6),l
	
	call loadEditor 
	call DrawInfoRandom
	ret
downActionRandom
	
	ld a,(newKey)
	bit bitDown,a
	ret nz
	;DEFB #ED,#FF
	call getAddressLevel
	ld h,(ix+5) ; recupere poids faible de la seed
	ld l,(ix+6) ; recupere poids faible de la seed
	ld de,&f 
	sbc hl,de
	ld (ix+5),h
	ld (ix+6),l
	
	call loadEditor 
	call DrawInfoRandom
	ret
DrawInfoRandom
	; recupere le poids fort
	ld iy,textRandom
	call getAddressLevel ; ix = adresse du level courant

	; poids faible
	ld a,(ix+6)
	and %00001111 ; poids faible
	call ConvertHex
	ld (iy+8),a

	ld a,(ix+6)
	;DEFB #ED,#FF
	and %11110000 : srl a : srl a: srl a : srl a; pods fort
	call ConvertHex
	ld (iy+7),a

	; poids fort
	ld a,(ix+5)
	and %00001111 ; poids faible
	call ConvertHex
	ld (iy+6),a

	ld a,(ix+5)
	;DEFB #ED,#FF
	and %11110000 : srl a : srl a: srl a : srl a; pods fort
	call ConvertHex
	ld (iy+5),a


	ld hl,&08E0;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
	ld (adrPrint),hl ; save la position
	ld hl,textRandom
	call printText
	
	ret
ConvertHex:
	cp 10 : jr nc,hex

	; update unité
	add &30 : ret
	hex:
	add 65-10
	ret

; *****************************
; *       	SIZE  			 	*
; *****************************

leftActionSize
	ld a,(newKey)
	bit bitLeft,a
	ret nz
	call getAddressLevel
	ld a,(ix+4) ; recupere nb de colonne du level
	cp 1 : ret z
	dec a
	ld (ix+4),a
	call resizeCursorStart
	call loadEditor 

	ret
rightActionSize

	ld a,(newKey) : bit bitRight,a :	ret nz
	call getAddressLevel ; levelManager.asm
	ld a,(ix+4) ; recupere nb de colonne du level
	cp maxRows : ret z
	inc a
	ld (ix+4),a

	call loadEditor 

	ret

upActionSize
	ld a,(newKey)
	bit bitUp,a
	ret nz
	call getAddressLevel ; levelManager.asm
	ld a,(ix+3) ; recupere nb de ligne du level
	cp maxLines : ret z
	inc a
	ld (ix+3),a

	call loadEditor

	ret
downActionSize
	ld a,(newKey)
	bit bitDown,a
	ret nz
	call getAddressLevel ; levelManager.asm
	ld a,(ix+3) ; recupere nb de ligne du level
	cp 1 : ret z
	dec a
	ld (ix+3),a
	call resizeCursorStart
	call loadEditor

	ret
resizeCursorStart
	call getAddressLevel
   ld a,(ix+3) : ld b,a ; recupere maxLine
	;DEFB #ED,#FF
	ld a,(ix) : and %1111 :cp b : jr c,.testX
	;DEFB #ED,#FF
	ld a,b : and %1111 : dec a : ld b,a 
	ld a,(ix) : and %11110000 : or b : ld (ix),a
	.testX
	;DEFB #ED,#FF
   ld a,(ix+4) : ld b,a ; recupere maxRow
	ld a,(ix) : and %11110000 : srl a : srl a : srl a : srl a :cp b : ret c
	ld a,b : dec a : sla a : sla a: sla a: sla a: ld b,a
	ld a,(ix) : and %1111 : or b : ld (ix),a  
	ret

escapeActionEditor

	ld a,(newKey)
	bit bitEscape,a
	ret nz

	ld e,sceneMenu
   call changeScene ; sceneManager
	ret
espaceActionEditor:
   ld a,(newKey)
	bit bitEspace,a
	ret nz

   ret
drawModeEditor:
	ld hl,&0CF8;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
 	ld (adrPrint),hl ; save la position
	ld a,(currentMode)
	sla a: sla a : sla a ; *8 =  7 lettres + 0 
	ld de,0
	ld e,a
	ld hl,textMode
	add hl,de
   call printText ; print.asm
	ret
