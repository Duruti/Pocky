
BUILDSNA
SNASET CPC_TYPE,0
BANKset 0

run #4000
org #4000

lineInt equ 3

; synchronise le compteur d'interruption

; Restore Stack Pointer
 di
      ld sp,#C000

      ; Select lower ROM
      ld bc,#7f80 | %1001
      out (c),c

      exx
      xor a
      ex af,af'

      call #0044                  ; Restore #00-#40 and
      call #08bd                  ; Restore vectors

      ; Other calls made by the ROM
      call #1b5c
      call #1fe9
      call #0abf
      call #1074
      call #15a8
      call #24bc
      call #07e0

      ; Back to RAM
      ld   bc,#7f80 | %1101
      out  (c),c
di

 

      

ld bc,&7f8c ; %10001100 bit 0,1 pour le mode
	out (c),c

      ld bc,&4000
      ld hl,img+128
      ld de,&c000
      ldir
       ld hl,palette
        call loadPalette
    


;intro      
;      ld hl,texte
;      call printText
;      djnz intro  



        call frame
	xor a
	ld (nbInt),a
        ld (timer),a
        ld (isRun),a
	; redirige les interruptions
	ld hl,(&39)
	ld (restorInt+1),hl
	; change le pointeur d'interruption
	
	ld hl,interrupt
	ld (#39),hl
	
    ld hl,Music_Start
   call Main_Player_Start + 0
   
   
   ei
bcl:
	;call &bb06
	;cp &20
        call frame
        ld a,(isRun)
        cp 0
        call z,initTest

   ;call Main_Player_Start + 3
	jr bcl
initTest
        ld a,(timer)
        inc A
        ld (timer),A
        cp 250
        ret nz
        ;@brk
        ld a,1
        ld (isRun),a
        ret



restorInt:
	di
	ld hl,&1234
	ld (#39),hl

 
	ei	
	ret

interrupt:
	ld a,(isRun)
        cp 1
        jr nz,endInt
	ld a,(nbInt)
	inc a
	ld (nbInt),a
	cp lineInt
	call z,changeColor
	call nz,Colorback
	ld a,(nbInt)
	cp 6
	jr nz,endInt
	xor a
	ld (nbInt),a

endInt

	ei
	ret
FRAME  	LD B,#F5
FRM     IN A,(C):RRA:JR NC,FRM : nop : ret

colorBack:
	; mode 0
	ld bc,&7f8c ; %10001100 bit 0,1 pour le mode
	out (c),c
	LD BC,#7F10:OUT (C),C:LD C,70:OUT (C),C
	ret

changeColor:
	; mode 1
	ld bc,&7f8d ; %10001100 bit 0,1 pour le mode
	out (c),c
        LD BC,#7F10:OUT (C),C:LD C,78:OUT (C),C
   call Main_Player_Start + 3
  
	LD BC,#7F10:OUT (C),C:LD C,88:OUT (C),C
	ret

printText:
   ld a,(hl)
   cp 0
   ret z
   call &bb5A
   inc hl
   jp printText


texte db, "ca marche....",0
timer db 0
isRun db 0




Start:  equ $

        di
        ld hl,#c9fb
        ld (#38),hl

	;Initializes the music.
        ld hl,Music_Start
        call Main_Player_Start + 0

        ;Some dots on the screen to judge how much CPU takes the player.
        ld a,255
        ld hl,#c000 + 5 * #50
        ld (hl),a
        ld hl,#c000 + 6 * #50
        ld (hl),a
        ld hl,#c000 + 7 * #50
        ld (hl),a
		
        ld bc,#7f03
        out (c),c
        ld a,#4c
        out (c),a
        
Sync:   ld b,#f5
        in a,(c)
        rra
        jr nc,Sync + 2

        ei
        nop
        LD BC,#7F10:OUT (C),C:LD C,70:OUT (C),C
        halt
        LD BC,#7F10:OUT (C),C:LD C,88:OUT (C),C
        halt
        LD BC,#7F10:OUT (C),C:LD C,70:OUT (C),C
        di

        ld b,90
        djnz $

        ld bc,#7f10
        out (c),c
        ld a,#4b
        out (c),a
        
        call Main_Player_Start + 3                ;Play.
        
        ld bc,#7f10
        out (c),c
        ld a,#54
        out (c),a
        LD BC,#7F10:OUT (C),C:LD C,70:OUT (C),C

         ei
         halt
        LD BC,#7F10:OUT (C),C:LD C,88:OUT (C),C
        di

        jr Sync

Main_Player_Start:
        ;Selects the hardware. Not mandatory, as Amstrad CPC is default.
        PLY_AKY_HARDWARE_CPC = 1
        
        ;Want a ROM player (a player without automodification)?
        ;PLY_AKY_Rom = 1                         ;Must be set BEFORE the player is included.

        ;Includes here the Player Configuration source of the songs (you can generate them with AT2 while exporting the songs).
        ;If you don't have any, the player will use a default Configuration (full code used), which may not be optimal.
        ;If you have several songs, include all their configuration here, their flags will stack up!
        ;Warning, this must be included BEFORE the player is compiled.
        ;include "../resources/MusicCarpet_playerconfig.asm"
        ;include "Mysong1_playerconfig.asm"
        ;include "Mysong2_playerconfig.asm"


        ;What player to use?
        include "PlayerAky.asm"                       ;Only this player has the ROM feature.
        ;include "../PlayerAkyStabilized_CPC.asm"        ;For now, this player does not take the Player Configuration in account.
        
        ;Declares the buffer for the ROM player, if you're using it. You can declare it anywhere of course.
        IFDEF PLY_AKY_Rom
                PLY_AKY_ROM_Buffer = $                  ;Can be set anywhere.
                ds PLY_AKY_ROM_BufferSize, 0            ;Reserves the buffer for the ROM player (not mandatory, but cleaner).
        ENDIF
Main_Player_End:

Music_Start:
        ;What music to play?
        include "mod.asm"
        ;include "MusicBoulesEtBits.asm"

Music_End:





nbInt: db 0
img: incbin "img.scr"

;palette: db #54,#4B,#40,#5F,#46,#44,#47,#43,#58,#5B,#4F,#5C,#5E,#56,#4C,#45

palette db #54,#40,#5E,#47,#4B,#5C,#58,#43,#4E,#45,#44,#4C,#4F,#46,#5F,#59
loadPalette

; Charge la palette de couleur	
; mettre dans HL l'adresse de la palette
        ld hl,palette
        ld bc,&7F00
        bclPal:
               
                ld d,(hl) : inc hl
                out (c),c : out (c),d
                inc c
                ld a,c
                cp 16
                jr nz,bclPal
        ret
