print ""
print "############################"
print "        address POCKY"
print "############################\n\n"
sizeMusic = endAdrMusic-adrMusic
print "address music: ",{hex}adrMusic,{hex}endAdrMusic," size :", {hex}sizeMusic
sizeCode = endCode-start
print "address code: ",{hex}start,{hex}endCode," size :", {hex}sizeCode
sizeVariable = endVariable-startVariable
print "address Variable: ",{hex}startVariable,{hex}endVariable," size :", {hex}sizeVariable
sizeGFX = endGFX-startGFX
print "address GFX: ",{hex}startGFX,{hex}endGFX," size :", {hex}sizeGFX
sizeLevel = endLevel-startLevel
print "address Level: ",{hex}startLevel,{hex}endLevel," size :", {hex}sizeLevel
print "address Lignes: ",{hex}LIGNES

totalSize = sizeCode + sizeMusic + sizeVariable + sizeGFX + sizeLevel

print "\nsize projet : ",{hex}totalSize
print "\nMemory Free : ",{hex}(&FFFF - &4000- &100 - totalSize )," / &FFFF"
print "Lenght Level : ",lenghtLevel
print "adress Level ",{int} initCurrentLevel," :",{hex} (lenghtLevel*(initCurrentLevel-1)+startLevel)
print "lstKeys ",{hex} lstKeys
print "\n---------------------------\n"
