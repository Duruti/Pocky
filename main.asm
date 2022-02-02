BUILDSNA
SNASET CPC_TYPE,0
BANKset 0

SAVE "pocky.bin",start,end-start,DSK,"pocky.dsk"

run #1000
org #1000

start:

include "conf.asm"


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

if IsMusic
   call initMusic
ENDIF


jp initGame

touche:
;jp touche

   ;call vbl
   ;call Main_Player_Start + 3

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







include "utils.asm"
include "initGrid.asm"
include "hub.asm"
include "changeColors.asm"
include "floodFill.asm"
include "drawCell2.asm"
include "drawKey.asm"
include "levelManager.asm"
include "counter.asm"
include "victory.asm"
include "overscan.asm"
include "interruption.asm"
include "keyManager.asm"
include "initGame.asm"
include "print.asm"


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

INCbin	"spriteRoutine/tl1.bin",&80
INCbin	"spriteRoutine/tl2.bin",&80
INCbin	"spriteRoutine/tl3.bin",&80
INCbin	"spriteRoutine/tl4.bin",&80
INCbin	"spriteRoutine/tl5.bin",&80
INCbin	"spriteRoutine/tl6.bin",&80
INCbin	"spriteRoutine/tl6.bin",&80

INCbin	"spriteRoutine/cell7.bin",&80
INCbin	"spriteRoutine/curs2.bin",&80
INCbin	"spriteRoutine/void3.bin",&80
INCbin	"spriteRoutine/padl3.bin",&80
;voidMode1: ds 68,&0

mkey: 
INCbin "spriteRoutine/mkey3.bin",&80
endMkey:
key: 
INCbin	"spriteRoutine/key3.bin",&80
endKey:

font: incbin "font3.bin",&80

lenghtLevel equ 29 ; taille en octet d'un level
maxLevel equ 10
nbInt: db 0
initCurrentLevel equ 1
levels :
 ;colors,maxTry,Line,Colums,seed*2,key,nbBlock,10*dataBlock,nbVoid,10*dataVoid
 
   db 3,4,10,12,&a2,&80,&FF,0,&30,&31,&32,&42,&06,0,0,0,0,0 ,0,0,0,0,0,0,0,0,0,0,0 
   db 3,5,5,5,&a1,&A2,&FF,0,&30,&31,&32,&42,&06,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
   db 4,6,5,5,&00,&00,&FF,0,&30,&31,&32,&42,&06,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
   db 5,6,5,5,&00,&00,&FF,0,&30,&31,&32,&42,&06,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
   db 6,6,5,5,&00,&00,&FF,0,&30,&31,&32,&42,&06,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
   db 6,12,7,7,&00,&00,&FF,0,&30,&31,&32,&42,&06,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
   db 4,12,4,10,&00,&00,&FF,0,&30,&31,&32,&42,&06,0,0,0,0,0,6,&50,&51,&52,&40,&41,&42,0,0,0,0
   db 3,5,4,8,&22,&56,&53,5,&50,&51,&52,&62,&63,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
   
   ;db 3,25,5,10,&FF,0,&30,&31,&32,&42,00
   ; key
   ;db 4,13,8,8,&77,4,&33,&34,&43,&44,&06,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
   db 4,14,10,10,&00,&00,&FF,0,&33,&34,&43,&44,&06,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
   
   db 5,13,12,4,&00,&00,&3B,8,&12,&13,&22,&23,&18,&19,&28,&29,0,0,0,0,0,0,0,0,0,0,0,0,0




   db 4,28,7,12,&FF,0,&30,&31,&32,&42,&06
   db 6,32,9,9,&55,5,&40,&11,&12,&42,&88

include "music.asm" 

end:
