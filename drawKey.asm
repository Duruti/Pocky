; dessine les clefs


drawKey: 
   

   call getAdrScreen
   ld hl,mkey
   call drawMask


   call getAdrScreen
   ld hl,key
   call drawSpriteOr


ret

getAdrScreen:
   ; retourne dans DE l'adresse ecran
   ; en fonction de la ligne (currentLine et de la colonne(multiple de 4))

   ld de,lines

   ld a,(currentLine)
   sla a    ; multiplie par 4 (2*2 octets) pour se déplacer sur le pointeur 
   sla a  

   add a,e  ; on déplace le pointeur, en changeant que le poids faible car on a mis l'adresse de grid a 0
   ld e,a
   ; on recupere l'adresse ecran dans HL
   ld a,(de)
   ld l,a
   inc de
   ld a,(de)
   ld h,a
   ; on a dans hl l'adresse ou afficher

   ; rajoute l'offset a X
   ld a,(offsetX)
   ld b,a
   ld a,(colonne)
   add B

   ld b,0
   ld c,a
   add hl,bc

   ex hl,de ; on remet dans DE l'adresse ecran
   ret 


include "spriteRoutine/transparence.asm"
