adrDrawCounter equ &19F0 ; &0719

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
   call getUnity
   ld e,a
   call getDecimal
   ld d,a
   ret
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
   
   ; affiche le compteur
   ; unité 
   ; ld a,colorPaperHub
   ; call  &BB96

   ld hl,adrDrawCounter
   ;   call &bb75 ; position
   ld (adrPrint),hl

   ld a,e
   add &30
   push de
   call printA
   ;   call &bb5A ; texte

   
  
   ; decimal
   ld hl,adrDrawCounter - &0100 ; decalage
   ld (adrPrint),hl
   ; call &bb75
   pop de
   ld a,d
   cp 0 ; n'affiche le decimal que si > 0
   ret z
   add &30
   call printA
 
   ;  call &bb5A

   ret

