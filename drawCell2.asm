
drawcells:
   ; calcul l'adresse de l'écran en fonction de la lignes
   ; 1 ligne = 16 pixels
   ; j'utilise une table ou son stocké les valeurs de ligne
   ld de,lines

   ld a,(currentLine)
   sla a    ; multiplie par 4 (2*2 octets) pour se déplacer sur le pointeur 
   sla a  

   add a,e  ; on déplace le pointeur, en changeant que le poids faible car on a mis l'adresse de grid a 0
   ld e,a
   ; on recupere l'adresse ecran dans HL
   ld a,(de)
   ld l,a
   inc de
   ld a,(de)
   ld h,a
   ; on a dans hl l'adresse ou afficher

   ; rajoute l'offset a X
   ld a,(offsetX)
   ld b,a
   ld a,(colonne)
   add B

   ld b,0
   ld c,a
   add hl,bc

   ex hl,de ; on remet dans DE l'adresse ecran
   
   push af
   ; on récupere le sprite à afficher
   ld a,(currentSprite) 
   ld hl,dataSprite
   call calcColor ;  retourne l'adresse du sprite a afficher
   pop af
   call drawSprite
   ret

drawSprite:
  ; ld de,&c040
 ;  ld e,a
   ;ld a,e
   ;ld (saveAdrX),A

   ld b,e ; utilise b pour sauver la position en X
   ld c,&ff ; le charge pour eviter de modifier b vu que c est decrementé avec ldi

   ldi:ldi:ldi:ldi : ld a,d : add 8 : ld d,A : ld e,b ;;ld a,(saveAdrX) : ld e,a
   ldi:ldi:ldi:ldi : ld a,d : add 8 : ld d,A : ld e,b ;; ld a,(saveAdrX) : ld e,a
   ldi:ldi:ldi:ldi : ld a,d : add 8 : ld d,A : ld e,b ;; ld a,(saveAdrX) : ld e,a
   ldi:ldi:ldi:ldi : ld a,d : add 8 : ld d,A : ld e,b ;; ld a,(saveAdrX) : ld e,a
   ldi:ldi:ldi:ldi : ld a,d : add 8 : ld d,A : ld e,b ;; ld a,(saveAdrX) : ld e,a
   ldi:ldi:ldi:ldi : ld a,d : add 8 : ld d,A : ld e,b ;; ld a,(saveAdrX) : ld e,a
   ldi:ldi:ldi:ldi : ld a,d : add 8 : ld d,A : ld e,b ;; ld a,(saveAdrX) : ld e,a
   ldi:ldi:ldi:ldi : ld e,b ;; ld a,(saveAdrX) : ld e,a
   ; DEFB #ED,#FF
   ex hl,de ; saut de ligne en 64 octets
   ld bc,&c840
   add hl,bc
   
   ex hl,de
 
   ; ld a,e
   ld b,e
   ld c,&ff
   ;ld (saveAdrX),A
   ;ld e,a

   ldi:ldi:ldi:ldi : ld a,d : add 8 : ld d,A : ld e,b ;;ld a,(saveAdrX) : ld e,a
   ldi:ldi:ldi:ldi : ld a,d : add 8 : ld d,A : ld e,b;;ld a,(saveAdrX) : ld e,a
   ldi:ldi:ldi:ldi : ld a,d : add 8 : ld d,A : ld e,b;;ld a,(saveAdrX) : ld e,a
   ldi:ldi:ldi:ldi : ld a,d : add 8 : ld d,A : ld e,b;;ld a,(saveAdrX) : ld e,a
   ldi:ldi:ldi:ldi : ld a,d : add 8 : ld d,A : ld e,b;;ld a,(saveAdrX) : ld e,a
   ldi:ldi:ldi:ldi : ld a,d : add 8 : ld d,A : ld e,b;;ld a,(saveAdrX) : ld e,a
   ldi:ldi:ldi:ldi : ld a,d : add 8 : ld d,A : ld e,b;;ld a,(saveAdrX) : ld e,a
   ldi:ldi:ldi:ldi : ld a,d : add 8 : ld d,A : ld e,b;;ld a,(saveAdrX) : ld e,a
   ldi:ldi:ldi:ldi 

   ret

calcColor:
   cp 0
   ret z
   push de
   ld de,69
   bclCalc:
      add hl,de 
      dec a
      jr nz,bclCalc
      
   pop de

   ret
