macro PlaySoundEffect,number,channel,invertedVolume
   ld a,{number} ;(&gt;=1)
   ld c,{channel} ;(0-2)
   ld b,{invertedVolume} ;(0-16 (0=full volume))
   call PLY_AKY_PlaySoundEffect
mend
