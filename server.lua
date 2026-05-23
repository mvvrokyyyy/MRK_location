ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent("location:paidVeh")
AddEventHandler("location:paidVeh", function(model, price)

    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney() >= price then

        xPlayer.removeMoney(price)

        TriggerClientEvent("maroky:spawnVeh", source, model)
        TriggerClientEvent("location:playBuySound", source)
       TriggerClientEvent("esx:showAdvancedNotification", source,
    "Location de véhicule",
    "7sparrow Location",
    "Vous avez loué un véhicule pour ~g~$" .. price,
    "CHAR_CARSITE",
    1

)

    else

        TriggerClientEvent('esx:showNotification', source,
            "~r~Pas assez d'argent")

    end
end)