lineInt equ 1 

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
	push af : push bc : push de : push hl
  ; LD BC,#7F10:OUT (C),C:LD C,88:OUT (C),C
	ld a,(nbInt)
	inc a
	ld (nbInt),a
   ld a,(nbInt)
	cp lineInt
	call z,changeColor
	call nz,Colorback
	
	ld a,(nbInt) : cp 3 : call z,playMusic
	ld a,(nbInt) : cp 4 : call z,DialogText
	;call nz,Colorback  
	
   ld a,(nbInt)
	cp 6

	jr nz,endInt
	xor a
	ld (nbInt),a

endInt
 
   pop hl : pop de : pop bc : pop af
  
	ei
	ret
DialogText
   
   ;call playMusic
   ; boite de dialogue pour informer le joueur

   ld a,(isDialog) : cp 0 : ret z
   
   ld bc,&7f8D ; %10001100 bit 0,1 pour le mode
   out (c),c
   ld hl,PaletteGA
   ld bc,&7F00
   .bclPalGAint:
   
      ld d,(hl) : inc hl
      out (c),c : out (c),d
      inc c
      ld a,c
      cp 4
      jr nz,.bclPalGAint
   ;LD BC,#7F10:OUT (C),C:LD C,82:OUT (C),C
   ret
colorBack:
   ld bc,&7f8c ; %10001100 bit 0,1 pour le mode
   out (c),c
   if Debug
   	LD BC,#7F10:OUT (C),C:LD C,70:OUT (C),C
   ENDIF

palInter:   ld hl,paletteMode0
   call loadPaletteGA
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
	ld bc,&7f8d ; %10001100 bit 0,1 pour le mode
	out (c),c
   
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

	ret


restorInt:
	di
	ld hl,&1234
	ld (#39),hl
	ei	
	ret
