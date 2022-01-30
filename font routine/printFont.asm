org #4000

heightFont equ 8
sizeBlocChar equ 8*2 ;8*2

ld hl,Palette
call loadPalette
	ld hl,&0064 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
	ld (adrPrint),hl ; save la position

	ld hl,texte ; hl l'adresse du texte
	call printText


	ld hl,&0074 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
	ld (adrPrint),hl ; save la position

	ld hl,texte2 ; hl l'adresse du texte
	call printText

	ret


	ret


PrintChar:
	push bc
	ldi:ldi
	dec de : dec de
	call calcul
	pop bc
	djnz printChar
	ret

printText:
	; affiche en mode RPG
	FRAME  	LD B,#F5
	FRM     IN A,(C):RRA:JR NC,FRM 
	ld a,(timer)
	inc a
	ld (timer),a
	cp 30
	jr nz,printText
	xor a
	ld (timer),a

	
   	ld a,(hl)
   	cp 0
   	ret z

 	push hl
	cp &20 ; si espace on affiche rien mais on decalle de 1 vers la droite
	jr z,finPrintChar
	call convertChar 
	call calcAdrPrint

	ld b,heightFont
   	call printChar
finPrintChar 
	ld hl,(adrPrint)
	inc h
	ld (adrPrint),hl	
	pop hl  	
	inc hl
   	jp printText
convertchar:
	; parse le code ASCII vers la font
	sub 32
	;ret
	; la fonte utilise pour le test est complete 32-127 pas besoin de parser
	ld hl,tableChar
	add a,l
	ld l,a
	ld a,(hl)
	ret

calcAdrPrint:
	
	call multi26
	ld de,font
	add hl,de ; hl nouvelle adresse du caractere Source
	push hl

	; pour y
	ld de,(adrPrint)
	ld hl,0
	ld d,0
	ld l,e
	add hl,de
	ex hl,de
	
	ld hl,lignes
	add hl,de
	ld e,(hl)
	inc hl
	ld d,(hl)
	
	; pour x
	ld hl,(adrPrint)
	sla h ; *2 
	ld l,h
	ld h,0
	add hl,de
	ex hl,de

	pop hl

	ret

calcul:  
	ld a,d                    ;on recopie D dans A
        add a,#08                  ;on ajoute #08 à A
        ld d,a                    ;on recopie A dans D
                        ;DE contient la nouvelle adresse
        ret nc
                ;si débordement on continue donc ici et cela signifie qu'on doit ajouter #C050 à notre adresse
        ex hl,de                  ;on a besoin que notre adresse soit dans HL pour pouvoir lui additionner quelque chose
                ;l'adresse est maintenant dans HL
        ld bc,#C050               ;on met #C050 dans BC
        add hl,bc                  ;on additionne HL et BC
                ;HL contient maintenant l'adresse de la ligne inférieure mais on la veut dans DE
        ex hl,de                  ;on refait l'échange et DE contient donc l'adr
 	       
	ret                      

multi26: ; 26 = 13*2
	; a nb a multiplier
	; result hl
	
	ld b,sizeBlocChar
	ld d,0
	ld e,a
	ld hl,0
	bclMulti26
		add hl,de
		djnz bclMulti26
	ret


loadPalette

; Charge la palette de couleur	
; mettre dans HL l'adresse de la palette

ld a,0
setcol:
	push hl
	push af
	ld b,(hl)
	ld c,b

	call &bc32
	pop af
	pop hl
	inc hl
	inc a
	cp &10
	jr nz,setcol
	ret





timer: db 0
font: incbin "font3.bin"
palette : db 1,22,10,26
texte: db "La fabuleuse histoire de cuisine",0
texte2: db "solitaire de DEADSYSTEM",0
;texte: db "ABCDEFGHIJKLMNOPQRSTUVWXYZ",0
;texte2: db "abcdefghijklmnopqrstuvwxyz",0
adrPrint: dw 1
align 256
tableChar ; table pour parser le code ascii en fonction de la font
	db 79,75,79,51,79,79,25,53,22,49,79,77,21,78,74,50
	db 47,44,71,18,45,72,19,46,73,20,76,23,79,24,79,48
	db 79,0,27,54,1,28,55,2,29,56,3,30,57,4,31,58
	db 5,32,59,6,33,60,7,34,61,8,35,79,79,79,79,79
	db 79,62,9,36,63,10,37,64,11,38,65,12,39,66,13,40,67,14,41,68,15,42
	db 69,16,43,70,17,44,71,18,45,72
	db 0,39,0,0,0,0,0,0,0,0,0,0,0,0,36,0
	db 26,27,28,29,30,31,32,33,34,35,38,0,0,0,0,40
	db 41,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14
	db 15,16,17,18,19,20,21,22,23,24,25,26
LIGNES: 
      DW &C000,&C800,&D000,&D800,&E000,&E800,&F000,&F800 ; 0-7
      DW &C050,&C850,&D050,&D850,&E050,&E850,&F050,&F850 ; 8-15
      DW &C0A0,&C8A0,&D0A0,&D8A0,&E0A0,&E8A0,&F0A0,&F8A0 ; 16-23
      DW &C0F0,&C8F0,&D0F0,&D8F0,&E0F0,&E8F0,&F0F0,&F8F0 ; 24-31
      DW &C140,&C940,&D140,&D940,&E140,&E940,&F140,&F940 ; 32-39
      DW &C190,&C990,&D190,&D990,&E190,&E990,&F190,&F990 ; 40-47
      DW &C1E0,&C9E0,&D1E0,&D9E0,&E1E0,&E9E0,&F1E0,&F9E0 ; 48-55
      DW &C230,&CA30,&D230,&DA30,&E230,&EA30,&F230,&FA30 ; 56-63
      DW &C280,&CA80,&D280,&DA80,&E280,&EA80,&F280,&FA80 ; 64-71
      DW &C2D0,&CAD0,&D2D0,&DAD0,&E2D0,&EAD0,&F2D0,&FAD0 ; 72-79
      DW &C320,&CB20,&D320,&DB20,&E320,&EB20,&F320,&FB20 ; 80-87
      DW &C370,&CB70,&D370,&DB70,&E370,&EB70,&F370,&FB70 ; 88-95
      DW &C3C0,&CBC0,&D3C0,&DBC0,&E3C0,&EBC0,&F3C0,&FBC0 ; 96-103
      DW &C410,&CC10,&D410,&DC10,&E410,&EC10,&F410,&FC10 ; 104-111
      DW &C460,&CC60,&D460,&DC60,&E460,&EC60,&F460,&FC60 ; 112-119
      DW &C4B0,&CCB0,&D4B0,&DCB0,&E4B0,&ECB0,&F4B0,&FCB0 ; 120-127
      DW &C500,&CD00,&D500,&DD00,&E500,&ED00,&F500,&FD00 ; 128-135
      DW &C550,&CD50,&D550,&DD50,&E550,&ED50,&F550,&FD50 ; 136-143
      DW &C5A0,&CDA0,&D5A0,&DDA0,&E5A0,&EDA0,&F5A0,&FDA0 ; 144-151
      DW &C5F0,&CDF0,&D5F0,&DDF0,&E5F0,&EDF0,&F5F0,&FDF0 ; 152-159
      DW &C640,&CE40,&D640,&DE40,&E640,&EE40,&F640,&FE40 ; 160-167
      DW &C690,&CE90,&D690,&DE90,&E690,&EE90,&F690,&FE90 ; 168-175
      DW &C6E0,&CEE0,&D6E0,&DEE0,&E6E0,&EEE0,&F6E0,&FEE0 ; 176-183
      DW &C730,&CF30,&D730,&DF30,&E730,&EF30,&F730,&FF30 ; 184-191
      DW &C780,&CF80,&D780,&DF80,&E780,&EF80,&F780,&FF80 ; 192-199