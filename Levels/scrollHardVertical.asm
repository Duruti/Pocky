; SKELETON CODE. PROBABLY DOESNT WORK. PROVIDED TO SHOW HOW IT IS DONE.
;
; This code shows an example to smoothly scroll a screen vertically
;
; This works by using register 5 which allows a line offset.
; So you use register 5 for smooth pixel shift, and when you have moved
; 8 lines, use the hardware scrolling to scroll the screen.
;
; When using splitting, you must set the register 5 before the block
; to scroll, and then set it again before the block ends (here a different
; value).
; If you dont do this, the block below the one scrolling will move
; too!!!
;
; before part to scroll:
;
; - top part &BC05 values 7,6,5,4,3,2,1,0 (shift values for section
;   to scroll)

; during part to scroll:
;
; - bottom part &BC05 values 0,1,2,3,4,5,6,7 (shift values for block
;   below section to scroll)
;
; during last section on screen:
;
; - before the last block ends &BC05 value 0 (so top block on screen
;   doesnt move
; - you may also find, that if this is not present, the whole screen
;   will jump up and down

.screen_width equ 40

org &4000

nolist

.main_loop
ld b,&f5
.vsync
in a,(c)
rra
jr nc,vsync           ;wait for vsync

ld bc,&bc07
out (c),c
ld bc,&bdff           ;init vertical split
out (c),c

;----------------------------------------------------------------------------

halt

; set vertical position for block to scroll

ld a,(vertical_position+1)

ld bc,&bc05
out (c),c
inc b
out (c),a

; set address of block

.screen_address ld hl,&0000	; holds screen scrolling offset
ld bc,&bc0c
out (c),c
inc b
ld a,h
or %00110000			; &C000-&FFFF screen range
out (c),a
ld bc,&bc0d
out (c),c
inc b
ld a,l
out (c),a

halt

halt

halt

; set vertical position for next block inside block being scrolled

ld a,7
.vertical_position sub 7
ld bc,&bc05
out (c),c
inc b
out (c),a

halt

halt

; set vertical position for top block on screen

ld bc,&bc05		; top block on screen doesnt have a shift
out (c),c
ld bc,&bd00
out (c),c

ld bc,&bc07		; part of vertical split
out (c),c
ld bc,&bd00
out (c),c
call scroll_up

jp main_loop




.scroll_up
ld a,(vertical_position+1)
dec a
and 7
ld (vertical_position+1),a	; change vertical position
cp 7
ret nz

ld hl,(screen_address+1)	; update screen address
ld bc,screen_width
add hl,bc
ld a,h
and 3
ld h,a
ld (screen_address+1),hl
ret

.scroll_down
ld a,(vertical_position+1)
inc a
and 7
ld (vertical_position+1),a	; change vertical position
ret nz

ld hl,(screen_address+1)	; change screen address
ld bc,-screen_width
add hl,bc
ld a,h
and 3
ld h,a
ld (screen_address+1),hl
ret