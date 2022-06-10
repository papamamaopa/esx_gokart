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
        TriggerClientEvent('CarError', source, price)
    end
end)
