;textGreetingInfo db "GREETING",0
konamiIndex db 0
konamiLst ds 10,0
konamiRef db bitUp,bitUp,bitDown,bitDown,bitLeft,bitRight,bitLeft,bitRight,bitEscape,bitEspace
konamiKey db 0
konamiEmpty equ &55

loadGreeting
   ld hl,&C000
   ld bc,&40FF
   ld a,%00000000 ;&30
   call FillRect ; utils.asm
   
   ld a,textGreetingInfo : call getAdressText
   ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de : inc hl

   call printText
   call eraseKonamiLst
  
   call createParticle
   call drawParticle
   ret
updateGreeting:
   call getKeys   ; controls keys and Joystick ; keyManager.asm
   call updateKeysGreeting ; update actions/keys
   ld a,(newKey) ; sauvegarde les etats des touches pour la prochaine boucle
   ld (oldKey),a
   call checkKonami
   ret
updateKeysGreeting:

	ld a,(oldKey) : bit bitEscape,a : call nz,escapeGreetingAction
	ld a,(oldKey) : bit bitUp,a : call nz,addUpKonami
	ld a,(oldKey) : bit bitDown,a : call nz,addDownKonami
	ld a,(oldKey) : bit bitLeft,a : call nz,addLeftKonami
	ld a,(oldKey) : bit bitRight,a : call nz,addRightKonami
	ld a,(oldKey) : bit bitEspace,a : call nz,addAKonami

   ret
KonamiUpdate:
   ; Activation du code konami
   ; affiche un message
 
   ld a,textKonami : call getAdressText
   ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de : inc hl
   call printText
   ret

checkKonami
   ; compare les deux listes pour validation

   ld hl,konamiLst : ld de,konamiRef : ld b,9
   .bcl
      ld c,(hl) : ld a,(de) : cp c : ret nz ; sort si c'est different a un moment
      inc hl : inc de
      djnz .bcl
   call KonamiUpdate
   ret
rotateKonamiLst
   ; décale la la liste a droite
   ; on remplis la liste a la derniere position
   ; pour verifier tout le temps si le code est fait
   ld a,(konamiLst+9) : cp konamiEmpty : ret z
   ld hl,konamiLst+1 : ld de,konamiLst : ld bc,9
   ldir   
   ret

eraseKonamiLst
   ; efface la liste et le remplace par une valeur

   ld hl,konamiLst
   ld b,10 : ld a,konamiEmpty
   .bcl  
      ld (hl),a : inc hl : djnz .bcl
   ret
addKonamiKey:
   ; rajoute le dernier bouton appuyer a la liste
   ; en commencant par la dernier position de la liste
   call rotateKonamiLst : ld hl,konamiLst+9 : ld a,(konamiKey):ld (hl),a 
   ret

addUpKonami
   ; On utilise konamiKey pour enregistrer le dernier bouton
   ld a,(newKey):	bit bitUp,a: ret nz
   ld a,bitUp : ld (konamiKey),a : call addKonamiKey
   ret
addDownKonami
   ld a,(newKey):	bit bitDown,a: ret nz
   ld a,bitDown : ld (konamiKey),a : call addKonamiKey
   ret
addLeftKonami
   ld a,(newKey):	bit bitLeft,a: ret nz
   ld a,bitLeft : ld (konamiKey),a : call addKonamiKey
   ret
addRightKonami
   ld a,(newKey):	bit bitRight,a: ret nz
   ld a,bitRight : ld (konamiKey),a : call addKonamiKey
   ret
addAKonami
   ld a,(newKey):	bit bitEspace,a: ret nz
   ld a,bitEspace : ld (konamiKey),a : call addKonamiKey
   ret

addBKonami
   ld a,(newKey):	bit bitEscape,a: ret nz
   ld a,bitEscape : ld (konamiKey),a : call addKonamiKey
   ret


escapeGreetingAction
	ld a,(newKey):	bit bitEscape,a: ret nz
   ; rustine
   ld a,(konamiLst+9) : cp bitRight : jp z,addBKonami 
   ; pour ce bouton (btn B) il est necessaire de verifier si le precedent bouton est celui
   ; figurant dans la liste de reference.
   ; car ce bouton sert également a quitter la scene

   ld e,sceneMenu : call changeScene ; sceneManager
	ret