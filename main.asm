; overscan

; border 0
ld bc,&0
call &bc38


ld bc,&bc00+1 : out (c),c
ld bc,&bd00+32 : out (c),c


ld bc,&bc00+2 : out (c),c
ld bc,&bd00+42 : out (c),c


ld bc,&bc00+6 : out (c),c
ld bc,&bd00+32 : out (c),c


ld bc,&bc00+7 : out (c),c
ld bc,&bd00+34 : out (c),c


; init

init:


call cls

xor A
ld (offsetX),a
call drawHub


; init variables

xor A
ld (currentLine),A
ld (compteurCoup),a
ld (colonne),A
ld (cursorPosition),a

call initGrid

; calcule l'offset
; offset = (16-nbRows)/2 * 4

 ld a,(nbRows)
 sla a : sla a ; *4
 ld b,a
 ld a,64
 sub b
 srl a 
ld (offsetX),a


ld hl,Palette
call loadPalette

;ld hl,adrColor
;ld de,Colors
;ld (hl),d
;inc hl
;ld (hl),e

; affiche la grille du jeu
ld de,grid + 2
ld a,7
ld (de),a
ld de,grid + 6
ld (de),a
ld de,grid + 10
ld (de),a

ld de,grid ; pointeur sur la grille du jeu
ld a,(nbLines)
ld b,a
loopLine:
  
   push bc
   ld a,(nbRows)
   ld b,a ; init boucle
   loopColonne: 
      push bc
      ; lit le tableau
      ld a,(de)
      inc de
      push de
 ;     ld d,0
  ;    ld e,a
      ld (currentSprite),a ;couleur du sprite
      
     ; ld hl,Colors
     ; add hl,de
     ; ld a,(hl)
     ; ld (currentColor),a

      call drawcells

      ld a,(colonne)
      add 4
      ld (colonne),A

      pop de
      pop bc
      dec B
      jp nz,loopColonne
  
   xor A
   ld (colonne),a

   ld a,(currentLine)
 
   inc A
   ld (currentLine),a

   pop bc
   dec b

   jp nz,loopLine 

   call drawCursor

touche:
	call #bb06 ; vecteur clavier attends l'appuis d'une touche
	cp 'Q'
	jp z,fin
	cp 'q'
	jp z,fin
   cp 'R'
	jp z,init
	cp 'r'
	jp z,init
   cp 'U'
	jp z,addLevel
	cp 'u'
	jp z,addLevel
   cp 'C'
	jp z,addColor
	cp 'c'
	jp z,addColor

   cp 'z'
	jp z,incCursor
   cp 'Z'
	jp z,incCursor
   
   cp 'a'
	jp z,decCursor
   cp 'A'
	jp z,decCursor

   cp ' '
   call z,ChangeColorCursor
  
 	
   jp touche

fin:	ret



read "utils.asm"
read "initGrid.asm"
read "hub.asm"
read "changeColors.asm"
read "floodFill.asm"
read "drawCell2.asm"

Palette: db 14, 15, 25, 9, 3, 5, 17, 26, 10, 13, 14, 20, 18, 15, 0, 15
org #6000
Colors : db &c0,&C,&CC,&30,&F0,&3C,&FC,&3,&C3,&F,&33,&F3,&3F,&FF
org #6100
grid : ds 255,0


org #5000
; table de lignes avec l'adresse ecran
lines : 
    dw &c000,&c040,&c080,&c0C0,&c100,&c140,&c180,&c1C0
    dw &c200,&c240,&c280,&c2C0,&c300,&c340,&c380,&c3C0
    dw &c400,&c440,&c480,&c4C0,&c500,&c540,&c580,&c5C0
    dw &c600,&c640,&c680,&c6C0,&c700,&c740,&c780,&c7C0
    dw &c800,&c840,&c880,&c8C0,&c900,&c940,&c980,&c9C0
    dw &ca00,&ca40,&ca80,&caC0,&cb00,&cb40,&cb80,&cbC0


adrColor : dw 0
currentSprite: db 0
currentColor : db 0
colonne : db 0  ; les colonnes sont des multiple de 4 octets 1,2,3 => 4,8,12
maxColor : db 3 ; 2 a 6 max Couleur maximun

nbLines : db 4 ;12 nombre de ligne de la grille
nbRows : db 4 ;12 nombre de colonnes de la grille
offsetX: db 0 ; l'offset de décallage pour centrer la grille en X
tempOffsetX : db 0

currentLine : db 0 ; la ligne a afficher, 1 ligne de grille = 16 pixels en y

; variable pour l'algo de floodfill
couleurCible : db 0
couleurRemplissage : db 0
indexPile: db 0
currentPosition : db 0
cursorPosition: db 0
tempPosition: db 0
compteurCoup : db 0

; fait commencer la pile en poids faible a 00 pour avoir un index sur 1 octect
org #7000
pileCouleur : ds 255,#FA

; data des sprites
dataSprite: 
INCbin	"spriteRoutine/cell1.bin"
INCbin	"spriteRoutine/cell2.bin"
INCbin	"spriteRoutine/cell3.bin"
INCbin	"spriteRoutine/cell4.bin"
INCbin	"spriteRoutine/cell5.bin"
INCbin	"spriteRoutine/cell6.bin"
INCbin	"spriteRoutine/cell6.bin"
INCbin	"spriteRoutine/cell7.bin"
INCbin	"spriteRoutine/cursor.bin"
INCbin	"spriteRoutine/void.bin"

