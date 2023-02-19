; variable du jeu

; les scenes

sceneMenu equ 0
sceneGame equ 1
sceneLevels equ 2
sceneGreeting equ 3
sceneEditor equ 4

maxLines equ 10
maxRows equ 14

currentScene db &FF
if build==0
adrUpdateScene dw updateMenu,updateGame,updateSceneLevels,updateGreeting,updateEditor
adrLoadScene dw loadMenu,loadGame,loadSceneLevels,loadGreeting,loadEditor
else 
adrUpdateScene dw updateMenu,updateGame,updateSceneLevels,updateGreeting
adrLoadScene dw loadMenu,loadGame,loadSceneLevels,loadGreeting
endif

; ------------------------------

