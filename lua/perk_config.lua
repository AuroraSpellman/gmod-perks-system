AddCSLuaFile("perk_config.lua")

PERKSYSTEM = {}
-----------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------
--- CONFIG STARTS HERE----------------------------------------------------------------------------------------------------------------------


PERKSYSTEM.lan_config = "EN" --"TR","FR" //LANGUAGE




PERKSYSTEM.perkmenu_key = KEY_P --Key to acess perk vault




PERKSYSTEM.active_perk_key = KEY_O --Key to cast active perks




PERKSYSTEM.menu_music = true -- (SET false TO TURN OFF)




PERKSYSTEM.perk_HUD_pos = 2 -- Default pos of HUD for players. 1 = TOP_LEFT, 2 = TOP_RIGHT, 3 = BTM_RIGHT, 4 = BTM_LEFT 




PERKSYSTEM.merhcant_vault = false  ----Set this to true if you want to disallow players to acess their perk vault outside of a close range from merchant. 




PERKSYSTEM.workshop_Autodownload = true ----Forces players to download content needed for this addon when connecting the server.


------------------------------
--PERK PRICES //Category Prices
------------------------------

local common_perk_price = 10000

local epic_perk_price = 5000

local legendary_perk_price = 10000

local key_perk_price = 25000

local active_perk_price = 50000
 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- FOR FOLLOWING CONFIGURATIONS YOU NEED TO KNOW UNIQUE PERK IDENTIFIER ASSIGNED TO A SPESIFIC PERK. // Check unique identifiers from Language files below. // Line 120
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------



local disabledperks = {"test","test2"} -- Perks added here with the bundles that include them won't appear on perk market.




PERKSYSTEM.individual_pricing = { --Override spesific perk prices
    ["test"] = 100000,
    ["test2"] = 10,
}




PERKSYSTEM.bundles = { -- Bundle creation // {BundleName, FirstPerkCode, SecondPerkCode, DiscountPercent, Description}
    {"Phoenix Reckoning","anka","elveda",10, "⚡ When your foes think they've triumphed over you, surprise them with a shocking twist! 'Final Say' ensures that, even in defeat, you have the last word with a spectacular electric explosion that punishes those who dare to vanquish you. But that's not all – with the power of 'Phoenix,' you rise from the ashes, defying death itself! Combine these two forces to create a strategy that keeps everyone guessing."}, 
    {"Harmonic Reflections","aynaxdxd","patlartohum",20, "⚡ Harmonic Reflections combines the formidable defenses of Mirrored Defiance with the explosive potential of Natural Harmony, creating a synergistic powerhouse for those who seek both resilience and retribution. Absorb, reflect, and explode. What else can one want?"},
    {"Skyward Surge","saglam","zipzip",5,"⚡ The synergy between Heavyfooted and Hitmans Soar is undeniable. Using Hitmans Soar for elevated positioning not only provides a strategic edge but also enhances the impact of the Heavyfooted. The greater the jump, the more significant the damage and radius of Heavyfooted!"},
    {"Solidarity","dost","birlikte",10,"⚡ Forge unbreakable bonds on the battlefield with the Solidarity Guardian Bundle. Unleash the power of unity with 'Unity Might,' gaining 5% strength for each ally within a 600-unit radius. As your comrades stand shoulder to shoulder, bolster your defenses with 'Comradeship,' reducing incoming damage by 5% for every ally in the same radius."}
}
 
 
-------------------------------
------- LANGUAGE FILES --------
-------------------------------

PERKSYSTEM.isimler = {} 
PERKSYSTEM.isimler["EN"] = { 
    ["anka"] = "Phoenix Rebirth", --["unique perk identifier"] = "Perk Name"    /////     ["perkcode"] is the unique perk identifier assigned to "Perk Name" named perk.
    ["dost"] = "Unity Might",
    ["deler"] = "Rebound Retribution",
    ["aynaxdxd"] = "Mirrored Defiance",
    ["tutulma"] = "Resurgence Beacon",
    ["becerikli"] = "Nanotech Optimization",
    ["kanicen"] = "Vampiric Vitality",
    ["xp"] = "Seasoned Slayer",
    ["ayna"] = "Hasty Retreat",
    ["saglam"] = "Heavyfooted",
    ["lutuf"] = "Seraphic Ignition",
    ["patlartohum"] = "Natural Harmony",
    ["ammo"] = "Endless Quiver",
    ["kupon"] = "Extreme Couponer",
    ["gelgit"] = "Glacial Monarch", 
    ["hayvani"] = "Blessing of the Sea",
    ["zipzip"] = "Hitmans Soar",
    ["imdat"] = "Lingering Knowledge",
    ["elveda"] = "Final Say",
    ["kask"] = "Secure Arrival",
    ["birlikte"] = "Comradeship",
}
PERKSYSTEM.isimler["TR"] = { 
    ["anka"] = "Ankanin Kulleri",
    ["dost"] = "Birligin Gücü",
    ["deler"] = "Ziplar Intikam",
    ["aynaxdxd"] = "Yansir Parcacik",
    ["tutulma"] = "Tutulma Isareti",
    ["becerikli"] = "Nanotek Optimizasyonu",
    ["kanicen"] = "Vampirik Canlilik",
    ["xp"] = "Deneyimli Katil",
    ["ayna"] = "Can Havli",
    ["saglam"] = "Agir Basar",
    ["lutuf"] = "Serafik Atesleme",
    ["patlartohum"] = "Doganin Dengesi",
    ["ammo"] = "Sonsuz Okluk",
    ["kupon"] = "Kupon Delisi",
    ["gelgit"] = "Buzul Monarsi", 
    ["hayvani"] = "Denizin Bereketi",
    ["zipzip"] = "Tetikcinin Yükselisi",
    ["imdat"] = "Kalici Bilgi",
    ["elveda"] = "Buyuk Kapanis",
    ["kask"] = "Hazirlikli",
    ["birlikte"] = "Yoldaslik",
}
PERKSYSTEM.isimler["FR"] = { 
    ["anka"] = "Larmes de phénix", 
    ["dost"] = "Puissance de l'Unité",
    ["deler"] = "Zap Rebondissante",
    ["aynaxdxd"] = "Défiance Miroir",
    ["tutulma"] = "Résurgence",
    ["becerikli"] = "Optimisation",
    ["kanicen"] = "Vitalité Vampirique",
    ["xp"] = "Tueur Expérimenté",
    ["ayna"] = "Retraite Hâtive",
    ["saglam"] = "Pieds Lourds",
    ["lutuf"] = "Ignition Séraphique",
    ["patlartohum"] = "Harmonie Nature",
    ["ammo"] = "Carquois Sans Fin",
    ["kupon"] = "Grand Utilisateur",
    ["gelgit"] = "Monarque Glacial", 
    ["hayvani"] = "Bénédiction Mer",
    ["zipzip"] = "Envol du Tueur",
    ["imdat"] = "Alphabétisé",
    ["elveda"] = "Dernier Mot",
    ["kask"] = "Arrivée Sécurisée",
    ["birlikte"] = "Camaraderie",
}




PERKSYSTEM.aciklamalar = {}
PERKSYSTEM.aciklamalar["TR"] = {
    ["dost"] = "600 birimlik yaricap icindeki her oyuncu basina %5 güc kazanirsin.",
    ["deler"] = "Hasar verdiginde, verilen hasarin ek %50'si hedeflenen kurbaninin en yakinindaki düsmana yönlendirilir; eger oyuncu bulunamazsa, hasari %10 artirir.",
    ["aynaxdxd"] = "Aldigin tüm hasarin %25'ini yansitirsin.",
    ["tutulma"] = "Kullanildiginda bir isaret koyarsin, ölürsen veya zaman biterse, isaretleyiciye kullandigin ​​sagliginla geri dönersin. Aktifken %25 DMG artisi.",
    ["anka"] = "Ölümün ardindan, bu perk'ü etkinlestirerek küllerinden dogabilirsin. 10 dakikalik cooldown.",
    ["becerikli"] = "Sansina bagli olarak hasarini 1.2x-1.4x oraninda ölcekler.",
    ["kanicen"] = "Vurdugun hasarin bir kismi sana can olarak geri döner. Hasarinin %10'u kadar iyilestirir.",
    ["xp"] = "Her öldürülen düsman sonrasinda, kisa bir süre icin gecici bir hasar artisi elde edersin. Basarilan öldürme sayisi arttikca, etkiler daha da güclenir.",
    ["ayna"] = "Sagligin %20'nin altina düstügünde, gecici bir hiz artisi kazanirsin, tehlikeli durumlardan daha kolay kacmani saglar.",
    ["saglam"] = "Adimlarin önemli bir agirlik tasir, bu sayede düsme hasarini önlersin ve dusus sirasinda hasar veren sok dalgalari yaratirsin.",
    ["lutuf"] = "Saldirdigin kisiyi atese verir ve keskinlik kaybetmesine neden olursun. (Ayni oyuncuda tekrar kullanim icin 20 saniye.)",
    ["patlartohum"] = "%10 ihtimalle aldigin hasari emersin. Aktive edildiginde, emilen bu enerji güclü bir patlamaya kanalize edilir ve etrafindaki herkesi yakar.",
    ["ammo"] = "Takildiginda sinirsiz cephane saglar.",
    ["kupon"] = "Maas kazanclarini iki katina cikarir ve F4 pazarindaki tüm ögelerde %20 indirim saglar.",
    ["gelgit"] = "Aktive edildiginde, seni cevreleyen ürpertici bir buz firtinasi cagirir ve belirli bir yaricap icindeki düsmanlari dondurur.",
    ["hayvani"] = "Herhangi bir su kütlesine girdiginde, sagligin hizla yenilenir. Ve yüzme hizinda bir artis kazanirsin.",
    ["zipzip"] = "Basarili bir kafa atisiyla, 3 perk sarji kazanirsin. (max12) Bu sarjlar, ardisik hava atlamalarini gerceklestirmene olanak tanir.",
    ["imdat"] = "Pasif olarak, aktif perk'lerinin cooldown süreleri %10 azalir. Bu kalici fayda, aktif perk'lerini daha sik kullanmana olanak tanir.",
    ["elveda"] = "Bir oyuncu tarafindan katledilme sonrasi etraftaki oyunculari carpan bir elektrik patlamasini tetikler.",
    ["kask"] = "Spawn anında savunmanızı +10 zırhla güçlendirir.",
    ["birlikte"] = "Alinan hasar 600 unitedeki her oyuncu icin %5 azalir.",
}
PERKSYSTEM.aciklamalar["EN"] = {
    ["dost"] = "Gain 5% strength per player within a 600-unit radius.",
    ["deler"] = "When dealing damage, aditional 50% of the damage is redirected to the nearest enemy to your targeted victim, if no player found, scales damage to 1.1x.",
    ["aynaxdxd"] = "Reflect %25 of all the incoming damage.",
    ["tutulma"] = "When cast you set a marker, if you die or timer ends, return to marker with initial health. %25 DMG boost while active.",
    ["anka"] = "Upon death, you may activate this perk to rise from the ashes and be reborn. 10 minute cooldown.",
    ["becerikli"] = "Based on luck scales your damage to 1.2x-1.4x.",
    ["kanicen"] = "A portion of the damage you deal is returned to you as health, healing you for 10% of the damage dealt.",
    ["xp"] = "After each kill, you gain a temporary damage boost for a short duration. The more kills you achieve, the stronger the effects become",
    ["ayna"] = "When your health drops below 20%, you gain a temporary speed boost, allowing you to escape dangerous situations more easily.",
    ["saglam"] = "Your footsteps carry a significant weight, allowing you to prevent fall damage and create shockwaves upon landing that deals damage.",
    ["lutuf"] = "Infuse your attacks with the divine flames, causing enemies to burn and loose accuracy upon attack. (20sec CD to re-use on same player)",
    ["patlartohum"] = "Grants %10 chance to absorb damage. On activation, this absorbed energy can be channeled into a powerful explosion. (min 100 energy)",
    ["ammo"] = "Grants infinite ammo while equipped.",
    ["kupon"] = "Doubles salary earnings and grants %20 discount on all F4 market items.",
    ["gelgit"] = "When activated, you summon a chilling blizzard that surrounds you, freezing enemies within a certain radius.",
    ["hayvani"] = "Upon entering any body of water, your health regenerates at a great speed. And you gain a boost in your swim speed.",
    ["zipzip"] = "Upon a successful headshot, you gain 3 perk charges. (max12) These charges enable you to perform consecutive mid-air jumps.",
    ["imdat"] = "Passively, the cooldowns for your active perks are %20 reduced. This allows you to utilize your active perks more frequently.",
    ["elveda"] = "When killed by a player, triggers an electrifying explosion that zaps everyone in the vicinity.",
    ["kask"] = "Bolsters your armor with +10 armor upon spawn.",
    ["birlikte"] = "Incoming damage decreased %5 per player within a 600-unit radius.",
}
PERKSYSTEM.aciklamalar["FR"] = {
    ["dost"] = "Gagnez 5% de force par joueur dans un rayon de 600 unités.",
    ["deler"] = "Lorsque vous infligez des dégâts, 50% supplémentaires des dégâts sont redirigés vers l'ennemi le plus proche de votre victime ciblée, si aucun joueur n'est trouvé, les dégâts sont augmentés à 1,1x.",
    ["aynaxdxd"] = "Réfléchissez à 25% de tous les dégâts entrants.",
    ["tutulma"] = "Lorsque lancé, vous définissez un marqueur, si vous mourez ou que le minuteur se termine, retournez au marqueur avec une santé initiale. Augmentation des dégâts de 25% pendant l'activité.",
    ["anka"] = "À la mort, vous pouvez activer ce bonus pour renaître de vos cendres. Cooldown de 10 minutes.",
    ["becerikli"] = "Basé sur la chance, échelonnez vos dégâts de 1,2x à 1,4x.",
    ["kanicen"] = "Une partie des dégâts que vous infligez vous est renvoyée sous forme de santé, vous guérissant de 10% des dégâts infligés.",
    ["xp"] = "Après chaque élimination, vous obtenez un boost de dégâts temporaire pendant une courte durée. Plus vous réalisez d'éliminations, plus les effets deviennent puissants",
    ["ayna"] = "Lorsque votre santé tombe en dessous de 20%, vous obtenez une augmentation de vitesse temporaire, vous permettant de vous échapper plus facilement des situations dangereuses.",
    ["saglam"] = "Vos pas portent un poids significatif, vous permettant d'éviter les dégâts de chute et de créer des ondes de choc à l'atterrissage qui infligent des dégâts.",
    ["lutuf"] = "Infusez vos attaques avec les flammes divines, causant aux ennemis des brûlures et une perte de précision lors des attaques. (20 sec de recharge pour réutiliser sur le même joueur)",
    ["patlartohum"] = "Accorde une chance de 10% d'absorber les dégâts. Lors de l'activation, cette énergie absorbée peut être canalisée dans une puissante explosion. (minimum 100 énergie)",
    ["ammo"] = "Accorde des munitions infinies lorsqu'il est équipé.",
    ["kupon"] = "Double les gains de salaire et accorde une réduction de 20% sur tous les objets du marché F4.",
    ["gelgit"] = "Lorsqu'il est activé, vous invoquez une tempête de neige glaciale qui vous entoure, gelant les ennemis dans un certain rayon.",
    ["hayvani"] = "Lorsque vous entrez dans n'importe quel plan d'eau, votre santé se régénère à grande vitesse. Et vous gagnez un boost dans votre vitesse de nage.",
    ["zipzip"] = "Lors d'un tir à la tête réussi, vous gagnez 3 charges de bonus. (max12) Ces charges vous permettent d'effectuer des sauts en l'air consécutifs.",
    ["imdat"] = "Passivement, les temps de recharge de vos bonus actifs sont réduits de 20%. Cela vous permet d'utiliser vos bonus actifs plus fréquemment.",
    ["elveda"] = "Lorsque tué par un joueur, déclenche une explosion électrisante qui frappe tout le monde dans les environs.",
    ["kask"] = "Renforce votre armure avec +10 d'armure à la réapparition.",
    ["birlikte"] = "Les dégâts entrants diminuent de 5% par joueur dans un rayon de 600 unités.",
}




PERKSYSTEM.konusmalar ={}
PERKSYSTEM.konusmalar["TR"] = {" ","Hos geldin, maceraperest, perk'ler diyarina hos geldin!",
"Ben essiz yeteneklerin bekcisiyim ve sana yolculugunu gelistirmen icin bir sans sunuyorum.",
"Perk'ler, sana yardimci olabilecek özel yeteneklerdir.",
"Onlari kullanarak oynama tarzini özellestirebilirsin.",
"Sana bes ana nadirlikte perk sunuyorum:",
"Anahtar, Aktif, Efsanevi, Epik ve Ortak perk'ler.",
"Perk'leri benden, yani Perk Tüccari'ndan satin alarak edinebilirsin.",
"Sohbet penceresine '/perk' yazmak, perk'lerini görmene, takmani veya cikartmani saglar. (Veya P tusu.)",
"Perk'lerini dikkatlice sec, cünkü sadece 4 yuvan var!",
"Unutmadan, iste ilk perk'ün. Bu benden sana hediye."} 

PERKSYSTEM.konusmalar["EN"] = {" ","Welcome, adventurer, to the realm of perks!",
"I am the keeper of unique abilities, and I offer you the chance to enhance your journey.",
"Perks are special abilities that can aid you.",
"You can equip them to customize your playstyle.",
"I offer five main rarities of perks:",
"Key, Active, Legendary, Epic and Common perks.",
"You can obtain perks by purchasing them from me, the Perk Merchant.",
"Typing '/perk' in the chat, will allow you to view, equip, or unequip your perks. (Or press P)",
"Choose your perks wisely, as you have only 4 slots!",
"Before I forget, here's your first perk. It's on me."}

PERKSYSTEM.konusmalar["FR"] = {" ","Bienvenue, aventurier, dans le royaume des avantages!",
"Je suis le gardien des capacités uniques, et je vous offre la chance d'améliorer votre voyage.",
"Les avantages sont des capacités spéciales qui peuvent vous aider.",
"Vous pouvez les équiper pour personnaliser votre style de jeu.",
"Je propose cinq principales raretés d'avantages:",
"Clé, Actif, Légendaire, Épique et Commun.",
"Vous pouvez obtenir des avantages en les achetant auprès de moi, le Marchand d'Avantages.",
"Tapez '/perk' dans le chat pour afficher, équiper ou déséquiper vos avantages. (Ou appuyez sur P)",
"Choisissez vos avantages avec sagesse, car vous n'avez que 4 emplacements!",
"Avant que j'oublie, voici votre premier avantage. C'est pour moi."}



local adddesc = {}
adddesc["TR"] = "Lütfen aciklama ekleyiniz."
adddesc["EN"] = "Please add a description."
adddesc["FR"] = "Veuillez ajouter une description."
     
       
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------DONT TOUCH BELOW UNLESS YOU KNOW WHAT YOU'RE DOING----------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

function table.find(tbl, value)
    for i, v in ipairs(tbl) do
        if v == value then
            return i
        end
    end
    return nil
end 

game.AddParticles("particles/aesshide.pcf")
PrecacheParticleSystem("aes_remove")
PrecacheParticleSystem("aes_roll_price")
PrecacheParticleSystem("aes_supsad")
PrecacheParticleSystem("aes_spawer")
game.AddParticles("particles/bomer.pcf") -- kullan 
PrecacheParticleSystem("skay")
game.AddParticles("particles/srenattack.pcf")-- kullan 
PrecacheParticleSystem("sren song2")
game.AddParticles("particles/srenattack.pcf")-- kullan 
game.AddParticles("particles/dragon strong.pcf") 
PrecacheParticleSystem("elc_strong_thunderhull")
game.AddParticles("particles/aranca.pcf") 
PrecacheParticleSystem("pillaranca") 
PrecacheParticleSystem("pillaranca2") 
PrecacheParticleSystem("pillaranca3")
PrecacheParticleSystem("aranca_pill")
game.AddParticles("particles/cargdigger.pcf") 
PrecacheParticleSystem("qye_lurker")  
PrecacheParticleSystem("qye_bomb")
game.AddParticles("particles/h_grenade.pcf")
PrecacheParticleSystem("h_grenade_initial_blast")
game.AddParticles("particles/misk.pcf")   
PrecacheParticleSystem("die2")
game.AddParticles("particles/pfx_redux.pcf")
PrecacheParticleSystem("[7]snow")
PrecacheParticleSystem("[4]arcs_electric_1")
game.AddParticles("particles/jug.pcf")
PrecacheParticleSystem("jug_p3")
game.AddParticles("particles/fire_01.pcf")
PrecacheParticleSystem("env_embers_small")
PrecacheParticleSystem("env_fire_large")
game.AddParticles("particles/glan.pcf")
PrecacheParticleSystem("glan_dust")

PERKSYSTEM.perks = {}
PERKSYSTEM.keyperk = {"anka","aynaxdxd","hayvani","elveda","becerikli"}
PERKSYSTEM.legendaryler = {"xp","saglam","deler","lutuf"} --"hormonlu","arinmis",
if DarkRP then
    table.insert(PERKSYSTEM.legendaryler, "kupon")
end
PERKSYSTEM.epicler = {"kanicen","ayna","dost","ammo","zipzip","birlikte"} -- "cicek","koridor","sifaci","aydin","irade","gurme","balkabagi","demir","goru","kitapkurtu","icgudu"
PERKSYSTEM.common = {"imdat","kask"} --{"kask","imdat","regen"} 
PERKSYSTEM.perkrenkleri = {}

PERKSYSTEM.aktifler = {"gelgit","tutulma","patlartohum"} --"duzenincagirisi"
PERKSYSTEM.aktifcooldown = {120,  120,       10}
PERKSYSTEM.aktifduration = {5,     10,         5}
PERKSYSTEM.aktifbufftext = {"","+%25 DMG",""}

PERKSYSTEM.aktifler_lookup = {}
for _, v in ipairs(PERKSYSTEM.aktifler) do
    PERKSYSTEM.aktifler_lookup[v] = true
end
 
PERKSYSTEM.perkorder = {PERKSYSTEM.common,PERKSYSTEM.epicler,PERKSYSTEM.legendaryler,PERKSYSTEM.aktifler,PERKSYSTEM.keyperk}

PERKSYSTEM.perks = table.Add(PERKSYSTEM.perks,PERKSYSTEM.keyperk) 
PERKSYSTEM.perks = table.Add(PERKSYSTEM.perks,PERKSYSTEM.legendaryler)
PERKSYSTEM.perks = table.Add(PERKSYSTEM.perks,PERKSYSTEM.aktifler)  
PERKSYSTEM.perks = table.Add(PERKSYSTEM.perks,PERKSYSTEM.epicler)
PERKSYSTEM.perks = table.Add(PERKSYSTEM.perks,PERKSYSTEM.common)  

if SERVER then
    if file.Read("perkler/common_perk_price.txt","DATA") then
        common_perk_price = tonumber(file.Read("perkler/common_perk_price.txt","DATA"))
    end
    if file.Read("perkler/key_perk_price.txt","DATA") then
        key_perk_price = tonumber(file.Read("perkler/key_perk_price.txt","DATA"))
    end
    if file.Read("perkler/legendary_perk_price.txt","DATA") then
        legendary_perk_price = tonumber(file.Read("perkler/legendary_perk_price.txt","DATA"))
    end
    if file.Read("perkler/epic_perk_price.txt","DATA") then
        epic_perk_price = tonumber(file.Read("perkler/epic_perk_price.txt","DATA"))
    end
    if file.Read("perkler/active_perk_price.txt","DATA") then
        active_perk_price = tonumber(file.Read("perkler/active_perk_price.txt","DATA"))
    end
end

PERKSYSTEM.fiyatlar = {}
for k,v in ipairs(PERKSYSTEM.perks) do

    if !PERKSYSTEM.aciklamalar[PERKSYSTEM.lan_config][v] then
        PERKSYSTEM.aciklamalar[PERKSYSTEM.lan_config][v] = adddesc[PERKSYSTEM.lan_config]
    end

    if table.HasValue(PERKSYSTEM.legendaryler, v) then
        PERKSYSTEM.fiyatlar[v] = legendary_perk_price
        PERKSYSTEM.perkrenkleri[v] = Color(230, 0, 255)
        PERKSYSTEM.aciklamalar[PERKSYSTEM.lan_config][v] = "Legendary Perk: "..PERKSYSTEM.aciklamalar[PERKSYSTEM.lan_config][v]
    elseif table.HasValue(PERKSYSTEM.epicler, v)then
        PERKSYSTEM.fiyatlar[v] = epic_perk_price
        PERKSYSTEM.perkrenkleri[v] = Color(0, 213, 255)
        PERKSYSTEM.aciklamalar[PERKSYSTEM.lan_config][v] = "Epic Perk: "..PERKSYSTEM.aciklamalar[PERKSYSTEM.lan_config][v]
    elseif table.HasValue(PERKSYSTEM.aktifler, v) then
        PERKSYSTEM.fiyatlar[v] = active_perk_price
        PERKSYSTEM.perkrenkleri[v] = Color(0, 255, 55)
        PERKSYSTEM.aciklamalar[PERKSYSTEM.lan_config][v] = "Active Perk: "..PERKSYSTEM.aciklamalar[PERKSYSTEM.lan_config][v].." ("..PERKSYSTEM.aktifcooldown[table.find(PERKSYSTEM.aktifler, v)].." Second CD)"
    elseif table.HasValue(PERKSYSTEM.keyperk, v) then
        PERKSYSTEM.fiyatlar[v] = key_perk_price
        PERKSYSTEM.perkrenkleri[v] = Color(255, 112, 51)
        PERKSYSTEM.aciklamalar[PERKSYSTEM.lan_config][v] = "Key Perk: "..PERKSYSTEM.aciklamalar[PERKSYSTEM.lan_config][v]
    else
        PERKSYSTEM.fiyatlar[v] = common_perk_price
        PERKSYSTEM.perkrenkleri[v] = Color(255,255,255,150)
        PERKSYSTEM.aciklamalar[PERKSYSTEM.lan_config][v] = "Common Perk: "..PERKSYSTEM.aciklamalar[PERKSYSTEM.lan_config][v]
    end
    if PERKSYSTEM.individual_pricing[v] then
        PERKSYSTEM.fiyatlar[v] = PERKSYSTEM.individual_pricing[v]
    end
    if PERKSYSTEM.isimler[PERKSYSTEM.lan_config][v] then
        PERKSYSTEM.aciklamalar[PERKSYSTEM.lan_config][v] = PERKSYSTEM.isimler[PERKSYSTEM.lan_config][v]..";\n"..PERKSYSTEM.aciklamalar[PERKSYSTEM.lan_config][v]
    end

    if table.HasValue(disabledperks, v) then
        print("[PERK SYSTEM] "..PERKSYSTEM.isimler[PERKSYSTEM.lan_config][v].." perk is disabled and removed from market! (Check config for more info.)")
        table.RemoveByValue(PERKSYSTEM.perks, v)
    end
end


for i,bundle in ipairs(PERKSYSTEM.bundles) do
    for _,disabled in ipairs(disabledperks) do
        if table.HasValue(bundle,disabled) then
            print("[PERK SYSTEM] "..bundle[1].." perk bundle contains disabled perks, therefore it is removed from market!")
            table.remove(PERKSYSTEM.bundles, i)
        end
    end
end

if PERKSYSTEM.Workshop_Autodownload and SERVER then
    resource.AddWorkshop( "3090792341" )
    resource.AddWorkshop( "1746004023" )
end


