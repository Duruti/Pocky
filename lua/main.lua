--[[
        Genère une liste random de code (0-&FFFF) pour les niveaux du jeu
        l'index du tableau correspond au numero de level
--]]


-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

math.randomseed(50)
local tableCode = {}
nbCode = 50
for i=1,nbCode do
    local rnd
    repeat
        local rndNotExist = true
        rnd = math.floor(math.random()*0xFFFF)
        for n=1,i do
            local v=tableCode[n]
            if v == rnd then
               rndNotExist = false
            end
        end
    until (rndNotExist)
--    print(string.format("%X",rnd))
    table.insert(tableCode,rnd)
end

-- copie dans le presse papier

local text = "dw "
for n,t in ipairs(tableCode) do
    text=text.."&"..tostring(string.format("%X",t))
    if n%10 == 0 and not(n==nbCode) then
    text=text.."\ndw "
    elseif not(n==nbCode) then
        text=text..","
    end
    
end

love.system.setClipboardText(text)
love.event.quit(1)
