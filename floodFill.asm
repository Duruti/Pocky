; algo de remplissage
 
;; issue de Wikipedia : https://fr.wikipedia.org/wiki/Algorithme_de_remplissage_par_diffusion#Algorithmes_%C3%A0_pile_explicite

;  remplissage4(pixel, colcible, colrep)
;  début
;    Soit P une pile vide
;    si couleur(pixel) ≠ colcible alors sortir finsi
;    Empiler pixel sur P
;    Tant que P non vide
;    faire
;      Dépiler n de P
;      couleur(n) ← colrep
;      si couleur(n nord) = colcible alors Empiler n nord sur P finsi
;      si couleur(n sud)  = colcible alors Empiler n sud  sur P finsi
;      si couleur(n est)  = colcible alors Empiler n est  sur P finsi
;      si couleur(n ouest)= colcible alors Empiler n ouest sur P finsi
;    fintantque
;  fin

;; couleurCible : c'est la couleur de la cellule en haut a gauche
;; couleurRemplissage : c'est la couleur choisie par le joueur
; pileCouleur l'endroit ou sera stocker les pixels a tester

floodFill:
   ; dans A on à le numero de couleurRemplissage
  
   ld (couleurRemplissage),a 
   ld b,a
   ld a,(grid)
   ld (couleurCible),a

   cp B ; si couleur(pixel) ≠ colcible alors sortir finsi
   ret z

   ld a,&00
   ld (pileCouleur),a
   
   xor a
   inc a
   ld (indexPile),a ; Empile la position de la cellule de départ (0,0)

   loopFloodFill:
      ; dépile 
      ld hl,pileCouleur
      ld a,(indexPile)
      dec a ; depile
      ld (indexPile),a
      ; positionne le pointeur de pile
      add l
      ld l,a
      ; recupere les coordonnées 
      
      ld a,(hl)
      ld (currentPosition),a

      call setColor

      call checkNorth
      call checkSouth
      call checkEast
      call checkWest


      ld a,(indexPile)
     ; DEFB #ED,#FF
      cp 0
      ret z
      jp loopFloodFill
   ret

; permet d'avoir la couleur dans la cellule dont les coordonnées sont dans A
; le quartet de poids fort pour X et le faible pour Y

setColor:
   ld c,A ; save a

   ; recupere y
   and %00001111
   ld b,a
   ld a,(nbRows)
   ld d,a
   xor a

   addRows:
      add d      
      dec b
      jr nz,addRows
   
   ld b,A ; save a
   ld a,c
   and %11110000
   srl a: srl a: srl a: srl a

   add B

   ld hl,grid
   add l
   ld l,a
   ld a,(couleurRemplissage)
   ld (currentSprite),a
   ld (hl),a

   call changeColors

   ret

getColor:
   ld c,A ; save a

   ; recupere y
   and %00001111
   ld b,a
   ld a,(nbRows)
   ld d,a
   xor a

   addRowsGet:
      add d      
      dec b
      jr nz,addRowsGet
   
   ld b,A ; save a
   ld a,c
   and %11110000
   srl a: srl a: srl a: srl a

   add B

   ld hl,grid
   add l
   ld l,a
   ld a,(hl)

   ret

checkNorth:
   ;DEFB #ED,#FF
   ; regarde si on ne sort pas de la grille en haut
   ld a,(currentPosition)
   ld c,a

   and %00001111
   ret z  ; si on est a 0 en y on ne poursuit pas

   ld a,(currentPosition)
   dec a ; enleve une ligne au y
   ld (tempPosition),a

   call controlColor
   
   ret

checkSouth:
   ld a,(nbLines)
   dec a
   ld b,A

   ld a,(currentPosition)
   and %00001111

   cp b
   ret z ; si egale a la derniere ligne on sort

   ld a,(currentPosition)
   inc a ; ajoute une ligne au y
   ld (tempPosition),a
   
   call controlColor
   
   ret

checkEast:
   ld a,(currentPosition)
   and %11110000
   ret z

   ld a,(currentPosition)
   sub a,#10 ; enleve 1 a x
   ld (tempPosition),a
   
   call controlColor

   ret

checkWest
   ld a,(nbRows)
   dec A
   ld b,a

   ld a,(currentPosition)
   and %11110000
   srl a : srl a: srl a: srl a
   cp b
   ret z

   ld a,(currentPosition)
   add a,#10 ; enleve 1 a x
   ld (tempPosition),a
   
   call controlColor



   ret

controlColor:
   call getColor
   ld b,a
   ld a,(couleurCible)
   cp B
   ret nz ; si pas egale on sort

   ld hl,pileCouleur
   ld a,(indexPile)
   add l
   ld l,a
   ld a,(tempPosition)
   ld (hl),a 

   ld a,(indexPile)
   inc a
   ld (indexPile),a
   ret
