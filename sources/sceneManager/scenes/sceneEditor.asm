textEditorInfo db "LEVEL   EDITOR",0
currentMode db 1
textMode: 
	;   12345678
	db "SIZE   ",0
	db "RANDOM ",0
	db "KEY    ",0
	db "WALL   ",0
	db "MODE 5 ",0
	db "MODE 6 ",0
	db "MODE 7 ",0
	db "MODE 8 ",0

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


	;ei
	;call overcanVertical
	;call loadInterruption

	call drawLevel ; initGame.asm
	ld hl,paletteMode0
   call loadPaletteGA ; print.asm

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

	;Right 
	ld d,0 
   call TestKeyboard ; a contient le test
	and %00000010 ; ne garde que le bit 7    	
	or e
	ld e,a

	;Up 
	ld d,0 
    	call TestKeyboard ; a contient le test
	and %00000001 ; ne garde que le bit 7    	
	sla a : sla a:sla a: sla a
	or e
	ld e,a

	;down 
	ld d,0 
    	call TestKeyboard ; a contient le test
	and %00000100 ; ne garde que le bit 7    	
	sla a 
	or e
	ld e,a

	;esc 
	ld d,8 
   call TestKeyboard ; a contient le test
	and %00000100 ; ne garde que le bit 2    	
	or e
	ld e,a

	;key R 
	ld d,6 ; 5 
   call TestKeyboard ; a contient le test
	and %00000100 ; ne garde que le bit 2    	
	sla a : sla a : sla a   
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
	call nz,mode3Editor	

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

	ld a,(oldKey)
	bit bitKeyR,a
	call nz,KeyRActionEditor

	ret
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
mode3Editor:
	ld a,(newMode)
	bit bitMode3,a
	ret nz
	ld a,3-1
	ld (currentMode),A
	call drawModeEditor
	
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


KeyRActionEditor
	
	ld a,(newKey)
	bit bitKeyR,a
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

	ret

leftActionEditor
	ld a,(newKey)
	bit bitLeft,a
	ret nz
	call getAddressLevel
	ld a,(ix+4) ; recupere nb de colonne du level
	cp 1 : ret z
	dec a
	ld (ix+4),a

	call loadEditor 

	ret
rightActionEditor
	ld a,(newKey)
	bit bitRight,a
	ret nz
	call getAddressLevel ; levelManager.asm
	ld a,(ix+4) ; recupere nb de colonne du level
	cp maxRows : ret z
	inc a
	ld (ix+4),a

	call loadEditor 

	ret

upActionEditor
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
downActionEditor
	ld a,(newKey)
	bit bitDown,a
	ret nz
	call getAddressLevel ; levelManager.asm
	ld a,(ix+3) ; recupere nb de ligne du level
	cp 1 : ret z
	dec a
	ld (ix+3),a

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
drawModeEditor:
	ld hl,&0aF0;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
 	ld (adrPrint),hl ; save la position
	ld a,(currentMode)
	sla a: sla a : sla a ; *8 =  7 lettres + 0 
	ld de,0
	ld e,a
	ld hl,textMode
	add hl,de
   call printText ; print.asm
	ret
