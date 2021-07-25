function initEsx()
  while not ESX do
    TriggerEvent('esx:getSharedObject', function(obj) 
      ESX = obj 
    end)

    Wait(100)
  end

  while not ESX.IsPlayerLoaded() do
    Wait(500)
  end

  playerData = ESX.GetPlayerData()
end

function setupBlips()
  for k,v in ipairs(Config.Objects) do
    if v.ShowBlip then
      local blip = AddBlipForCoord(v.Coords)
      SetBlipSprite (blip, v.Type)
      SetBlipScale  (blip, v.Size)
      SetBlipColour (blip, v.Color)
      SetBlipAsShortRange(blip, true)
      BeginTextCommandSetBlipName('STRING')
      AddTextComponentSubstringPlayerName(v.Label)
      EndTextCommandSetBlipName(blip)
    end
  end
end

function getClosestObject(pos)
  local closest,dist

  for k,v in ipairs(Config.Objects) do
    local d = #(v.Coords - pos)

    if not dist or d < dist then
      closest = k
      dist = d
    end

    if d <= 50.0 then
      if v.ShowProp and not v.Ent then
        loadObj(k)
      end
    else
      if v.Ent then
        unloadObj(k)
      end
    end
  end

  return closest,dist
end

function loadObj(i)
  local obj = Config.Objects[i]
  if obj.ShowProp then
    local hash = GetHashKey(obj.Prop)

    RequestModel(hash)
    while not HasModelLoaded(hash) do
      Wait(0)
    end

    obj.Ent = CreateObject(hash, obj.Coords.x, obj.Coords.y, obj.Coords.z - 1.0)
    SetEntityHeading(obj.Ent, (obj.InvType == "crafting" and obj.Heading + 90.0 or obj.Heading + 180.0))
    FreezeEntityPosition(obj.Ent,true)
  end
end

function unloadObj(i)
  local obj = Config.Objects[i]
  if obj.Ent then
    SetEntityAsMissionEntity(obj.Ent,true,true)
    DeleteEntity(obj.Ent)
    obj.Ent = nil
  end
end

function showHelpNotification(msg)
  AddTextEntry('vaultsHelpNotif', msg)
  DisplayHelpTextThisFrame('vaultsHelpNotif', false)
end

function removeRequiredItem(itemName)
  TriggerServerEvent("inventoryExamples:removeItem",itemName)
end

function startSafecracker(obj,cb)
  exports['safecracker']:start(obj.Ent or false,obj.PinCount or 4,function(res)
    if obj.RemoveOnSuccess and res or obj.RemoveOnFail and not res then
      removeRequiredItem(obj.RequiredBreakInItem)
    end
    cb(res)
  end,false)
end

function startMinigame(obj,cb)
  exports['mf-inventory']:minigame(obj.MinigameLength,obj.MinigameSpeed,function(res)
    if obj.RemoveOnSuccess and res or obj.RemoveOnFail and not res then
      removeRequiredItem(obj.RequiredBreakInItem)
    end
    cb(res)
  end)
end

function checkBreakInItems(obj,cb)  
  exports["mf-inventory"]:getInventoryItems(playerData.identifier,function(items)
    for k,v in pairs(items) do
      if type(v) == "table" and v.name == obj.RequiredBreakInItem and v.count > 0 then
        if obj.InvType == "vault" then
          startSafecracker(obj,function(res)
            cb(res)
          end)
        elseif obj.InvType == "crafting" then
          startMinigame(obj,function(res)
            cb(res)
          end)
        end

        return
      end 
    end

    cb(false)
  end)
end

function checkBreakIn(obj,cb)
  if obj.RequiredBreakInItem then
    checkBreakInItems(obj,function(res)
      cb(res)
    end)
  else
    if obj.InvType == "vault" then
      startSafecracker(obj,function(res)
        cb(res)
      end)
    elseif obj.InvType == "crafting" then
      startMinigame(obj,function(res)
        cb(res)
      end)
    end
  end
end

function checkAllowed(obj,cb)
  if obj.ReqJob and obj.ReqJob[playerData.job.name] then
    cb(true)
    return
  end

  if not obj.AllowBreakIn or not obj.Ent then
    cb(false)
    return
  end

  checkBreakIn(obj,function(res)
    cb(res)
  end)
end

Citizen.CreateThread(function()
  local lastObj,busy
  local helpLabels = {
    vault = _U('vault_menu'),
    crafting = _U('crafting_menu')
  }

  initEsx()
  setupBlips()

  while true do
    local closestObj,objDist

    if not busy then
      local ped = PlayerPedId()
      local pos = GetEntityCoords(ped)

      closestObj,objDist = getClosestObject(pos)

      if closestObj then        
        if objDist <= Config.InteractDist then
          local obj = Config.Objects[closestObj]

          if not obj.ReqJob or obj.ReqJob[playerData.job.name] or obj.AllowBreakIn then
            showHelpNotification(helpLabels[obj.InvType])

            if IsControlJustPressed(0,38) then
              busy = true

              checkAllowed(obj,function(allowed)
                if allowed then
                  if obj.InvType == "vault" then
                    exports["mf-inventory"]:openOtherInventory(obj.Identifier)
                  elseif obj.InvType == "crafting" then
                    exports["mf-inventory"]:openCrafting(obj.Identifier)
                  end
                end

                busy = false
              end)
            end
          end
        end
      end
    end

    Wait(objDist and objDist < 10.0 and 0 or 500)
  end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob',function(j)
  if not playerData then
    return
  end
  
  playerData.job = j
end)
