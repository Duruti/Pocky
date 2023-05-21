-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

table = {2,4,5,2,3,4,0,5,2,3,0,5}

function encode(pT)
    local lenght = #pT
    local new = 0
    for b=1,lenght/3 do
        new = 0
        for i=1,3 do
            local t=i+(b-1)*3
            local v = pT[t]
            local n = v * math.pow(6,i-1)
            new = new + n
        end
        local r= string.format('%02x',new)
        print("&"..string.upper(r))
    end

end


encode(table)