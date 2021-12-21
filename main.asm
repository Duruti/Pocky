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

; affiche 3 cellules murs
; ld de,grid + 3
; ld a,10
; ld (de),a
; ld de,grid + 8
; ld (de),a
; ld de,grid + 13
; ld (de),a
; ld de,grid + 14
; ld (de),a


ld a,4
ld (nbBlocks),a

ld a,&30
ld (blocks),a
call drawPadlock
ld a,&31
ld (blocks+1),a
call drawPadlock
ld a,&32
ld (blocks+2),a
call drawPadlock
ld a,&42
ld (blocks+3),a
call drawPadlock

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

   ; init le compteur de clés
   ld a,1
   ld (nbKey),a

   ; range dans le tableau la coordonnées de la clef sur 1 octet   
   ld a,&23
   ld (keys),a

   ; *************
   ; Rajoute une clef
   ; **************

   
   ld a,(keys) ; recupere la position 
   ; recupere le X
   
   and %11110000
   srl a : srl a;  srl a ; srl a
   ld (colonne),a

   ld a,(keys) ; recupere la position 
   ; recupere la ligne
   and %1111
   ld (currentLine),a

;   ld a,4
;   ld (colonne),a
   call drawKey 



; gameloop

touche:
	call #bb06 ; vecteur clavier attends l'appuis d'une touche
;	DEFB #ED,#FF
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

   cp &F3 ;'z' fleche droite
	jp z,incCursor
 ;  cp &F3 ;'Z'
	;jp z,incCursor
   
   cp &F2 ;'a' fleche gauche
	jp z,decCursor
  ; cp 'A'
;	jp z,decCursor

   cp ' '
   call z,ChangeColorCursor
  
 	
   jp touche

fin:	ret

drawPadlock:
    ld c,A ; save a

   ; recupere y
   and %00001111
   ld b,a
   ld a,(nbRows)
   ld d,a
   xor a

   addRows4:
      add d      
      dec b
      jr nz,addRows4
   
   ld b,A ; save a
   ld a,c
   and %11110000
   srl a: srl a: srl a: srl a

   add B

   ld hl,grid
   add l
   ld l,a
   ld a,10
   ld (hl),a
   ret



read "utils.asm"
read "initGrid.asm"
read "hub.asm"
read "changeColors.asm"
read "floodFill.asm"
read "drawCell2.asm"
read "drawKey.asm"
Palette: db 14, 15, 25, 9, 3, 5, 17, 26, 10, 13, 14, 20, 18, 15, 0, 15
org #6000
Colors : db &c0,&C,&CC,&30,&F0,&3C,&FC,&3,&C3,&F,&33,&F3,&3F,&FF
org #6100
grid : ds 255,0
gridCopy : ds 255,0
blocks : ds 10,0
nbBlocks : db 0
nbKey: db 0
keys: ds 10,0


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
maxColor : db 6 ; 2 a 6 max Couleur maximun

nbLines : db 5 ;12 nombre de ligne de la grille
nbRows : db 5 ;12 nombre de colonnes de la grille
offsetX: db 0 ; l'offset de décallage pour centrer la grille en X
tempOffsetX : db 0

currentLine : db 0 ; la ligne a afficher, 1 ligne de grille = 16 pixels en y

; variable pour l'algo de floodfill
couleurCible : db 0
couleurRemplissage : db 0
indexPile: db 0
indexPilePositionKey: db 0
controlKey: db 0
tempColor: db 0
currentPosition : db 0
cursorPosition: db 0
tempPosition: db 0
compteurCoup : db 0

; fait commencer la pile en poids faible a 00 pour avoir un index sur 1 octect
org #7000
pileCouleur : ds 255,#FA
org #7100
pilePositionKey : ds 255,0

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
INCbin	"spriteRoutine/padlock.bin"

mkey: INCbin	"spriteRoutine/mkey.bin" endMkey:
key: INCbin	"spriteRoutine/key.bin" endKey:
