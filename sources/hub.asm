; draw hub
drawHub:
   ; ld hl,Colors
   ld a,0
   ld (isOffsetY),a


   ld a,13 ; positionne le hub sur la 14 eme lignes
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

      call clearLine
   ret


drawCursor:
   push af
   ld a,0
   ld (isOffsetY),a
   pop af

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
   ld a,12
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

resetCursor2:
   ld hl,&c614
   ld bc,&180f
   ld a,%11000000 ;&30
   call FillRect
ret


resetCursor:
   jp resetCursor2


   ld a,12 ; positionne le hub sur la 14 eme lignes
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
   
   push af ; sauve l'offset
   xor a
   ld (offsetX),a

   call drawHub
   
   pop af ; restaure l'offset
   ld (offsetX),a

   call drawCursor
   PlaySoundEffect 2,2,0

   ret
;   jp touche


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
   PlaySoundEffect 2,2,0

      ret
      jp gameloop

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
   PlaySoundEffect 2,2,0

   ret

   jp gameloop

   initCursorHigh:
      ld a,(maxColor)
      dec a
      ld (cursorPosition),a
      ld a,(offsetX)
      push af
      xor a
      ld (offsetX),a

     ; call drawHub
      pop af
      ld (offsetX),a

      call drawCursor
      PlaySoundEffect 2,2,0

      ret
      jp gameloop

updateTextHub:
   
   ;Modifie directement la chaine de texte
   ; ecrit le nombre maximal d'essai
   ; comme c'est à la fin de la chaine on va récuperer la longueur de celle ci

   ld a,TextHub : call getAdressText 
   inc hl : inc hl : inc hl : push hl
   call getLenghtText
   
   ld b,0 : dec c : pop hl : add hl,bc ; decremente c pour bien pointer
   
   ; unitée
   ld a,(maxTry)
   and %00001111
   add &30
   ld (hl),a : dec hl
   ; decimal
   ld a,(maxTry)
   and %11110000
   srl a : srl a :srl a :srl a
   add &30
   ld (hl),a

   ret
getLenghtText 
   ; retourne dans c la longueur de la chaine
   ld c,-1
   .loop
      inc c
      ld a,(hl) : cp 0 :
      inc hl
      jr nz,.loop
   ret

ChangeColorCursor:
   ; applique le floodfill avec la couleur sous le curseur 
  ; DEFB #ED,#FF
   PlaySoundEffect 1,2,0

   ld a,(cursorPosition)
   call floodFill
   call drawIndicator

  ; DEFB #ED,#FF
   ret

clearHud:
   ld hl,&FEC0
   ld bc,&4021
   ld a,0
   call FillRect
   ret




clearLine:
    ; premiere ligne
   ld b,64
      ld hl,&FEC0
   bclClear
      ld (hl),&0
      inc hl
      djnz bclClear
      ret

currentCaractere : db 0

offsetHub: db 0
