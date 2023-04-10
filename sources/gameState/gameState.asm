; variable du jeu

; les scenes

sceneMenu equ 0
sceneGame equ 1
sceneCode equ 2
sceneGreeting equ 3
sceneLevels equ 4
sceneLangage equ 5
sceneEditor equ 6

maxLines equ 10
maxRows equ 14

currentScene db &FF
if build==0
   adrUpdateScene dw updateMenu,updateGame,updateSceneCode,updateGreeting,updateSceneLevels,updateSceneLangage,updateEditor
   adrLoadScene dw loadMenu,loadGame,loadSceneCode,loadGreeting,loadSceneLevels,loadSceneLangage,loadEditor
else 
   adrUpdateScene dw updateMenu,updateGame,updateSceneCode,updateGreeting,updateSceneLevels,updateSceneLangage
   adrLoadScene dw loadMenu,loadGame,loadSceneCode,loadGreeting,loadSceneLevels,loadSceneLangage
endif

; ------------------------------

