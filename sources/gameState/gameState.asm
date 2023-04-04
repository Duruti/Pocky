; variable du jeu

; les scenes

sceneMenu equ 0
sceneGame equ 1
sceneCode equ 2
sceneGreeting equ 3
sceneLevels equ 4
sceneEditor equ 5

maxLines equ 10
maxRows equ 14

currentScene db &FF
if build==0
   adrUpdateScene dw updateMenu,updateGame,updateSceneCode,updateGreeting,updateSceneLevels,updateEditor
   adrLoadScene dw loadMenu,loadGame,loadSceneCode,loadGreeting,loadSceneLevels,loadEditor,
else 
   adrUpdateScene dw updateMenu,updateGame,updateSceneCode,updateGreeting,updateSceneLevels
   adrLoadScene dw loadMenu,loadGame,loadSceneCode,loadGreeting,loadSceneLevels
endif

; ------------------------------

