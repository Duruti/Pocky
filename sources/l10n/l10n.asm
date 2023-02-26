fr equ 0
en equ 1
; index
TextGreetingInfo equ 0
TextChooseLevel equ 1
TextGameover equ 2
TextVictory equ 3
TextLevel equ 4
TextHub equ 5


currentLangage db fr ; 0:Fr 1 :En

getAdressText:
   ; a contient l'index retourne dans hl l'adresse du texte
   
   sla a : ld c,a : ld b,0 ; bc contient l'index de l'adresse
   ld a,(currentLangage) : cp en : jr z,textEnglish 
   
   ld hl,fr_i10n 
   calcAdressText
      
      add hl,bc ; pointe au bon endroit
      ld e,(hl) : inc hl : ld d,(hl) : ex hl,de
      ret
   textEnglish : ld hl,en_i10n : jr calcAdressText

; table de pointeur sur les textes

fr_i10n: dw frTextGreetingInfo,frTextChooseLevel,frTextGameover,frTextVictory,frTextLevel,frTextHub
en_i10n: dw enTextGreetingInfo,enTextChooseLevel,enTextGameover,enTextVictory,enTextLevel,enTextHub

include "fr.asm"
include "en.asm"