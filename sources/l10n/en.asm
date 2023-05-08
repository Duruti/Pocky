; les deux premiers octets contienne la position du debut du texte
; x tout les 8 pixels 
; y numero de ligne
; le troisieme octet est le début de la zone d'automodification

enTextGreetingInfo db &0b,&f0,&ff,"GREETING",0
enTextChooseLevel db &08,&f0,&ff,"Choose your level",0
enTextGameover db &0c,&5a,&ff,"Game over",0            ;
enTextVictory db &0b,&4b,&ff,"Next Level",0               ;
enTextLevel : db &00,&f0,6,"Level:  ",0
enTextHub : db &15,&f0,5,"Try: 00/15",0
enTextKonami : db &07,&f0,&ff, "KONAMI CODE ACTIVED",0
enTextEnterCode db &09,&e1,&ff,"ENTER YOUR CODE",0
enCodeLevelOK db &0c,&52,&ff,"CODE VALID",0
enTextWorld db &00,&e0,&6,"World 0",0
enCodeLevel db &0c,&62,&6,"LEVEL 0 ",0
enCodeWorld db &0c,&5a,&6,"WORLD 0 ",0
enChooseLangage db &00,&c0,&ff,"         I love rosbeeF       ",0 ; 4
enTextNewCode db &09,&6A,12,"New code : 0000",0
enNewLevel db &12,&5a,&7,"Level: 0 ",0
enNewWorld db &07,&5a,&7,"World: 0 ",0