initMusic:	
   
   ld hl,Music1
   call Main_Player_Start + 0
   
   ret




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
        include "PlayerAkyMultiPsg.asm"                       ;Only this player has the ROM feature.
;        include "PlayerAky.asm"                       ;Only this player has the ROM feature.
        ;include "../PlayerAkyStabilized_CPC.asm"        ;For now, this player does not take the Player Configuration in account.
        
        ;Declares the buffer for the ROM player, if you're using it. You can declare it anywhere of course.
        IFDEF PLY_AKY_Rom
                PLY_AKY_ROM_Buffer = $                  ;Can be set anywhere.
                ds PLY_AKY_ROM_BufferSize, 0            ;Reserves the buffer for the ROM player (not mandatory, but cleaner).
        ENDIF
Main_Player_End:

Music_Start:
        ;What music to play?
    music1    include "../music/menu.asm"
    music2    include "../music/code.asm"
    musicStart    include "../music/start.asm"
    musicGameover    include "../music/gameover.asm"
    musicWinner    include "../music/winner.asm"
        ;include "MusicBoulesEtBits.asm"

Music_End:
soundEffects:
        include "../music/effect.asm"
