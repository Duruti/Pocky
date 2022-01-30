

heightFont equ 8
sizeBlocChar equ 8*2 ;8*2





;call changeMode

;call test
;ret

; ld hl,Palette
; call loadPalette
; 	ld hl,&0000;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
; 	ld (adrPrint),hl ; save la position

; 	ld hl,texte ; hl l'adresse du texte
; 	ld b,32
; loopMain

	
; 	push bc
; 	push hl
; 	ld de,(adrPrint)
; 	push de
; 	call printText

; 	pop hl
; 	ld bc,8
; 	add hl,bc
; 	ld (adrPrint),hl

; 	pop hl
; 	ld bc,33
; 	add hl,bc
; 	pop bc
; 	djnz loopMain	

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
	; hl adresse du texte

	; affiche en mode RPG
;	jr speed
   call vbl
	ld a,(timerTexte)
	inc a
	ld (timerTexte),a
	cp 1 ; vitesse
	jr nz,printText
	xor a
	ld (timerTexte),a

speed	
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

PrintA:
   cp &20
   ret z
   call convertChar 
	call calcAdrPrint

	ld b,heightFont
   call printChar
   ret



calcAdrPrint:
	
	call multiSize
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
        ld bc,#C040               ;on met #C050 dans BC
        add hl,bc                  ;on additionne HL et BC
                ;HL contient maintenant l'adresse de la ligne inférieure mais on la veut dans DE
        ex hl,de                  ;on refait l'échange et DE contient donc l'adr
 	       
	ret                      

multiSize: ; 26 = 13*2
	; a nb a multiplier
	; result hl
	
	ld b,sizeBlocChar
	ld d,0
	ld e,a
	ld hl,0
	bclMultiSize
		add hl,de
		djnz bclMultiSize
	ret

test

	ld hl,&c000
	ld de,&800
	ld b,30
	loop
		ld (hl),255
		add hl,de
		;inc hl
		djnz loop
	ret

paletteGA db #54,#59,#46,#49,#4B,#5C,#58,#43,#4E,#45,#44,#4C,#4F,#46,#5F,#59

loadPaletteGA:

; Charge la palette de couleur	
; mettre dans HL l'adresse de la palette
     ;   ld hl,palette
        ld bc,&7F00
        bclPalGA:
               
                ld d,(hl) : inc hl
                out (c),c : out (c),d
                inc c
                ld a,c
                cp 16
                jr nz,bclPalGA
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



timerTexte: db 0
font: incbin "font3.bin"
;palette : db 1,22,10,26
;texte: db "La fabuleuse histoire de cuisine",0
;texte2: db "solitaire de DEADSYSTEM",0
;texte: db "ABCDEFGHIJKLMNOPQRSTUVWXYZ",0
;texte2: db "abcdefghijklmnopqrstuvwxyz",0
;org #5000
texte:
;	db "                                ",0
	db "Lorem ipsum dolor sit amet. Qui ",0
	db "numquam minima aut perspiciatis ",0
	db "quisquam eos consequuntur       ",0
	db "necessitatibus et ipsa rerum est",0
	db "voluptatem mollitia et iste     ",0
	db "quidem id saepe harum. Ea nihil ",0
	db "aliquam non neque voluptatem et ",0
	db "illum illo. Qui illo velit ex   ",0
	db "voluptatem rerum non neque      ",0
	db "repudiandae cum officiis        ",0
	db "consequuntur. Rem aspernatur    ",0
	db "perferendis aut similique       ",0
	db "laborum ut debitis eius sit     ",0
	db "dignissimos provident ut        ",0
	db "sapiente soluta sit accusamus   ",0
	db "Quis et nobis tempore.          ",0
	db "Lorem ipsum dolor sit amet. Qui ",0
	db "numquam minima aut perspiciatis ",0
	db "quisquam eos consequuntur       ",0
	db "necessitatibus et ipsa rerum est",0
	db "voluptatem mollitia et iste     ",0
	db "quidem id saepe harum. Ea nihil ",0
	db "aliquam non neque voluptatem et ",0
	db "illum illo. Qui illo velit ex   ",0
	db "voluptatem rerum non neque      ",0
	db "repudiandae cum officiis        ",0
	db "consequuntur. Rem aspernatur    ",0
	db "perferendis aut similique       ",0
	db "laborum ut debitis eius sit     ",0
	db "dignissimos provident ut        ",0
	db "sapiente soluta sit accusamus   ",0
	db "Quis et nobis tempore.          ",0

adrPrint: dw 1 ; pour stocker les coordonnees du caractere

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
incbin "table64.bin"

