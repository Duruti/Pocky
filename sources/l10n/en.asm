; les deux premiers octets contienne la position du debut du texte
; x tout les 8 pixels 
; y numero de ligne
; le troisieme octet est le début de la zone d'automodification

enTextGreetingInfo db &0b,&f0,&ff,"GREETING",0
enTextChooseLevel db &08,&f0,&ff,"Choose your level",0
enTextGameover db &0c,&5a,&ff,"Game over",0            ;
enTextVictory db &0c,&5a,&ff,"You Win",0               ;
enTextLevel : db &01,&f0,6,"Level:  ",0
enTextHub : db &15,&f0,5,"Try: 00/15",0
enTextKonami : db &07,&f0,&ff,"KONAMI CODE ACTIVED",0