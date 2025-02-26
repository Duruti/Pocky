;textGreetingInfo db "GREETING",0
konamiIndex db 0
konamiLst ds 10,0
konamiRef db bitUp,bitUp,bitDown,bitDown,bitLeft,bitRight,bitLeft,bitRight,bitEscape,bitEspace
konamiKey db 0
konamiEmpty equ &55
counterTextGreeting db 0
endListText equ 7
align 8
listText db TextGreeting1,TextGreeting2,1,2,3,4,5
speedTimer db 3,6,4,8,5,10,2,6
maxNbTimer equ 8
counterTimer db 0
exitGreeting db 0
loadGreeting
   LD BC,#7F10:OUT (C),C:LD C,88:OUT (C),C
  
  ; automodification pour le mode et la couleur dans la routine d'interruption


	ld hl,modeInterruption+1 : ld (hl),&8d
  ; ld hl,color+6 : ld (hl),75 ; &4b
  ; ld hl,color+15 : ld (hl),79 ; &4f
  ; ld hl,color+24 : ld (hl),71 ; &47
 
   ; changer la palette
	ld hl,palInter+1 : ld (hl),paletteGA2

   ld hl,&C000
   ld bc,&40FF
   ld a,%00000000 ;&30
   call FillRect ; utils.asm
   
   ld a,textGreetingInfo : call getAdressText
   ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de : inc hl

   call printText
   call eraseKonamiLst
  
   xor a : ld (counterTextGreeting),a
   ld (exitGreeting),a
  ; call createParticle
  ; call drawParticle
   ret
updateGreeting:
    call animateGreeting 
    ret
checkKey
   push hl : push af : push bc : push de 
   ld hl,(adrPrint) : push hl
   call getKeys   ; controls keys and Joystick ; keyManager.asm
   call updateKeysGreeting ; update actions/keys
   ld a,(newKey) ; sauvegarde les etats des touches pour la prochaine boucle
   ld (oldKey),a
   call checkKonami
   pop hl : ld (adrPrint),hl
   pop de : pop bc : pop af : pop hl
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
   ld a,50 : ld (maxCurrentLevel),a
   call eraseKonamiLst
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
 ;  pop de : pop bc : pop af : pop hl
   call cls2
   ld hl,modeInterruption+1 : ld (hl),&8c
   ld e,sceneMenu : call changeScene ; sceneManager
   ld a,1 : ld (exitGreeting),a
	ret
animateGreeting
   ;ld a,(currentScene) : cp sceneGreeting : ret nz
   ;breakpoint
   call checkKey
   
   ; recupere le texte a afficher dans la liste
   ld hl,listText : ld a,(counterTextGreeting) : add l : ld l,a
   ld a,(hl) : call getAdressText
   ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de : inc hl
   
   call printText2
   ; Controle si on arrive au bout de la liste
   ld a,(counterTextGreeting) : inc a : cp endListText : jr nz,.suite
   ;call cls2
   xor a
   .suite
      ld (counterTextGreeting),a
   endUpdateGreeting
   ret
printText2:
	; hl adresse du texte

	; affiche en mode RPG
	;	jr speed
   ;push hl : push af : push bc : push de
   call checkKey
  ; ld a,(currentScene) : cp sceneGreeting : ret nz
   push hl: 
   ld a,(exitGreeting) : cp 1 : jr nz,.suite2
   pop hl : jp endUpdateGreeting
   .suite2
	;call vbl
   ; charge les vitesse timer
    ld hl,speedTimer : ld a,(counterTimer) : add l : ld l,a   

   ld a,(timerTexte) : inc a : ld (timerTexte),a
	
   cp (hl) ; vitesse
   pop hl

	jr nz,printText2
	xor a
	ld (timerTexte),a
   ld a,(counterTimer) : inc a : cp maxNbTimer : jr nz,.suite
    xor a
    .suite 
    ld (counterTimer),a    


  	ld a,(hl) ; verifie si fin du texte
  	cp 0
  	ret z

   push hl
	
	call convertChar 
	call calcAdrPrint
	;breakpoint
	ld b,heightFont
   call printChar

finPrintChar2 
	ld hl,(adrPrint) : inc h :	ld (adrPrint),hl	
	pop hl  	
	inc hl
   	jp printText2


