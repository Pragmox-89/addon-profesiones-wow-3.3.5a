PA = PA or {}

local addon = CreateFrame("Frame")
addon:RegisterEvent("ADDON_LOADED")
addon:SetScript("OnEvent", function(self, event, name)
    if event == "ADDON_LOADED" and name == "ProfessionAssistant" then
        PA:CreateProfessionFrame()
        DEFAULT_CHAT_FRAME:AddMessage("|cff66ccffProfession Assistant|r cargado. Escribe |cffffff00/pa|r para abrirlo.")
    end
end)

SLASH_PROFESSIONASSISTANT1 = "/pa"
SlashCmdList["PROFESSIONASSISTANT"] = function()
    if not PA.frame then PA:CreateProfessionFrame() end
    if PA.frame:IsShown() then
        PA.frame:Hide()
    else
        PA.frame:Show()
    end
end
