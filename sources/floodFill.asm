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
   push bc

   ld a,(positionStart) ; recupere la couleur cible
   ;DEFB #ED,#FF
   call getColor
   ;DEFB #ED,#FF
   ld (couleurCible),a
   pop bc

   cp B ; si couleur(pixel) ≠ colcible alors sortir finsi
   ret z

   call addCounter
   ;call transferCounter
   call drawCounter

   ;xor A
   ;ld (controlKey),a

   ld a,(positionStart)
   ld (pileCouleur),a
  ; DEFB #ED,#FF
   ld a,1
   ld (indexPile),a ; Empile la position de la cellule de départ (0,0)
   ;ld (indexPilePositionKey),a ; mets a zero

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
      ld a,1
      ld (isOffsetY),a
      
      ld a,(hl)
      ld (currentPosition),a
  

      call setColor
   ;DEFB #ED,#FF

      call checkNorth
      call checkSouth
      call checkEast
      call checkWest


      ld a,(indexPile)
    ;  DEFB #ED,#FF
      cp 0
      jp z,endLoopFill
      jp loopFloodFill

      endLoopFill
      ;DEFB #ED,#FF
     ; ld a,(couleurRemplissage) : cp 3 : call z,debugKey

         ld a,(nbKey) ; faut il verifier la présence de Keys
         cp 0
         ret z ; call nz,isKey

      ; copy la grid
      ld bc,255
      ld hl,grid
      ld de,gridCopy
      ldir

      ; init variables
      xor a :  ld (isFoundKey),a
      ld a,1 : ld (controlKey),a

      ld a,(couleurRemplissage) : ld (couleurCible),a
      ld a,&FF : ld (couleurRemplissage),a

      ld a,(positionStart) : ld (pileCouleur),a
   
      ld a,1 : ld (indexPile),a ; Empile la position de la cellule de départ (0,0)
      ;ld (indexPilePositionKey),a ; mets a zero

      call searchKey

      ; restore la grid
      ld bc,255
      ld hl,gridCopy
      ld de,grid
      ldir

      ld a,(isFoundKey)
      cp 1
      call z,drawDebugKey

   ret

searchKey:
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

      call setColor2

      call checkNorth
      call checkSouth
      call checkEast
      call checkWest


      ld a,(indexPile)
     ; DEFB #ED,#FF
      cp 0
      jp z,endSearchKey
      jp searchKey

      endSearchKey:
         xor A
         ld (controlKey),a
   ret

isKey:
   ; test pour chaque clef
   push bc : push hl

   ld hl,lstKeys : ld b,6
   ;breakpoint
   nop
   .bcl
      ld a,(hl) : inc hl 
      ld d,A
      ld a,(tempPosition)
      cp &41 : call z,debugKey
      cp d
      ;DEFB #ED,#FF
      call z,foundKey

   djnz .bcl
  
   

   pop hl : pop bc
   ret
debugKey 
   nop : breakpoint : ret
foundKey:
   ;breakpoint
   ld a,(isFoundKey) : cp 1 : ret z
   ld a,1
   ld (isFoundKey),a
   ld a,6 : sub b : ld (numberKeyFound),a ; sauvergarde l'index de la clef
   ld a,(nbKey) : dec a : ld (nbKey),a

   ret




drawDebugKey:
   

   ld a,(couleurCible)
   
   ld (couleurRemplissage),a

  ; ld a,(tempPosition)
   ld a,(numberKeyFound) : ld hl,lstKeys : add l : ld l,a : 
   ld a,(hl)
   ld (currentPosition),a
   call setColor

   ; ld de,&c000
   ; ld hl,mkey
   ; call drawMask
   ; ret


   ; ld de,&c000
   ; ld hl,key
   ; call drawSpriteOr
   
  ; ld a,&FF
  ; ld (couleurRemplissage),a
   
   call unblock

   ; ld a,0
   ; ld (nbKey),a
   call updateListKey
   call drawListKeyInGame
   ret


   ; permet d'avoir la couleur dans la cellule dont les coordonnées sont dans A
   ; le quartet de poids fort pour X et le faible pour Y
updateListKey
   ld a,(numberKeyFound)
   ld hl,lstKeys : add l : ld l,a : ld (hl),&FF
   ret
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
setColor2:
   ld c,A ; save a

   ; recupere y
   and %00001111
   ld b,a
   ld a,(nbRows)
   ld d,a
   xor a

   addRows2:
      add d      
      dec b
      jr nz,addRows2
   
   ld b,A ; save a
   ld a,c
   and %11110000
   srl a: srl a: srl a: srl a

   add B

   ld hl,grid
   add l
   ld l,a
   ld a,(couleurRemplissage)
  ; ld (currentSprite),a
   ld (hl),a


   ret


getColor:
   ; recupere dans a la couleur de la tuile
   ; donner en entre la position dans A xxxxyyyy
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
   ;ld (tempColor),a


   ;ld a,(tempColor)
   
   ld b,a
   ld a,(couleurCible)
   cp B
   ret nz ; si pas egale on sort

   ld a,(controlKey)
   cp 1
   call z,isKey

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

unblock:

   ;DEFB #ED,#FF
     
   ld a,(numberKeyFound) : sla a ; 
   ld hl,lstIntervalBlocks : add l : ld l,a ; hl pointe sur la position start
   ld e,(hl) ; recupere le start
   inc hl : ld a,(hl) : sub e : ld b,a ; met dans b la longueur de la chaine
   ld d,0 : ld hl,blocks : add hl,de
  ;   ld a,(nbBlocks)

  ;   ld b,10 ; nb de block a supprimer
  ;   ld hl,blocks ;  adresse depart des blocks 
   loopUnBlock:
      ld a,(hl)
      push bc
      inc hl
      push hl
      call drawUnBlock
      pop hl
      pop bc
      dec b
      jp nz,loopUnBlock
   ret

   drawUnBlock:
      ld (currentPosition),a
      call initCell
     ; ld a,0
      ld (couleurRemplissage),a
      ;ld a,(currentPosition)
      ld a,(currentPosition)
      call setColor

      ret
drawListKeyInGame
	ld b,6 : ld hl,lstKeys
	.draw
		push bc
		ld a,(hl) : cp &ff : jr z,.endDraw 
      ld a,(hl) : call getPadlockInGrid
      cp &ff : jr z,.endDraw
      ;ld a,(hl) : and %11110000 : srl a : srl a : ld (colonne),a 
	   ;ld a,(hl) : and %1111 : ld (currentLine),a 

		ld a,1 : ld (isOffsetY),a
      push hl:  ld a,(hl) : and %11110000 : srl a : srl a : ld (colonne),a 
	   ld a,(hl) : and %1111 : ld (currentLine),a 
		call drawKey : pop hl 
		.endDraw
			NOP
			;ld a,9 : ld (currentSprite),a : call drawcells
			inc hl : pop bc: djnz .draw
	ret
getPadlockInGrid 
   ; retourne dans a &FF si position key=padlock
	push hl
   ld a,(nbRows) : ld d,0 : ld e,a 
   ld a,(hl) : and %11110000 : srl a : srl a : srl a : srl a : ld (colonne),a 
	ld a,(hl) : and %1111 : ld (currentLine),a 
   call DE_Mul_A : ld a,(colonne) : add l : ld l,a 
   ld de,grid : add hl,de : ld a,(hl)
   ; test si on est dans l'interval des cadenas 
   ; a>= 17  c=0 et  a< 23 c =1 
   cp 17 : jr c,.endTest
   cp 23 : jr nc,.endTest
   ld a,&ff : pop hl : ret
   .endTest
   pop hl : ret
   ret



