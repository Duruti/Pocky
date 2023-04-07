ON  EQU 1
OFF EQU 0

macro Asic switch
	if {switch}
	ld 		bc,#7FB8
	out 	(c),c
	else
	ld 		bc,#7FA0
	out 	(c),c
	endif
mend

buildcpr    ; indique que l'on veut construire une cartouche
bank 0      ; initialisation commence toujours en BANK 0
org 0       ; le tout premier code commence toujours à l'adresse 0
di          ; on désactive les INT au cas ou on reset soft
Asic OFF    ; dans le cas où l'on reboot le soft avec l'Asic ON
jr rom_init ; saut par dessus les interruptions et certaines données


; séquence pour délocker l'ASIC
unlockdata defb #ff,#00,#ff,#77,#b3,#51,#a8,#d4,#62,#39,#9c,#46,#2b,#15,#8a,#cd,#ee
; valeurs pour tous les registres du CRTC
crtcdata   defb #3f, 48, 50, #8e, 38, 0, 34, 35, #00, #07, #00,#00,#20,#00,#00,#DD

; au cas où nous aurions besoin d'une interruption à l'initialisation, 
; on doit interrompre le vecteur à #38
	org 	#38
	; ei
	ret

;****************** ROM INIT ***************
rom_init

	
   nop : nop
;********************* MANDATORY TO EXECUTE WITH A C4CPC ***************
	im 		1 					; don't know why but C4CPC corrupt interruption mode!
;***
	ld 		bc,#7FC0 			; default memory conf
	out 	(c),c
	ld 		sp,0     			; raz 64K with stack
	ld 		bc,4
	ld 		hl,0
	.raz
	repeat 	32
	push 	hl
	rend
	djnz .raz
	dec 	c
	jr 		nz,.raz
	;DEFB #ED,#FF

	; CrtcSettings
	ld hl,crtcdata
	ld 			c,0
	ld 			e,16
	.loop
	out 		(c),c
	ld 			a,(hl)
	inc 		hl
	inc 		b
	out 		(c),a
	dec 		b
	inc 		c
	dec 		e
	jr 			nz,.loop	

	ld bc,&BC0C  ; selectionne R12
	out (c),c  
	ld bc,&bd00+%00110000  ; place l'ecran en &c000 et en 16ko
   out (c),c                 
	ld bc,&BC0D  ; selectionne R13
	out (c),c  
	ld bc,&bd00+0  ; mets tout a zero
   out (c),c                 
		
	;formatage de l'écran

	ld	bc,#bc01
	ld	a,40
	out	(c),c
	ld	bc,#bd00
	out	(c),a

	ld	bc,#bc02
	ld	a,46
	out	(c),c
	ld	bc,#bd00
	out	(c),a

	ld	bc,#bc06
	ld	a,25
	out	(c),c
	ld	bc,#bd00
	out	(c),a

	ld	bc,#bc07
	ld	a,30
	out	(c),c
	ld	bc,#bd00
	out	(c),a

	;init du PPI
	ld bc,#f782                     ; setup initial PPI port directions
	out (c),c
	ld bc,#f400                     ; set initial PPI port A (AY)
	out (c),c
	ld b,#f6                        ; set initial PPI port C (AY direction)
	out (c),c
	ld bc,#EF7F                     ; firmware printer init d0->d6=1
	out (c),c

	ld sp,&100 ; met la pile en &100
 	; -------------------------------


	ld bc,#DF01+#80 : out (c),c  ; connection ROM 1 sur cartouche physique
	ld bc,#7F00+%10000000 : out (c),c ; connection en ROM haute(c000) et (basse 0-3FFF)
	
	ld de,start : ld hl,&c000 : ld bc,endVariable-start : ldir
	;DEFB #ED,#FF
	ld bc,#DF02+#80 : out (c),c  ; connection ROM 1 sur cartouche physique
	
	ld de,startGFX
	ld hl,&c000 : ld bc,endGFX-startGFX : ldir

	ld bc,#DF03+#80 : out (c),c  ; connection ROM 1 sur cartouche physique
	ld de,startLevel :
	ld hl,&c000 : ld bc,end-startLevel : ldir

	ld bc,#DF00+#80 : out (c),c  ; connection ROM 1 sur cartouche physique
	ld bc,#7F00+%10001100 : out (c),c ; deconnecte les ROMs haute et basse
	
	
	
	;DEFB #ED,#FF
	jp &100


;**************************** END OF MANDATORY CODE ********************

; unlock ASIC so we can access ASIC registers (Kevin Thacker)

; AsicUnlock
; 	ld 		b,#bc
; 	ld 		hl,unlockdata
; 	ld 		e,17
; 	.loop
; 	inc 	b
; 	outi
; 	dec 	e
; 	jr 		nz,.loop

; CrtcSettings
; ld 			c,0
; ld 			e,16
; .loop
; out 		(c),c
; ld 			a,(hl)
; inc 		hl
; inc 		b
; out 		(c),a
; dec 		b
; inc 		c
; dec 		e
; jr 			nz,.loop	


; R12 selectionne et Ecran en #c000

; LD BC,#BC00+12:OUT (C),C
; LD BC,#BD00+%00110000:OUT (C),C


; formatage de l'écran

; ld	bc,#bc01
; ld	a,40
; out	(c),c
; ld	bc,#bd00
; out	(c),a

; ld	bc,#bc02
; ld	a,46
; out	(c),c
; ld	bc,#bd00
; out	(c),a

; ld	bc,#bc06
; ld	a,25
; out	(c),c
; ld	bc,#bd00
; out	(c),a

; ld	bc,#bc07
; ld	a,30
; out	(c),c
; ld	bc,#bd00
; out	(c),a


; Asic On

; all colors to black and sprites disabled 
;(DO NOT USE LDIR with a real CPC except if you like the red color ;)

; AsicRazParam
; 	ld 		hl,#6000
; 	ld 		de,#6400
; 	ld 		b,128
; 	xor 	a
; .loop
; 	ld 		(hl),a
; 	ld 		(de),a
; 	inc 	l
; 	inc 	e
; 	djnz 	.loop
	
; init du PPI
; ld bc,#f782                     ; setup initial PPI port directions
; out (c),c
; ld bc,#f400                     ; set initial PPI port A (AY)
; out (c),c
; ld b,#f6                        ; set initial PPI port C (AY direction)
; out (c),c
; ld bc,#EF7F                     ; firmware printer init d0->d6=1
; out (c),c

; initialisation de la pile !!!
; ld	sp,#bbfe
; asic off


; Programme principale
; 	LD 		BC,#DF01+#80:OUT (C),C				; on choisit DE LIRE la ROM 01 (#01)
; 	LD 		BC,#7FC0:OUT (c),c					; on choisit D'ECRIRE  dans la RAM central
; 	LD		BC,#7F00+%10000000:OUT (C),C 		; connexion Upper ROM et Lower ROM (et écran en mode 0.)
; 	ld		hl,#c000							; lecture
; 	ld		de,#8000							; ecriture
; 	ld		bc,#4000							; longueur
; 	LDIR

; jp	#8000


; bank 1
; include"programme.asm"

; bank 2
; incbin"images\image.scr"

; bank 3
; incbin"images\screen.kit"












	
	
	
	