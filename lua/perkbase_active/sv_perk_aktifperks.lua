
hook.Add( "EntityTakeDamage", "perk_tutulma", function( target, dmginfo ) -- key

    local ply = dmginfo:GetAttacker()

    if ply:IsPlayer() then
        if IsPerkEquipped(ply,"tutulma") then
            if timer.Exists(ply:SteamID64().."_tutulma") then
                dmginfo:ScaleDamage(1.25)
            end
        end
    end
 
end)

hook.Add("EntityTakeDamage", "patlartohumbiriktir", function(target,dmginfo)

    local ply = dmginfo:GetAttacker()

    if target:IsPlayer() and ply:IsPlayer() and ply != target then
        
        if !target.DMGHold then target.DMGHold = 1 end

        if IsPerkEquipped(target,"patlartohum") then

            target.DMGHold = target.DMGHold + math.Round(dmginfo:GetDamage()/10)
            --if target.DMGHold > 100 then target.DMGHold = 100 end

            net.Start("aktifperkkullanildi")
            net.WriteInt(target.DMGHold,32)
            net.Send(target)


            if math.random(1, 100) <= 10 then 

                ShowBuffIndicator(target,'patlartohum','Damage absorbed!',2)

                return 0 

            end
        
        end
    end 

end)

net.Receive("aktifperkkullanildi", function(len,ply)

    local kullanilmakistenen = net.ReadString()
    local kacinci = table.find(PERKSYSTEM.aktifler,kullanilmakistenen)
    if IsPerkEquipped(ply,kullanilmakistenen) then
        if kullanilmakistenen == "tutulma" then

            ply:EmitSound("perksounds/tutulma-kullandi.wav",150)
            --ParticleEffectAttach("aes_roll_price",4,ply,1)
            ParticleEffect("aes_tage", ply:GetPos()+Vector(0, 0, 30), Angle(0,0,0), ply)
            ply:SetNWVector("lastloc", ply:GetPos())
            ParticleEffect( "aes_remove", ply:GetPos(), Angle(0,0,0), ply )

            timer.Create(ply:SteamID64().."_tutulma",PERKSYSTEM.aktifduration[kacinci],1,function()
                if ply:IsValid() then
                    ply:StopParticles()
                    ply:EmitSound("perksounds/tutulma-bitti.wav") --sesler burda
                    ply:SetPos(ply:GetNWVector("lastloc"))
                end
                hook.Remove("EntityTakeDamage",ply:SteamID64().."hasarboost")
                hook.Remove("PlayerDeath", "oldunmudogrusoyle"..ply:SteamID64())
            end)

            hook.Add("PlayerDeath","oldunmudogrusoyle"..ply:SteamID64(),function(oyuncu)
                if oyuncu == ply then
                    hook.Remove("PlayerDeath", "oldunmudogrusoyle"..ply:SteamID64())
                    hook.Remove("EntityTakeDamage",ply:SteamID64().."hasarboost")
                    timer.Remove(ply:SteamID64().."_tutulma")
                    ply:EmitSound("perksounds/tutulma-bitti.wav")
                    timer.Simple(0.5, function()
                        ply:Spawn()
                        ply:SetPos(ply:GetNWVector("lastloc")) 
                    end)
                end
            end)

            hook.Add("EntityTakeDamage",ply:SteamID64().."hasarboost",function(target,dmg)
                if dmg:GetAttacker() == ply then
                    dmg:ScaleDamage(1.25)
                end
            end)

        elseif kullanilmakistenen == "patlartohum" then

            ply:ChatPrint("Patlar tohum kullanmaya çalıştın")

            if !ply.DMGHold then ply.DMGHold = 1 end

            if ply.DMGHold >= 100 then
                ShowBuffIndicator(ply,'patlartohum','Activated, behold!',2)
                ply:EmitSound("perksounds/patlartohum_explode.wav",100)

                timer.Simple(1, function()
                    ParticleEffectAttach("skay", 2, ply, 1)

                    timer.Simple(0.2, function()
                        for k,v in ipairs(ents.FindInSphere(ply:GetPos(), 700)) do
                            if v:IsPlayer() and v != ply then
                                v:TakeDamage(math.Clamp(200/k, 33, ply:Health()-2),ply,ply)
                                v:Ignite(PERKSYSTEM.aktifduration[kacinci])
                            end
                        end
                    end)

                    timer.Simple(4, function()
                        if ply:IsValid() then
                            StopSpesificParticle(ply,"skay") 
                        end
                    end)
                end)

                ply.DMGHold = 0
                net.Start("aktifperkkullanildi")
                net.WriteInt(ply.DMGHold,32)
                net.Send(ply)
            end
        elseif kullanilmakistenen == "gelgit" then


            ParticleEffectAttach( "qye_bomb",2, ply, 1 )
            ParticleEffect("[7]snow",ply:GetPos()+Vector(0,0,200),ply:GetAngles(),ply)
            ply:EmitSound("perksounds/gelgit.wav",100)
            ply:EmitSound("perksounds/gelgit2.wav",100)
            ShowBuffIndicator(ply,'gelgit','Activated!',5)

            RunGesture(ply,1641)

            for k,v in ipairs(ents.FindInSphere(ply:GetPos(), 400)) do
                if v:IsPlayer() and v != ply then
                    if v:Alive() then
                        v:Freeze(true)
                        ParticleEffectAttach("qye_lurker",2, v,1)
                        ShowBuffIndicator(v,'gelgit','You froze!',"..PERKSYSTEM.aktifduration[kacinci]..")

                        timer.Simple(PERKSYSTEM.aktifduration[kacinci], function()
                            if v:IsValid() then
                                StopSpesificParticle(v,"qye_lurker")
                                v:Freeze(false)
                            end
                        end)
                    end
                end
            end
            
            timer.Simple(3, function()
                if ply:IsValid() then
                    ply:StopParticles()
                end
            end)



        end
    end
end)

local letterToKeyEnum = {A = KEY_A, B = KEY_B, C = KEY_C, D = KEY_D, E = KEY_E, F = KEY_F, G = KEY_G, H = KEY_H, I = KEY_I, J = KEY_J, K = KEY_K, L = KEY_L, M = KEY_M, N = KEY_N, O = KEY_O, P = KEY_P, Q = KEY_Q, R = KEY_R, S = KEY_S, T = KEY_T, U = KEY_U, V = KEY_V, W = KEY_W, X = KEY_X, Y = KEY_Y, Z = KEY_Z}
hook.Add("OnPerkEquipped", "perk_active", function(ply, perk)
    --print(ply:Nick().." equipped "..perk)
    if PERKSYSTEM.aktifler_lookup[perk] then
        ply:ChatPrint("You equipped a active perk! Default perk activation key is ("..table.KeyFromValue(letterToKeyEnum,PERKSYSTEM.active_perk_key).."). You can use (active_perk_key) console command to change the key.")
    end
end)