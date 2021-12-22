adrDrawCounter equ &0719
addCounter:
   scf : ccf ; remet a zero le flag C qui peut etre alterer ailleurs
   ; c'est lui qui gere le dépassement quand on utilise daa

   ld a,(compteurCoup)
   inc A
   daa
   ld (compteurCoup),a
   ret

getUnity:
   ld a,(compteurCoup)
   and %00001111

   ret

getDecimal:
   ld a,(compteurCoup)
   and %11110000
   srl a : srl a : srl a : srl a
   ret
transferCounter:
   call getUnity
   ld e,a
   call getDecimal
   ld d,a
   ret

drawCounter:
   ; affiche le compteur
   ; unité 
   ld hl,adrDrawCounter
   call &bb75
   ld a,e
   add &30
   call &bb5A

   

   ; decimal
   ld hl,adrDrawCounter - &0100
   call &bb75
   ld a,d
   cp 0 ; n'affiche le decimal que si > 0
   ret z
   add &30
   call &bb5A

   ret

