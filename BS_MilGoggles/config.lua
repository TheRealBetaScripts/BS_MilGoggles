Config = {}

Config.Debug = {
  enabled = false, -- Enable Debug console prints
  logLevel = "shallow", -- Select shallow logs or not; Options: "shallow", "deep"
}

Config.KeepOverlayEnabledEnteringVeh = false -- Enable to replace goggles if active when player enters vehicle

Config.Clothing = { -- Clothing Options
  Male = { -- mp_m_freemode_01
    goggles = { -- Enabled goggles, down over eyes
      ["default"] = -1, -- No goggles, value for removing
      [1] = 93, -- Index Key, goggles Value
      [2] = 95,
    },
    disabledGoggles = { -- Disabled goggles, lifted off eyes
      [1] = 94, -- Swaps with goggles[key] when enable triggered
      [2] = 96,
    },
    flashlightGoggles = { -- Goggles with flashlights, doesn't need one technically can put the offset anywhere
      [2] = { -- SpotLight native https://docs.fivem.net/natives/?_0xD0F64B265C8C8B33
        offset = vector3(-0.15, 0.1, 0.185), -- Goggles value, offset from ped FACIAL_facialRoot bone (31086 https://wiki.rage.mp/index.php?title=Bones)
        color = {r = 255, g = 255, b = 255},
        distance = 115.0, 
        brightness = 15.0,
        hardness = 0.15,
        radius = 25.0,
        falloff = 35.0
      },
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
    },
    flashlightGoggles = {
      [2] = {
        offset = vector3(-0.15, 0.1, 0.185),
        color = {r = 255, g = 255, b = 255},
        distance = 115.0, 
        brightness = 15.0,
        hardness = 0.15,
        radius = 25.0,
        falloff = 35.0
      },
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
  Swap = true, -- When enabling/disable goggles
  Dictionary = "amb@code_human_wander_idles@female@idle_b", -- Dictionary to call animation from
  Name = "idle_e_wipeforehead", -- Animation name to call from dictionary
  ParamTable = {2.0, 1.0, 1250, 49, 0.0, false, false, false}, -- TaskPlayAnim parameters past animation name https://docs.fivem.net/natives/?_0xEA47FE3719165B94
}

Config.SkinChangeFunction = function(value, gogglesOn) -- Change player clothes (Hat/Helmet Skin ID, Goggles On Check)
  print("Triggering Config.SkinChangeFunction", value, gogglesOn)
  
  
  -- Works with OUR fivem-appearance/inventory/metadata clothes system
  TriggerEvent("skinchanger:getSkin", function(skin)
    local compIndex; for i = 1,#skin.props do if skin.props[i].prop_id and skin.props[i].prop_id==0 then compIndex = i; break; end end
    if not compIndex then compIndex = 1 end
    local updatedClothes = {["helmet_1"] = value, ["helmet_2"] = 0}
    skin.props[compIndex].drawable = value
    skin.props[compIndex].texture = 0
    TriggerEvent("skinchanger:loadClothes", skin, updatedClothes)
    TriggerServerEvent("fivem-appearance:save", skin) -- Our fivem-appearance save trigger
    TriggerServerEvent("illenium-appearance:server:saveAppearance", skin) -- Example using illenium-appearance (because it *should* be immediately compatible)
  end)
  
  
end

--[[
Exports for putting goggles on/taking them off with items/keybinds/etc
Trigger exports["BS_MilGoggles"]:PutGogglesOn(keyFrom_Config.Clothing.Gender.goggles, enabledDisabledVersion)
Example exports["BS_MilGoggles"]:PutGogglesOn(1, true) will put on goggles[1]
Example exports["BS_MilGoggles"]:PutGogglesOn(1, false) will put on disabledGoggles[1]

Trigger exports["BS_MilGoggles"]:TakeGogglesOff()
Example exports["BS_MilGoggles"]:TakeGogglesOff()
]]