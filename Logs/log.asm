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


totalSize = sizeCode + sizeMusic + sizeVariable + sizeGFX + sizeLevel

print "\nsize projet : ",{hex}totalSize

print "\n---------------------------\n"