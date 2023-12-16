local RSGCore = exports['rsg-core']:GetCoreObject()

pumpid = nil
local spawnedPump = nil
local isSpawned = false
pumpBlip = nil
local ownedCID = nil
local spawnedHorseID = 0
local pumpStorage = 0
local pumpWeight = 0
local isLoggedIn = false



exports('CheckActiveWagon', function()
    return spawnedPump
end)

RegisterNetEvent('mms-oilpumps:client:updatepumpid', function(pumpid, cid)
    ownedCID = cid
    --print('Owned CID: ' .. ownedCID)
end)

RegisterNetEvent('RSGCore:Client:OnPlayerLoaded')
AddEventHandler('RSGCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    Citizen.Wait(2000)
    if spawnedPump == nil then
    Citizen.Wait(1000)
    Checkpump()
    end
end)


Citizen.CreateThread(function()
    for shop,v in pairs(Config.Dealer) do
    local model = v.model
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(1)
    end
    local coords = v.DealerPos
    local dealer = CreatePed(model, coords.x, coords.y, coords.z - 1.0, coords.w, false, false, 0, 0)
    Citizen.InvokeNative(0x283978A15512B2FE, dealer, true)
    SetEntityCanBeDamaged(dealer, false)
    SetEntityInvincible(dealer, true)
    FreezeEntityPosition(dealer, true)
    SetBlockingOfNonTemporaryEvents(dealer, true)
    Wait(1)
    end

    for shop,v in pairs(Config.shops) do
        exports['rsg-core']:createPrompt(v.name, v.coords, RSGCore.Shared.Keybinds['J'],  (' ') .. v.lable, {
            type = 'client',
            event = 'mms-oilpumps:client:shopmenu',
            args = {},
        })
        if v.showblip == true then
            local shopmain = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, v.coords)
            SetBlipSprite(shopmain, GetHashKey(v.blipSprite), true)
            SetBlipScale(shopmain, v.blipScale)
            Citizen.InvokeNative(0x9CB1A1623062F402, shopmain, v.blipName)
        end
    end
    
end)

RegisterNetEvent('mms-oilpumps:client:shopmenu', function()
        
    lib.registerContext(
        {
            id = 'shopmenu',
            title = ('Pumpen Shop'),
            position = 'top-right',
            options = {
                {
                    title = ('Kaufe Pumpe.'),
                    description = ('Kaufe eine Pumpe.' ),
                    icon = 'fas fa-shop',
                    event = 'mms-oilpumps:client:buypump',
                },
            }
        }
    )
    lib.showContext('shopmenu')
end)

RegisterNetEvent('mms-oilpump:client:spawnpump')
AddEventHandler('mms-oilpump:client:spawnpump', function()
    local ped = PlayerPedId()
    local playerpos = GetEntityCoords(ped)
    local valentine = Config.TownValentine
    local rhodes = Config.TownRhodes
    local strawberry = Config.TownStrawberry
    local blackwater = Config.TownBlackwater
    local annesburg = Config.TownAnnesburg
    local vanhorn = Config.TownVanhorn
    local saintdenise = Config.TownSaintdenise
    local tumbleweed = Config.TownTumbleweed
    local armadillo = Config.TownArmadillo
    local distancevalentine = #(playerpos - valentine)
    local distancerhodes = #(playerpos - rhodes)
    local distancestrawberry = #(playerpos - strawberry)
    local distanceblackwater = #(playerpos - blackwater)
    local distanceannesburg = #(playerpos - annesburg)
    local distancevanhorn = #(playerpos - vanhorn)
    local distancesaintdenise = #(playerpos - saintdenise)
    local distancetumbleweed = #(playerpos - tumbleweed)
    local distancearmadillo = #(playerpos - armadillo)
    print(distanceannesburg) print(distancearmadillo) print(distanceblackwater) print(distancerhodes) print(distancesaintdenise)
    print(distancestrawberry) print(distancetumbleweed) print(distancevalentine) print(distancevanhorn)
        if distancevalentine >= Config.TownDistanceNeeded and distancerhodes >= Config.TownDistanceNeeded and distancestrawberry >= Config.TownDistanceNeeded and distanceblackwater >= Config.TownDistanceNeeded and distanceannesburg >= Config.TownDistanceNeeded and distancevanhorn >= Config.TownDistanceNeeded and distancesaintdenise >= Config.TownDistanceNeeded and distancetumbleweed >= Config.TownDistanceNeeded and distancearmadillo >= Config.TownDistanceNeeded then
        TriggerServerEvent('mms-oilpumps:server:activatepump')
        Citizen.Wait(1000)
        TriggerServerEvent('mms-oilpumps:server:spawnpump')
    else
        RSGCore.Functions.Notify('Pumpen können nicht in der nähe von Städten Platziert werden!', 'error', 3000)
        TriggerServerEvent('mms-oilpumps:server:givebackpumpitem')
    end
end)

RegisterNetEvent('mms-oilpumps:client:spawnpump2', function(model, ownedCid, spawnedpumpid, storage, weight)
    local PlayerData = RSGCore.Functions.GetPlayerData()
    local citizenid = PlayerData.citizenid
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    
    
    RemoveBlip(pumpBlip)
    
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(1)
    end

    spawnedPump = CreateObject(model, coords.x , coords.y +3 , coords.z -1, true, false, false) 
    isSpawned = true
    PlaceObjectOnGroundProperly(spawnedPump)
    SetEntityAsMissionEntity(spawnedPump,true,true)
    Wait(200)
    FreezeEntityPosition(spawnedPump,true)
    SetModelAsNoLongerNeeded(model)
    local pumpPos = GetEntityCoords(spawnedPump)


    pumpBlip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, pumpPos)
            SetBlipSprite(pumpBlip, GetHashKey(Config.pumpblipSprite), true)
            SetBlipScale(pumpBlip, Config.pumpblipScale)
            Citizen.InvokeNative(0x9CB1A1623062F402, pumpBlip, Config.pumpblipName)

    pumpStorage = storage
    pumpWeight = weight
    pumpid = spawnedpumpid
    local pumpposx = pumpPos.x
    local pumpposy = pumpPos.y
    local pumpposz = pumpPos.z
    exports['rsg-core']:createPrompt(pumpid, pumpPos, RSGCore.Shared.Keybinds['J'], 'Deine Pumpe ' ..pumpid , {
        type = 'client',
        event = 'mms-oilpumps:client:pumpmenu',
        args = {},
    })
    TriggerServerEvent('mms-oilpumps:server:updatetemppump', spawnedPump, pumpposx, pumpposy, pumpposz)
    Citizen.Wait(3000)
    WorkPump()
end)

RegisterNetEvent('mms-oilpumps:client:spawnpump3', function(model, ownedCid, spawnedpumpid, storage, weight, pumpposx, pumpposy, pumpposz)
    
    
    local PlayerData = RSGCore.Functions.GetPlayerData()
    local citizenid = PlayerData.citizenid
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    
    
    RemoveBlip(pumpBlip)
    
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(1)
    end

    spawnedPump = CreateObject(model, pumpposx, pumpposy, pumpposz, true, false, false) 
    isSpawned = true
    PlaceObjectOnGroundProperly(spawnedPump)
    SetEntityAsMissionEntity(spawnedPump,true,true)
    Wait(200)
    FreezeEntityPosition(spawnedPump,true)
    SetModelAsNoLongerNeeded(model)
    local pumpPos = GetEntityCoords(spawnedPump)
    

    pumpBlip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, pumpPos)
            SetBlipSprite(pumpBlip, GetHashKey(Config.pumpblipSprite), true)
            SetBlipScale(pumpBlip, Config.pumpblipScale)
            Citizen.InvokeNative(0x9CB1A1623062F402, pumpBlip, Config.pumpblipName)

    pumpStorage = storage
    pumpWeight = weight
    pumpid = spawnedpumpid
    exports['rsg-core']:createPrompt(pumpid, pumpPos, RSGCore.Shared.Keybinds['J'], 'Deine Pumpe ' ..pumpid , {
        type = 'client',
        event = 'mms-oilpumps:client:pumpmenu',
        args = {},
    })
    TriggerServerEvent('mms-oilpumps:server:updatetemppump', spawnedPump, pumpposx, pumpposy, pumpposz)
    Citizen.Wait(3000)
    WorkPump()
end)

RegisterNetEvent('mms-oilpumps:client:playerhaspump', function()
    RSGCore.Functions.Notify('Du hast bereits eine Pumpe!', 'error', 3000)
end)

RegisterNetEvent('mms-oilpumps:client:buypump', function()
    TriggerServerEvent('mms-oilpumps:server:hasplayerpump', pumpid)
end)

RegisterNetEvent('mms-oilpumps:client:playerhasnopump', function()
    PumpMenu()
end)


RegisterNetEvent('mms-oilpumps:client:pumpmenu', function()
        
    lib.registerContext(
        {
            id = 'pumpmenu',
            title = ('Pumpen Menü'),
            position = 'top-right',
            options = {
                {
                    title = ('Pumpen Inventar.'),
                    description = ('Pumpen Inventar.' ),
                    icon = 'fas fa-info',
                    event = 'mms-oilpumps:client:getstash',
                },
                {
                    title = ('Pumpe Abreißen.'),
                    description = ('Pumpe Abreißen.' ),
                    icon = 'fas fa-x',
                    event = 'mms-oilpumps:client:pumpdelete',
                },
            }
        }
    )
    lib.showContext('pumpmenu')
end)

RegisterNetEvent('mms-oilpumps:client:getstash',function()
    TriggerServerEvent('mms-oilpumps:server:pumpstash', stash)
end)

RegisterNetEvent('mms-oilpumps:client:ReturnStash', function(stashcount)
    count = stashcount
    lib.registerContext(
        {
            id = 'pumpstash',
            title = ('Pumpen Inventar'),
            position = 'top-right',
            options = {
                {
                    title = ('Öl Produziert: '..stashcount),
                    description = ('Öl Produziert: '..stashcount),
                    icon = 'fas fa-info',
                },
                {
                    title = ('Öl aus der Pumpe holen.'),
                    description = ('Öl aus der Pumpe holen.'),
                    icon = 'fas fa-info',
                    event = 'mms-oilpumps:client:getoil',
                },
                
            }
        }
    )
    lib.showContext('pumpstash')
end)

RegisterNetEvent('mms-oilpumps:client:getoil',function()
    input = lib.inputDialog('Öl Anzahl', {
        { 
            type = 'number',
            label = 'Anzahl Öl',
            required = true,
            allowCancel = true,
            min = 1, max = 500000,
        },
    })
    if input then
        oilamount = input[1]
    else return
    end
    TriggerServerEvent('mms-oilpumps:server:getoil', stash,count,oilamount)

end)

RegisterNetEvent('mms-oilpumps:client:pumpdelete', function()
    if spawnedPump ~= nil then
        TriggerServerEvent('mms-oilpumps:server:deletepump', spawnedPump)
        TriggerServerEvent('mms-oilpumps:server:deletestash', stash)
        DeleteObject(spawnedPump)
        exports['rsg-core']:deletePrompt(pumpid)
        RemoveBlip(pumpBlip)
        spawnedPump = nil
        stash = nil
        Wait()
    else
        RSGCore.Functions.Notify('Du hast keine Pumpe!', 'error', 3000)
    end
end)

Citizen.CreateThread(function()
    while spawnedPump == nil do
        Citizen.Wait(5000)
    end
    WorkPump()
end)

function WorkPump()
    while spawnedPump ~= nil and pumpid ~= nil do
       stash = 'player_' .. pumpid
       local item = 'oil'
       local oil = Config.AddOil
       TriggerServerEvent('mms-oilpumps:server:AddItemToStash', stash, item, oil)
       Citizen.Wait(Config.WorkTime)
    end
    return
end


function Checkpump()
    local PlayerData = RSGCore.Functions.GetPlayerData()
    local citizenid = PlayerData.citizenid
    TriggerServerEvent('mms-oilpumps:server:checkpump',citizenid)
end

function PumpMenu()
    menuData = {}

    table.insert(menuData, {
        header = 'Pumpen Shop',
        isMenuHeader = true
    })

    for _, pumps in ipairs(Config.pumpid) do
        table.insert(menuData, {
            header = pumps.name,
            txt = 'Preis: $' .. pumps.price .. ' Platz: ' .. pumps.storage,
            params = {
                event = 'mms-oilpumps:client:pumpinfo',
                isServer = false,
                args = {
                    price = pumps.price,
                    storage = pumps.storage,
                    model = pumps.model,
                    weight = pumps.weight
                }
            }
        })
    end

    table.insert(menuData, {
        header = 'Close Menu',
        txt = '',
        params = {
            event = 'rsg-menu:closeMenu'
        }
    })

    exports['rsg-menu']:openMenu(menuData)
end

RegisterNetEvent('mms-oilpumps:client:pumpinfo', function(data)
    local price = data.price
    local model = data.model
    local storage = data.storage
    local weight = data.weight

    local info = exports['rsg-input']:ShowInput({
        header = 'Pumpen Info',
        inputs = {
            {
                text = 'Pumpen Name',
                name = 'name',
                type = 'text',
                isRequired = true
            }
        }
    })

    TriggerServerEvent('mms-oilpumps:server:buypump', info.name, price, model, storage, weight)
end)


function Wait()
    Citizen.Wait(Config.WorkTime)
end



--AddEventHandler("onResourceStop",function (resourceName)
--    if resourceName == GetCurrentResourceName() then
--       TriggerServerEvent('mms-oilpumps:server:deletepump', spawnedPump)
--       DeleteObject(spawnedPump)
--        exports['rsg-core']:deletePrompt(pumpid)
--        RemoveBlip(pumpBlip)
--        spawnedPump = nil
--    end
--end)

