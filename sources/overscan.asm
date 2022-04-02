overcanVertical:



   ; passage en overcan vertical 32 caractere et 32 lignes


   ld bc,&bc00+1 : out (c),c
   ld bc,&bd00+32 : out (c),c


   ld bc,&bc00+2 : out (c),c
   ld bc,&bd00+42 : out (c),c


   ld bc,&bc00+6 : out (c),c
   ld bc,&bd00+32 : out (c),c


   ld bc,&bc00+7 : out (c),c
   ld bc,&bd00+34 : out (c),c

ret

modeStandart:
   ; 40 colonne et 25 ligne
    ld bc,&bc00+1 : out (c),c
   ld bc,&bd00+40 : out (c),c


   ld bc,&bc00+2 : out (c),c
   ld bc,&bd00+46: out (c),c


   ld bc,&bc00+6 : out (c),c
   ld bc,&bd00+25 : out (c),c


   ld bc,&bc00+7 : out (c),c
   ld bc,&bd00+30 : out (c),c
   ret
