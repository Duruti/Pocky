fr equ 0
en equ 1
; index
TextGreetingInfo equ 0
TextChooseLevel equ 1
TextGameover equ 2
TextVictory equ 3
TextLevel equ 4
TextHub equ 5
textKonami equ 6
TextEnterCode equ 7
TextCodeLevelOK equ 8
TextWorld equ 9
TextCodeLevel equ 10
TextCodeWorld equ 11
TextChooseLangage equ 12
TextNewCode equ 13
TextNewLevel equ 14
TextNewWorld equ 15
TextTrack equ 16
TextCodeTrack equ 17
TextGreeting1 equ 18
TextGreeting2 equ 19

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

fr_i10n: dw frTextGreetingInfo,frTextChooseLevel,frTextGameover,frTextVictory,frTextLevel
         dw frTextHub,frTextKonami,frTextEnterCode,frCodeLevelOK,frTextWorld,frCodeLevel
         dw frCodeWorld,frChooseLangage,frTextNewCode,frNewLevel,frNewWorld,frTextTrack
         dw frCodeTrack,frGreetingText1,frGreetingText2
en_i10n: dw enTextGreetingInfo,enTextChooseLevel,enTextGameover,enTextVictory,enTextLevel
         dw enTextHub,enTextKonami,enTextEnterCode,enCodeLevelOK,enTextWorld,enCodeLevel
         dw enCodeWorld,enChooseLangage,enTextNewCode,enNewLevel,enNewWorld,frTextTrack
         dw frCodeTrack,enGreetingText1,enGreetingText2
include "fr.asm"
include "en.asm"