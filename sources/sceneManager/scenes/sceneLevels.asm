textLevelsInfo db "CHOISI TON LEVEL",0

loadSceneLevels
   ld hl,&C000
   ld bc,&40FF
   ld a,%00000000 ;&30
   call FillRect ; utils.asm

   ld hl,&08F0;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
 	ld (adrPrint),hl ; save la position
   ld a,TextChooseLevel : call getAdressText 
   ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de : inc hl
   call printText
   ret
updateSceneLevels
   call getKeys   ; controls keys and Joystick ; keyManager.asm
   call updateKeysLevels ; update actions/keys
   ld a,(newKey) ; sauvegarde les etats des touches pour la prochaine boucle
   ld (oldKey),a
   ret
updateKeysLevels
	ld a,(oldKey) : bit bitEscape,a : call nz,.escapeAction

   ret
.escapeAction
	ld a,(newKey):	bit bitEscape,a: ret nz
	ld e,sceneMenu : call changeScene ; sceneManager
	ret