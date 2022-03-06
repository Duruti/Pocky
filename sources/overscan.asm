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
