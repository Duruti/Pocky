addCounter:
   ; j'ai fais un double compteur, un pour l'affichage et l'autre pour tester le game over
   
   
   ld a,(nbTry)
   inc A
   ld (nbTry),A

   scf : ccf ; remet a zero le flag C qui peut etre alterer ailleurs
   ; c'est lui qui gere le dépassement quand on utilise daa


   ld a,(compteurAffichage)
   inc A
   daa
   ld (compteurAffichage),a
   ret

getUnity:
   ld a,(compteurAffichage)
   and %00001111
   ret

getDecimal:
   ld a,(compteurAffichage)
   and %11110000
   srl a : srl a : srl a : srl a
   ret
transferCounter:
   ; call getUnity
   ; ld e,a
   ; call getDecimal
   ; ld d,a
   ; ret
convertTry:
   ld d,a
   ld e,10
   call div
   ; decale a vers le poids fort
   sla d : sla d: sla d : sla d
   add d ; rajoute le poids faible
   ; dans a on a le compteur max a afficher

   ret
drawCounter:

   ld a,TextHub : call getAdressText :
   ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de
   ld c,(hl) : inc c : inc hl : ld b,0
   push hl: add hl,bc 

   call getUnity
   add &30
   ld (hl),a
   call getDecimal
   cp 0 : jr z,.draw
   dec hl
   add &30
   ld (hl),a
   .draw
      pop hl :  call printText
      ret

initCounter
   ; remet a zero le compteur   
   ld a,TextHub : call getAdressText :
   ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de
   ld c,(hl) : inc c : inc hl : ld b,0
   push hl: add hl,bc 

   ld (hl),&30 : dec hl : ld (hl),&30 
   pop hl :  call printText
   ret
