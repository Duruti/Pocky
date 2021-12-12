TestKeyboard :
 	ld bc,#f40e  ; Valeur 14 sur le port A
   out (c),c
   ld bc,#f6c0  ; C'est un registre
   out (c),c    ; BDIR=1, BC1=1
   ld bc,#f600  ; Validation
   out (c),c
   ld bc,#f792  ; Port A en entrée
   out (c),c
   ld a,d       ; A=ligne clavier
   or %01000000 ; BDIR=0, BC1=1
   ld b,#f6
   out (c),a
   ld b,#f4     ; Lecture du port A
   in a,(c)     ; A=Reg 14 du PSG
   ld bc,#f782  ; Port A en sortie
   out (c),c
   ld bc,#f600  ; Validation
   out (c),c
   ret

random:
        push    hl
        push    de
        ld      hl,(randData)
        ld      a,r
        ld      d,a
        ld      e,(hl)
        add     hl,de
        add     a,l
        xor     h
        ld      (randData),hl
        pop     de
        pop     hl
        
        ret

randData dw &5000

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

vbl:
	push bc
        LD    B,#F5     ;adresse du port B du PPI
frm:    IN    A,(C)     ;On recupere l'octet contenu sur le port dans A
        RRA             ;On fait une rotation afin de recuperer le bit 0 dans le flag carry
        JR    NC,frm    ;tant que le flag carry n'est pas a 1 on boucle au label frm
	pop bc
	ret	

cls:
	Ld hl,#c000
	Ld de,#c001
	ld a,&3F
	Ld (hl),a
	Ld bc,#4000
	Ldir
	ret
	nop
ret


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