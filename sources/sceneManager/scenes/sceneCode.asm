L1 equ &C20F
L2 equ &c30f
L3 equ &c40F
MaxLetterBuffer equ 4
currentCursor db 0
oldCurrentCursor db 0
currentLetterCode db 0
align 4 
bufferCode  ds 4,&30
maxLetterCode equ 18-1
indexBuffer db 0
codeHex dw 0
maxLevelCode db 50
align 128
tableCodeHex 
   dw &0001,&0002,&0003,&0004,&0005,&0006,&0007,&0008,&0009,&000A
   dw &0011,&0012,&0013,&0014,&0015,&0016,&0017,&0018,&0019,&001A
   dw &0021,&0022,&0023,&0024,&0025,&0026,&0027,&0028,&0029,&002A
   dw &0031,&0032,&0033,&0034,&0035,&0036,&0037,&0038,&0039,&003A
   dw &0041,&0042,&0043,&0044,&0045,&0046,&0047,&0048,&0049,&004A
isCodeValid db 0

align 16
tableAsciiCode db &30,&31,&32,&33,&34,&35,&36,&37,&38,&39,&41,&42,&43,&44,&45,&46

align 64
tableCode ; adresse video pour le curseur
   dw l1,l1+6,l1+12,l1+18,l1+24,l1+30
   dw l2,l2+6,l2+12,l2+18,l2+24,l2+30
   dw l3,l3+6,l3+12,l3+18,l3+24,l3+30

loadSceneCode:
   xor a : ld (indexBuffer),a : ld (currentLetterCode),a : ld (isCodeValid),a
   call initBuffer
   ld hl,&C000
   ld bc,&40FF
   ld a,%00000000 ;&30
   call FillRect ; utils.asm

   ld hl,&08F0;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
 	ld (adrPrint),hl ; save la position
   ld a,TextEnterCode : call getAdressText 
   ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de : inc hl
   call printText

   ld hl,&0eF0;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
 	ld (adrPrintCode),hl ; save la position

   ; affiche les lettres pour le joystick
   ld de,(tableCode)
 
   ld b,18

   .loop
      push bc 
      
      ld hl,tableCode : ld a,(currentLetterCode) : sla a : add l : ld l,a
      ld e,(hl) : inc hl : ld d,(hl) : push de
      ld a,(currentLetterCode) : call multi64
      ld bc,codegfx : add hl,bc
      pop de
      ld bc,&410 : call drawWindows 
      ld a,(currentLetterCode) : inc a : ld (currentLetterCode),a
      pop bc : djnz .loop
   
  
   ld a,(currentCursor) : call calcAdrCursorCode
   ld hl,cursorCodeMask : call drawMask
   ld a,(currentCursor) : call calcAdrCursorCode
   ld hl,cursorCode :  call drawSpriteOr
   ; affiche le cursor
   ;adrCurs equ L1 
   ;ld bc,&0F60 : call calcAdr64 : breakpoint
   ;ld de,L1
   ;ld hl,cursorCodeMask : call drawMask
   ;;ld bc,adrCurs : call calcAdr64 
   ;ld de,L1
   ;ld hl,cursorCode : : call drawSpriteOr
   ret
eraseLetter
   ld a,&20
   ld hl,(adrPrintCode) : dec h : ld (adrPrint),hl : ld (adrPrintCode),hl
   call convertChar
   call calcAdrPrint

	ld b,heightFont
   call printChar
   ret
initBuffer
   xor a : ld (indexBuffer),a
    ld b,4 
   .loop
      push bc : call eraseLetter : pop bc : djnz .loop
   ret

updateSceneCode
   
   
   call getKeys   ; controls keys and Joystick ; keyManager.asm
   call updateKeysCode ; update actions/keys
   ld a,(newKey) : ld (oldKey),a ; sauvegarde les etats des touches pour la prochaine boucle
   
   
   call waitKey
   ret
updateKeysCode   
  	ld a,(oldKey) : bit bitEscape,a : call nz,escapeActionCode 
   ld a,(oldKey) : bit bitEspace,a : call nz,validActionCode 
   ld a,(isCodeValid) : cp 2 : ret z
 	ld a,(oldKey) : bit bitRight,a : call nz,rightActionCode 
 	ld a,(oldKey) : bit bitLeft,a : call nz,leftActionCode 
 	ld a,(oldKey) : bit bitUp,a : call nz,upActionCode 
 	ld a,(oldKey) : bit bitDown,a : call nz,downActionCode 
   ret
rightActionCode
	ld a,(newKey):	bit bitRight,a:ret nz
   ld a,(currentCursor) : cp maxLetterCode : ret z :
   inc a : ld (currentCursor),a
   call drawCursorCode
   ld a,(currentCursor) : ld (oldCurrentCursor),a

   ;jp updateKeysCode.end
   ret
leftActionCode
	ld a,(newKey):	bit bitLeft,a:ret nz
   ld a,(currentCursor) : cp 0 : ret z :
   dec a : ld (currentCursor),a
   call drawCursorCode
   ld a,(currentCursor) : ld (oldCurrentCursor),a

   ret
upActionCode
	ld a,(newKey):	bit bitUp,a:ret nz
   ld a,(currentCursor) : cp 6 : ret c :
   sub 6 : ld (currentCursor),a
   call drawCursorCode
   ld a,(currentCursor) : ld (oldCurrentCursor),a
   ret
downActionCode
	ld a,(newKey):	bit bitDown,a:ret nz
   ld a,(currentCursor) : cp 6*2 : ret nc :
   add 6 : ld (currentCursor),a
   call drawCursorCode
   ld a,(currentCursor) : ld (oldCurrentCursor),a
   ret

escapeActionCode
	ld a,(newKey):	bit bitEscape,a:ret nz
   ld a,0 : ld (isDialog),a
	ld e,sceneMenu : call changeScene ; sceneManager
   	ret
validActionCode
	ld a,(newKey):	bit bitEspace,a:ret nz
   ld a,(isCodeValid) : cp 2 : jp z,exitSceneCode
   ld a,(currentCursor) 
   cp 16 : jp z,backspaceCode
   cp 17 : jp z,controlCode
   
   ld a,(indexBuffer) : cp MaxLetterBuffer : ret nc 
   ld hl,tableAsciiCode : ld a,(currentCursor)
   add l : ld l,a
   ld a,(hl) : ld b,a : call printCode
	ld a,(indexBuffer) : inc a : ld (indexBuffer),a

	ret
exitSceneCode
   ld a,0 : ld (isDialog),a
	ld e,sceneGame : call changeScene ; sceneManager
  
   ret
drawCursorCode
   ld a,(currentCursor) : call calcAdrCursorCode : ld hl,cursorCodeMask : call drawMask
   ld a,(currentCursor) : call calcAdrCursorCode : ld hl,cursorCode : : call drawSpriteOr
   ; restore le fond
 
   ld a,(oldCurrentCursor) : call calcAdrCursorCode : push de
   ld a,(oldCurrentCursor) : call multi64 : ld bc,codegfx : add hl,bc
   pop de : ld bc,&410 : call drawWindows 
  
   call vbl
   ret
calcAdrCursorCode
  ; breakpoint
   sla a
   ld hl,tableCode : add l : ld l,a
   ld e,(hl) : inc l : ld d,(hl)
   ret
backspaceCode
   ld a,(indexBuffer) : cp 0 : ret z
   call eraseLetter
   ld a,(indexBuffer) : dec a : ld (indexBuffer),a
   ret
controlCode
   ;breakpoint
   call convertAsciiToHex
   call checkCode
   ld a,(isCodeValid) : cp 2
   jr nz,.end 
   call codeTrue
   
   nop :nop
   .end
      call initBuffer
   ret

checkCode
   
   ; controle que le code est valide (z=1) ou pas (Z=0)  
   ld a,(maxLevelCode) : ld b,a
   ld de,(codeHex)
   ld hl,tableCodeHex
   .loop
      xor a : ld (isCodeValid),a
      ld a,(hl) : cp e : jr nz,.next
      ld a,1 : ld (isCodeValid),a
      .next 
      inc hl : ld a,(hl) : cp d : jr nz,.next2
      ld a,(isCodeValid) : inc a : ld (isCodeValid),a : cp 2 : jr z,.end
      
      .next2
      inc hl
      djnz .loop
   ret
   .end
   ld a,(maxLevelCode) : sub b : inc a : ld (currentLevel),a
   ret
codeTrue
   ;init
   call getCurrentLevelWorld
   xor A : ld (exit),a
   ld a,startLineBoxDialog : ld (countLineDown),a : ld (countLineUp),a
   call drawBoxDialog
   
   ld a,TextCodeLevelOK: call getAdressText
   ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de : inc hl
   call printText 
   

   
  ld a,TextCodeLevel : call getAdressText :
  ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de
  ld c,(hl) : inc c : inc hl : ld b,0
  push hl: add hl,bc : push hl

  ld a,(currentLevelWorld)
  ld d,a
  ld e,10
  call div
  ; update unité
  add &30
  ;ld ix,textLevel
  pop hl
  ld (hl),a
  ld a,d
  add &30
  dec hl
  ld (hl),a

  ;ld hl,&01F0;64 ;h=x (x=1 pour 8 pixels (soit 2 octets en mode 1) &  l=Y (ligne en pixel)
 	;ld (adrPrint),hl ; save la position
  pop hl :  call printText

  ld a,TextCodeWorld : call getAdressText 
  ld d,(hl) : inc hl : ld e,(hl) : inc hl : ld (adrPrint),de : inc hl : push hl
  dec hl : ld c,(hl) : inc hl : ld b,0 : add hl,bc : ld a,(currentWorld): inc a : add &30 : ld (hl),a
  pop hl : call printText

   ; ld a,(currentWorld): ld (maxCurrentWorld),a
   ; ld a,(currentLevelWorld) : ld (maxCurrentLevelWorld),a
   ld a,(currentLevel) : ld (maxCurrentLevel),a
  ret

convertAsciiToHex
   ;converti les 4 caracteres pour le code et le place dans un buffer
  ; breakpoint
   ; init codeHex
   ld hl,0 : ld (codeHex),hl
   ld hl,bufferCode : ld b,4 :
   
    ld de,codeHex+1
   .loop
      ld a,(hl) 
      sub &30 : cp 10 : jp c,.suite ; routine pour convertir A-F
      sub &7
      .suite ; on a dans A le code en Hex
      bit 0,b : jr nz,.impaire ; test si impaire pour faire un decalage
      ; pour index 4 et 2 
      ld c,a : ld a,(de) : or c : ld (de),a
      jr .endloop
      ; pour index 3 et 1 
      .impaire 
      ld c,a : ld a,(de)  : sla a : sla a : sla a: sla a: : or c : ld (de),a
      dec de
      .endloop
      inc hl
      djnz .loop

   ret
; valeur des bits
bit0 equ &FE
bit1 equ &FD
bit2 equ &FB
bit3 equ &F7
bit4 equ &EF
bit5 equ &DF
bit6 equ &BF
bit7 equ &7F

; pour faire le keypressed
adrPrintCode dw 0
newKeyCode db &ff
oldKeyCode db &ff

waitKey

	ld hl,tableKey : ld b,(hl) ; recupere le nombre de touche a tester 
	
	ld a,&ff : ld (newKeyCode),a ; initialisation de newkey
	
	loop_table
		push bc
		inc hl : ld d,(hl): inc hl : call read_key ; lecture de la ligne
		ld d,(hl) : inc hl : cp d : call z,updateKey ; si identique a la table
		pop bc : djnz loop_table 

	ld a,(newKeyCode) : ld (oldKeyCode),a ; sauve l'etat de la touche
   ret
controlKeyCode
   breakpoint
   ld a,(isCodeValid) : cp 2 : jp z,exitSceneCode
   jp controlCode
   ret
updateKey
	ld b,(hl) : ld a,b : ld (newKeyCode),a  ; acutalise la nouvelle touche
	ld a,(oldKeyCode) : cp b : ret z ; la compare avec l'ancienne pour faire un keypressed
   ld a,b 
   cp 'Z' : jp z,backspaceCode
   cp 'V' : jp z,controlKeyCode
   
   ld a,(indexBuffer) : cp MaxLetterBuffer : ret nc 
   ; /////  ici action a faire si touche presse
	; moi je me contente d'afficher le code ascci de la table.
	
   push hl : ld a,b : call printCode: pop hl ; affiche a l'ecran la lettre
	ld a,(indexBuffer) : inc a : ld (indexBuffer),a
   ret
printCode
   ; copie dans le buffer
   
   
   ld a,(indexBuffer) : ld hl,bufferCode : add l : ld l,a : ld (hl),b
   ; affiche le caractere
   ld a,b
   ld hl,(adrPrintCode) : ld (adrPrint),hl : inc h : ld (adrPrintCode),hl
   call convertChar
   call calcAdrPrint

	ld b,heightFont
   call printChar
   ret

read_key

	     LD          BC,&F40E        ; Valeur 14 sur le port A         
        OUT         (C),C         
        LD          BC,&F6C0        ; C'est un registre         
        OUT         (C),C         
        LD          BC,&F600        ; Validation         
        OUT         (C),C         
        LD          BC,&F792        ; Port A en entrée         
        OUT         (C),C         
        LD          A,D             ; A=ligne clavier         
        OR          %01000000        
        LD          B,&F6         
        OUT         (C),A         
        LD          B,&F4           ; Lecture du port A         
        IN          A,(C)           ; A=Reg 14 du PSG         
        LD          BC,&F782        ; Port A en sortie         
        OUT         (C),C         
        LD          BC,&F600        ; Validation         
        OUT         (C),C           ; Et A contient la ligne
	RET

tableKey
	; le premier octet c'est le nombre de touche a tester
	; ensuite c'est une table de 3 octets
	; 1 - la ligne a tester
	; 2 - le bit a tester
	; 3 - la valeur de la touche, ici un code ascii 

	db 29 
	db 8,bit3,'A', 6,bit6,'B', 7,bit6,'C', 7,bit5,'D', 7,bit2,'E', 6,bit5,'F'
	db 4,bit0,'0', 8,bit0,'1', 8,bit1,'2', 7,bit1,'3', 7,bit0,'4', 6,bit1,'5'
	db 6,bit0,'6', 5,bit1,'7', 5,bit0,'8', 4,bit1,'9', 1,bit7,'0', 1,bit5,'1'
	db 1,bit6,'2', 0,bit5,'3', 2,bit4,'4', 1,bit4,'5', 0,bit4,'6', 1,bit2,'7'
	db 1,bit3,'8', 0,bit3,'9' ,9,bit7,'Z', 0,bit6,'V', 2,bit2,'V'