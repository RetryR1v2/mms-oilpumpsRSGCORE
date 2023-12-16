Config = {}

Config.AddOil = 10         ---------------- Die Pumpe Fördert 10 Öl Alle Worktime
Config.WorkTime = 5000    ---------------- 5000 = alle 5 Sekunden Fördert die Pumpe AddOil

Config.pumpblipSprite= 'blip_code_center_on_horse'
Config.pumpblipScale = 4.5
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

Config.pumpid = {
    {
        hash = -824257932, 
        model = 'p_enginefactory01x',
        name = 'Ölpumpe',
        price = 2000,
        storage = 50,
        weight = 50000000,
    },

}