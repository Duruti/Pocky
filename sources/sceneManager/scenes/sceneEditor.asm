loadEditor:
   ;DEFB #ED,#FF
   
   call initKeyboard

   call clearHud
ld hl,&C000
ld bc,&40E0-1
ld a,%11000000 ;&30
call FillRect
   ;call vbl
   ld hl,&0CF0;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
 	ld (adrPrint),hl ; save la position
   ld hl,textEditorInfo
   call printText
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
	
	; ld a,(oldKey)
	; bit bitLeft,a
	 ;call nz,espaceActionEditor	

	; ld a,(oldKey)
	; bit bitRight,a
	; call nz,rightAction	
   ;DEFB #ED,#FF
		
	 ;ld a,(oldKey)
	 ;bit bitUp,a
	 ;call nz,espaceActionEditor	
	; call nz,upAction

	; ld a,(oldKey)
	; bit bitDown,a
	; call nz,downAction


	ret
espaceActionEditor:
   ld a,(newKey)
	bit bitEspace,a
	ret nz
   ld e,sceneGame
   call changeScene
   ret
