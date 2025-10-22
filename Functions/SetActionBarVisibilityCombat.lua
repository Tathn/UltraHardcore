
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

function SetActionBarCombatVisibility(hideActionBars)
    if hideActionBars then
        local inCombat = UnitAffectingCombat("player") == true
        if inCombat or SpellBookFrame:IsShown() then
          ShowActionBarsCombat()
        else
          HideActionBarsCombat()
        end
      end
end

hooksecurefunc("ToggleSpellBook", function(bookType)
    SetActionBarCombatVisibility(GLOBAL_SETTINGS.hideActionBarsCombat)
end)
-- Self-contained event registration (only for events not handled by main addon)
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_REGEN_DISABLED") -- entering combat
f:RegisterEvent("PLAYER_REGEN_ENABLED")  -- leaving combat

f:SetScript("OnEvent", function(self, event, ...)
    SetActionBarCombatVisibility(GLOBAL_SETTINGS.hideActionBarsCombat)
end)
