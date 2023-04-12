initGame:

init:
  if build == 0
 	  ld a,0 : ld (modeEditor),a
  ENDIF 
  ; nettoyage du hub en affichant un rectangle remplis
  call clearHud
  ld hl,&C000
  ld bc,&40E0-1
  ld a,%11000000 ;&30
  call FillRect


  call drawLevel  
  
  ld a,0
  ld (isOffsetY),a 
  
  call drawCursor ; hub.asm

  ; init le compteur de clés


  ; affiche le compteur 
  call initCounter
  call transferCounter
  call drawCounter


  ; change le paper
  ;  ld a,colorPaperHub
  ;  call  &BB96


  call updateTextHub ; hub.asm
   
  ; draw nombre hub
  ;ld hl,&11F0;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
 	;ld (adrPrint),hl ; save la position

  ; ld hl,&0E19 ; 0819 centrer
  ; call locate
  
  ld a,TextHub : call getAdressText
  ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de : inc hl
  call printText


  ; drawLevel
  ld hl,&01F0;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
  call drawLevelInfoHub
  
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

  
  LD BC,#7F10:OUT (C),C:LD C,84:OUT (C),C ; border 0

  ld hl,paletteMode0
  call loadPaletteGA

  ld hl,MusicStart
  call Main_Player_Start + 0
  
  ret


; ****************************************************
; ****************************************************
; ****************************************************
; ****************************************************

  ; jp touche

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
  ; dessine l'indicateur de la zone de debut de remplissage

  ld a,1
  ld (isOffsetY),a

  ld a,(positionStart)
  and %00001111
  ld (currentLine),a
  ld a,(positionStart)
  and %11110000
  srl a : srl a 
  ld (colonne),a

  call getAdrScreen ; drawKey.asm
  ld hl,mshow
  call drawMask ; transparence.asm


  call getAdrScreen
  ld hl,show
  call drawSpriteOr ; transparence.asm

  ret
  
drawLevel
  ; dessine le current level

  call loadLevel
  ; ld a,3
  ; ld (currentTry),a

  ; initialisation des variables

  xor A
  ld (isWin),a
  ld (offsetX),a
  ld (nbTry),A
  ld (exit),a

  ld a,0
  ld (isOffsetY),a
  call drawHub ; hub.asm

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



  ; recherche la presence de mur cadenas
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

  call drawBorder ; dessine le contour du level

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
  ret

drawLevelInfoHub:

  call getCurrentLevelWorld

  ld a,TextLevel : call getAdressText :
  ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de
  ld c,(hl) : inc c : inc hl : ld b,0
  push hl: add hl,bc : push hl

  ld a,(currentLevelWorld)
  ld d,a
  ld e,10
  call div
  ; update unité
  add &30
  ;ld ix,textLevel
  pop hl
  ld (hl),a
  ld a,d
  add &30
  dec hl
  ld (hl),a

  ;ld hl,&01F0;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
 	;ld (adrPrint),hl ; save la position
  pop hl :  call printText

  ld a,TextWorld : call getAdressText 
  ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de : inc hl : push hl
  dec hl : ld c,(hl) : inc hl : ld b,0 : add hl,bc : ld a,(currentWorld): inc a : add &30 : ld (hl),a
  pop hl : call printText

  ret
