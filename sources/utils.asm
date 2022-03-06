; affiche à l'écran une chaine de caractere finissant par 0
; hl = adresse chaine à afficher
printTextVecteur:
   ld a,(hl)
   cp 0
   ret z
   call &bb5A
   inc hl
   jp printText

locate :
        call &bb75
        ret

FillRect:
        ; hl = adresse destination
        ; a = valeur a remplir
        ; bc = colonne, ligne
	ld d,b
		
	push af
	fillRowRight
		ld (hl),a
		inc hl 
		djnz fillRowRight

	dec c
	jp z,endFill
 	      
	dec hl
	call calcul64
	
	
	ld b,d
	pop af
	push af
	
	fillRowLeft
		ld (hl),a
		dec hl 
		djnz fillRowLeft

	dec c
	jp z,endFill
	inc hl
	call calcul64

	ld b,d
	pop af
	push af
	

	jp fillRowRight
	
endFill
	pop af
	ret
calcul64
	ld a,h
	add 8
	ld h,a

	ret nc
	push bc
	ld bc,#C040
	add hl,bc
	pop bc
	ret


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

div :
 ;;https://wikiti.brandonw.net/index.php?title=Z80_Routines:Math:Division
 ; div d/e => result d , a => modulo
   xor	a
   ld	b, 8

   loopDiv:
        sla	d
        rla
        cp	e
        jr	c, $+4
        sub	e
        inc	d
        
        djnz	loopDiv
        
        ret


rnd:
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

random:
        push    hl
        push    de
        ;DEFB #ED,#FF
        rndseed:
                ld  hl,&1111   ; yw -> zt
                ld  de,&C0DE   ; xz -> yw
                ld  (rndseed+4),hl  ; x = y, z = w
                ld  a,l         ; w = w ^ ( w << 3 )
                add a,a
                add a,a
                add a,a
                xor l
                ld  l,a
                ld  a,d         ; t = x ^ (x << 1)
                add a,a
                xor d
                ld  h,a
                rra             ; t = t ^ (t >> 1) ^ w
                xor h
                xor l
                ld  h,e         ; y = z
                ld  l,a         ; w = t
                ld  (rndseed+1),hl
        pop     de
        pop     hl
        
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
	ld a,&30 ; &3F
	Ld (hl),a
	Ld bc,#4000
	Ldir
	ret
	nop
ret

