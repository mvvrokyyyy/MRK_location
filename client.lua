ESX = exports["es_extended"]:getSharedObject()

local open = false
local PedPostition = vec3(313.3149, -240.4381, 54.0342)
local pedHeading = 343.28
local pedModel = "a_m_y_skater_02"

RMenu.Add("location",'main',RageUI.CreateMenu("Location",'Louer un véhicule'))


CreateThread(function()
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do Wait(0) end

    local ped = CreatePed(4, pedModel,
        PedPostition.x, PedPostition.y, PedPostition.z - 1,
        pedHeading, false, true)

    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)
end)


CreateThread(function()
    while true do
        local sleep = 1000

        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local dist = #(coords - PedPostition)

        if dist < 10.0 then
            sleep = 0
            DrawMarker(27, PedPostition.x, PedPostition.y, PedPostition.z - 1.0,
                0.0,0.0,0.0,0.0,0.0,0.0,
                1.5,1.5,0.5,0,150,255,180,false,true,2,false)

            if dist < 2.0 then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ pour louer un véhicule")

                if IsControlJustPressed(0, 38) then
                    open = true
                    RageUI.Visible(RMenu:Get('location','main'), true)
                end
            end
        end

        RageUI.IsVisible(RMenu:Get('location','main'), function()

            RageUI.Button("Panto", "500$", {}, true, {
                onSelected = function()
                    TriggerServerEvent("location:paidVeh",'blista',500)
                    open = false
                    RageUI.Visible(RMenu:Get('location','main'), false)
                end
            })

            RageUI.Button("Faggio", "300$", {}, true, {
                onSelected = function()
                    TriggerServerEvent("location:paidVeh",'faggio',300)
                    open = false
                    RageUI.Visible(RMenu:Get('location','main'), false)
                end
            })

            RageUI.Button("BMX", "150$", {}, true, {
                onSelected = function()
                    TriggerServerEvent("location:paidVeh",'bmx',150)
                    open = false
                    RageUI.Visible(RMenu:Get('location','main'), false)
                end
            })

        end)

        Wait(sleep)
    end
end)

RegisterNetEvent("maroky:spawnVeh")
AddEventHandler("maroky:spawnVeh", function(model)

    local playerPed = PlayerPedId()
    local spawn = Config.SpawnsVeh[math.random(#Config.SpawnsVeh)]
    local hash = GetHashKey(model)

    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(0) end

    local vehicle = CreateVehicle(hash, spawn.x, spawn.y, spawn.z, 190.0, true, false)

    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

    SetVehicleNumberPlateText(vehicle, "LOC"..math.random(100,999))


    TriggerEvent("location:playBuySound")

    ESX.ShowNotification("Véhicule loué avec succès")
end)


RegisterNetEvent("location:playBuySound")
AddEventHandler("location:playBuySound", function()
    PlaySoundFrontend(-1, "PURCHASE", "HUD_LIQUOR_STORE_SOUNDSET", true)
end)