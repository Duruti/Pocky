/*
   TODO
   - afficher un point
*/
xParticle equ 0
yParticle equ 2
colorParticle equ 9
align 16
Particles ds 10*16,0 ; 10 particules (16 octets) (x*2 ,y*2 ,vx*2,vy*2,time,color)

createParticle
   ld ix,particles
   ld a,50 : ld (ix+xParticle),a
   ld a,100 : ld (ix+yParticle),a
   ld a,3 : ld (ix+colorParticle),a ; couleur

   ret
drawParticle
   ld ix,particles
   ld d,(ix+xParticle)
   ld e,(ix+yParticle)   
   call getAdressParticle
   ld a,%00101000 : srl a : ld (bc),a

   ret
getAdressParticle 
   ; le numero de ligne
 ; breakpoint
   ld bc,lignes : ld h,0 : ld l,e : add hl,hl : add hl,bc ; pointe sur la ligne dans la table
   ld a,d : srl a : ld c,(hl): add c : ld c,a ; gere le x en /2 pour se retrouver a l'octet
   inc hl : ld b,(hl) 
   ret
