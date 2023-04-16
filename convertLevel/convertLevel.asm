BUILDSNA
SNASET CPC_TYPE,0
BANKset 0
run &1000


positionStart equ 8 ; position (index) où rajouter des cases
nbCells equ 5 ; nb de cases a rajouter
nbLevel equ 50 ; nb de level
lenghtLevel equ 70 ; longueur du level octet

org &1000

ld hl,startLevel : ld de,newLevel : ld c,nbLevel

.bclLevels
   push bc
   ld b,0
   .bclFor1Level
      ld a,b : cp positionStart : call z,addCell
      ; copie la cell
      ld a,(hl) : ld (de),a : inc hl : inc de 
      inc b : ld a,b : cp lenghtLevel : jp nz,.bclFor1Level

pop bc : dec c : jp nz,.bclLevels

jp $


addCell
   ld c,nbCells : ld a,&BB

   .bcl
      ld (de),a : inc de : dec c : jr nz,.bcl
   ret



org &2000
startLevel
INCbin	"../Levels/world.bin",0 ; enleve le header 128 octets
endLevel
print "oldLevel start to : ",{hex}startLevel,{hex}endLevel
org &4000
newLevel

print "newLevel start to : ",{hex}newLevel,{hex}(newLevel+(lenghtLevel+nbCells)*nbLevel)
print "size : ",{hex}((lenghtLevel+nbCells)*nbLevel)