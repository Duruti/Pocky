loadEditor:
   ;DEFB #ED,#FF
   
   call initKeyboard
	;di
   call clearHud
	ld hl,&C000
	ld bc,&40E0-1
	ld a,%11000000 ;&30
	call FillRect
   ;call vbl
   ld hl,&0aF0;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
 	ld (adrPrint),hl ; save la position
   ld hl,textEditorInfo
   call printText
	;ei
	;call overcanVertical
	;call loadInterruption

	call drawLevel
	ld hl,paletteMode0
   call loadPaletteGA

   ret


updateEditor:
;DEFB #ED,#FF
    call getKeys   ; controls keys and Joystick
    call updateKeysEditor ; update actions/keys
      ld a,(newKey) ; sauvegarde les etats des touches pour la prochaine boucle
      ld (oldKey),a
   ret
   
textEditorInfo db "LEVEL EDITOR",0

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

	call loadEditor

	ret
rightActionEditor
	ld a,(newKey)
	bit bitRight,a
	ret nz
	call getAddressLevel
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
	call getAddressLevel
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
	call getAddressLevel
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
   call changeScene
	ret
espaceActionEditor:
   ld a,(newKey)
	bit bitEspace,a
	ret nz

   ret
