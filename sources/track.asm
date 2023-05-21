
 
div36
	ld b,0
	bcldiv
		sub 36 : jr c,endDiv
		inc b : jr bcldiv
	endDiv
   ret
div6
	ld b,0
	bcldiv6
		sub 6 : jr c,endDiv6
		inc b : jr bcldiv6
	endDiv6
   ret
	





encode:
	ld hl,tamponLeveltrack
	ld ix,result
	ld a,(indexTamponLevelTrack) : ld b,a
	ld a,0 : ld (lenghtCode),a ; compteur de longueur du code
   ld c,0

	.bcl:
		ld a,b : cp 0 : jp z,endEncode : dec b
		; chiffre 1
		ld a,(lenghtCode) : inc a : ld (lenghtCode),a
      ld a,(hl) : add c : ld c,a 
		; chiffre 2
		ld a,b : cp 0 : jp z,endbcl : dec b
		inc hl : ld a,(hl) 
		call mul6
		; chiffre 3
		ld a,b : cp 0 : jp z,endbcl :  dec b
		inc hl : ld a,(hl) 
		call mul36
		add c
		; a = result
		ld (ix),a : inc ix : ld c,0 : inc hl
		jp .bcl 
	endbcl
	   ld a,c : ld (ix),a 
	endEncode
   ret
mul6   ; a*6
	; d et a modifie
	; result dans a
	ld d,a : sla a : sla a : add d : add d : add c : ld c,a
	ret
mul36   ; a*36
	; d et a modifie
	; result dans a
	ld d,a : sla a : sla a : sla a : sla a : sla a : add d : add d : add d : add d ; *36
	ret


decode

	ld hl,result : ld ix,resultDecode ; point sur le depart des 3 chiffres
	ld a,(lenghtDecode) : ld e,a : sla a : add e : ld e,a

	.bclDecode
		
		; chiffre 3 floor(nb/36)
		ld a,e : cp 0 : jp z,endDecode : dec e
		ld a,(hl) : 
		; div 36
		call div36
		ld (ix+2),b

		; chiffre2 floor(nb - (chiffre3*36)/6 )
		ld a,e : cp 0 : jp z,endDecode : dec e
		ld a,(ix+2) : call mul36 : ld b,a
		ld a,(hl) : sub b : call div6
		ld (ix+1),b
		
		; chiffre 1 nb mod 6
		ld a,e : cp 0 : jp z,endDecode : dec e
		ld a,(hl) : call div6 : add 6
		ld (ix),a
		
		inc hl : inc ix : inc ix : inc ix
		jp .bclDecode

	   endBclDecode
	   endDecode
   ret

ConvertCodeToText
   ld a,TextCodeTrack : call getAdressText :
   inc hl : inc hl : inc hl

   ld a,(lenghtCode) : ld b,a : ld c,a
   ; on centre
   ld a,32 : sla b : sub b : srl c : sub c : srl a
   ld b,0 : ld c,a : add hl,bc
   push hl : pop de
   ld hl,result
    ld a,(lenghtCode) : ld b,a 
   .bcl
      ld a,(hl) :and %11110000 : srl a : srl a : srl a : srl a 
      cp 10 : jr c,.chiffre
      add 7
      .chiffre
         add &30
      ld (de),a : inc de

      ld a,(hl) : and %1111
      cp 10 : jr c,.chiffre1
      add 7
      .chiffre1
      add &30
      ld (de),a : inc de
      inc hl  
      ; test si impaire
      bit 0,b : jr z,.end
      ld a,&20 : ld (de),a : inc de
      .end
   djnz .bcl

   ret


