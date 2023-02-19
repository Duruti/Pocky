initScene:

   ret


changeScene:
   ; e contient la nouvelle scene
   ; verifie si faut changer la scene
   ; si e = currentScene alors non
   ld a,(currentScene)
   cp e
   ret z
   ; on actualise le changement de scene
   ld a,e
   ld (currentScene),a
   
   ; on change le update en recuperant l'adresse de la nouvelle scene 
   ld d,0
   sla e
   ld hl,adrUpdateScene  ;gameState.asm
   add hl,de
   ex hl,de

   ; automodif du update dans le main
   ld hl,updateCurrentScene+1
   ld a,(de)
   ld (hl),a
   inc hl : inc de
   ld a,(de)
   ld (hl),a

   
   ; on appelle le load de la scene


   ; chargement palette
   ;di
   ;ld hl,palInter+1
   ;ld (hl),paletteBlack  
   ;ei
   
   ld hl,paletteBlack
   call loadPaletteGA
   LD BC,#7F10:OUT (C),C:LD C,84:OUT (C),C


   ld a,(currentScene)
   ld e,a
   ld d,0
   sla e
   ld hl,adrLoadScene ;gameState.asm
   add hl,de
   ex hl,de

   ; automodif du load
   ld hl,loadCurrentScene+1
   ld a,(de)
   ld (hl),a
   inc hl : inc de
   ld a,(de)
   ld (hl),a

   loadCurrentScene call $
   
   ret
if build==0 
   read "scenes/sceneEditor.asm"
endif
read "scenes/sceneMenu.asm"
read "scenes/sceneGame.asm"
read "scenes/sceneLevels.asm"
read "scenes/sceneGreeting.asm"