-- Local variable initialization
local refFunc = print
local visionState = 0
local previousState = 0
local Male, Female = GetHashKey("mp_m_freemode_01"), GetHashKey("mp_f_freemode_01")
local dict, anim = "amb@code_human_wander_idles@female@idle_b", "idle_e_wipeforehead"

-- Settable/checkable through config.lua
gogglesOn = false
gogglesEnabled = false
adjustingGoggles = false

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
if not Config.Clothing or type(Config.Clothing)~="table" then print("Invalid Config.Clothing table"); Config.Clothing = {}; end
if not Config.Clothing.Male or type(Config.Clothing.Male)~="table" then
  print("Invalid Config.Clothing.Male table");
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
if not Config.Clothing.Male.goggles or type(Config.Clothing.Male.goggles)~="table" then print("Invalid Config.Clothing.Male.goggles table"); Config.Clothing.Male.goggles = {["default"] = -1,}; end
if not Config.Clothing.Male.goggles["default"] or type(Config.Clothing.Male.goggles["default"])~="number" then print("Invalid Config.Clothing.Male.goggles['default'] value"); Config.Clothing.Male.goggles["default"] = -1; end
if not Config.Clothing.Male.disabledGoggles or type(Config.Clothing.Male.disabledGoggles)~="table" then print("Invalid Config.Clothing.Male.disabledGoggles table"); Config.Clothing.Male.disabledGoggles = {}; end
if #Config.Clothing.Male.disabledGoggles<#Config.Clothing.Male.goggles then
  print("Config.Clothing.Male.disabledGoggles table shorter than Config.Clothing.Male.goggles, adding missing disabledGoggles as 0")
  for k,v in ipairs(Config.Clothing.Male.goggles) do
    Config.Clothing.Male.disabledGoggles[k] = Config.Clothing.Male.disabledGoggles[k] or 0
  end
elseif #Config.Clothing.Male.disabledGoggles>#Config.Clothing.Male.goggles then
  print("Config.Clothing.Male.disabledGoggles table longer than Config.Clothing.Male.goggles, removing additional disabledGoggles")
  for i = #Config.Clothing.Male.disabledGoggles, 1, -1 do
    if not Config.Clothing.Male.goggles[i] then table.remove(Config.Clothing.Male.disabledGoggles, i) end
  end
end
if not Config.Clothing.Female.goggles or type(Config.Clothing.Female.goggles)~="table" then print("Invalid Config.Clothing.Female.goggles table"); Config.Clothing.Female.goggles = {["default"] = -1,}; end
if not Config.Clothing.Female.goggles["default"] or type(Config.Clothing.Female.goggles["default"])~="number" then print("Invalid Config.Clothing.Female.goggles['default'] value"); Config.Clothing.Female.goggles["default"] = -1; end
if not Config.Clothing.Female.disabledGoggles or type(Config.Clothing.Female.disabledGoggles)~="table" then print("Invalid Config.Clothing.Female.disabledGoggles table"); Config.Clothing.Female.disabledGoggles = {}; end
if #Config.Clothing.Female.disabledGoggles<#Config.Clothing.Female.goggles then
  print("Config.Clothing.Female.disabledGoggles table shorter than Config.Clothing.Female.goggles, adding missing disabledGoggles as 0")
  for k,v in ipairs(Config.Clothing.Female.goggles) do
    Config.Clothing.Female.disabledGoggles[k] = Config.Clothing.Female.disabledGoggles[k] or 0
  end
elseif #Config.Clothing.Female.disabledGoggles>#Config.Clothing.Female.goggles then
  print("Config.Clothing.Female.disabledGoggles table longer than Config.Clothing.Female.goggles, removing additional disabledGoggles")
  for i = #Config.Clothing.Female.disabledGoggles, 1, -1 do
    if not Config.Clothing.Female.goggles[i] then table.remove(Config.Clothing.Female.disabledGoggles, i) end
  end
end
if not Config.Interaction or type(Config.Interaction)~="table" then print("Invalid Config.Interaction table"); Config.Interaction = {}; end
if not Config.Interaction.Enable or type(Config.Interaction.Enable)~="table" then print("Invalid Config.Interaction.Enable table"); Config.Interaction.Enable = {["KEYBOARD"] = "", ["PAD_ANALOGBUTTON"] = ""}; end
if not Config.Interaction.Enable["KEYBOARD"] or type(Config.Interaction.Enable["KEYBOARD"])~="string" then print("Invalid Config.Interaction.Enable['KEYBOARD'] value"); Config.Interaction.Enable["KEYBOARD"] = ""; end
if not Config.Interaction.Enable["PAD_ANALOGBUTTON"] or type(Config.Interaction.Enable["PAD_ANALOGBUTTON"])~="string" then print("Invalid Config.Interaction.Enable['PAD_ANALOGBUTTON'] value"); Config.Interaction.Enable["PAD_ANALOGBUTTON"] = ""; end
if not Config.Interaction.Cycle or type(Config.Interaction.Cycle)~="table" then print("Invalid Config.Interaction.Cycle table"); Config.Interaction.Cycle = {["KEYBOARD"] = "", ["PAD_ANALOGBUTTON"] = ""}; end
if not Config.Interaction.Cycle["KEYBOARD"] or type(Config.Interaction.Cycle["KEYBOARD"])~="string" then print("Invalid Config.Interaction.Cycle['KEYBOARD'] value"); Config.Interaction.Cycle["KEYBOARD"] = ""; end
if not Config.Interaction.Cycle["PAD_ANALOGBUTTON"] or type(Config.Interaction.Cycle["PAD_ANALOGBUTTON"])~="string" then print("Invalid Config.Interaction.Cycle['PAD_ANALOGBUTTON'] value"); Config.Interaction.Cycle["PAD_ANALOGBUTTON"] = ""; end
if not Config.Animations or type(Config.Animations)~="table" then
  print("Invalid Config.Animations table")
  Config.Animations = { PutOn = false, TakeOff = false, Swap = true, Dictionary = "amb@code_human_wander_idles@female@idle_b", Name = "idle_e_wipeforehead", ParamTable = {2.0, 1.0, 1250, 49, 0.2, 1, 1} }
end
if not Config.Animations.Dictionary or type(Config.Animations.Dictionary)~="string" then print("Invalid Config.Animations.Dictionary value"); Config.Animations.Dictionary = "amb@code_human_wander_idles@female@idle_b"; end
if not Config.Animations.Name or type(Config.Animations.Name)~="string" then print("Invalid Config.Animations.Name value"); Config.Animations.Name = "idle_e_wipeforehead"; end
if not DoesAnimDictExist(Config.Animations.Dictionary) then
  print("Config.Animations.Dictionary does not exist")
  Config.Animations.Dictionary = "amb@code_human_wander_idles@female@idle_b"
  Config.Animations.Name = "idle_e_wipeforehead"
end
if not Config.Animations.ParamTable or type(Config.Animations.ParamTable)~="table" then print("Invalid Config.Animations.ParamTable table"); Config.Animations.ParamTable = {2.0, 1.0, 1250, 49, 0.0, false, false, false}; end
if not Config.SkinChangeFunction or type(Config.SkinChangeFunction)~="function" then print("Invalid Config.SkinChangeFunction function"); Config.SkinChangeFunction = function(v, gO) end; end

-- Script Functions
IsMpPed = function()
	local CurrentModel = GetEntityModel(PlayerPedId())
  print("IsMpPed check", CurrentModel)
  return ((CurrentModel==Male) and "Male") or ((CurrentModel==Female) and "Female") or false
end

GoggleAnim = function()
  while not HasAnimDictLoaded(Config.Animations.Dictionary) do print("Loading GoggleAnim", Config.Animations.Dictionary); RequestAnimDict(Config.Animations.Dictionary); Wait(50); end
  local pos = GetEntityCoords(PlayerPedId())
  --TaskPlayAnimAdvanced(PlayerPedId(), Config.Animations.Dictionary, Config.Animations.Name, pos.x, pos.y, pos.z, 0.0, 0.0, GetEntityHeading(PlayerPedId()), table.unpack(Config.Animations.ParamTable))
  print("Playing GoggleAnim", Config.Animations.Dictionary, Config.Animations.Name, table.unpack(Config.Animations.ParamTable))
  TaskPlayAnim(PlayerPedId(), Config.Animations.Dictionary, Config.Animations.Name, table.unpack(Config.Animations.ParamTable))
  RemoveAnimDict(Config.Animations.Dictionary)
  print("Waiting animation duration", Config.Animations.ParamTable[3])
  Wait(Config.Animations.ParamTable[3])
end

PutGogglesOn = function(id, enabled, isToggle)
  print("PutGogglesOn triggered", id, enabled)
  if not enabled then if isToggle then CycleGoggles(Config.Animations.Swap, 0) else CycleGoggles(Config.Animations.PutOn, 0) end end
  print("Checking goggles are still on", gogglesOn)
  if not gogglesOn then return end -- Can like, toggle while removing and then it still works cuz animation timer so this stops that?
  gogglesOn = id or 1
  print("Checking enabled value", enabled)
  gogglesEnabled = enabled or false
  local conTab = IsMpPed()
  print("Validating conversion table", conTab)
  if not conTab then return end
  print("Converting conversion table to Config.Clothing table", conTab)
  conTab = ((conTab=="Male") and Config.Clothing.Male) or Config.Clothing.Female
  print("Successful conversion to Config table", json.encode(conTab, {indent = true}))
  if gogglesEnabled then if isToggle then CycleGoggles(Config.Animations.Swap, previousState, true) else CycleGoggles(Config.Animations.PutOn, previousState, true) end end
  print("Checking goggles are still on", gogglesOn)
  if not gogglesOn then Wait(Config.Animations.ParamTable[3]) end -- Wait for animations to finish?
  if not gogglesOn then return end
  if gogglesOn > #conTab.disabledGoggles then gogglesOn = #conTab.disabledGoggles end
  Config.SkinChangeFunction(((gogglesEnabled) and conTab.goggles[gogglesOn]) or conTab.disabledGoggles[gogglesOn], true)
end
exports("PutGogglesOn", PutGogglesOn)

TakeGogglesOff = function()
  print("TakeGogglesOff triggered")
  CycleGoggles(Config.Animations.TakeOff, 0)
  gogglesOn = false
  gogglesEnabled = false
  local conTab = IsMpPed()
  print("Validating conversion table", conTab)
  if not conTab then return end
  print("Converting conTab to Config.Clothing table", conTab)
  conTab = ((conTab=="Male") and Config.Clothing.Male) or Config.Clothing.Female
  print("Successful conversion to Config table", json.encode(conTab, {indent = true}))
  Config.SkinChangeFunction(conTab.goggles["default"], false)
end
exports("TakeGogglesOff", TakeGogglesOff)

ToggleGoggles = function()
  print("ToggleGoggles triggered")
  --if not gogglesOn then Config.CheckIfWearingGoggles(true); return; end
  CheckIfWearingGoggles(true);
  if not gogglesOn then return end
  print("Goggles on validated, checking adjustingGoggles", adjustingGoggles)
  if adjustingGoggles then return end
  print("Setting adjustingGoggles true")
  adjustingGoggles = true
  PutGogglesOn(gogglesOn, (not gogglesEnabled), true)
  print("Setting adjustingGoggles false")
  adjustingGoggles = false
end

CycleGoggles = function(animPerform, state, skipCheck)
  print("CycleGoggles triggered", animPerform, state, visionState)
  if not skipCheck then CheckIfWearingGoggles(true, true) end
  if not gogglesOn then return end
  print("Goggles on validated, checking gogglesEnabled", gogglesEnabled)
  if not gogglesEnabled then return end
  print("Checking perform animation", animPerform)
  if animPerform then GoggleAnim(); end
  print("Checking goggles are still on", gogglesOn)
  if not gogglesOn then return end -- Can like, cycle while removing and then it still works cuz animation timer so this stops that?
  previousState = visionState
  local conTab = IsMpPed()
  conTab = ((conTab=="Male") and Config.Clothing.Male) or Config.Clothing.Female
  print(gogglesOn)
  print(conTab.flashlightGoggles[gogglesOn])
  visionState = state or (conTab.flashlightGoggles[gogglesOn] and ((visionState + 1)%4)) or ((visionState + 1)%3)
  SetNightvision(visionState==1)
  SetSeethrough(visionState==2)
  currentFlashlight = (visionState==3 and conTab.flashlightGoggles[gogglesOn]) or false
  Entity(PlayerPedId()).state:set("helmetLight", currentFlashlight, true)
  print("Completed goggle cycle", visionState)
end

CheckIfWearingGoggles = function()
  print("Triggering Config.CheckIfWearingGoggles")
  adjustingGoggles = true
  gogglesOn = false
  gogglesEnabled = false
  local hatIndex = GetPedPropIndex(PlayerPedId(), 0)
  print("Checking PedPropIndex against goggles tables", hatIndex)
  local conTab = IsMpPed()
  print("Validating conversion table", conTab)
  if not conTab then return end
  print("Converting conversion table to Config.Clothing table", conTab)
  conTab = ((conTab=="Male") and Config.Clothing.Male) or Config.Clothing.Female
  print("Successful conversion to Config table", json.encode(conTab, {indent = true}))
  for k,v in ipairs(conTab.goggles) do if hatIndex==v then gogglesEnabled = true; gogglesOn = k; break; end if k%10==0 then Wait(0) end end
  if not gogglesOn then for k,v in ipairs(conTab.disabledGoggles) do if hatIndex==v then gogglesEnabled = false; gogglesOn = k; break; end if k%10==0 then Wait(0) end end end
  adjustingGoggles = false
  print("Completed CheckIfWearingGoggles", gogglesOn)
end

ClearState = function()
  print("Clearing vision state")
  previousState = visionState
  visionState = 0
  SetNightvision(false)
  SetSeethrough(false)
end

RotAnglesToVec = function(rot) -- input vector3
	local z = math.rad(rot.z)
	local x = math.rad(rot.x)
	local num = math.abs(math.cos(x))
	return vector3(-math.sin(z)*num, math.cos(z)*num, math.sin(x))
end

Citizen.CreateThread(function()
  while true do
    sleep = 250
    if visionState~=0 then
      local conTab = IsMpPed()
      if not conTab then ClearState() else
        local doClear = true
        conTab = ((conTab=="Male") and Config.Clothing.Male) or Config.Clothing.Female
        local hatIndex = GetPedPropIndex(PlayerPedId(), 0)
        if hatIndex==-1 then hatIndex = GetPedHelmetStoredHatPropIndex(PlayerPedId()); if Config.KeepOverlayEnabledEnteringVeh and hatIndex~=-1 then SetPedPropIndex(PlayerPedId(), 0, hatIndex, GetPedHelmetStoredHatTexIndex(PlayerPedId()), true) end end
        for k,v in ipairs(conTab.goggles) do if hatIndex==v then doClear = false; break; end if k%10==0 then Wait(0) end end
        if doClear then for k,v in ipairs(conTab.disabledGoggles) do if hatIndex==v then doClear = false; break; end if k%10==0 then Wait(0) end end end
        if doClear then ClearState() end
        if not doClear and currentFlashlight then
          sleep = 0
          local boneInd = GetPedBoneIndex(PlayerPedId(), 65068)
          local bonePos = GetWorldPositionOfEntityBone(PlayerPedId(), boneInd)
          local boneRot = RotAnglesToVec(GetEntityBoneRotation(PlayerPedId(), boneInd))
          local lightPos = GetOffsetFromCoordAndHeadingInWorldCoords(bonePos.x, bonePos.y, bonePos.z, GetEntityHeading(PlayerPedId()), currentFlashlight.offset.x, currentFlashlight.offset.y, currentFlashlight.offset.z)
          DrawSpotLight(lightPos.x, lightPos.y, lightPos.z, boneRot.x, boneRot.y, boneRot.z, currentFlashlight.color.r, currentFlashlight.color.g, currentFlashlight.color.b, currentFlashlight.distance, currentFlashlight.brightness, currentFlashlight.hardness, currentFlashlight.radius, currentFlashlight.falloff)
        end
      end
    end
    Wait(sleep)
  end
end)

Citizen.CreateThread(function()
  while true do
    Wait(0)
    local players = GetActivePlayers()
    for i = 1,#players do
      local ped = GetPlayerPed(players[i])
      if ped~=PlayerPedId() then
        print(Entity(ped).state.helmetLight)
        if Entity(ped).state.helmetLight then
          local boneInd = GetPedBoneIndex(ped, 65068)
          local bonePos = GetWorldPositionOfEntityBone(ped, boneInd)
          local boneRot = RotAnglesToVec(GetEntityBoneRotation(ped, boneInd))
          local lightPos = GetOffsetFromCoordAndHeadingInWorldCoords(bonePos.x, bonePos.y, bonePos.z, GetEntityHeading(ped), Entity(ped).state.helmetLight.offset.x, Entity(ped).state.helmetLight.offset.y, Entity(ped).state.helmetLight.offset.z)
          DrawSpotLight(lightPos.x, lightPos.y, lightPos.z, boneRot.x, boneRot.y, boneRot.z, Entity(ped).state.helmetLight.color.r, Entity(ped).state.helmetLight.color.g, Entity(ped).state.helmetLight.color.b, Entity(ped).state.helmetLight.distance, Entity(ped).state.helmetLight.brightness, Entity(ped).state.helmetLight.hardness, Entity(ped).state.helmetLight.radius, Entity(ped).state.helmetLight.falloff)
        end
      end
    end
  end
end)

-- Command registration
RegisterCommand("+ToggleGoggles", ToggleGoggles, false)
RegisterCommand("-ToggleGoggles", function() end, false) -- Probably not needed

RegisterCommand("+CycleGoggles", function() CycleGoggles(Config.Animations.Swap) end, false)
RegisterCommand("-CycleGoggles", function() end, false) -- Probably not needed

RegisterKeyMapping("+ToggleGoggles", "Lift/Lower Goggles", "KEYBOARD", Config.Interaction.Enable.KEYBOARD)
RegisterKeyMapping("~!+ToggleGoggles", "Lift/Lower Goggles - Alternate", "PAD_ANALOGBUTTON", Config.Interaction.Enable.PAD_ANALOGBUTTON)

RegisterKeyMapping("+CycleGoggles", "Cycle Goggle State", "KEYBOARD", Config.Interaction.Cycle.KEYBOARD)
RegisterKeyMapping("~!+CycleGoggles", "Cycle Goggle State - Alternate", "PAD_ANALOGBUTTON", Config.Interaction.Cycle.PAD_ANALOGBUTTON)

AddEventHandler("onResourceStop", function(resource) if resource==GetCurrentResourceName() then if visionState~=0 then SetNightvision(false); SetSeethrough(false); end end end)