; les deux premiers octets contienne la position du debut du texte
; x tout les 8 pixels 
; y numero de ligne

frTextGreetingInfo db &0b,&f0,&ff,"Merci",0              ;
frTextChooseLevel db &08,&f0,&ff,"Choisi ton niveau",0   ;
frTextGameover db &0d,&5a,&ff,"Perdu",0                  ;
frTextVictory db &09,&4e,&ff,"Prochain Niveau",0       ;
frTextLevel : db &00,&f0,7,"Niveau:  ",0                 ;
frTextHub : db &13,&f0,7,"Essai: 00/15",0
frTextKonami : db &07,&f0,&ff, "CODE KONAMI ACTIVE",0        ;
frTextEnterCode db &09,&e1,&ff,"ENTRE TON CODE",0
frCodeLevelOK db &0c,&52,&ff,"CODE VALIDE",0
frTextWorld db &00,&e2,&6,"Monde 0",0
frCodeLevel db &0c,&62,&7,"NIVEAU 0 ",0
frCodeWorld db &0c,&5a,&6,"MONDE 0 ",0
frChooseLangage db &00,&c0,&ff,"     J'aime les grenouilles     ",0
frTextNewCode db &07,&6A,16,"Nouveau code : 0000",0
frNewLevel db &11,&5c,&8,"Niveau: 0 ",0
frNewWorld db &06,&5c,&7,"Monde: 0 ",0
;frTextTrack db &00,&52,&ff,"TU ES LE PLUS RAPIDE",0
frTextTrack db &07,&52,&ff,"Code a transmettre",0;          .
frCodeTrack db &00,&62,&ff,"                                 ",0
frGreetingText1 db &0B,&10,&ff,"Code : Duruti",0
frGreetingText2 db &00,&30,&ff,"Gfx : BDCIron le gros raleur",0
