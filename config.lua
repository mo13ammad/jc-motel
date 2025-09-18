Config = Config or {}
Config.Locale = 'en' -- Currently supported languages, which you can make as many you want as long the files are set up properly use existing as reference! Current supported(en, dk)

-- General Config --
Config.Framework = 'qbx' -- Compatible for QB and QBX
Config.UseTarget = 'ox_target' -- Whether you wanna use target, ox_target, qb-target or false if false will use polyzone
Config.Polyzone = 'PolyZone' -- Currently only use PolyZone
Config.KeyItemUseable = false -- Whether you wanna make it useable, if it's useable then will check if you're within a certain distance for the door to use the key to unlock(By using inventory useable!)
Config.EnableRobbery = false -- Whether you wanna make motel rooms robbable
Config.AllowPoliceRaids = false -- Whether you want cops to be able to raid motel rooms or not!
Config.RestrictRooms = true -- Whether you want the player to only rent 1 motel room at a time!
Config.RestrictMotels = true -- Whether you want the player to only be able to own 1 motel at a time!
Config.WipeStash = true -- Removes items in stash if room is no longere rented!
Config.AllowOwnerAutoPay = true -- Toggles whether the player who owns a motel can set autopay or not for their renters!
Config.StashProtection = 'password' -- Whether you wanna make some sort of protection for your motel stash!(password, citizenid or false)
Config.LostkeyReplaceAll = true -- Whether it should remove all keys from players and storages from a specific room if key has been reported lost(Aka a lock change)
Config.ToggleDebug = false -- Whether you wanna have debug enabled or not(For developers!)
Config.Motelkey = 'motelkey' -- The item for the motel room key!

-- Criminal Config --
Config.LockpickItem = 'lockpick' -- The item to lockpick motel rooms if Config.EnableRobbery is true!
Config.DoorRam = 'weapon_sledgehammer' -- The item cops uses as a doorram when breaching doors
Config.LoseLockpickOnFail = true -- Whether the player will lose the lockpick if they fail lockpicking or not!
Config.AlertOnFail = true -- Whether the cops should be alerted on failed lockpicking or not, if false will use Config.AlarmChance for both success and fail!
Config.CopCount = 0 -- How many cops required to rob a motel room if Config.EnableRobbery is true
Config.LoseLockpickChance = 0 -- How high a chance for losing lockpick when breaking into a room
Config.AlarmChance = 100 -- How high a chance police will be alerted on a breakin!
Config.PicklockCircles = math.random(3, 5) -- How many circles for picklocking motel door!
Config.CircleTime = 10 -- How fast the circle goes, the lower, the faster.

-- Script Integration Config --
Config.DoorlockScript = 'ox_doorlock' -- Can use qb-doorlock or ox_doorlock

function Config.Appearance() -- How you wanna use appearance script client-sided!
    local QBCore = exports['qb-core']:GetCoreObject()
    if GetResourceState('illenium-appearance') == 'started' then
        TriggerEvent('qb-clothing:client:openOutfitMenu')
    elseif GetResourceState('qb-clothing') == 'started' then
        TriggerEvent('qb-clothing:client:openOutfitMenu')
    end
end

function Config.PoliceAlert() -- How you wanna use police alerts client-sided!
    local QBCore = exports['qb-core']:GetCoreObject()
    exports['ps-dispatch']:HouseRobbery()
end

function Config.Stash(name, stash, roomData, masterCode, coords) -- How you wanna handle stashes!
    local QBCore = exports['qb-core']:GetCoreObject()
    if GetResourceState('qs-inventory') == 'started' then
        QBCore.Functions.TriggerCallback('motel:getRooms', function(data)
            if data then
                for _, room in pairs(data) do
                    if room.uniqueID == roomData.uniqueID then
                        if room.password then
                            local info = lib.inputDialog('Insert Password', {
                                {
                                    type = 'input',
                                    label = _L('password'),
                                    description = _L('passwordeesc'),
                                }
                            })

                            if info[1] == room.password or masterCode and info[1] == tostring(masterCode) then
                                exports['qs-inventory']:RegisterStash(name .. '_' .. roomData.uniqueID, stash.slots, stash.weight, coords)
                            else
                                QBCore.Functions.Notify(_L('wrongpassword'), 'error', 3000)
                            end
                        else
                            exports['qs-inventory']:RegisterStash(name .. '_' .. roomData.uniqueID, stash.slots, stash.weight, coords)
                        end
                    end
                end
            else
                QBCore.Functions.Notify(_L('nodata'), 'error', 3000)
                return
            end
        end, name)
    elseif GetResourceState('qb-inventory') == 'started' then
        QBCore.Functions.TriggerCallback('motel:getRooms', function(data)
            if data then
                for _, room in pairs(data) do
                    if room.uniqueID == roomData.uniqueID then
                        if room.password then
                            local info = lib.inputDialog('Insert Password', {
                                {
                                    type = 'input',
                                    label = _L('password'),
                                    description = _L('passwordeesc'),
                                }
                            })

                            if info[1] == room.password or masterCode and info[1] == tostring(masterCode) then
                                TriggerServerEvent('motel:server:openStash', name .. '_' .. roomData.uniqueID, stash.slots, stash.weight, coords)
                            else
                                QBCore.Functions.Notify(_L('wrongpassword'), 'error', 3000)
                            end
                        else
                            TriggerServerEvent('motel:server:openStash', name .. '_' .. roomData.uniqueID, stash.slots, stash.weight, coords)
                        end
                    end
                end
            else
                QBCore.Functions.Notify(_L('nodata'), 'error', 3000)
                return
            end
        end, name)
    elseif GetResourceState('ox_inventory') == 'started' then
        QBCore.Functions.TriggerCallback('motel:getRooms', function(data)
            if data then
                for _, room in pairs(data) do
                    if room.uniqueID == roomData.uniqueID then
                        if room.password then
                            local info = lib.inputDialog('Insert Password', {
                                {
                                    type = 'input',
                                    label = _L('password'),
                                    description = _L('passwordeesc'),
                                }
                            })

                            if info[1] == room.password or masterCode and info[1] == tostring(masterCode) then
                                TriggerServerEvent('motel:server:openStash', name .. '_' .. roomData.uniqueID, stash.slots, stash.weight, coords)
                            else
                                QBCore.Functions.Notify(_L('wrongpassword'), 'error', 3000)
                            end
                        else
                            TriggerServerEvent('motel:server:openStash', name .. '_' .. roomData.uniqueID, stash.slots, stash.weight, coords)
                        end
                    end
                end
            else
                QBCore.Functions.Notify(_L('nodata'), 'error', 3000)
                return
            end
        end, name)
    elseif GetResourceState('origen_inventory') == 'started' then
        QBCore.Functions.TriggerCallback('motel:getRooms', function(data)
            if data then
                for _, room in pairs(data) do
                    if room.uniqueID == roomData.uniqueID then
                        if room.password then
                            local info = lib.inputDialog('Insert Password', {
                                {
                                    type = 'input',
                                    label = _L('password'),
                                    description = _L('passwordeesc'),
                                }
                            })

                            if info[1] == room.password or masterCode and info[1] == tostring(masterCode) then
                                TriggerServerEvent('motel:server:openStash', name .. '_' .. roomData.uniqueID, stash.slots, stash.weight, coords)
                                exports['origen_inventory']:openInventory('stash', name .. '_' .. roomData.uniqueID)
                            else
                                QBCore.Functions.Notify(_L('wrongpassword'), 'error', 3000)
                            end
                        else
                            exports['origen_inventory']:openInventory('stash', name .. '_' .. roomData.uniqueID)
                        end
                    end
                end
            else
                QBCore.Functions.Notify(_L('nodata'), 'error', 3000)
                return
            end
        end, name)
    end
end



-- Motels --
Config.Motels = {
    ['bayviewlodge'] = { -- The unique name for the motels, MUST BE UNIQUE!
        autoPayment = true, -- Only works if Config.AllowOwnerAutoPay is true
        buyable = true, -- Whether the motel is buyable by a player!
        label = 'Motel Sicilia', -- The name of the motel, can be anything!
        coords = vector3(1572.7762451172, 3745.0739746094, 35.227198791504), -- The coords where the blip and reception will be!
        price = 25000000000, -- The price of the motel if buyable!
        roomprices = 250, -- Prices for each room each pay interval!
        payInterval = 168, -- How often players has to pay in hours!
        keyPrice = 200 -- The price to get a new key if lost!
    }
}

-- Motel Rooms --
Config.Rooms = {
    ['bayviewlodge'] = {
        {
            room = 'Room #1', -- A simple room label/name, can be named anything!
            uniqueID = 15, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1616.8640136719, 3787.9077148438, 35.291239929199), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1614.7412109375, 3794.8002929688, 35.232043457031), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 500000, -- How much weight stash should have!
                slots = 50, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1618.9663085938, 3791.6791992188, 35.352854919434), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #2', -- A simple room label/name, can be named anything!
            uniqueID = 16, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1612.5808105469, 3784.6276855469, 35.469275665283), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1610.4194335938, 3791.490234375, 35.19437713623), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 500000, -- How much weight stash should have!
                slots = 50, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1614.4616699219, 3788.4604492188, 35.308493804932), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #3', -- A simple room label/name, can be named anything!
            uniqueID = 17, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1608.099609375, 3781.1625976562, 35.41590423584), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1605.9288330078, 3787.9907226562, 35.19437713623), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 500000, -- How much weight stash should have!
                slots = 50, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1610.1668701172, 3784.9519042969, 35.281806182861), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #4', -- A simple room label/name, can be named anything!
            uniqueID = 18, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1603.7458496094, 3777.8217773438, 35.296981048584), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1601.6745605469, 3784.771484375, 35.010203552246), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 500000, -- How much weight stash should have!
                slots = 50, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1605.7884521484, 3781.5769042969, 35.392432403564), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #5', -- A simple room label/name, can be named anything!
            uniqueID = 19, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1585.2796630859, 3763.6755371094, 35.494063568115), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1583.3129882812, 3770.7053222656, 34.986842346191), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 500000, -- How much weight stash should have!
                slots = 50, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1587.2056884766, 3767.6779785156, 35.518347930908), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #6', -- A simple room label/name, can be named anything!
            uniqueID = 20, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1580.3248291016, 3759.8723144531, 35.185198974609), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1578.3095703125, 3766.8364257812, 34.943740081787), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 500000, -- How much weight stash should have!
                slots = 50, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1582.2994384766, 3763.8425292969, 35.492221069336), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #7', -- A simple room label/name, can be named anything!
            uniqueID = 21, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1584.0064697266, 3744.4533691406, 35.486270141602), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1585.7852783203, 3737.279296875, 34.898635101318), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 500000, -- How much weight stash should have!
                slots = 50, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1581.9813232422, 3740.3676757812, 35.476538848877), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #8', -- A simple room label/name, can be named anything!
            uniqueID = 22, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1588.3040771484, 3747.7514648438, 35.461184692383), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1590.4345703125, 3740.8474121094, 34.979582977295), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 500000, -- How much weight stash should have!
                slots = 50, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1586.3090820312, 3744.1040039062, 35.396559906006), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #9', -- A simple room label/name, can be named anything!
            uniqueID = 23, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1592.9904785156, 3751.34765625, 35.345282745361), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1595.0714111328, 3744.4052734375, 34.947913360596), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 500000, -- How much weight stash should have!
                slots = 50, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1591.1129150391, 3747.3681640625, 35.312213134766), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #10', -- A simple room label/name, can be named anything!
            uniqueID = 24, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1597.9748535156, 3755.1723632812, 35.418154907227), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1600.0983886719, 3748.2626953125, 35.05347366333), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 500000, -- How much weight stash should have!
                slots = 50, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1596.0194091797, 3751.2685546875, 35.325457763672), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #11', -- A simple room label/name, can be named anything!
            uniqueID = 25, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1602.9560546875, 3758.9946289062, 35.311267089844), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1604.9475097656, 3751.9836425781, 34.861949157715), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 500000, -- How much weight stash should have!
                slots = 50, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1601.0236816406, 3755.0556640625, 35.298480224609), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #12', -- A simple room label/name, can be named anything!
            uniqueID = 26, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1607.87890625, 3762.7719726562, 35.322737884521), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1610.0114746094, 3755.8693847656, 34.986785125732), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 500000, -- How much weight stash should have!
                slots = 50, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1605.9205322266, 3758.9724121094, 35.284400177002), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #13', -- A simple room label/name, can be named anything!
            uniqueID = 27, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1612.9858398438, 3766.5725097656, 35.041541290283), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1614.9841308594, 3759.6850585938, 35.03317565918), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 500000, -- How much weight stash should have!
                slots = 50, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1610.9781494141, 3762.67578125, 35.289302062988), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #14', -- A simple room label/name, can be named anything!
            uniqueID = 28, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1617.9395751953, 3770.3735351562, 35.242930603027), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1619.9995117188, 3763.5334472656, 34.888877105713), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 500000, -- How much weight stash should have!
                slots = 50, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1615.9320068359, 3766.5251464844, 35.205641937256), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #15', -- A simple room label/name, can be named anything!
            uniqueID = 29, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1622.8125, 3774.2309570312, 35.320002746582), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1624.9765625, 3767.3522949219, 34.917601776123), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 500000, -- How much weight stash should have!
                slots = 50, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1620.9375, 3770.2622070312, 35.390135955811), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #16', -- A simple room label/name, can be named anything!
            uniqueID = 30, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1622.8671875, 3774.2724609375, 39.062174987793), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1625.0024414062, 3767.3718261719, 38.596747589111), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 500000, -- How much weight stash should have!
                slots = 50, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1620.8767089844, 3770.3288574219, 39.035521697998), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #17', -- A simple room label/name, can be named anything!
            uniqueID = 31, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1617.8820800781, 3770.447265625, 39.112162780762), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1620.0302734375, 3763.556640625, 38.633559417725), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 500000, -- How much weight stash should have!
                slots = 50, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1615.9757080078, 3766.4541015625, 39.087470245361), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #18', -- A simple room label/name, can be named anything!
            uniqueID = 32, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1612.9307861328, 3766.6479492188, 39.091792297363), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1614.9755859375, 3759.6779785156, 38.575408172607), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 500000, -- How much weight stash should have!
                slots = 50, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1611.0119628906, 3762.64453125, 38.911544036865), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #19', -- A simple room label/name, can be named anything!
            uniqueID = 33, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1607.9367675781, 3762.8159179688, 39.01559753418), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1609.9904785156, 3755.8527832031, 38.513591003418), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 500000, -- How much weight stash should have!
                slots = 50, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1605.9881591797, 3758.9169921875, 39.015246582031), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #20', -- A simple room label/name, can be named anything!
            uniqueID = 34, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1602.9200439453, 3758.9665527344, 39.145446014404), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1605.06640625, 3752.0744628906, 38.553408813477), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 500000, -- How much weight stash should have!
                slots = 50, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1601.0882568359, 3754.984375, 39.130107116699), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #21', -- A simple room label/name, can be named anything!
            uniqueID = 35, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1597.9389648438, 3755.1442871094, 39.138674926758), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1600.0686035156, 3748.2395019531, 38.417052459717), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 500000, -- How much weight stash should have!
                slots = 50, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1596.0767822266, 3751.2019042969, 39.043635559082), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #22', -- A simple room label/name, can be named anything!
            uniqueID = 36, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1592.9417724609, 3751.3100585938, 39.085021209717), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1595.0620117188, 3744.3979492188, 38.614840698242), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 500000, -- How much weight stash should have!
                slots = 50, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1591.1057128906, 3747.3447265625, 39.0981590271), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #23', -- A simple room label/name, can be named anything!
            uniqueID = 37, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1588.0277099609, 3747.5395507812, 38.940055084229), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1590.1204833984, 3740.6062011719, 38.558318328857), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 500000, -- How much weight stash should have!
                slots = 50, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1586.1123046875, 3743.5766601562, 39.038996887207), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #24', -- A simple room label/name, can be named anything!
            uniqueID = 38, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1583.0910644531, 3743.7512207031, 39.0893699646), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1585.1546630859, 3736.7956542969, 38.538962554932), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 500000, -- How much weight stash should have!
                slots = 50, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1581.1044921875, 3739.7961425781, 39.011061859131), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #25', -- A simple room label/name, can be named anything!
            uniqueID = 39, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1572.7844238281, 3754.0895996094, 39.037890625), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1570.8006591797, 3761.1064453125, 38.496981811523), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 500000, -- How much weight stash should have!
                slots = 50, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1574.5810546875, 3758.1118164062, 38.92660446167), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #26', -- A simple room label/name, can be named anything!
            uniqueID = 40, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1577.740234375, 3757.8881835938, 39.028716278076), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1575.7296142578, 3764.8842773438, 38.574164581299), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 500000, -- How much weight stash should have!
                slots = 50, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1579.6510009766, 3761.8037109375, 38.952811431885), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #27', -- A simple room label/name, can be named anything!
            uniqueID = 41, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1582.626953125, 3761.6203613281, 39.219180297852), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1580.6359863281, 3768.6616210938, 38.586501312256), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 500000, -- How much weight stash should have!
                slots = 50, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1584.6021728516, 3765.5715332031, 38.962294769287), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #29 VIP', -- A simple room label/name, can be named anything!
            uniqueID = 42, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1603.7126464844, 3777.8081054688, 39.041464996338), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1601.5651855469, 3784.7270507812, 38.64021987915), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 1000000, -- How much weight stash should have!
                slots = 80, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1605.4847412109, 3781.87890625, 39.002436828613), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #30 VIP', -- A simple room label/name, can be named anything!
            uniqueID = 43, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1608.1118164062, 3781.1870117188, 39.244681549072), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1606.0660400391, 3788.1853027344, 38.624388885498), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 1000000, -- How much weight stash should have!
                slots = 80, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1609.9993896484, 3785.2260742188, 38.917739105225), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #31 VIP', -- A simple room label/name, can be named anything!
            uniqueID = 44, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1612.5205078125, 3784.5788574219, 39.133979034424), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1610.5096435547, 3791.6044921875, 38.587050628662), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 1000000, -- How much weight stash should have!
                slots = 80, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1614.4073486328, 3788.5903320312, 39.055293273926), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
        {
            room = 'Room #32 VIP', -- A simple room label/name, can be named anything!
            uniqueID = 45, -- A uniqueID for the doorlock must match the doorid for the selected doorlock script!
            isLocked = true, -- Whether the motel room is locked by default or not!
            door = {
                pos = vector3(1616.8708496094, 3787.9128417969, 39.066691589355), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            stash = {
                pos = vector3(1614.8648681641, 3794.9423828125, 38.557955932617), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
                weight = 1000000, -- How much weight stash should have!
                slots = 80, -- How many slots stash should have!
            },
            wardrobe = {
                pos = vector3(1618.7897949219, 3791.9182128906, 39.08228225708), -- The position to stand for door!
                radius = 0.8, -- Radius for target!
                polyRadius = 1.5, -- If using polyzones then how big the polyzone is!
            },
            renter = nil, -- Leave nil unless you want a default renter then add CitizenID
            renterName = '', -- Leave this blank! Unless you want a default renter!
        },
    }
}

function Config.DoorlockAction(doorId, setLocked)
    if Config.DoorlockScript == 'qb-doorlock' then
        TriggerServerEvent('qb-doorlock:server:updateState', doorId, setLocked, false, false, true, false, false)
    elseif Config.DoorlockScript == 'ox_doorlock' then
        TriggerServerEvent('jc-motel:server:setDoorStateOx', doorId, setLocked)
    end
end