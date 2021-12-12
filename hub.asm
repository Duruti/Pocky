; draw hub
drawHub:
   ld hl,Colors
   ld a,14
   ld (currentLine),a

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
      
      ld a,(hl)
      ld (currentColor),a
      call drawcells
      ld a,(colonne)
      add 4
      ld (colonne),a
      
      pop bc
      pop hl

      inc hl

      dec b
      jp nz,loopDrawHub
   ret

drawCursor:
   ld a,(cursorPosition)
   sla a : sla a:
   ld b,A

   ld hl,&c740
   ld a,(offsetHub)
   add 2
   add b
   ld d,0
   ld e,A
   add hl,de

   ld de,&800

   ld a,&Fc
   ld (hl),a
   add hl,de
   ld (hl),a
   ret

incCursor:
   ld a,(maxColor)
   dec a
   ld b,a
   ld a,(cursorPosition)
   cp b
   jr z,initCursor
   inc a
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



getColorCursor:
   ld a,(cursorPosition)
   call floodFill
   ret


; drawHub:
;    ld a,0
;    ld (currentLine),A
;    ld a,76
;    ld (colonne),A
;    ld b,8
;    ld c,1
;    ld a,#30
;    ld (currentCaractere),a
;    ld hl,Colors

;    loopDrawHub:
;       push hl
;       ld h,#13
;       ld l,c
;       call #BB75
;       ld a,(currentCaractere)
;       inc A
;       ld (currentCaractere),a
;       call #BB5A
;       pop hl
;       ld a,(hl)
;       ld (currentColor),a
;       inc hl
;       push hl
;       push bc
;       call drawcells
;       ld a,(currentLine)
;       inc a
;       ld (currentLine),a
;       pop bc
;       pop hl
;       inc c
;       inc c
;       dec B
;       jp nz,loopDrawHub
; ret

currentCaractere : db 0
org #9000
offsetHub: db 0
