lineInt equ 1 
colorBorderHud equ 93 ; 93
loadInterruption:
      di
      KILLSYS            LD             HL,#C9FB:LD (#38),HL
      ei

      FRAMEint  	LD B,#F5
      FRMint     IN A,(C):RRA:JR NC,FRMint 
      Halt : halt : halt 
      FRM2                   IN                      A,(C):RRA:JR NC,FRM2
      ld a,0
      ld (nbInt),a
      di
      LD A,#C3:LD (#38),A
      ld hl,interrupt
      ld (#39),hl
      ei


interrupt:
	push af : push bc : push de : push hl ;: push ix
	
   ld a,(nbInt) : inc a : ld (nbInt),a
   ;ld a,(currentScene) : cp sceneMenu : jr z,.suite
   cp lineInt : call z,changeColor
	.suite
   ld a,(nbInt) : cp lineInt : call nz,Colorback
   push ix
	ld a,(nbInt) : cp 3 : call z,playMusic
   pop ix
	ld a,(nbInt) : cp 4 : call z,DialogText
	;call nz,Colorback  
	
   ld a,(nbInt)
	cp 6

	jr nz,endInt
	xor a
	ld (nbInt),a

endInt
 
   ;pop ix :
   pop hl : pop de : pop bc : pop af 
  
	ei
	ret
DialogText
   
   ;call playMusic
   ; boite de dialogue pour informer le joueur

   ld a,(isDialog) : cp 0 : ret z
  ;.DS 10

  ; LD BC,#7F10:OUT (C),C:LD C,colorBorderHud:OUT (C),C
   ds 4
   ld bc,&7f8D ; %10001100 bit 0,1 pour le mode
   out (c),c

   LD BC,#7F00:OUT (C),C:LD C,84:OUT (C),C
   LD BC,#7F02:OUT (C),C:LD C,79:OUT (C),C
   LD BC,#7F01:OUT (C),C:LD C,75:OUT (C),C
   LD BC,#7F03:OUT (C),C:LD C,71:OUT (C),C
   ret


colorBack:
  
   
   
   if Debug
   	LD BC,#7F10:OUT (C),C:LD C,70:OUT (C),C
   ENDIF
   ;ds 18
   ; LD BC,#7F00:OUT (C),C:LD C,76:OUT (C),C
     LD BC,#7F01:OUT (C),C:LD C,88:OUT (C),C
     LD BC,#7F02:OUT (C),C:LD C,68:OUT (C),C
     LD BC,#7F03:OUT (C),C:LD C,85:OUT (C),C
   ;ds 15
   ld bc,&7f8c :out (c),c ; %10001100 bit 0,1 pour le mode
   ;ret

   
   ;LD BC,#7F10:OUT (C),C:LD C,70:OUT (C),C
   
   palInter:   
   ld hl,paletteMode0 : call loadPaletteGA
   ;LD BC,#7F10:OUT (C),C:LD C,88:OUT (C),C
   LD BC,#7F10:OUT (C),C:LD C,88:OUT (C),C
   ret
playMusic
   if Debug
	   LD BC,#7F10:OUT (C),C:LD C,76:OUT (C),C
   ENDIF
   
   if IsMusic
      ld a,(isMusicPlaying) : cp 0 : jr z,.suite
      call Main_Player_Start + 3
   ENDIF
   .suite
  
   if Debug
      LD BC,#7F10:OUT (C),C:LD C,86:OUT (C),C
   ENDIF
   ret
changeColor:
   ; LD BC,#7F10:OUT (C),C:LD C,76:OUT (C),C
   ; LD BC,#7F00:OUT (C),C:LD C,70:OUT (C),C
   ; ds 48
   LD BC,#7F10:OUT (C),C:LD C,colorBorderHud:OUT (C),C
   LD BC,#7F00:OUT (C),C:LD C,colorBorderHud:OUT (C),C
  ;breakpoint
	
   ld bc,&7f8d ; %10001100 bit 0,1 pour le mode
	out (c),c
   LD BC,#7F01:OUT (C),C:LD C,75:OUT (C),C
   LD BC,#7F02:OUT (C),C:LD C,79:OUT (C),C
   LD BC,#7F03:OUT (C),C:LD C,71:OUT (C),C

   ret
   
   ;------------------------

   ld hl,PaletteGA
   ld bc,&7F00
   bclPalGAint:
   
      ld d,(hl) : inc hl
      out (c),c : out (c),d
      inc c
      ld a,c
      cp 4
      jr nz,bclPalGAint
   ;call playMusic

   LD BC,#7F00:OUT (C),C:LD C,79:OUT (C),C
   LD BC,#7F10:OUT (C),C:LD C,79:OUT (C),C
	ret


restorInt:
	di
	ld hl,&1234
	ld (#39),hl
	ei	
	ret
