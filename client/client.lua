local RSGCore = exports['rsg-core']:GetCoreObject()
local FeatherMenu =  exports['feather-menu'].initiate()
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
            event = 'mms-oilpumps:client:openshopmenu',
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
        event = 'mms-oilpumps:client:openpumpmenu',
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
        event = 'mms-oilpumps:client:openpumpmenu',
        args = {},
    })
    TriggerServerEvent('mms-oilpumps:server:updatetemppump', spawnedPump, pumpposx, pumpposy, pumpposz)
    Citizen.Wait(3000)
    WorkPump()
end)

RegisterNetEvent('mms-oilpumps:client:playerhaspump', function()
    RSGCore.Functions.Notify('Du hast bereits eine Pumpe!', 'error', 3000)
end)



RegisterNetEvent('mms-oilpumps:client:playerhasnopump', function()
    Citizen.Wait(200)
    ShopMenu2:Open({
        startupPage = ShopPage2,
    })
end)




RegisterNetEvent('mms-oilpumps:client:pumpdelete', function()
    if spawnedPump ~= nil then
        local PlayerData = RSGCore.Functions.GetPlayerData()
        local citizenid = PlayerData.citizenid
        TriggerServerEvent('mms-oilpumps:server:deletepump', citizenid)
        TriggerServerEvent('mms-oilpumps:server:deletestash', stash)
        DeleteObject(spawnedPump)
        exports['rsg-core']:deletePrompt(pumpid)
        RemoveBlip(pumpBlip)
        spawnedPump = nil
        stash = nil
        TriggerEvent('mms-oilpumps:client:closeshopmenu3')
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





function Wait()
    Citizen.Wait(5000)
end


RegisterNetEvent('mms-oilpumps:client:openshopmenu',function()
    ShopMenu:Open({
        startupPage = ShopPage,
    })
end)
RegisterNetEvent('mms-oilpumps:client:openpumpmenu',function()
    ShopMenu3:Open({
        startupPage = ShopPage3,
    })
end)
RegisterNetEvent('mms-oilpumps:client:openpumpinv',function()
    ShopMenu4:Open({
        startupPage = ShopPage4,
    })
end)

RegisterNetEvent('mms-oilpumps:client:closeshopmenu',function()
    ShopMenu:Close({ 
    })
end)
RegisterNetEvent('mms-oilpumps:client:closeshopmenu2',function()
    ShopMenu2:Close({ 
    })
end)
RegisterNetEvent('mms-oilpumps:client:closeshopmenu4',function()
    ShopMenu4:Close({ 
    })
end)
RegisterNetEvent('mms-oilpumps:client:closeshopmenu3',function()
    ShopMenu3:Close({ 
    })
end)

Citizen.CreateThread(function()  --- RegisterFeather Menu
ShopMenu = FeatherMenu:RegisterMenu('feather:character:menu', {
    top = '50%',
    left = '50%',
    ['720width'] = '500px',
    ['1080width'] = '600px',
    ['2kwidth'] = '700px',
    ['4kwidth'] = '900px',
    style = {
    },
    contentslot = {
        style = {
            ['height'] = '300px',
            ['min-height'] = '300px'
        }
    },
    draggable = true,
})
ShopPage = ShopMenu:RegisterPage('first:page')
ShopPage:RegisterElement('header', {
    value = 'Pumpen Shop',
    slot = "header",
    style = {}
})
ShopPage:RegisterElement('line', {
    slot = "header",
    style = {}
})
ShopPage:RegisterElement('button', {
    label = "Kaufe Pumpe",
    style = {
    },
}, function()
    TriggerServerEvent('mms-oilpumps:server:hasplayerpump')
end)
ShopPage:RegisterElement('button', {
    label = "Schließe Shop",
    style = {
    },
}, function()
    TriggerEvent('mms-oilpumps:client:closeshopmenu')
end)
ShopPage:RegisterElement('subheader', {
    value = "Pumpen Shop",
    slot = "footer",
    style = {}
})
ShopPage:RegisterElement('line', {
    slot = "footer",
    style = {}
})
end)
--- Seite 2
Citizen.CreateThread(function()  --- RegisterFeather Menu
    ShopMenu2 = FeatherMenu:RegisterMenu('feather:character:menu2', {
        top = '50%',
        left = '50%',
        ['720width'] = '500px',
        ['1080width'] = '600px',
        ['2kwidth'] = '700px',
        ['4kwidth'] = '900px',
        style = {
        },
        contentslot = {
            style = {
                ['height'] = '300px',
                ['min-height'] = '300px'
            }
        },
        draggable = true,
    })
    ShopPage2 = ShopMenu2:RegisterPage('secound:page')
ShopPage2 = ShopMenu2:RegisterPage('secound:page')
ShopPage2:RegisterElement('header', {
    value = 'Pumpen Name',
    slot = "header",
    style = {}
})
ShopPage2:RegisterElement('line', {
    slot = "header",
    style = {}
})
local inputValue = ''
ShopPage2:RegisterElement('input', {
    label = "Pumpen Name:",
    placeholder = "Name",
    style = {
    }
}, function(data)
    inputValue = data.value
end)
ShopPage2:RegisterElement('button', {
    label = "Benenne Pumpe",
    style = {
    },
}, function()
    TriggerEvent('mms-oilpumps:client:pumpinfo', inputValue)
end)
ShopPage2:RegisterElement('button', {
    label = "Schließe Shop",
    style = {
    },
}, function()
    TriggerEvent('mms-oilpumps:client:closeshopmenu2')
end)
ShopPage2:RegisterElement('subheader', {
    value = "Pumpen Name Wählen",
    slot = "footer",
    style = {}
})
ShopPage2:RegisterElement('line', {
    slot = "footer",
    style = {}
})
end)


----- Seite 3
Citizen.CreateThread(function()  --- RegisterFeather Menu
    ShopMenu3 = FeatherMenu:RegisterMenu('feather:character:menu3', {
        top = '50%',
        left = '50%',
        ['720width'] = '500px',
        ['1080width'] = '600px',
        ['2kwidth'] = '700px',
        ['4kwidth'] = '900px',
        style = {
        },
        contentslot = {
            style = {
                ['height'] = '300px',
                ['min-height'] = '300px'
            }
        },
        draggable = true,
    })

ShopPage3 = ShopMenu3:RegisterPage('third:page')
ShopPage3:RegisterElement('header', {
    value = 'Pumpen Menu',
    slot = "header",
    style = {}
})
ShopPage3:RegisterElement('line', {
    slot = "header",
    style = {}
})
ShopPage3:RegisterElement('button', {
    label = "Pumpen Inventar.",
    style = {
    },
}, function()
    TriggerEvent('mms-oilpumps:client:closeshopmenu3')
    TriggerEvent('mms-oilpumps:client:openpumpinv')
end)
ShopPage3:RegisterElement('button', {
    label = "Pumpe Abreißen.",
    style = {
    },
}, function()
    TriggerEvent('mms-oilpumps:client:pumpdelete')
end)
ShopPage3:RegisterElement('button', {
    label = "Schließe Shop",
    style = {
    },
}, function()
    TriggerEvent('mms-oilpumps:client:closeshopmenu3')
end)
ShopPage3:RegisterElement('subheader', {
    value = "Pumpen Menu",
    slot = "footer",
    style = {}
})
ShopPage3:RegisterElement('line', {
    slot = "footer",
    style = {}
})

end)


----- Seite 4
Citizen.CreateThread(function()  --- RegisterFeather Menu
    ShopMenu4 = FeatherMenu:RegisterMenu('feather:character:menu4', {
        top = '50%',
        left = '50%',
        ['720width'] = '500px',
        ['1080width'] = '600px',
        ['2kwidth'] = '700px',
        ['4kwidth'] = '900px',
        style = {
        },
        contentslot = {
            style = {
                ['height'] = '500px',
                ['min-height'] = '500px'
            }
        },
        draggable = true,
    })

ShopPage4 = ShopMenu4:RegisterPage('fourth:page')
ShopPage4:RegisterElement('header', {
    value = 'Produktions Menu',
    slot = "header",
    style = {}
})
ShopPage4:RegisterElement('line', {
    slot = "header",
    style = {}
})
TextDisplay = ShopPage4:RegisterElement('textdisplay', {
    value = "Öl Produziert: NA",
    style = {}
})
ShopPage4:RegisterElement('button', {
    label = "Update Öl",
    style = {
    },
}, function()
    TriggerEvent('mms-oilpumps:client:getstash')
end)

local inputValue2 = 0
ShopPage4:RegisterElement('input', {
    label = "Öl Anzahl Entnehmen:",
    placeholder = 0,
    style = {
    }
}, function(data)
    inputValue2 = data.value
end)
ShopPage4:RegisterElement('button', {
    label = "Öl Entnehmen.",
    style = {
    },
}, function()
    TriggerEvent('mms-oilpumps:client:getoil', inputValue2)
end)
ShopPage4:RegisterElement('button', {
    label = "Zurück zum Pumpen Menu",
    style = {
    },
}, function()
    TriggerEvent('mms-oilpumps:client:openpumpmenu')
end)
ShopPage4:RegisterElement('button', {
    label = "Schließe Inventar",
    style = {
    },
}, function()
    TriggerEvent('mms-oilpumps:client:closeshopmenu4')
end)
ShopPage4:RegisterElement('subheader', {
    value = "Öl Entnehmen",
    slot = "footer",
    style = {}
})
ShopPage4:RegisterElement('line', {
    slot = "footer",
    style = {}
})
end)


RegisterNetEvent('mms-oilpumps:client:getstash',function()
    TriggerServerEvent('mms-oilpumps:server:pumpstash', stash)
end)
RegisterNetEvent('mms-oilpumps:client:ReturnStash', function(stashcount) ----------------
    count = stashcount
    
    TextDisplay:update({
        value = "Öl Produziert: " .. count,
        style = {}
    }) 
end)


RegisterNetEvent('mms-oilpumps:client:getoil',function(inputValue2)
    local oilamount = tonumber(inputValue2)
    TriggerServerEvent('mms-oilpumps:server:getoil', stash,oilamount)
    TriggerEvent('mms-oilpumps:client:closeshopmenu4')
end)


RegisterNetEvent('mms-oilpumps:client:pumpinfo',function(inputValue)
    local price = Config.price
    local model = Config.model
    local storage = Config.storage
    local weight = Config.weight
    local name = inputValue
    TriggerServerEvent('mms-oilpumps:server:registerpump', name, price, model, storage, weight)
    TriggerEvent('mms-oilpumps:client:closeshopmenu2')
end)

----------------------------------------CRAFTING PART ---------------------------------------

Citizen.CreateThread(function()
    for Crafter,v in pairs(Config.Crafter) do
    local model = v.model
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(1)
    end
    local coords = v.CrafterPos
    local crafter = CreatePed(model, coords.x, coords.y, coords.z - 1.0, coords.w, false, false, 0, 0)
    Citizen.InvokeNative(0x283978A15512B2FE, crafter, true)
    SetEntityCanBeDamaged(crafter, false)
    SetEntityInvincible(crafter, true)
    FreezeEntityPosition(crafter, true)
    SetBlockingOfNonTemporaryEvents(crafter, true)
    Wait(1)
    end

    for crafter,v in pairs(Config.crafter) do
        exports['rsg-core']:createPrompt(v.name, v.coords, RSGCore.Shared.Keybinds['J'],  (' ') .. v.lable, {
            type = 'client',
            event = 'mms-oilpumps:client:opencraftingmenu',
            args = {},
        })
        if v.showblip == true then
            local crafting = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, v.coords)
            SetBlipSprite(crafting, GetHashKey(v.blipSprite), true)
            SetBlipScale(crafting, v.blipScale)
            Citizen.InvokeNative(0x9CB1A1623062F402, crafting, v.blipName)
        end
    end
    
end)

Citizen.CreateThread(function()  --- RegisterFeather Menu
    
    CraftingMenu = FeatherMenu:RegisterMenu('feather:character:menu2', {
        top = '50%',
        left = '50%',
        ['720width'] = '500px',
        ['1080width'] = '600px',
        ['2kwidth'] = '700px',
        ['4kwidth'] = '900px',
        style = {
        },
        contentslot = {
            style = {
                ['height'] = '500px',
                ['min-height'] = '500px'
            }
        },
        draggable = true,
    })
    CraftingPage1 = CraftingMenu:RegisterPage('first:page')

    CraftingPage1:RegisterElement('header', {
        value = 'Öl Verarbeiter',
        slot = "header",
        style = {}
    })
    CraftingPage1:RegisterElement('line', {
        slot = "header",
        style = {}
    })
    
    for reciepes, v in pairs(Config.Reciepes) do    
    if v.active == true then
        CraftingPage1:RegisterElement('button', {
            label = v.name,
            style = {
            },
        }, function()
            v.id:RouteTo()
        end)
    end
    end
    
    CraftingPage1:RegisterElement('button', {
        label = "Schließe Verarbeiter",
        style = {
        },
    }, function()
        TriggerEvent('mms-oilpumps:client:closecraftingmenu')
    end)
    CraftingPage1:RegisterElement('subheader', {
        value = "Öl Verarbeiter",
        slot = "footer",
        style = {}
    })
    CraftingPage1:RegisterElement('line', {
        slot = "footer",
        style = {}
    })
---------- Register Crafting Pages
    
    for reciepes, v in pairs(Config.Reciepes) do    
        if v.active == true then
            v.id = CraftingMenu:RegisterPage(v.id)  
            v.id:RegisterElement('header', {
                value = v.name,
                slot = "header",
                style = {}
            })
            v.id:RegisterElement('line', {
                slot = "header",
                style = {}
            })
            TextDisplay = v.id:RegisterElement('textdisplay', {
                value = "Rezept: " .. v.zutatneeded .. ' ' .. v.zutat .. ' = ' .. v.ergebnisanzahl .. ' ' .. v.ergebnis,
                style = {}
            })
            local inputValue = ''
            v.id:RegisterElement('input', {
                label = "Wieviele Herstellen :",
                placeholder = 0,
                style = {
                }
            }, function(data)
                inputValue = data.value
            end)
            v.id:RegisterElement('button', {
                label = "Herstellen",
                style = {
                },
            }, function()
                local zutat = v.zutat
                local zutatneeded = v.zutatneeded
                local ergebnis = v.ergebnis
                local ergebnisanzahl = v.ergebnisanzahl
                TriggerEvent('mms-oilpumps:client:startcrafting' , inputValue , zutat,zutatneeded,ergebnis,ergebnisanzahl)
            end)
            v.id:RegisterElement('button', {
                label = "Zurück zum Crafting Menü",
                style = {
                },
            }, function()
                CraftingMenu:Open({
                    startupPage = CraftingPage1,
                })
            end)
            v.id:RegisterElement('button', {
                label = "Schließe Verarbeiter",
                style = {
                },
            }, function()
                TriggerEvent('mms-oilpumps:client:closecraftingmenu')
            end)

        end
    end



end)

RegisterNetEvent('mms-oilpumps:client:startcrafting',function(inputValue , zutat,zutatneeded,ergebnis,ergebnisanzahl)
    local anzahl = tonumber(inputValue)
    TriggerServerEvent('mms-oilpumps:server:crafting' , anzahl , zutat,zutatneeded,ergebnis,ergebnisanzahl)
    TriggerEvent('mms-oilpumps:client:closecraftingmenu')
end)



    RegisterNetEvent('mms-oilpumps:client:opencraftingmenu',function()
        CraftingMenu:Open({
            startupPage = CraftingPage1,
        })
    end)
    
    RegisterNetEvent('mms-oilpumps:client:closecraftingmenu',function()
        CraftingMenu:Close({
        })
    end)

    RegisterNetEvent('mms-oilpumps:client:craftingtime',function()
        lib.progressCircle({
            duration = Config.Crafttime, -- Adjust the duration as needed
            label = 'Verarbeite Öl',
            position = 'bottom',
            useWhileDead = false,
        })
    end)