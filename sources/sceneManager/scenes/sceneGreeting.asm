textGreetingInfo db "GREETING",0

loadGreeting
   ld hl,&C000
   ld bc,&40FF
   ld a,%00000000 ;&30
   call FillRect ; utils.asm

   ld hl,&0BF0;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
 	ld (adrPrint),hl ; save la position
   ld hl,textGreetingInfo
   call printText
   ret
updateGreeting
   call getKeys   ; controls keys and Joystick ; keyManager.asm
   call updateKeysGreeting ; update actions/keys
   ld a,(newKey) ; sauvegarde les etats des touches pour la prochaine boucle
   ld (oldKey),a
   ret
updateKeysGreeting
	ld a,(oldKey) : bit bitEscape,a : call nz,.escapeAction

   ret
.escapeAction
	ld a,(newKey):	bit bitEscape,a: ret nz
	ld e,sceneMenu : call changeScene ; sceneManager
	ret