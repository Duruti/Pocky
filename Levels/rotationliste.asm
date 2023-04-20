
; Rotation d'une liste d'un octet a droite
org &1000

pointeur equ 06 ; l'endroit ou on va ecrire (pointeur)
lstLenght equ 10 ; longueur de la liste

ld hl,lst+lstLenght-1
ld de,lst+lstLenght
ld bc,lstLenght-pointeur ; nb d'octet a deplacer
lddr
; on place &FF a la position du pointeur
ld a,&FF
ld hl,lst+pointeur : ld (hl),a
ret


align 16
lst db 0,1,2,3,4,5,6,7,8,9