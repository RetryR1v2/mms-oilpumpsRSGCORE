local RSGCore = exports['rsg-core']:GetCoreObject()

-----------------------------------------------------------------------
-- version checker
-----------------------------------------------------------------------
local function versionCheckPrint(_type, log)
    local color = _type == 'success' and '^2' or '^1'

    print(('^5['..GetCurrentResourceName()..']%s %s^7'):format(color, log))
end

local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/RetryR1v2/mms-oilpumps/main/version.txt', function(err, text, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')

        if not text then 
            versionCheckPrint('error', 'Currently unable to run a version check.')
            return 
        end

      
        if text == currentVersion then
            versionCheckPrint('success', 'You are running the latest version.')
        else
            versionCheckPrint('error', ('Current Version: %s'):format(currentVersion))
            versionCheckPrint('success', ('Latest Version: %s'):format(text))
            versionCheckPrint('error', ('You are currently running an outdated version, please update to version %s'):format(text))
        end
    end)
end

RegisterServerEvent('mms-oilpumps:server:registerpump', function(name, price, model, storage, weight)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local randomLetters = string.char(math.random(65, 90), math.random(65, 90), math.random(65, 90))
    local pumpid = randomLetters .. math.random(100, 999)
    local citizenid = Player.PlayerData.citizenid
    -- Check if the player has enough money
    if Player.Functions.GetItemByName('oilpump') and Player.Functions.GetItemByName('oilpump').amount >=1 then
        RSGCore.Functions.Notify('Du hast bereits eine Ölpumpe', 'error')
    else
    if Player.Functions.GetMoney('cash') >= price then
            MySQL.insert('INSERT INTO `mms_pumps` (citizenid, pumpid, model, name, storage, weight) VALUES (?, ?, ?, ?, ?, ?)', {
            citizenid, pumpid, model, name, storage, weight
            }, function(id)
           -- print(id)
            end)
            Player.Functions.RemoveMoney('cash', price)      
            Player.Functions.AddItem('oilpump', 1)
            TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['oilpump'], "add")
        else
            -- Here you could add a notification or feedback to the player that they do not have enough money
            RSGCore.Functions.Notify('Du hast nicht genug Geld!', 'error')
        end
    end
end)



RegisterServerEvent('mms-oilpumps:server:activatepump', function(data)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    local currentActive = 0
    local newActive = 1

    MySQL.update('UPDATE mms_pumps SET active = ? WHERE citizenid = ? AND active = ?', {
        newActive, citizenid, currentActive
    }, function(affectedRows)
        --print(affectedRows)
    end)

end)

RegisterServerEvent('mms-oilpumps:server:spawnpump')
AddEventHandler('mms-oilpumps:server:spawnpump', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    local isActive = 1

    MySQL.query('SELECT `model`, `citizenid`, `pumpid`, `storage`, `weight` FROM `mms_pumps` WHERE `citizenid` = ? AND `active` = ?', {citizenid, isActive}, function(result)
        if result and #result > 0 then
            for i = 1, #result do
                local row = result[i]
                local model = row.model
                local ownedCid = row.citizenid
                local storage = row.storage
                local weight = row.weight
                local spawnedpumpid = row.pumpid
                TriggerClientEvent('mms-oilpumps:client:spawnpump2', src, model, ownedCid, spawnedpumpid, storage, weight)
            end
        else
            RSGCore.Functions.Notify(src, 'Du hast keine Aktive Pumpe!', 'error', 3000)
        end
    end)
end)

RegisterServerEvent('mms-oilpumps:server:hasplayerpump', function()
    local src = source
    MySQL.query('SELECT * FROM mms_pumps WHERE pumpid = ?',{pumpid} , function(result)
        if result[1] ~= nil then
            TriggerClientEvent('mms-oilpumps:client:playerhaspump', src )
        else
            TriggerClientEvent('mms-oilpumps:client:playerhasnopump',src)
        end
    end)
end)

RegisterServerEvent('mms-oilpumps:server:AddItemToStash', function(stash, item, oil)
    MySQL.query('SELECT * FROM pumps_stock WHERE stash = ? AND item = ?',{stash, item} , function(result)
        if result[1] ~= nil then
            local stockadd = result[1].oil + oil
            MySQL.update('UPDATE pumps_stock SET oil = ? WHERE stash = ? AND item = ?',{stockadd, stash, item})
        else
            MySQL.insert('INSERT INTO pumps_stock (`stash`, `item`, `oil`) VALUES (?, ?, ?);', {stash, item, oil})
        end
    end)
end)

RegisterServerEvent('mms-oilpumps:server:pumpstash', function(stash)
    local src = source
    MySQL.query('SELECT * FROM pumps_stock WHERE stash = ? ',{stash} , function(result)
        if result[1].oil >=0 then
        local stashcount = result[1].oil
        TriggerClientEvent('mms-oilpumps:client:ReturnStash', src, stashcount)
        end
    end)
end)



RegisterServerEvent('mms-oilpumps:server:getoil', function(stash,oilamount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    MySQL.query('SELECT * FROM pumps_stock WHERE stash = ? ',{stash} , function(result)
        if result[1].oil ~= nil and result[1].oil >= oilamount then
            local stockadd = result[1].oil - oilamount
            MySQL.update('UPDATE pumps_stock SET oil = ? WHERE stash = ? ',{stockadd, stash})
            TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['oil'], "add")
            Player.Functions.AddItem('oil', oilamount)
        else
            RSGCore.Functions.Notify(src, 'Du hast nicht genug Öl!', 'error', 3000)
        end
    end)
end)


RegisterServerEvent('mms-oilpumps:server:checkpump', function(citizenid)
    local src = source
    MySQL.query('SELECT `model`, `citizenid`, `pumpid`, `storage`, `weight`, `pumpposx`, `pumpposy`, `pumpposz` FROM mms_pumps WHERE citizenid = ?',{citizenid} , function(result)
        if result and #result > 0 then
            for i = 1, #result do
                local row = result[i]
                local model = row.model
                local ownedCid = row.citizenid
                local storage = row.storage
                local weight = row.weight
                local spawnedpumpid = row.pumpid
                local pumpposx = row.pumpposx
                local pumpposy = row.pumpposy
                local pumpposz = row.pumpposz
                TriggerClientEvent('mms-oilpumps:client:spawnpump3', src, model, ownedCid, spawnedpumpid, storage, weight, pumpposx, pumpposy, pumpposz)
            end
        end
    end)
end)

RegisterServerEvent('mms-oilpumps:server:deletestash', function(stash)
    MySQL.query('SELECT `item` FROM `pumps_stock` WHERE stash = ?', {stash}, function(result)
        if result and #result > 0 then
            for i = 1, #result do
                local row = result[i]
            end
        end
    end)
    MySQL.execute('DELETE FROM `pumps_stock` WHERE stash = ?', { stash }, function(rowsChanged)
        if rowsChanged ~= nil then
        else
            print('No matching rows found.')
        end
    end)
end)

RegisterServerEvent('mms-oilpumps:server:updatetemppump')
AddEventHandler('mms-oilpumps:server:updatetemppump', function(temppump, pumpposx, pumpposy, pumpposz)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    local isActive = 1

    MySQL.update('UPDATE mms_pumps SET temppump = ? WHERE citizenid = ? AND active = ?', {
        temppump, citizenid, isActive
    }, function(affectedRows)
    end)
    MySQL.update('UPDATE mms_pumps SET pumpposx = ? WHERE citizenid = ? AND active = ?', {
        pumpposx, citizenid, isActive
    }, function(affectedRows)
    end)
    MySQL.update('UPDATE mms_pumps SET pumpposy = ? WHERE citizenid = ? AND active = ?', {
        pumpposy, citizenid, isActive
    }, function(affectedRows)
    end)
    MySQL.update('UPDATE mms_pumps SET pumpposz = ? WHERE citizenid = ? AND active = ?', {
        pumpposz, citizenid, isActive
    }, function(affectedRows)
    end)
end)

RegisterServerEvent('mms-oilpumps:server:deletepump', function(citizenid)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local model = nil

    MySQL.query('SELECT `model` FROM `mms_pumps` WHERE citizenid = ?', {citizenid}, function(result)
            if result and #result > 0 then
                for i = 1, #result do
                    local row = result[i]
                end
            end
        end)
        MySQL.execute('DELETE FROM `mms_pumps` WHERE citizenid = ?', { citizenid }, function(rowsChanged)
            if rowsChanged ~= nil then
            else
                print('No matching rows found.')
            end
        end)
        
end)




RSGCore.Functions.CreateUseableItem("oilpump", function(source, item)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    Player = RSGCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem('oilpump', 1) then
        TriggerClientEvent("mms-oilpump:client:spawnpump", source, 'oilpump')
        TriggerClientEvent("inventory:client:ItemBox", source, RSGCore.Shared.Items['oilpump'], "remove")
    end
end)
RegisterServerEvent('mms-oilpumps:server:givebackpumpitem', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    Player.Functions.AddItem('oilpump', 1)
    TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items['oilpump'], "add")
end)



------------------ Crafting -------------------------



RegisterServerEvent('mms-oilpumps:server:crafting', function(anzahl, zutat,zutatneeded,ergebnis,ergebnisanzahl)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    
    if Player.Functions.GetItemByName(zutat) and Player.Functions.GetItemByName(zutat).amount >= zutatneeded * anzahl then
        TriggerClientEvent('mms-oilpumps:client:craftingtime',src)
        Citizen.Wait(Config.Crafttime - 200)
        Player.Functions.RemoveItem(zutat, zutatneeded * anzahl)
        Player.Functions.AddItem(ergebnis, ergebnisanzahl * anzahl)
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[zutat], "remove")
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[ergebnis], "add")
        TriggerClientEvent('ox_lib:notify', src, {title = 'Du hast ' .. zutatneeded * anzahl .. ' ' .. zutat .. ' zu ' .. ergebnisanzahl * anzahl .. ' ' .. ergebnis .. ' Verarbeitet.'      , description =  'Hergestellt', type = 'succes' , duration = 5000 })
    else
        TriggerClientEvent('ox_lib:notify', src, {title = 'Du hast nicht genug ' .. zutat .. ' zum Verarbeiten.' , description =  zutat ..' Fehlt', type = 'error', duration = 5000 }) 
    end

end)






--------------------------------------------------------------------------------------------------
-- start version check
--------------------------------------------------------------------------------------------------
CheckVersion()