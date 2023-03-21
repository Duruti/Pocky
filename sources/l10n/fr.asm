; les deux premiers octets contienne la position du debut du texte
; x tout les 8 pixels 
; y numero de ligne

frTextGreetingInfo db &0b,&f0,&ff,"Merci",0              ;
frTextChooseLevel db &08,&f0,&ff,"Choisi ton niveau",0   ;
frTextGameover db &0c,&5a,&ff,"Perdu",0                  ;
frTextVictory db &08,&5a,&ff,"Bravo tu as gagne",0       ;
frTextLevel : db &01,&f0,7,"Niveau:  ",0                 ;
frTextHub : db &13,&f0,7,"Essai: 00/15",0
frTextKonami : db &07,&f0,&ff,"CODE KONAMI ACTIVER",0        ;
