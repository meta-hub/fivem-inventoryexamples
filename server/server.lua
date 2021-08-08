TriggerEvent("esx:getSharedObject",function(obj)
  ESX = obj
end)

Citizen.CreateThread(function()
  exports["mf-inventory"]:onReady(function()
    for _,data in pairs(Config.Objects) do
      if data.InvType ~= "crafting" then
        local inv = exports["mf-inventory"]:getInventory(data.Identifier)
        if not inv then
          print(string.format("creating new vault inventory for identifier '%s'",data.Identifier))

          if data.Temporary then
            exports["mf-inventory"]:createTemporaryInventory(
              data.Identifier,
              "inventory",
              data.InvType,
              data.InvLabel,
              data.MaxWeight or 500.0,
              data.MaxSlots or 50
            )
          else
            exports["mf-inventory"]:createInventory(
              data.Identifier,
              "inventory",
              data.InvType,
              data.InvLabel,
              data.MaxWeight or 500.0,
              data.MaxSlots or 50
            )
          end
        end
      end
    end
  end)
end)

RegisterNetEvent("inventoryExamples:removeItem")
AddEventHandler("inventoryExamples:removeItem",function(item)
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.removeInventoryItem(item,1)
end)
