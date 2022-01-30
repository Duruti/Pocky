; U = Changer la taille de la grille
; C = Changer le nombre de couleurs
; Flèche directionnelle gauche-droite déplace le curseur
; Espace = Valider
; R = Redemarrer le jeu
; Q = Quitter le jeu

colorPaperHub equ 1




; redirige les interruptions
;save interruption pointer
	ld hl,(&39)
	ld (restorInt+1),hl
 
	; change le pointeur d'interruption


; align 256 positionne le code a une adresse multiple de 256
;nop
;align #FF ;marche pas

call overcanVertical

xor A
ld (compteurAffichage),A

  



; init
ld a,initCurrentLevel
ld (currentLevel),a
 call loadInterruption 
jp initGame

touche:
;jp touche

  ; call vbl
 
   call checkIsWin
   ld a,(isWin)
   cp 1
   jp z,drawVictory

   ; check is lose
   ld a,(nbTry)
   ld b,a
   ld a,(currentTry)
   cp b
   jp z,gameover 

	;call #bb06 ; vecteur clavier attends l'appuis d'une touche
;	DEFB #ED,#FF
   xor a
   cp 'Q'
	jp z,fin
	cp 'q'
	jp z,fin
   cp 'R'
	jp z,init
	cp 'r'
	jp z,init
   ; cp 'U'
	; jp z,addLevel
	; cp 'u'
	; jp z,addLevel
   ; cp 'C'
	; jp z,addColor
	; cp 'c'
	; jp z,addColor

   cp &F3 ;'z' fleche droite
	jp z,incCursor
 ;  cp &F3 ;'Z'
	;jp z,incCursor
   
   cp &F2 ;'a' fleche gauche
	jp z,decCursor
  ; cp 'A'
;	jp z,decCursor

   cp &F0 ; fleche haut
;	jp z,addLevel1
   cp &F1 ;'a' fleche bas
	jp z,decLevel

   cp ' '
   call z,ChangeColorCursor
  

   call getKeys
   call updateKeys

 	ld a,(newKey) ; sauvegarde les etats des touches pour la prochaine boucle
 	ld (oldKey),a

 	;ld a,(exit)    	; test si on quitte le programme
  	;cp 1
  	jr touche


  ; jp touche

fin:	ret



initCurrentLevel equ 1



read "utils.asm"
read "initGrid.asm"
read "hub.asm"
read "changeColors.asm"
read "floodFill.asm"
read "drawCell2.asm"
read "drawKey.asm"
read "levelManager.asm"
read "counter.asm"
read "victory.asm"
read "overscan.asm"
read "interruption.asm"
read "keyManager.asm"
read "initGame.asm"
read "print.asm"
; texte
textWin : db " WIN yeah ",0
textGameover : db "GAME OVER",0
textHub : db "Reste:   /15",0
textLevel : db "Lvl:  ",0

palette: db 13,2,3,10,0,9,18,6,24,8,20,11,18,14,22,23
paletteMode0: db &40,&55,&5c,&46,&54,&56,&52,&4c,&4a,&4d,&53,&57,&52,&5f,&59,&5b
;palette : db 13,0,3,6,17,26,9,24,25,15,12,16,18,14,22,23
;Palette: db 14, 15, 25, 9, 3, 5, 17, 26, 10, 13, 14, 20, 18, 10, 0, 15
Colors : db &c0,&C,&CC,&30,&F0,&3C,&FC,&3,&C3,&F,&33,&F3,&3F,&FF
align 256
;org #6000
grid : ds 255,0
gridCopy : ds 255,0


align 256
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
currentLevel : db 1

colonne : db 0  ; les colonnes sont des multiple de 4 octets 1,2,3 => 4,8,12
maxColor : db 6 ; 2 a 6 max Couleur maximun

currentTry : db 0
maxTry : db 0
compteurAffichage : db 0
nbTry : db 0

nbLines : db 5 ;12 nombre de ligne de la grille
nbRows : db 5 ;12 nombre de colonnes de la grille
;org #6000
blocks : ds 10,0
nbBlocks : db 4
walls : ds 10,0
nbWalls : db 4
nbKey: db 0
keys: ds 10,0

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
isWin : db 0

; fait commencer la pile en poids faible a 00 pour avoir un index sur 1 octect
align 256
pileCouleur : ds 255,#FA
;org #7100
;pilePositionKey : ds 255,0

; data des sprites
dataSprite: 
;  INCbin	"spriteRoutine/t1.bin"
;  INCbin	"spriteRoutine/t2.bin"
;  INCbin	"spriteRoutine/t3.bin"
;  INCbin	"spriteRoutine/t4.bin"
;  INCbin	"spriteRoutine/t5.bin"
;  INCbin	"spriteRoutine/t6.bin"
;  INCbin	"spriteRoutine/t6.bin"

INCbin	"spriteRoutine/tl1.bin"
 INCbin	"spriteRoutine/tl2.bin"
 INCbin	"spriteRoutine/tl3.bin"
 INCbin	"spriteRoutine/tl4.bin"
 INCbin	"spriteRoutine/tl5.bin"
 INCbin	"spriteRoutine/tl6.bin"
 INCbin	"spriteRoutine/tl6.bin"

;INCbin	"spriteRoutine/t76.bin"

;INCbin	"spriteRoutine/cell1.bin"
;INCbin	"spriteRoutine/cell2.bin"
;INCbin	"spriteRoutine/cell3.bin"
;INCbin	"spriteRoutine/cell4.bin"
;INCbin	"spriteRoutine/cell5.bin"
;INCbin	"spriteRoutine/cell6.bin"
;INCbin	"spriteRoutine/cell6.bin"

INCbin	"spriteRoutine/cell7.bin"
;INCbin	"spriteRoutine/cursor.bin"
INCbin	"spriteRoutine/curs2.bin"
;INCbin	"spriteRoutine/void.bin"
INCbin	"spriteRoutine/void3.bin"
INCbin	"spriteRoutine/padl3.bin"
voidMode1: ds 68,&0

mkey: INCbin "spriteRoutine/mkey3.bin" endMkey:
key: INCbin	"spriteRoutine/key3.bin" endKey:

lenghtLevel equ 29 ; taille en octet d'un level
maxLevel equ 10
nbInt: db 0
levels :
 ;colors,maxTry,Line,Colums,seed*2,key,nbBlock,10*dataBlock,nbVoid,10*dataVoid
 
   db 3,24,4,4,&a2,&80,&FF,0,&30,&31,&32,&42,&06,0,0,0,0,0 ,0,0,0,0,0,0,0,0,0,0,0 
   db 3,5,5,5,&00,&00,&FF,0,&30,&31,&32,&42,&06,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
   db 4,7,5,5,&00,&00,&FF,0,&30,&31,&32,&42,&06,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
   db 5,8,5,5,&00,&00,&FF,0,&30,&31,&32,&42,&06,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
   db 6,9,5,5,&00,&00,&FF,0,&30,&31,&32,&42,&06,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
   db 6,12,7,7,&00,&00,&FF,0,&30,&31,&32,&42,&06,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
   db 4,11,4,10,&00,&00,&FF,0,&30,&31,&32,&42,&06,0,0,0,0,0,6,&50,&51,&52,&40,&41,&42,0,0,0,0
   
   ;db 3,25,5,10,&FF,0,&30,&31,&32,&42,00
   ; key
   db 3,6,4,8,&00,&00,&63,5,&50,&51,&52,&62,&72,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
   ;db 4,13,8,8,&77,4,&33,&34,&43,&44,&06,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
   db 2,99,12,12,&00,&00,&FF,0,&33,&34,&43,&44,&06,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
   
   db 5,13,12,4,&00,&00,&3B,8,&12,&13,&22,&23,&18,&19,&28,&29,0,0,0,0,0,0,0,0,0,0,0,0,0




   db 4,28,7,12,&FF,0,&30,&31,&32,&42,&06
   db 6,32,9,9,&55,5,&40,&11,&12,&42,&88


   ;; Test clavier de la ligne; dont le numéro est dans D; D doit contenir une valeur de 0 à 9;
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
   out (c),c; Et A contient la ligne

