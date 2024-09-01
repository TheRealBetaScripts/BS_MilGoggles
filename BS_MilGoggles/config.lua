Config = {}

Config.Debug = {
  enabled = false, -- Enable Debug console prints
  logLevel = "shallow", -- Select shallow logs or not; Options: "shallow", "deep"
}

Config.Clothing = { -- Clothing Options
  Male = { -- mp_m_freemode_01
    goggles = { -- Enabled goggles, down over eyes
      ["default"] = -1, -- No goggles, value for removing
      [1] = 93, -- Index Key, goggles Value
      [2] = 95,
    },
    disabledGoggles = { -- Disabled goggles, lifted off eyes
      [1] = 94, -- Swaps with goggles [key] when enable triggered 
      [2] = 96,
    }
  },
  Female = { -- mp_f_freemode_01
    goggles = {
      ["default"] = -1,
      [1] = 91,
      [2] = 93,
    },
    disabledGoggles = {
      [1] = 92,
      [2] = 94,
    }
  },
}

Config.Interaction = { -- Set Interaction keybinds https://docs.fivem.net/natives/?_0xD7664FD1
  Enable = { -- Enable/Disable Current Goggles
    ["KEYBOARD"] = "H", -- Keyboard keybinding IO parameter ID https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
    ["PAD_ANALOGBUTTON"] = "", -- Controller keybinding IO parameter ID https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/pad_analogbutton/
  },
  Cycle = { -- Cycle Current Goggle Overlay
    ["KEYBOARD"] = "J",
    ["PAD_ANALOGBUTTON"] = "",
  },
}

Config.Animations = { -- Set Times Animations Run
  PutOn = false, -- When putting on goggles with exports["BS_MilGoggles"]:PutGogglesOn(1, true)
  TakeOff = false, -- When taking off goggles with exports["BS_MilGoggles"]:TakeGogglesOff()
  Swap = true, -- When enabling/disabling goggles
  Dictionary = "amb@code_human_wander_idles@female@idle_b", -- Dictionary to call animation from -- https://alexguirre.github.io/animations-list/
  Name = "idle_e_wipeforehead", -- Animation name to call from dictionary
  ParamTable = {2.0, 1.0, 500, 49, 0.2, 1, 1}, -- TaskPlayAnimAdvanced parameters past rotZ https://docs.fivem.net/natives/?_0x83CDB10EA29B370B
}

Config.SkinChangeFunction = function(value, gogglesOn) -- Hat/Helmet Skin ID, Goggles On Check
  -- Works with OUR fivem-appearance/inventory/metadata clothes system
  TriggerEvent('skinchanger:getSkin', function(skin)
    local compIndex; for i = 1,#skin.props do if skin.props[i].prop_id and skin.props[i].prop_id==0 then compIndex = i; break; end end
    if not compIndex then compIndex = 1 end
    local updatedClothes = {["helmet_1"] = value, ["helmet_2"] = 0}
    skin.props[compIndex].drawable = value
    skin.props[compIndex].texture = 0
    TriggerEvent('skinchanger:loadClothes', skin, updatedClothes)
    TriggerServerEvent('fivem-appearance:save', skin)
  end)
  -- Probably will need to be changed for your clothes system
end


--[[
Trigger exports["BS_MilGoggles"]:PutGogglesOn(Config.Clothing.Gender.goggles[key], enabledDisabledVersion)
Example exports["BS_MilGoggles"]:PutGogglesOn(1, true) will put on goggles[1] enabled
Example exports["BS_MilGoggles"]:PutGogglesOn(1, false) will put on goggles[1] disable

Trigger exports["BS_MilGoggles"]:TakeGogglesOff()
Example exports["BS_MilGoggles"]:TakeGogglesOff()
]]