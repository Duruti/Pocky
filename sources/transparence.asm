drawMask:
   ; hl source
   ; de destination
   ld c,e
   ld b,8
   bclLine:
      push bc
      ld c,(hl): ld a,(de) : and c : ld (de),a : inc hl : inc de
      ld c,(hl): ld a,(de) : and c : ld (de),a : inc hl : inc de
      ld c,(hl): ld a,(de) : and c : ld (de),a : inc hl : inc de
      ld c,(hl): ld a,(de) : and c : ld (de),a : inc hl 
      ld a,d : add 8 : ld d,a  
      pop bc
      ld e,c
      djnz bclLine

   ex hl,de : ld bc,&c040 : add hl,bc : ex hl,de

   ld c,e
   ld b,8

   bclLine2:
      push bc
      ld c,(hl): ld a,(de) : and c : ld (de),a : inc hl : inc de
      ld c,(hl): ld a,(de) : and c : ld (de),a : inc hl : inc de
      ld c,(hl): ld a,(de) : and c : ld (de),a : inc hl : inc de
      ld c,(hl): ld a,(de) : and c : ld (de),a : inc hl 
      ld a,d : add 8 : ld d,a  
      pop bc
      ld e,c
      djnz bclLine2

   ret

drawSpriteOr:
  
   ld c,e
   ld b,8
   bclLineOr:
      push bc
      ld c,(hl): ld a,(de) : or c : ld (de),a : inc hl : inc de
      ld c,(hl): ld a,(de) : or c : ld (de),a : inc hl : inc de
      ld c,(hl): ld a,(de) : or c : ld (de),a : inc hl : inc de
      ld c,(hl): ld a,(de) : or c : ld (de),a : inc hl 
      ld a,d : add 8 : ld d,a  
      pop bc
      ld e,c
      djnz bclLineOr

   ex hl,de : ld bc,&c040 : add hl,bc : ex hl,de

   ld c,e
   ld b,8

   bclLineOr2:
      push bc
      ld c,(hl): ld a,(de) : or c : ld (de),a : inc hl : inc de
      ld c,(hl): ld a,(de) : or c : ld (de),a : inc hl : inc de
      ld c,(hl): ld a,(de) : or c : ld (de),a : inc hl : inc de
      ld c,(hl): ld a,(de) : or c : ld (de),a : inc hl 
      ld a,d : add 8 : ld d,a  
      pop bc
      ld e,c
      djnz bclLineOr2

   ret