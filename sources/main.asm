
; ______          _            _____                      
; | ___ \        | |          |  __ \                     
; | |_/ /__   ___| | ___   _  | |  \/ __ _ _ __ ___   ___ 
; |  __/ _ \ / __| |/ / | | | | | __ / _` | '_ ` _ \ / _ \
; | | | (_) | (__|   <| |_| | | |_\ \ (_| | | | | | |  __/
; \_|  \___/ \___|_|\_\\__, |  \____/\__,_|_| |_| |_|\___|
;                       __/ |                             
;                      |___/                              


BUILDSNA
SNASET CPC_TYPE,0
BANKset 0

;SAVE "pocky.bin",start,end-start,DSK,"builds/DSKA0000.dsk"

run #100
org #100

start:

   ; fichier de configuration du jeu
   ld sp,&ff
   include "conf.asm"
 

   ; U = Changer la taille de la grille
   ; C = Changer le nombre de couleurs
   ; Flèche directionnelle gauche-droite déplace le curseur
   ; Espace = Valider
   ; R = Redemarrer le jeu
   ; Q = Quitter le jeu

   colorPaperHub equ 1


   ld bc,&7f8c ; %10001100 bit 0,1 pour le mode
   out (c),c
  
   if IsMusic
      call initMusic
   ENDIF


   ; redirige les interruptions
   ;save interruption pointer
   ;DEFB #ED,#FF
      ;di
      ;ld hl,(&39)
      ;ld (restorInt+1),hl
      ;ei
      ; change le pointeur d'interruption


   ; align 256 positionne le code a une adresse multiple de 256
   ;nop
   ;align #FF ;marche pas

   ;call overcanVertical
   ;xor A
   ;ld (compteurAffichage),A

   ; call initEditor
   ; call updateEditor

   ;call initScene




   ld a,initCurrentLevel ; conf.asm
   ld (currentLevel),a 
   call overcanVertical ; overscan.asm
   call loadInterruption ; interruption.asm 


   ld e,sceneLevels ;sceneGame ; sceneEditor
   call changeScene  ; sceneManager.asm



   ;DEFB #ED,#FF

   gameloop:
      
      updateCurrentScene:   call $ ; automodifié en fonction des scènes selectionnées

      jp gameloop



   ; touche:


   ;    ; check is win
   ;    call checkIsWin
   ;    ld a,(isWin)
   ;    cp 1
   ;    jp z,drawVictory

   ;    ; check is lose
   ;    ld a,(nbTry)
   ;    ld b,a
   ;    ld a,(currentTry)
   ;    cp b
   ;    jp z,gameover 
   
   ;    call getKeys   ; controls keys and Joystick
   ;    call updateKeys ; update actions/keys

   ;  	ld a,(newKey) ; sauvegarde les etats des touches pour la prochaine boucle
   ;  	ld (oldKey),a

   ;   	jr touche



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
   include "border.asm"
   include "gameState/gameState.asm"
   include "sceneManager/sceneManager.asm"
   include "l10n/l10n.asm"
endCode:

startVariable:
   nbInt: db 0
   ;textWin : db " WIN yeah ",0
  ; textGameover : db "GAME OVER",0
  ; textHub : db "Essai: 00/15",0
   ;textLevel : db "Lvl:  ",0

   palette: db 13,2,3,10,0,9,18,6,24,8,20,11,18,14,22,23
   ;paletteMode0: db &40,&55,&5c,&46,&54,&56,&52,&4c,&4a,&4d,&53,&57,&52,&5f,&59,&5b
   paletteMode0: db 84,88,77,79,75,74,78,94,92,68,85,87,90,86,69,64
   paletteBlack: db 84,84,84,84,84,84,84,84,84,84,84,84,84,84,84,84

   ;palette : db 13,0,3,6,17,26,9,24,25,15,12,16,18,14,22,23
   ;Palette: db 14, 15, 25, 9, 3, 5, 17, 26, 10, 13, 14, 20, 18, 10, 0, 15
   Colors : db &c0,&C,&CC,&30,&F0,&3C,&FC,&3,&C3,&F,&33,&F3,&3F,&FF
   align 256
   grid : ds 255,0   ; grille du jeu
   gridCopy : ds 255,0 ; grille tampon


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
   currentLevel : db 0

   colonne : db 0  ; les colonnes sont des multiple de 4 octets 1,2,3 => 4,8,12
   maxColor : db 6 ; 2 a 6 max Couleur maximun

   currentTry : db 0
   maxTry : db 0
   compteurAffichage : db 0
   nbTry : db 0

   nbLines : db 5 ;12 nombre de ligne de la grille
   nbRows : db 5 ;12 nombre de colonnes de la grille
   ;org #6000
   blocks : ds maxNbBlock,0
   nbBlocks : db 4
   walls : ds maxNbWall,0
   nbWalls : db 4
   nbKey: db 0
   keys: ds 10,0

   isOffsetY: db 0
   offsetY: db 32
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
   isFoundKey: db 0
   oldColor db 0 ; pour sauver l'ancienne couleur
   oldPositionStart db 0
   positionStart: db &00 ; position de départ de la grille (xy)

   ; fait commencer la pile en poids faible a 00 pour avoir un index sur 1 octect
   align 256
   pileCouleur : ds 255,#FA
   align 256
   lignes80:
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
endVariable:
startGFX:
   ; data des sprites
   dataSprite: 


   INCbin	"../img/cell1bd.win",&80 ; enleve le header 128 octets
   INCbin	"../img/cell2bd.win",&80
   INCbin	"../img/cell3bd.win",&80
   INCbin	"../img/cell4bd.win",&80
   INCbin	"../img/cell5bd.win",&80
   INCbin	"../img/cell6bd.win",&80
   INCbin	"../img/cell6bd.win",&80

   INCbin	"../spriteRoutine/cell7.bin",&80
   cursor
   INCbin	"../img/cursbd.win",&80
   INCbin	"../img/voidBD.win",&80
   INCbin	"../img/padlbd.win",&80

   mkey: 
   INCbin "../img/keymbd.win",&80
   endMkey:
   key: 
   INCbin	"../img/keybd.win",&80
   endKey:
   INCbin	"../img/border1.win",&80
   INCbin	"../img/border2.win",&80
   INCbin	"../img/border3.win",&80
   INCbin	"../img/border4.win",&80
   INCbin	"../img/border5.win",&80
   INCbin	"../img/border6.win",&80
   INCbin	"../img/border7.win",&80


   mShow: 
   INCbin "../img/showm.win",&80
   endmShow:
   show: 
   INCbin	"../img/show.win",&80
   endshow:


   font: incbin "../fonts/font3.bin",&80
   logotitle incbin "../img/logot.bin",&80
   logoPlay incbin "../img/play.bin",&80
   logoEditor incbin "../img/editor.bin",&80
   logoQuit incbin "../img/quit.bin",&80
   worldimg incbin "../img/world.bin",&80
   levelImg incbin "../img/number.bin",&80

endGFX:

startLevel:

   
   
   levels :
   INCbin	"../Levels/world1.bin",0 ; enleve le header 128 octets
   ;db &24,2,25,10,10,&a2,&80,&FF,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,&30,&31,&32,&42,&06,0,0,0,0,0 ,0 ,0,0,0,0,0,0,0,0,0,0 ,0,0,0,0,0,0,0,0,0,0 ,0,0,0,0,0,0,0,0,0,0 
      ; 1 ligne =  un level
      ;startPosition,colors,maxTry,Line,Colums,seed*2,key,nbBlock,10*dataBlock,nbVoid,10*dataVoid
      
      ; db &24,2,25,5,3,&a2,&80,&FF,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,&30,&31,&32,&42,&06,0,0,0,0,0 ,0 ,0,0,0,0,0,0,0,0,0,0 ,0,0,0,0,0,0,0,0,0,0 ,0,0,0,0,0,0,0,0,0,0 
      ; db &10,2,4,4,4,&a2,&80,&FF,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,&30,&31,&32,&42,&06,0,0,0,0,0 ,0,0,0,0,0,0,0,0,0,0,0 ,0,0,0,0,0,0,0,0,0,0 ,0,0,0,0,0,0,0,0,0,0
      ; db &12,3,5,5,5,&a1,&A2,&FF,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,&30,&31,&32,&42,&06,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ,0,0,0,0,0,0,0,0,0,0
      ; db &44,4,6,5,5,&00,&00,&FF,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,&30,&31,&32,&42,&06,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ,0,0,0,0,0,0,0,0,0,0
      ; db &22,5,6,5,5,&00,&00,&FF,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,&30,&31,&32,&42,&06,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ,0,0,0,0,0,0,0,0,0,0
      ; db &00,6,6,5,5,&00,&00,&FF,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,&30,&31,&32,&42,&06,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ,0,0,0,0,0,0,0,0,0,0
      ; db &63,6,12,7,7,&00,&00,&FF,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,&30,&31,&32,&42,&06,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ,0,0,0,0,0,0,0,0,0,0
      ; db &61,4,12,8,10,&00,&00,&FF,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,&30,&31,&32,&42,&06,0,0,0,0,0,10,&50,&51,&52,&40,&41,&42,&53,&54,&55,&56,0,0,0,0,0,0,0,0,0,0 ,0,0,0,0,0,0,0,0,0,0
      ; db &11,3,5,4,8,&22,&56,&53,5,&40,&41,&42,&52,&62,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ,0,0,0,0,0,0,0,0,0,0
      
      ; ;db 3,25,5,10,&FF,0,&30,&31,&32,&42,00
      ; ; key
      ; ;db 4,13,8,8,&77,4,&33,&34,&43,&44,&06,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      ; db 4,14,10,14,&00,&00,&FF,0,&33,&34,&43,&44,&06,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
      
      ; db 5,13,10,4,&00,&00,&39,8,&12,&13,&22,&23,&18,&19,&28,&29,0,0,0,0,0,0,0,0,0,0,0,0,0




      ; db 4,28,7,12,&FF,0,&30,&31,&32,&42,&06
      ; db 6,32,9,9,&55,5,&40,&11,&12,&42,&88
endLevel 

org &8000
adrMusic:

include "music.asm" 
endAdrMusic:
end:
include "../logs/log.asm"