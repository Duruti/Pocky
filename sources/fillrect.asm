org #4000

call changeMode
call fillrect


ret



FillRect:
        ; hl = adresse destination
        ; a = valeur a remplir
        ; bc = colonne, ligne
	ld hl,&c000
	ld bc,&4019
	ld d,b
	ld a,255

	
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

changeMode:

ld bc,&bc00+1 : out (c),c ; R1 = Nombre de caracteres affichables sur une ligne .
ld bc,&bd00+32 : out (c),c ; 


ld bc,&bc00+2 : out (c),c ; R2 = Synchronisation de l'affichage horizontal
ld bc,&bd00+42 : out (c),c


ld bc,&bc00+6 : out (c),c ; R6 = Nombre de lignes caracteres affichables
ld bc,&bd00+32 : out (c),c


ld bc,&bc00+7 : out (c),c ; R7 = Synchronisation de l'affichage vertical
ld bc,&bd00+34 : out (c),c
	ret