org &1000

ld a,206  
;call encode
call decode
ret

 
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
	ld hl,tampon
	ld ix,result
	ld a,(lenght) : ld b,a
	ld c,0

	bcl:
		ld a,b : cp 0 : jp z,endEncode : dec b
		; chiffre 1
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
		jp bcl 
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

	bclDecode
		
		; chiffre 3 floor(nb/36)
		ld a,e : cp 0 : jp c,endDecode : jp z,endDecode : dec e
		ld a,(hl) : 
		; div 36
		call div36
		ld (ix+2),b

		; chiffre2 floor(nb - (chiffre3*36)/6 )
		ld a,e : cp 0 : jp c,endDecode : jp z,endDecode : dec e
		ld a,(ix+2) : call mul36 : ld b,a
		ld a,(hl) : sub b : call div6
		ld (ix+1),b
		
		; chiffre 1 nb mod 6
		ld a,e : cp 0 : jp c,endDecode : jp z,endDecode : dec e
		ld a,(hl) : call div6 : add 6
		ld (ix),a
		
		inc hl : inc ix : inc ix : inc ix
		jp bclDecode

	endBclDecode
	endDecode
ret


tampon db 2,4,5,2,3,4,0,5,2,3,0,5
result db &25,&06,&01 
org 8000
resultDecode ds 20,&FF
lenght db 12
lenghtDecode db 3
