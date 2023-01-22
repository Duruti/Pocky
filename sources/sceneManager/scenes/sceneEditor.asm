textEditorInfo db "LEVEL EDITOR",0

loadEditor:
   ;DEFB #ED,#FF
   
   call initKeyboard ; keyManager.asm
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
   call printText ; print.asm
	;ei
	;call overcanVertical
	;call loadInterruption

	call drawLevel ; initGame.asm
	ld hl,paletteMode0
   call loadPaletteGA ; print.asm

   ret


updateEditor:
	;DEFB #ED,#FF
    call getKeys   ; controls keys and Joystick  keyManager.asm
    call updateKeysEditor ; update actions/keys
      ld a,(newKey) ; sauvegarde les etats des touches pour la prochaine boucle
      ld (oldKey),a
   ret
   


updateKeysEditor:
   ;DEFB #ED,#FF

	ld a,(oldKey)
	bit bitEspace,a
	call nz,espaceActionEditor	
	
	ld a,(oldKey)
	bit bitEscape,a
	call nz,escapeAction

	ld a,(oldKey)
	bit bitLeft,a
	call nz,leftActionEditor	

	ld a,(oldKey)
	bit bitRight,a
	call nz,rightActionEditor	
   ;DEFB #ED,#FF
		
	ld a,(oldKey)
	bit bitUp,a
	call nz,upActionEditor

	ld a,(oldKey)
	bit bitDown,a
	call nz,downActionEditor


	ret
leftActionEditor
	ld a,(newKey)
	bit bitLeft,a
	ret nz
	call getAddressLevel
	ld a,(ix+3) ; recupere nb de colonne du level
	cp 1 : ret z
	dec a
	ld (ix+3),a

	call loadEditor ; levelManager.asm

	ret
rightActionEditor
	ld a,(newKey)
	bit bitRight,a
	ret nz
	call getAddressLevel ; levelManager.asm
	ld a,(ix+3) ; recupere nb de colonne du level
	cp maxRows : ret z
	inc a
	ld (ix+3),a

	call loadEditor 

	ret

upActionEditor
	ld a,(newKey)
	bit bitUp,a
	ret nz
	call getAddressLevel ; levelManager.asm
	ld a,(ix+2) ; recupere nb de ligne du level
	cp maxLines : ret z
	inc a
	ld (ix+2),a

	call loadEditor

	ret
downActionEditor
	ld a,(newKey)
	bit bitDown,a
	ret nz
	call getAddressLevel ; levelManager.asm
	ld a,(ix+2) ; recupere nb de ligne du level
	cp 1 : ret z
	dec a
	ld (ix+2),a

	call loadEditor

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
