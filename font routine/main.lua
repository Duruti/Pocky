-- Crée une table pour le calcule de ligne 
-- pour CPC en ovescan vertical 64 octets/ligne
-- et 32 lignes de caractere soit 256 lignes

local CurrentTable = {}

local nbLine = 32
nbRow = 8


function love.load()
    makeTable()
    --writeFile("table64.bin",CurrentTable)
end


function writeFile(pName,pData)
   local file = io.open(pName,"wb")

    for l=1 , nbLine do
        for c=1,nbRow do
            local value = CurrentTable[l][c] 
            file:write(bytes(value))
        end
    end
   file:close() 
end
function bytes(x)
    -- convertie le nombre en deux octets
    
    local b2=x%256  x=(x-x%256)/256
    local b1=x%256  x=(x-x%256)/256
    return string.char(b2,b1)
end


function makeTable()
    
    -- ma ligne de référence
    local firstLine = { 0xC000,0xC800,0xD000,0xD800,0xE000,0xE800,0xF000,0xF800}
    for l=1 , nbLine do
        CurrentTable[l] = {}
        for c=1,nbRow do
        
        local value = firstLine[c] + (l-1)*0x40 
        CurrentTable[l][c] = value
        end
         local v1=decimalToHex(CurrentTable[l][1])
         local v2=decimalToHex(CurrentTable[l][2])
         local v3=decimalToHex(CurrentTable[l][3])
         local v4=decimalToHex(CurrentTable[l][4])
         local v5=decimalToHex(CurrentTable[l][5])
         local v6=decimalToHex(CurrentTable[l][6])
         local v7=decimalToHex(CurrentTable[l][7])
         local v8=decimalToHex(CurrentTable[l][8])
        
        -- pour le debug
        
        print(v1,v2,v3,v4,v5,v6,v7,v8)
    end
   -- 
end


function decimalToHex(num)
    if num == 0 then
        return '0'
    end
    local neg = false
    if num < 0 then
        neg = true
        num = num * -1
    end
    local hexstr = "0123456789ABCDEF"
    local result = ""
    while num > 0 do
        local n = math.mod(num, 16)
        result = string.sub(hexstr, n + 1, n + 1) .. result
        num = math.floor(num / 16)
    end
    if neg then
        result = '-' .. result
    end
    return result
end