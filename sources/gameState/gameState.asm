; variable du jeu

; les scenes

sceneMenu equ 0
sceneGame equ 1
sceneEditor equ 2

currentScene db &FF
adrUpdateScene dw updateMenu,updateGame,updateEditor
adrLoadScene dw loadMenu,loadGame,loadEditor

; ------------------------------
