--[[
    Convertion palette INK en GA64
]]--


-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')


local tableGA64 = {84,68,85,92,88,93,76,69,77,86,70,87,94,64,95,78,71,79,82,66,83,90,89,91,74,67,75}
-- mettre ici la palette a convertir
local tableInk = {1,11,2,6,16,26}

local palette ="db "
for i=1,#tableInk do
    local v = tableInk[i] + 1
    local c = tableGA64[v]
    palette=palette..c..","
end
print(palette)
love.system.setClipboardText(palette)
love.event.quit(1)
