hook.Add("playerBoughtCustomEntity", "couponer", function(ply,enttab,ent,price)

    if IsPerkEquipped(ply,"kupon") then
        ply:addMoney(price/5)
        ShowBuffIndicator(ply,'kupon','Gained %20 cashback on your purchase.',10)
    end

end)

hook.Add("playerGetSalary", "couponer", function(ply,money)
    if IsPerkEquipped(ply,"kupon") then
        ply:addMoney(money)
        ShowBuffIndicator(ply,'kupon','Salary earnings doubled.',10)
    end
end)