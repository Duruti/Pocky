
BUILDSNA
SNASET CPC_TYPE,0
BANKset 0

run #1000
org #1000

lineInt equ 3

; synchronise le compteur d'interruption

        call frame
	xor a
	ld (nbInt),a
        ld (timer),a
        ld (isRun),a
	; redirige les interruptions

	; change le pointeur d'interruption
	ld a,&c3 
        ld (&38),a
	ld hl,interrupt
	ld (#39),hl
	
        ld hl,Music_Start
        call Main_Player_Start + 0
   
        ei

bcl:
	jr bcl


interrupt:
	push af : push bc : push de : push hl

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
        pop hl : pop de : pop bc : pop af

	ei
	ret


FRAME  	LD B,#F5
FRM     IN A,(C):RRA:JR NC,FRM : nop : ret

colorBack:
	
	lD BC,#7F10:OUT (C),C:LD C,70:OUT (C),C
	ret

changeColor:
	
	
        LD BC,#7F10:OUT (C),C:LD C,78:OUT (C),C
        call Main_Player_Start + 3
  
	LD BC,#7F10:OUT (C),C:LD C,88:OUT (C),C
	ret

timer db 0
isRun db 0
nbInt: db 0




Main_Player_Start:
        ;Selects the hardware. Not mandatory, as Amstrad CPC is default.
        PLY_AKY_HARDWARE_CPC = 1
        PLY_AKY_ROM = 1
        PLY_AKY_ROM_Buffer = #8000
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






