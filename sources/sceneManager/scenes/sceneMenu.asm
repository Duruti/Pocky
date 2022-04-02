loadMenu
;DEFB #ED,#FF
       di
 ;      LD A,#C3:LD (#38),A
 ;      ld hl,restorInt+1
 ;      ld (#39),hl
 ;      ei
  
;DEFB #ED,#FF
   ; mode standart
   call modeStandart

   ; mode 0
   ld bc,&7f8c ; %10001100 bit 0,1 pour le mode
   out (c),c
   ; affichage image
   ld de,&c000
   ld hl,titleScreen
   ld bc,&4000
   ldir

   call vbl
   ; chargement palette
   ld hl,paletteMode0
   call loadPaletteGA
   ; border
     LD BC,#7F10:OUT (C),C:LD C,85:OUT (C),C

   ret
   
updateMenu:
   call getKeys   ; controls keys and Joystick
   call updateKeysMenu ; update actions/keys
   ld a,(newKey) ; sauvegarde les etats des touches pour la prochaine boucle
   ld (oldKey),a
   ret
   
updateKeysMenu:
   ;DEFB #ED,#FF

	ld a,(oldKey)
	bit bitEspace,a
	call nz,espaceActionMenu
	
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
espaceActionMenu:
   ld a,(newKey)
	bit bitEspace,a
	ret nz
   ld e,sceneGame
   call changeScene
   ret