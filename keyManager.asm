



bitEspace equ 7  ; d=5
bitLeft equ 0 ; d=1
bitRight equ 1 ; d=0
bitUp equ 4 ; d=0
bitDown equ 3 ; d=0

initKeyboard:
	xor a
	ld (exit),a
	ld a,&FF
	ld (oldKey),a
   ret

    	di ; coupe les interruptions pour pas avoir de conflit
;;bcl:

; FRAME  	LD B,#F5

;; FRM     IN A,(C):RRA:JR NC,FRM 

; 	call getKeys
; 	call updateKeys

; 	ld a,(newKey) ; sauvegarde les etats des touches pour la prochaine boucle
; 	ld (oldKey),a

; 	ld a,(exit)    	; test si on quitte le programme
;  	cp 1
;     	jr nz,bcl
    
; fin:
; 	ei
; 	ret

getKeys:
	;xor a
	;ld e,a
	
	call vbl
	
	ld e,&0
	;ld e,a ; save dans e

	; bit 7

	ld d,5 ; espace
    	call TestKeyboard ; a contient le test
	and %10000000 ; ne garde que le bit 7    	
	or e 
	ld e,a


	;bit 0 
	ld d,1 ; espace
    	call TestKeyboard ; a contient le test
	and %00000001 ; ne garde que le bit 7    	
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

	ld (newKey),a	
	
	ret

updateKeys:

	ld a,(oldKey)
	bit bitEspace,a
	call nz,espaceAction	
	
	ld a,(oldKey)
	bit bitLeft,a
	call nz,leftAction	

	ld a,(oldKey)
	bit bitRight,a
	call nz,rightAction	
		
	ld a,(oldKey)
	bit bitUp,a
	call nz,upAction

	ld a,(oldKey)
	bit bitDown,a
	call nz,downAction


	ret

espaceAction:
	ld a,(newKey)
	bit bitEspace,a
	ret nz
   call ChangeColorCursor
	
   ld a,1
   ld (exit),a	
	
   ret

leftAction:
	ld a,(newKey)
	bit bitLeft,a
	ret nz
   call decCursor
   ; action a faire
	ret
rightAction:
	ld a,(newKey)
	bit bitRight,a
	ret nz
   ; action a faire
   call incCursor
	ret

upAction:
	ld a,(newKey)
	bit bitUp,a
	ret nz
	if cheat
   	jp addLevel1
	ENDIF
   ; action a faire
	ret
downAction:
	ld a,(newKey)
	bit bitDown,a
	ret nz
	if cheat
  	   jp decLevel
	endif
   ; action a faire
	ret


; en double
testKeyboard2:
	ld bc,&f40e  ; Valeur 14 sur le port A
        out (c),c
        ld bc,&f6c0  ; C'est un registre
        out (c),c    ; BDIR=1, BC1=1
        ld bc,&f600  ; Validation
        out (c),c
        ld bc,&f792  ; Port A en entrée
        out (c),c
        ld a,d       ; A=ligne clavier
        or %01000000 ; BDIR=0, BC1=1
        ld b,&f6
        out (c),a
        ld b,&f4     ; Lecture du port A
        in a,(c)     ; A=Reg 14 du PSG
        ld bc,&f782  ; Port A en sortie
        out (c),c
        ld bc,&f600  ; Validation
        out (c),c
	ret

; -------------------------------
oldKey: db 0
newKey: db 0
exit: 	db 0