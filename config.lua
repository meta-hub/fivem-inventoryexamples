--[[
  Credits to Mr Bluffz for the original resource that was expanded and modified (BluffzJobVaults/https://github.com/MrBluffz/BluffzJobVault).
  Discord: Mr Bluffz#0001
  Github: https://github.com/MrBluffz
--]]

Config = {
  Locale = 'en',        -- Options: 'de' (german), 'en' (english), 'fr' (french), 'ru' (russian), 'sp' (spanish) I used google translate, feel free to DM me with better translation.
  Notify = 'esx',       -- OPTIONS: 'esx', 'ns', 'mythic_old', 'mythic_new', 'chat', 'custom'. Adjust custom notification on line 82 of client.lua, change notification message on line 111
  InteractDist = 2.0,   -- Distance from object to interact
  Objects = {
    {
      InvType = "vault",                                -- vault or crafting
      Identifier = "evidenceMRPD1",                     -- Inventory Name (MUST BE UNIQUE). Script will auto search if this inventory exists, and if it doesn't, it will create it for you.
      ShowProp = true,                                  -- Set to true if you want to see the vault prop. set to false if you do not want to see the vault prop. (Default: true)
      Prop = 'p_v_43_safe_s',                           -- Vault Prop Name
      Coords = vector3(474.73,-946.31,27.55),           -- These coords are used for your vault prop location, and your blip location.
      Heading = 271.79,                                 -- Heading for prop. Make it the same heading your player is standing.
      ShowBlip = true,                                  -- Set to true if you want blip, set to false if you do NOT want map blip (default: true)
      Size  = 1.0,                                      -- How big the blip will be on the map/minimap.
      Type  = 59,                                       -- Which blip to display    See: https://docs.fivem.net/docs/game-references/blips/
      Color = 25,                                       -- What color Blip you want   See: https://docs.fivem.net/docs/game-references/blips/
      Label = 'MRPD Evidence Locker 1',                 -- This will be the Blip name if you have ShowBlip = true. 
      ReqJob = {'police', 'ambulance'},                 -- Delete entire line if you don't want a job check, otherwise make sure your job/jobs are in { } like this example {'insertjob', 'insertjob2'}
      MaxWeight = 500.0,                                -- The max weight for this inventory container.
      MaxSlots = 50,                                    -- The slot count for this inventory
      AllowBreakIn = true,                              -- Allow anybody to break in? (NOTE: Only works when the prop is enabled/ShowProp = true)
      RequiredBreakInItem = "basic_tools",              -- Item required to break in? False if no item required.
      RemoveOnSuccess = true,                           -- Remove break-in item on success?
      RemoveOnFail = false,                             -- Remove break-in item on fail?
      PinCount = 4,                                     -- Count of pins to break in?
    },
    {   
      InvType = "vault",                                -- vault or crafting
      Identifier = "evidenceMRPD2",                     -- Inventory Name. Script will auto search if this inventory exists, and if it doesn't, it will create it for you.
      ShowProp = false,                                 -- set to true if you want to see the vault prop. set to false if you do not want to see the vault prop. (Default: true)
      Prop = 'p_v_43_safe_s',                           -- Vault Prop Name
      Coords = vector3(472.5785, -995.2488, 26.2734),   -- Coords for Blip and Prop
      Heading = 189.61,                                 -- Heading for prop
      ShowBlip = false,                                 -- Set to true if you want blip, set to false if you do NOT want map blip (default: true)
      Size  = 1.0,                                      -- How big the blip will be on the map/minimap.
      Type  = 59,                                       -- Which blip to display    See: https://docs.fivem.net/docs/game-references/blips/
      Color = 25,                                       -- What color Blip you want   See: https://docs.fivem.net/docs/game-references/blips/
      Label = 'MRPD Evidence Locker 2',                 -- This will be the Blip name if you have ShowBlip = true. 
      ReqJob = {'police', 'ambulance'},                 -- Delete entire line if you don't want a job check, otherwise make sure your job/jobs are in { } like this example {'insertjob', 'insertjob2'}
      MaxWeight = 500.0,                                -- The max weight for this inventory container.
      MaxSlots = 50,                                    -- The slot count for this inventory
      AllowBreakIn = true,                              -- Allow anybody to break in?
      RequiredBreakInItem = false,                      -- Item required to break in? False if no item required.
      RemoveCountOnFail = false,                        -- Remove count of required break in item on fail. False if none.
      RemoveCountOnSuccess = false,                     -- Remove count of required break in item on success. False if none.
    },
    {
      InvType = "crafting",                             -- vault or crafting
      Identifier = "example_recipe",                    -- Crafting recipe name. Must be defined in mf-inventory config.lua.
      ShowProp = true,                                  -- set to true if you want to see the crafting table prop.
      Prop = 'prop_tool_bench02_ld',                    -- Table prop name.
      Coords = vector3(481.38,-946.36,27.32),           -- Coords for Blip and Prop
      Heading = 269.50,                                 -- Heading for prop
      ShowBlip = true,                                  -- Set to true if you want blip, set to false if you do NOT want map blip (default: true)
      Size  = 1.0,                                      -- How big the blip will be on the map/minimap.
      Type  = 402,                                      -- Which blip to display    See: https://docs.fivem.net/docs/game-references/blips/
      Color = 25,                                       -- What color Blip you want   See: https://docs.fivem.net/docs/game-references/blips/
      Label = 'Some Crafting Table',                    -- This will be the Blip name if you have ShowBlip = true. 
      ReqJob = {'police', 'ambulance'},                 -- Delete entire line if you don't want a job check, otherwise make sure your job/jobs are in { } like this example {'insertjob', 'insertjob2'}
    },
  }
}

-- DO NOT TOUCH BELOW THIS LINE

for k,v in ipairs(Config.Objects) do
  if v.ReqJob then
    local lookup = {}

    for _,name in ipairs(v.ReqJob) do
      lookup[name] = true
    end

    v.ReqJob = lookup
  end
end
