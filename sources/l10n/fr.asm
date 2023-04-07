; les deux premiers octets contienne la position du debut du texte
; x tout les 8 pixels 
; y numero de ligne

frTextGreetingInfo db &0b,&f0,&ff,"Merci",0              ;
frTextChooseLevel db &08,&f0,&ff,"Choisi ton niveau",0   ;
frTextGameover db &0c,&5a,&ff,"Perdu",0                  ;
frTextVictory db &08,&5a,&ff,"Bravo tu as gagne",0       ;
frTextLevel : db &01,&f0,7,"Niveau:  ",0                 ;
frTextHub : db &13,&f0,7,"Essai: 00/15",0
frTextKonami : db &07,&f0,&ff, "CODE KONAMI ACTIVER",0        ;
frTextEnterCode db &09,&e1,&ff,"ENTRE TON CODE",0
frCodeLevelOK db &09,&5a,&ff,"CODE VALIDE",0
frTextWorld db &01,&e0,&6,"Monde 0",0
frCodeLevel db &0c,&5a,&7,"NIVEAU 0 ",0
frCodeWorld db &0c,&5a,&6,"MONDE 0 ",0
