
--[[
  Action Bar Visibility Controller
  - Hides action bars when not resting (or below level threshold)
  - Shows them when resting or under Cozy Fire (spell ID 7353)
]]

-- all frames to hide
ACTION_BAR_FRAMES_TO_HIDE = {
  MainMenuBar,
  MultiBarBottomLeft,
  MultiBarBottomRight,
  MultiBarLeft,
  MultiBarRight,
}

local function HideActionBarsCombat()
  for _, frame in ipairs(ACTION_BAR_FRAMES_TO_HIDE) do
    ForceHideFrame(frame)
  end
end

local function ShowActionBarsCombat()
  for _, frame in ipairs(ACTION_BAR_FRAMES_TO_HIDE) do
    RestoreAndShowFrame(frame)
  end
end

local initialized = false

function SetActionBarCombatVisibility(hideActionBars)
    if hideActionBars then
        local inCombat = UnitAffectingCombat("player") == true
        if inCombat or
           SpellBookFrame:IsShown() or
           CharacterFrame:IsShown() then
          ShowActionBarsCombat()
        else
          HideActionBarsCombat()
        end
    end
end

SpellBookFrame:HookScript("OnShow", function()
    SetActionBarCombatVisibility(GLOBAL_SETTINGS.hideActionBarsCombat)
end)

SpellBookFrame:HookScript("OnHide", function()
    SetActionBarCombatVisibility(GLOBAL_SETTINGS.hideActionBarsCombat)
end)

CharacterFrame:HookScript("OnShow", function()
    SetActionBarCombatVisibility(GLOBAL_SETTINGS.hideActionBarsCombat)
end)

CharacterFrame:HookScript("OnHide", function()
    SetActionBarCombatVisibility(GLOBAL_SETTINGS.hideActionBarsCombat)
end)

--inne customowe
hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
    tooltip:SetOwner(parent, "ANCHOR_NONE")
    tooltip:ClearAllPoints()
    tooltip:SetPoint("CENTER", UIParent, "LEFT", 515, 300)
end)

local clockFrame = CreateFrame("Frame", "MyClockFrame", UIParent)
clockFrame:SetSize(100, 20)
clockFrame:SetPoint("TOP", UIParent, "TOP", 0, -100)
clockFrame.text = clockFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
clockFrame.text:SetAllPoints()
clockFrame.text:SetTextColor(1, 1, 1)

clockFrame:SetMovable(true)
clockFrame:EnableMouse(true)
clockFrame:RegisterForDrag("LeftButton")
clockFrame:SetScript("OnDragStart", clockFrame.StartMoving)
clockFrame:SetScript("OnDragStop", clockFrame.StopMovingOrSizing)

local elapsed = 10
clockFrame:SetScript("OnUpdate", function(self, delta)
    elapsed = elapsed + delta
    if elapsed >= 10 then
        local timeString = date("%H:%M")  -- real-world time, 24-hour format
        clockFrame.text:SetText(timeString)
        elapsed = 0
    end
end)

-- Self-contained event registration (only for events not handled by main addon)
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_REGEN_DISABLED") -- entering combat
f:RegisterEvent("PLAYER_REGEN_ENABLED")  -- leaving combat

f:SetScript("OnEvent", function(self, event, ...)
    SetActionBarCombatVisibility(GLOBAL_SETTINGS.hideActionBarsCombat)
end)
