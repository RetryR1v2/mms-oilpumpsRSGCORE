Config = {}

Config.AddOil = 10         ---------------- oil amount that added every min
Config.WorkTime = 60000    ---------------- 60000 = every 1 min the pump add oil 

Config.pumpblipSprite= 'blip_donate_food'
Config.pumpblipScale = 5.0
Config.pumpblipName = 'Deine Ölpumpe'

Config.Dealer = {
{ 
    DealerPos = vector4(-363.93, 810.41, 116.02, 246.92),
    model = 'U_M_M_BwmStablehand_01',
},


-- add more as required
}

Config.shops = {
    {
        lable = 'Valentine Pumpen Händler',
        name = 'Pumpen Händler Valentine',
        coords = vector3(-363.93, 810.41, 116.02),
        showblip = true,
        blipName = 'Pumpen Händler Valentine',
        blipSprite = 'blip_ambient_tithing',
        blipScale = 4.5
    },
    -- add more as required-345.01, 807.78, 116.66
}


--------- Pumpen Settings

        Config.hash = -824257932
        Config.model = 'p_enginefactory01x'
        Config.name = 'Ölpumpe'
        Config.price = 2000
        Config.storage = 10
        Config.weight = 500000000
 

------------------------- Config  Town Distance

Config.TownDistanceNeeded = 1000

---- Town Coords Middle of Town ----
Config.TownValentine = vector3(-281.13, 715.79, 113.93)  --Check
Config.TownRhodes = vector3(1341.21, -1277.12, 76.94)  --Check
Config.TownStrawberry = vector3(-1798.92, -457.03, 159.48)  --Check
Config.TownBlackwater = vector3(-850.22, -1298.28, 43.37)  --Check
Config.TownAnnesburg = vector3(2919.48, 1368.80, 45.24)  -- Check
Config.TownVanhorn = vector3(2962.95, 547.93, 44.50)   -- Check
Config.TownSaintdenise = vector3(2613.23, -1216.01, 53.39)   --Check
Config.TownTumbleweed = vector3(-5506.68, -2941.55, -1.80)   --Check
Config.TownArmadillo = vector3(-3689.10, -2609.74, -14.03)   --Check

----------------- Crafting Part -------------------

Config.Crafter = {
    { 
        CrafterPos = vector4(-354.42, 811.27, 116.37, 201.88),
        model = 'U_M_M_BwmStablehand_01',
    },
    
    
    -- add more as required
    }
    
    Config.crafter = {
        {
            lable = 'Valentine Öl Verarbeiter',
            name = 'Öl Verarbeiter Valentine',
            coords = vector3(-354.42, 811.27, 116.37),
            showblip = true,
            blipName = 'Öl Verarbeiter Valentine',
            blipSprite = 'blip_shop_blacksmith',
            blipScale = 4.5
        },
        -- add more as required-345.01, 807.78, 116.66
    }

--------------------------------------------- CRAFTING ---------------------------

Config.Crafttime = 5000
    ------ reciepes 
    Config.Reciepes = {
        {
            id = 1,     --- only  1 id per reciepe  reciepe 2 need id 2 reciepe3 need 3 .....
            active = true,
            name = 'Cleankit Herstellen',
            zutat = 'oil',
            zutatneeded = 10,
            ergebnis = 'cleankit',
            ergebnisanzahl = 2,
            
        },
        {
            id = 2,
            active = true,
            name = 'Öl für Zug Herstellen',
            zutat = 'oil',
            zutatneeded = 10,
            ergebnis = 'trainoil',
            ergebnisanzahl = 1,
            
        },

     }