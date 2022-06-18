ESX = nil
local xPlayer

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("cart:checkMoney")
AddEventHandler("cart:checkMoney", function(kart, price)
    xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        TriggerClientEvent("cart:spawn", source, kart, price)
    else
        TriggerClientEvent('CarError', source, "Du hast nicht genug Geld dabei!")
    end
end)

RegisterServerEvent("gokart:spawnCart")
AddEventHandler("gokart:spawnCart", function(modelHash)
    print(modelHash)
    local vehicle = CreateVehicle(modelHash, -1146.11, -2121.44, 14.56, 1.0, true, true)
    TriggerClientEvent("gokart:setCart", vehicle)
end)
