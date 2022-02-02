drawcells:
;DEFB #ED,#FF

ld de,lines

ld a,(currentLine)
sla a
sla a
add a,e
ld e,a
ld a,(de)
ld l,a
inc de
ld a,(de)
ld h,a
ld a,(offsetX)
ld b,a
ld a,(colonne)
add B

ld b,0
ld c,a
add hl,bc
 

ld b,8
olddrawLine:
   ld a,(currentColor)
   
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   ld de,&800
   dec hl
   dec hl
   dec hl
   
   add hl,de
   dec b
   jp nz,drawLine



ld de,lines
inc de
inc de 

ld a,(currentLine)
sla a
sla a

add e

ld e,a
ld a,(de)
ld l,a
inc de
ld a,(de)
ld h,a
ld a,(offsetX)
ld b,a
ld a,(colonne)
add B

   ld b,0
   ld c,a
   add hl,bc
 
   ld b,8

drawLine2: 
   ; ld a,(adrColor)
   ; ld d,a
   ; ld a,(adrColor+1)
   ; ld e,a
   ; ld a,(de)

   ld a,(currentColor)
   
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   inc hl
   ld (hl),a
   ld de,&800
   dec hl
   dec hl
   dec hl
   
   add hl,de
   dec b
   jp nz,drawLine2

;DEFB #ED,#FF

ret
drawline:

   ret
