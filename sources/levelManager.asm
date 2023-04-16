/* Encodage des clés
   On peut utiliser 6 cles de couleurs differentes
   Elles sont alors associer au cadenas de la couleur ou se trouve la tuile où est positionné la clé
   exemple : Clé sur tuile verte alors cadenas Vert
   - 6 octets , 1 octet par clé qui contient la position
      Rangé par ordre de couleur
   - 12 octets, 2 octets par clé
      il contiennent la position de debut et de fin dans la liste des cadenas
      une soustraction (end-start) donne la longueur
*/
posStart equ 0
posColor equ 1
posMaxTry equ 2
posLine equ 3
posRow equ 4
posSeed equ 5
posKey equ 7 ; first Key
lenghtKey equ 6 
intervalBlocks equ posKey+lenghtKey
lenghtInterval equ 6*2
posNbBlocks equ intervalBlocks+lenghtInterval
posNbWall equ posNbBlocks+maxNbBlock+1

maxNbBlock equ 30
maxNbWall equ 30
idPadlock equ 18 ; first padlock (17 - 22)

lenghtLevel equ posNbWall+maxNbWall+1 ;40 taille en octet d'un level

maxLevel equ 50

align 6
lstKeys ds 6,0
lstIntervalBlocks ds 6*2,0
numberKeyFound db 0

loadPadlock:
   if build == 0
   
   ld a,(modeEditor) : cp 1 : ret z ; rustine pour eviter conflit avec editeur
   ENDif 


   ld b,6 : ld hl,lstIntervalBlocks
   .bcl
      ; prends la longueur
      ;breakpoint
      ld e,(hl) ; recupere le start
      inc hl : ld a,(hl) : sub e ; a = la longueur de la chaine
      push hl
      jp z,.endbcl
      ld d,0 : ld hl,blocks : add hl,de ; hl pointe sur les block
      push bc
      ld e,a
      .loopBlock:
         ld a,(hl)
         push hl

         call drawPadlock     
         pop hl
         inc hl
         dec e
         jp nz,.loopBlock
         pop bc
      .endbcl
      pop hl : inc hl
   djnz .bcl

   ret

   ; ----------------------------------------------------------
   
   ld a,(nbBlocks)
   ;DEFB #ED,#FF 
  

   ld e,a
   ld hl,blocks
   loopBlock:
      ld a,(hl)
      push hl
      call drawPadlock     
      pop hl
      inc hl
      dec e
      jp nz,loopBlock

   ;call drawPadlock

   ret

drawPadlock:
   push bc
   call getAdresseCell
   pop bc
   ld a,6 : sub b : add 17
  ; ld a,idPadlock
   ld (hl),a
   ret

loadKey:
   xor a : ld (nbKey),a
   ld hl,lstKeys : ld b,6
   .bcl
      ld a,(hl) : cp &FF : jr z,.endbcl  ; si pas de clé on passe le tour 

      ld a,(nbKey) : inc a : ld (nbKey),a ; compte les clefs

      ; range dans le tableau la coordonnées de la clef sur 1 octet   
      ; ld a,&22
      ; ld (keys),a

      ; *************
      ; Rajoute une clef
      ; **************

      
      ld a,(hl) ; recupere la position 
      
      ; recupere le X
      
      and %11110000
      srl a : srl a;  srl a ; srl a
      ld (colonne),a

      ld a,(hl) ; recupere la position 
      ; recupere la ligne
      and %1111
      ld (currentLine),a

      ;   ld a,4
      ;   ld (colonne),a
      push bc : push hl
      call drawKey 
      pop hl : pop bc :
      .endbcl inc hl
      djnz .bcl
   ret
getAddressLevel
   ; retourne l'adresse du level courant dans ix
   
   ld hl,levels
   ld de,lenghtLevel
   ld a,(currentLevel)
   ;   breakpoint
   dec a
   jr z,suite
   ld b,A
   bclAddAdrLevel:
      add hl,de
      djnz bclAddAdrLevel
   suite:
   push hl ;transfert hl dans ix
   pop ix
   ret


loadLevel:
   ; charge le level avec ses carateristiques
   call getAddressLevel
  ; ld ix,levels

   ld a,(ix)      ; position de depart
   ld (positionStart),a

   ld a,(ix+posColor)      ;max color
   ld (maxColor),a
 ; DEFB #ED,#FF
   ld a,(ix+posMaxTry)    ; nb essais
   ld (currentTry),a
   call convertTry
   ld (maxTry),a
   ld a,(ix+posLine)    ; nb lignes
   ld (nbLines),a
   ld a,(ix+posRow)    ; nb colonne
   ld (nbRows),a
      ;seed +5,+6
   push hl
   ld h,(ix+posSeed)
   ld l,(ix+posSeed+1)
   ld  (rndseed+1),hl   ; la seed

   ld hl,&c0de
   ld  (rndseed+4),hl   
   
   pop hl : push hl

   ;   ld a,(ix+posKey)          ; récupere la 1ere clef 
   ;   ld (keys),a
   ; copie des position de cle
   ld bc,6 : ld de,posKey : add hl,de : ld de,lstKeys
   ldir 
   ; copie position des blocks
   ld bc,12 : ld de,lstIntervalBlocks : ldir

   ; --------------
   pop hl
   ld a,(ix+posNbBlocks)          ; nb block
   ld (nbBlocks),a
   cp 0
   call nz,loadBlocks

   ld bc,posNbWall ; decalle ix de 19 
   add ix,bc
   ld a,(ix)
   ld (nbWalls),a
   cp 0
   call nz,loadWalls
   ; charge les walls

  
   ret
initWalls:
   if build == 0
      ld a,(modeEditor) : cp 1 : ret z ; rustine pour eviter conflit avec editeur
   endif
   ld a,(nbWalls)

  

   ld e,a
   ld hl,walls
   loopDrawWalls:
      ld a,(hl)
      push hl
      call drawWalls     
      pop hl
      inc hl
      dec e
      jp nz,loopDrawWalls

   ;call drawPadlock

   ret
drawWalls:
   call getAdresseCell

   ld a,idWall
   ld (hl),a
   ret

loadWalls:
   ld c,a
   ld b,0

   push ix
   pop hl 
   inc hl
   ld de,walls
   ldir
   ret

loadBlocks:
   ld c,a
   ld b,0
  ;DEFB #ED,#FF 
  ; ld hl,levels
   ld de,posNbBlocks+1
   add hl,de
   ;;;   inc hl : inc hl : inc hl : inc hl : inc hl : inc hl ; positionne la pile +6
   ld de,blocks
   ldir   

   ret
addLevel1:
    

   ld a,(currentLevel)
   cp maxLevel ; maxlevel
   jr z,endAddLevel
   ;DEFB #ED,#FF
   inc A
   ld (currentLevel),A
   ;jp init
   call init
   ret

   endAddLevel:
   ld a,1
   ld (currentLevel),A
   ;jp init
   call init
   ret
   
decLevel
   ld a,(currentLevel)
   cp 1 ; maxlevel
   jr z,endDecLevel
   ;  DEFB #ED,#FF
   dec A
   ld (currentLevel),A
   ;jp init
   call init
   ret
   
   endDecLevel:
   ld a,maxLevel
   ld (currentLevel),A
   ;jp init
   call init
   ret
   

getAdresseCell:
      ; retourne l'adresse dans la grille (hl) en fonction de la position de la cellule dans A
   ld c,A ; save a

   ; recupere y
   and %00001111
   ld b,a
   ld a,(nbRows)
   ld d,a
   xor a

   addRows4:
      add d      
      dec b
      jr nz,addRows4
   
   ld b,A ; save a
   ld a,c
   and %11110000
   srl a: srl a: srl a: srl a

   add B

   ld hl,grid
   add l
   ld l,a
   ret
