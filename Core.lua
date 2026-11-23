PA = PA or {}

local ADDON_VERSION = PA.VERSION or "0.8.2"
local addon = CreateFrame("Frame")
local function Print(message)
    if DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage("|cffd8b35aProfession Assistant|r: " .. tostring(message))
    end
end

local function EnsureWindow()
    if PA.frame then return true end
    if not PA.CreateProfessionFrame then
        Print("No se encontró el módulo de interfaz. Revisa la instalación del addon.")
        return false
    end

    local ok, err = pcall(function() PA:CreateProfessionFrame() end)
    if not ok then
        Print("No se pudo crear la ventana: " .. tostring(err))
        return false
    end
    return PA.frame ~= nil
end

addon:RegisterEvent("PLAYER_LOGIN")
addon:RegisterEvent("SKILL_LINES_CHANGED")
addon:RegisterEvent("TRADE_SKILL_SHOW")
addon:RegisterEvent("TRADE_SKILL_UPDATE")
addon:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        if EnsureWindow() then
            Print("v" .. ADDON_VERSION .. " cargado. Escribe /pa para abrir la ventana.")
        else
            Print("Se cargó el código, pero la ventana no inició. Usa /pa debug y comparte el mensaje de error.")
        end
    elseif event == "SKILL_LINES_CHANGED" and PA.frame then
        PA.frame:RefreshProfessionSelection()
    elseif (event == "TRADE_SKILL_SHOW" or event == "TRADE_SKILL_UPDATE") and PA.ScanTradeSkill then
        PA:ScanTradeSkill()
    end
end)

local function ShowDebug()
    local version, build, _, interface = GetBuildInfo()
    local learnedCount = 0
    if PA.frame and PA.frame.knownProfessions then
        for _ in pairs(PA.frame.knownProfessions) do learnedCount = learnedCount + 1 end
    end
    Print("Estado: cargado | cliente " .. tostring(version) .. " (" .. tostring(build) .. "), interfaz " .. tostring(interface) .. ".")
    Print("Profesiones aprendidas detectadas: " .. tostring(learnedCount) .. ". Última línea leída: " .. tostring(PA.LastTradeSkillLine or "ninguna") .. ".")
    if PA.LastScanError then Print("Lectura de recetas: " .. PA.LastScanError) end
end

local function HandleCommand(message)
    local command = string.lower(string.gsub(message or "", "^%s*(.-)%s*$", "%1"))
    if command == "debug" or command == "diagnostico" then
        ShowDebug()
        return
    end

    if command == "scan" or command == "actualizar" then
        if PA.ScanTradeSkill then
            local ok, count = PA:ScanTradeSkill()
            if ok then Print("Lectura completada: " .. tostring(count) .. " recetas conocidas.") end
        end
        return
    end

    if command == "help" or command == "ayuda" then
        Print("Comandos: /pa (abrir/cerrar), /pa debug (estado), /pa scan (leer el libro abierto).")
        return
    end

    if not EnsureWindow() then return end
    if PA.frame:IsShown() then
        PA.frame:Hide()
    else
        PA.frame:RefreshProfessionSelection()
        PA.frame:Show()
    end
end

SLASH_PROFESSIONASSISTANT1 = "/pa"
SLASH_PROFESSIONASSISTANT2 = "/professionassistant"
SlashCmdList["PROFESSIONASSISTANT"] = HandleCommand
