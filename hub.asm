; draw hub
drawHub:
   ; ld hl,Colors
   
   ld a,14 ; positionne le hub sur la 14 eme lignes
   ld (currentLine),a

   ; fait le calcul pour centrer le hub
   ld a,(maxColor)
   sla a : sla a ; *4
   ld b,a
   ld a,64
   sub b
   srl a 
   ld (colonne),a
   ld (offsetHub),a

   ld a,(maxColor)
   ld b,a
   ld c,0

   loopDrawHub:
      push hl
      push bc
      
      ld a,(maxColor) ; permet de calculer la couleur de 0 a maxColor
      sub b
      ld (currentSprite),A
      
      ;ld a,(hl)
      ;ld (currentColor),a
      call drawcells
      ld a,(colonne) ; decalle la colonne d'une celulle
      add 4
      ld (colonne),a
      
      pop bc
      pop hl

      inc hl

      dec b
      jp nz,loopDrawHub
   ret


drawCursor:
   ld a,(offsetX)
   ld (tempOffsetX),a
   xor A
   ld (offsetX),a

   call resetCursor

   ld a,(cursorPosition) ; multiplie par 4 pour positionner sur la bonne colonne
   sla a : sla a
   ld b,A

 ; fait le calcul pour centrer le hub
   ; ld a,(maxColor)
   ; sla a : sla a ; *4
   ; ld b,a
   ; ld a,64
   ; sub b
   ; srl a 


   ;ld hl,&c680 ; adresse ecran à la moitié de la 14eme ligne
   ld a,(offsetHub) ; applique l'offset
  ; srl a
   ;add 2
   add b
   
   ld (colonne),a
   ld a,13
   ld (currentLine),a
   ld a,8
   ld (currentSprite),a
   call drawcells
   ;ld d,0
   ;ld e,A
   ;add hl,de
   ;ex hl,de

   ; restaure l'offset
   ld a,(tempOffsetX)
   ld (offsetX),a
   ret

resetCursor:
    
   ld a,13 ; positionne le hub sur la 14 eme lignes
   ld (currentLine),a

   ; fait le calcul pour centrer le hub
   ld a,(offsetHub)
   ld (colonne),a

   ld a,(maxColor)
   ld b,a
   ld c,0

   loopResetHub:
      push hl
      push bc
      
      ld a,9
      ld (currentSprite),A
      
      ;ld a,(hl)
      ;ld (currentColor),a
      call drawcells
      ld a,(colonne) ; decalle la colonne d'une celulle
      add 4
      ld (colonne),a
      
      pop bc
      pop hl

      inc hl

      dec b
      jp nz,loopResetHub
   ret

   ret


drawCursor2:
   ld a,(cursorPosition) ; multiplie par 4 pour positionner sur la bonne colonne
   sla a : sla a:
   ld b,A

   ld hl,&c740 ; adresse ecran à la moitié de la 14eme ligne
   ld a,(offsetHub) ; applique l'offset
   add 2
   add b
   ld d,0
   ld e,A
   add hl,de

   ld de,&800 

   ld a,&F ; couleur du curseur
   ld (hl),a
   add hl,de
   ld (hl),a
   ret

incCursor:
   ; déplace le curseur a droite

   ld a,(maxColor) ; calcul les limites des couleurs (maxColor-1)
   dec a
   ld b,a
   ld a,(cursorPosition)
   cp b
   jr z,initCursor ; si le curseur est à la derniere couleur on recommence a la premiere
   inc a ; sinon on incrémente le curseur
   ld (cursorPosition),a

   ; là je réaffiche tout le hub pour effacer le curseur
   ; routine à revoir

   ld a,(offsetX)
   push af
   xor a
   ld (offsetX),a

   call drawHub
   pop af
   ld (offsetX),a

   call drawCursor
   jp touche

   initCursor:
      xor a
      ld (cursorPosition),a
      ld a,(offsetX)
      push af
      xor a
      ld (offsetX),a

      call drawHub
      pop af
      ld (offsetX),a

      call drawCursor
      jp touche

decCursor:
   
   ; idem plus haut mais pour déplacement du curseur a gauche

   ld a,(cursorPosition)
   cp 0
   jr z,initCursorHigh
   dec a
   ld (cursorPosition),a

   ld a,(offsetX)
   push af
   xor a
   ld (offsetX),a

   call drawHub
   pop af
   ld (offsetX),a

   call drawCursor
   jp touche

   initCursorHigh:
      ld a,(maxColor)
      dec a
      ld (cursorPosition),a
      ld a,(offsetX)
      push af
      xor a
      ld (offsetX),a

      call drawHub
      pop af
      ld (offsetX),a

      call drawCursor
      jp touche



ChangeColorCursor:
   ; applique le floodfill avec la couleur sous le curseur 
   ld a,(cursorPosition)
   call floodFill
   ret


currentCaractere : db 0
; org #9000
offsetHub: db 0
