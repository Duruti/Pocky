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
   
   ; on change le update 
   ld d,0
   sla e
   ld hl,adrUpdateScene
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
   ld hl,paletteBlack
   call loadPaletteGA
   LD BC,#7F10:OUT (C),C:LD C,84:OUT (C),C

   ld a,(currentScene)
   ld e,a
   
   ld d,0
   sla e
   ld hl,adrLoadScene
   add hl,de
   ex hl,de

   ; automodif du update dans le main
   ld hl,loadCurrentScene+1
   ld a,(de)
   ld (hl),a
   inc hl : inc de
   ld a,(de)
   ld (hl),a

   loadCurrentScene call $
   
   ret

read "scenes/sceneEditor.asm"
read "scenes/sceneMenu.asm"
read "scenes/sceneGame.asm"
