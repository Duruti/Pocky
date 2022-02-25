initGame:

init:

 ; border 0
  LD BC,#7F10:OUT (C),C:LD C,88:OUT (C),C

call clearHud
ld hl,&C000
ld bc,&40E0-1
ld a,%11000000 ;&30
call FillRect


call loadLevel
; ld a,3
; ld (currentTry),a

xor A
ld (isWin),a
ld (offsetX),a
ld (nbTry),A
ld (exit),a

ld a,0
ld (isOffsetY),a
call drawHub


; init variables

xor A
ld (currentLine),A
ld (compteurAffichage),a
ld (colonne),A
ld (cursorPosition),a

call initGrid


call CalcOffsetY
; calcule l'offset X 
; offset = (16-nbRows)/2 * 4

 ld a,(nbRows)
 sla a : sla a ; *4
 ld b,a
 ld a,64
 sub b
 srl a 
ld (offsetX),a


ld hl,paletteMode0
call loadPaletteGA


ld a,(nbBlocks)
cp 0
call nz,loadPadlock

; rajoute les murs

ld a,(nbWalls)
cp 0
call nz,initWalls
; ld ix,grid ; pointeur sur la grille du jeu
; ld a,idWall
; ld (ix+4),a
; ld (ix+5),a
ld a,1
ld (isOffsetY),a

call drawBorder

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
   
   call loadKey 
  
  
   ld a,0
   ld (isOffsetY),a 
   
   call drawCursor

   ; init le compteur de clés


   ; affiche le compteur 
   call transferCounter
   call drawCounter


   ; change le paper
 ;  ld a,colorPaperHub
 ;  call  &BB96


   call updateTextHub 
   
   ; draw nombre hub
    ld hl,&11F0;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
 	ld (adrPrint),hl ; save la position

  ; ld hl,&0E19 ; 0819 centrer
  ; call locate
   ld hl,textHub
   call printText


   ; drawLevel
   ld a,(currentLevel)
   ld d,a
   ld e,10
   call div
   ; update unité
   add &30
   ld ix,textLevel
   ld (ix+5),a
   ld a,d
   add &30
   ld (ix+4),a

   ld hl,&01F0;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
 	ld (adrPrint),hl ; save la position
 ;  ld hl,&0119
 ;  call locate
   ld hl,textLevel
   call printText

; gameloop
 ; change le paper
  ; ld a,5
  ; call  &BB96
   
   ; j'ai un bug sur l'initialisation du compteur d'interruption
   ; il me décalle de 1 unité 
   ; alors je fais 2 initialisations pour avoir le compteur correct.

   ;call loadInterruption 
  ; call loadInterruption 
   call initKeyboard

   ; ld hl,&00F0;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
 	; ld (adrPrint),hl ; save la position
 	; ld hl,texte ; hl l'adresse du texte
   ; call printText
  call drawIndicator

   jp touche

   CalcOffsetY:
    ld a,(nbLines)
    sla a: sla a: sla a: sla a ; *16
    ld b,a
    ld a,192
    sub b
    srl a
    ld (offsetY),a
    ret

drawIndicator:

  ld a,1
  ld (isOffsetY),a

  ld a,(positionStart)
  and %00001111
  ld (currentLine),a
  ld a,(positionStart)
  and %11110000
  srl a : srl a 
  ld (colonne),a

  call getAdrScreen
  ld hl,mshow
  call drawMask


  call getAdrScreen
  ld hl,show
  call drawSpriteOr

  ret
  