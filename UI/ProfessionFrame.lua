PA = PA or {}

function PA:CreateProfessionFrame()
    if self.frame then return self.frame end

    local frame = CreateFrame("Frame", "ProfessionAssistantFrame", UIParent)
    frame:SetWidth(720)
    frame:SetHeight(480)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    frame:Hide()

    local backdrop = {
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    }
    frame:SetBackdrop(backdrop)
    frame:SetBackdropColor(0, 0, 0, 1)

    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", frame, "TOP", 0, -22)
    title:SetText("Asistente de profesiones")

    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -6, -6)

    local left = CreateFrame("Frame", nil, frame)
    left:SetPoint("TOPLEFT", frame, "TOPLEFT", 24, -58)
    left:SetWidth(300)
    left:SetHeight(380)
    left:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    left:SetBackdropColor(0.05, 0.05, 0.05, 0.75)

    local listTitle = left:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    listTitle:SetPoint("TOPLEFT", left, "TOPLEFT", 12, -12)
    listTitle:SetText("Recetas")

    local empty = left:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    empty:SetPoint("TOPLEFT", listTitle, "BOTTOMLEFT", 0, -18)
    empty:SetWidth(270)
    empty:SetJustifyH("LEFT")
    empty:SetText("Aquí aparecerán las recetas de la profesión seleccionada.")

    local right = CreateFrame("Frame", nil, frame)
    right:SetPoint("TOPLEFT", left, "TOPRIGHT", 16, 0)
    right:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -24, 24)
    right:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    right:SetBackdropColor(0.05, 0.05, 0.05, 0.75)

    local detailTitle = right:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    detailTitle:SetPoint("TOPLEFT", right, "TOPLEFT", 14, -12)
    detailTitle:SetText("Detalles de receta")

    local detail = right:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    detail:SetPoint("TOPLEFT", detailTitle, "BOTTOMLEFT", 0, -18)
    detail:SetWidth(330)
    detail:SetJustifyH("LEFT")
    detail:SetText("Selecciona una receta para consultar materiales, cantidades y requisitos.")

    self.frame = frame
    return frame
end
