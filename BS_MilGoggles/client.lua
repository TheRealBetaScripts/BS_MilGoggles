-- Local variable initialization
local refFunc = print
local visionState = 0
local previousState = 0
local gogglesOn = false
local gogglesEnabled = false
local Male, Female = GetHashKey("mp_m_freemode_01"), GetHashKey("mp_f_freemode_01")
local dict, anim = "amb@code_human_wander_idles@female@idle_b", "idle_e_wipeforehead"

-- Init validation of Config
if not Config or type(Config)~="table" then Config = {}; end
if not Config.Debug or type(Config.Debug)~="table" then Config.Debug = {enabled = false, logLevel = "simple"} end

-- Local print function for debug
print = function(...)
  if Config.Debug.enabled then
    local args = {...}
    if Config.Debug.logLevel and Config.Debug.logLevel=="shallow" then
      refFunc(args[1])
    else
      refFunc(table.unpack(args))
    end
  end
end

-- Remaining validation of Config
if not Config.Clothing or type(Config.Clothing)~="table" then Config.Clothing = {}; end
if not Config.Clothing.Male or type(Config.Clothing.Male)~="table" then
  Config.Clothing.Male = {
    goggles = {
      ["default"] = -1,
      [1] = 93,
      [2] = 95,
    },
    disabledGoggles = {
      [1] = 94,
      [2] = 96,
    }
  }
end
if not Config.Clothing.Male.goggles or type(Config.Clothing.Male.goggles)~="table" then Config.Clothing.Male.goggles = {["default"] = -1,} end
if not Config.Clothing.Male.goggles["default"] or type(Config.Clothing)~="number" then Config.Clothing.Male["default"] = -1; end
if not Config.Clothing.Male.disabledGoggles or type(Config.Clothing.Male.disabledGoggles)~="table" then Config.Clothing.Male.disabledGoggles = {} end
if #Config.Clothing.Male.disabledGoggles<#Config.Clothing.Male.goggles then
  for k,v in ipairs(Config.Clothing.Male.goggles) do
    Config.Clothing.Male.disabledGoggles[k] = Config.Clothing.Male.disabledGoggles[k] or 0
  end
elseif #Config.Clothing.Male.disabledGoggles>#Config.Clothing.Male.goggles then
  for i = #Config.Clothing.Male.disabledGoggles, 1, -1 do
    if not Config.Clothing.Male.goggles[i] then table.remove(Config.Clothing.Male.disabledGoggles, i) end
  end
end
if not Config.Clothing.Female.goggles or type(Config.Clothing.Female.goggles)~="table" then Config.Clothing.Female.goggles = {["default"] = -1,} end
if not Config.Clothing.Female.goggles["default"] or type(Config.Clothing)~="number" then Config.Clothing.Female["default"] = -1; end
if not Config.Clothing.Female.disabledGoggles or type(Config.Clothing.Female.disabledGoggles)~="table" then Config.Clothing.Female.disabledGoggles = {} end
if #Config.Clothing.Female.disabledGoggles<#Config.Clothing.Female.goggles then
  for k,v in ipairs(Config.Clothing.Female.goggles) do
    Config.Clothing.Female.disabledGoggles[k] = Config.Clothing.Female.disabledGoggles[k] or 0
  end
elseif #Config.Clothing.Female.disabledGoggles>#Config.Clothing.Female.goggles then
  for i = #Config.Clothing.Female.disabledGoggles, 1, -1 do
    if not Config.Clothing.Female.goggles[i] then table.remove(Config.Clothing.Female.disabledGoggles, i) end
  end
end
if not Config.Interaction or type(Config.Interaction)~="table" then Config.Interaction = {} end
if not Config.Interaction.Enable or type(Config.Interaction.Enable)~="table" then Config.Interaction.Enable = {["KEYBOARD"] = "", ["PAD_ANALOGBUTTON"] = ""} end
if not Config.Interaction.Cycle or type(Config.Interaction.Cycle)~="table" then Config.Interaction.Cycle = {["KEYBOARD"] = "", ["PAD_ANALOGBUTTON"] = ""} end
if not Config.Animations or type(Config.Animations)~="table" then
  Config.Animations = { PutOn = false, TakeOff = false, Swap = true, Dictionary = "amb@code_human_wander_idles@female@idle_b", Name = "idle_e_wipeforehead", ParamTable = {2.0, 1.0, 500, 49, 0.2, 1, 1} }
end
if not DoesAnimDictExist(Config.Animations.Dictionary) then
  Config.Animations.Dictionary = "amb@code_human_wander_idles@female@idle_b"
  Config.Animations.Name = "idle_e_wipeforehead"
end
if not Config.Animations.ParamTable or type(Config.Animations.ParamTable)~="table" then Config.Animations.ParamTable = {2.0, 1.0, 500, 49, 0.2, 1, 1} end
if not Config.SkinChangeFunction or type(Config.SkinChangeFunction)~="function" then Config.SkinChangeFunction = function(v, gO) end end

-- Script Functions
IsMpPed = function()
	local CurrentModel = GetEntityModel(PlayerPedId())
  return ((CurrentModel==Male) and "Male") or ((CurrentModel==Female) and "Female") or false
end

GoggleAnim = function()
  print("Loading GoggleAnim", Config.Animations.Dictionary)
  while not HasAnimDictLoaded(Config.Animations.Dictionary) do RequestAnimDict(Config.Animations.Dictionary); Wait(50); end
  local pos = GetEntityCoords(PlayerPedId())
  TaskPlayAnimAdvanced(PlayerPedId(), Config.Animations.Dictionary, Config.Animations.Name, pos.x, pos.y, pos.z, 0.0, 0.0, GetEntityHeading(PlayerPedId()), table.unpack(Config.Animations.ParamTable))
  RemoveAnimDict(Config.Animations.Dictionary)
end

PutGogglesOn = function(id, enabled, isToggle)
  print("PutGogglesOn triggered", id, enabled)
  if not enabled then
    if isToggle then
      CycleGoggles(Config.Animations.Swap, 0)
    else
      CycleGoggles(Config.Animations.PutOn, 0)
    end
  end
  gogglesOn = id or 1
  gogglesEnabled = enabled or false
  if gogglesEnabled then
    if isToggle then
      CycleGoggles(Config.Animations.Swap, previousState)
    else
      CycleGoggles(Config.Animations.PutOn, previousState)
    end
  end
  print("Getting IsMpPed")
  local conTab = IsMpPed()
  if not conTab then return end
  print("Converting conTab to Config.Clothing table", conTab)
  conTab = ((conTab=="Male") and Config.Clothing.Male) or Config.Clothing.Female
  print("Successful conversion to Config table", json.encode(conTab, {indent = true}))
  if gogglesOn > #conTab.disabledGoggles then gogglesOn = #conTab.disabledGoggles end
  Config.SkinChangeFunction(((gogglesEnabled) and conTab.goggles[gogglesOn]) or conTab.disabledGoggles[gogglesOn], true)
end
exports("PutGogglesOn", PutGogglesOn)

TakeGogglesOff = function()
  print("TakeGogglesOff triggered")
  CycleGoggles(Config.Animations.TakeOff, 0)
  gogglesOn = false
  gogglesEnabled = false
  print("Getting IsMpPed")
  local conTab = IsMpPed()
  if not conTab then return end
  print("Converting conTab to Config.Clothing table", conTab)
  conTab = ((conTab=="Male") and Config.Clothing.Male) or Config.Clothing.Female
  print("Successful conversion to Config table", json.encode(conTab, {indent = true}))
  Config.SkinChangeFunction(conTab.goggles["default"], false)
end
exports("TakeGogglesOff", TakeGogglesOff)

ToggleGoggles = function()
  print("Attempting to toggle goggles")
  if not gogglesOn then return end
  PutGogglesOn(gogglesOn, (not gogglesEnabled), true)
end

CycleGoggles = function(animPerform, state)
  print("Attempting to cycle goggles", visionState, animPerform, state)
  if not gogglesOn then return end
  if not gogglesEnabled then return end
  if animPerform then GoggleAnim(); Wait(500); end
  previousState = visionState
  visionState = state or ((visionState + 1)%3)
  SetNightvision(visionState==1)
  SetSeethrough(visionState==2)
  print("Set new visionState", visionState)
end

-- Command registration
RegisterCommand("+ToggleGoggles", ToggleGoggles, false)
RegisterCommand("-ToggleGoggles", function() end, false) -- Probably not needed

RegisterCommand("+CycleGoggles", function() CycleGoggles(Config.Animations.Swap) end, false)
RegisterCommand("-CycleGoggles", function() end, false) -- Probably not needed

RegisterKeyMapping("+ToggleGoggles", "Lift/Lower Goggles", "KEYBOARD", Config.Interaction.Enable.KEYBOARD)
RegisterKeyMapping("~!+ToggleGoggles", "Lift/Lower Goggles - Alternate", "PAD_ANALOGBUTTON", Config.Interaction.Enable.PAD_ANALOGBUTTON)

RegisterKeyMapping("+CycleGoggles", "Cycle Goggle State", "KEYBOARD", Config.Interaction.Cycle.KEYBOARD)
RegisterKeyMapping("~!+CycleGoggles", "Cycle Goggle State - Alternate", "PAD_ANALOGBUTTON", Config.Interaction.Cycle.PAD_ANALOGBUTTON)