PA = PA or {}

local WINDOW_WIDTH, WINDOW_HEIGHT = 1140, 720
local WINDOW_SCALE = 0.78
local ROW_HEIGHT, VISIBLE_ROWS = 48, 6
local MATERIAL_ROW_HEIGHT, VISIBLE_MATERIAL_ROWS = 62, 1

local PROFESSION_ICONS = {
    ALCHEMY = "Interface\\Icons\\Trade_Alchemy",
    BLACKSMITHING = "Interface\\Icons\\Trade_BlackSmithing",
    ENCHANTING = "Interface\\Icons\\Trade_Engraving",
    ENGINEERING = "Interface\\Icons\\Trade_Engineering",
    HERBALISM = "Interface\\Icons\\Trade_Herbalism",
    INSCRIPTION = "Interface\\Icons\\INV_Inscription_Tradeskill01",
    JEWELCRAFTING = "Interface\\Icons\\INV_Misc_Gem_01",
    LEATHERWORKING = "Interface\\Icons\\INV_Misc_ArmorKit_17",
    MINING = "Interface\\Icons\\Trade_Mining",
    SKINNING = "Interface\\Icons\\INV_Misc_Pelt_Wolf_01",
    TAILORING = "Interface\\Icons\\Trade_Tailoring",
    COOKING = "Interface\\Icons\\INV_Misc_Food_15",
    FIRST_AID = "Interface\\Icons\\Spell_Holy_SealOfSacrifice",
    FISHING = "Interface\\Icons\\Trade_Fishing"
}

local GOLD = { 1, 0.78, 0.12 }
local PALE = { 0.92, 0.88, 0.78 }
local MUTED = { 0.63, 0.59, 0.50 }
local GREEN = { 0.18, 0.95, 0.20 }
local RED = { 1, 0.23, 0.12 }

local function CreateLabel(parent, text, font, point, relative, relativePoint, x, y, width)
    local label = parent:CreateFontString(nil, "OVERLAY", font or "GameFontHighlight")
    label:SetPoint(point, relative, relativePoint, x, y)
    if width then label:SetWidth(width) end
    label:SetJustifyH("LEFT")
    local fontPath, fontSize, fontFlags = label:GetFont()
    if fontPath and fontSize then label:SetFont(fontPath, fontSize, fontFlags) end
    label:SetText(text or "")
    return label
end

local function CreatePanel(parent, width, height)
    local panel = CreateFrame("Frame", nil, parent)
    if width then panel:SetWidth(width) end
    if height then panel:SetHeight(height) end
    panel:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 32, edgeSize = 24,
        insets = { left = 5, right = 5, top = 5, bottom = 5 }
    })
    panel:SetBackdropColor(0.13, 0.095, 0.060, 0.98)
    panel:SetBackdropBorderColor(0.72, 0.52, 0.23, 0.92)
    local panelFill = panel:CreateTexture(nil, "BACKGROUND")
    panelFill:SetPoint("TOPLEFT", panel, "TOPLEFT", 7, -7)
    panelFill:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -7, 7)
    panelFill:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
    panelFill:SetVertexColor(0.10, 0.075, 0.045, 0.88)
    panel.interiorFill = panelFill
    return panel
end

local function GetDifficultyColor(recipe)
    local difficulty = recipe and recipe.difficulty
    if difficulty == "orange" then return 1, 0.34, 0.12 end
    if difficulty == "yellow" then return 1, 0.82, 0.16 end
    if difficulty == "green" then return 0.24, 0.95, 0.18 end
    if difficulty == "gray" or difficulty == "grey" then return 0.62, 0.62, 0.62 end
    return 0.92, 0.88, 0.78
end

local function GetDifficultyName(recipe)
    local difficulty = recipe and recipe.difficulty
    if difficulty == "orange" then return "Naranja" end
    if difficulty == "yellow" then return "Amarilla" end
    if difficulty == "green" then return "Verde" end
    if difficulty == "gray" or difficulty == "grey" then return "Gris" end
    return "No indicada"
end

local function GetProfessionByID(id)
    for _, profession in ipairs(PA_ProfessionCatalog or {}) do
        if profession.id == id then return profession end
    end
end

function PA:CreateProfessionFrame()
    if self.frame then return self.frame end

    local frame = CreateFrame("Frame", "ProfessionAssistantFrame", UIParent)
    frame:SetWidth(WINDOW_WIDTH)
    frame:SetHeight(WINDOW_HEIGHT)
    frame:SetScale(WINDOW_SCALE)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    frame:SetFrameStrata("DIALOG")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 14, right = 14, top = 14, bottom = 14 }
    })
    frame:SetBackdropColor(0.14, 0.105, 0.065, 0.99)
    frame:SetBackdropBorderColor(0.88, 0.68, 0.31, 1)
    local bodyFill = frame:CreateTexture(nil, "BACKGROUND")
    bodyFill:SetPoint("TOPLEFT", frame, "TOPLEFT", 30, -30)
    bodyFill:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 30)
    bodyFill:SetTexture("Interface\\Buttons\\WHITE8X8")
    bodyFill:SetVertexColor(0.025, 0.019, 0.013, 1)
    frame.bodyFill = bodyFill
    frame:Hide()

    local headerBand = CreatePanel(frame)
    headerBand:SetPoint("TOPLEFT", frame, "TOPLEFT", 128, -14)
    headerBand:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -46, -14)
    headerBand:SetHeight(54)
    headerBand:SetBackdropColor(0.075, 0.055, 0.035, 0.98)
    local headerRule = headerBand:CreateTexture(nil, "ARTWORK")
    headerRule:SetTexture("Interface\\ClassTrainerFrame\\UI-ClassTrainer-HorizontalBar")
    headerRule:SetTexCoord(0, 1, 0, 0.25)
    headerRule:SetPoint("BOTTOMLEFT", headerBand, "BOTTOMLEFT", 22, 3)
    headerRule:SetPoint("BOTTOMRIGHT", headerBand, "BOTTOMRIGHT", -22, 3)
    headerRule:SetHeight(12)
    local title = CreateLabel(headerBand,
        "Profession Assistant  |cffffcc00" .. tostring(PA.VERSION or "0.8.2") .. "|r",
        "GameFontNormalLarge", "CENTER", headerBand, "CENTER", 0, 0)
    title:SetJustifyH("CENTER")

    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -12, -12)
    close:SetScript("OnClick", function() frame:Hide() end)

    local brandFrame = CreatePanel(frame, 108, 108)
    brandFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 18, -26)
    brandFrame:SetBackdropBorderColor(0.98, 0.70, 0.22, 1)
    local brandIcon = brandFrame:CreateTexture(nil, "ARTWORK")
    brandIcon:SetSize(80, 80)
    brandIcon:SetPoint("CENTER", brandFrame, "CENTER")
    brandIcon:SetTexture("Interface\\Icons\\INV_Misc_Book_09")
    brandIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    local professionText = CreateLabel(frame, "Profesiones", "GameFontNormalLarge",
        "TOPLEFT", frame, "TOPLEFT", 148, -89, 230)
    professionText:SetTextColor(GOLD[1], GOLD[2], GOLD[3])

    local skillLevelText = CreateLabel(frame, "Nivel actual: - / -", "GameFontNormal",
        "TOPLEFT", frame, "TOPLEFT", 392, -79, 300)
    local skillBar = CreateFrame("StatusBar", nil, frame)
    skillBar:SetSize(390, 18)
    skillBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 392, -111)
    skillBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    skillBar:SetStatusBarColor(0.08, 0.82, 0.10)
    skillBar:SetMinMaxValues(0, 1)
    skillBar:SetValue(0)
    local skillBarBackground = skillBar:CreateTexture(nil, "BACKGROUND")
    skillBarBackground:SetAllPoints(skillBar)
    skillBarBackground:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
    skillBarBackground:SetVertexColor(0.035, 0.035, 0.035, 1)
    local skillBarBorder = skillBar:CreateTexture(nil, "OVERLAY")
    skillBarBorder:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-Skills-BarBorder")
    skillBarBorder:SetSize(398, 25)
    skillBarBorder:SetPoint("CENTER", skillBar, "CENTER")

    local nextStepText = CreateLabel(frame, "Selecciona una profesión",
        "GameFontNormal", "TOPRIGHT", frame, "TOPRIGHT", -44, -83, 360)
    nextStepText:SetJustifyH("RIGHT")
    nextStepText:SetTextColor(GOLD[1], GOLD[2], GOLD[3])

    local professionPanel = CreatePanel(frame, 324, 404)
    professionPanel:SetPoint("TOPLEFT", frame, "TOPLEFT", 26, -148)
    local recipesPanel = CreatePanel(frame, 324, 404)
    recipesPanel:SetPoint("TOPLEFT", professionPanel, "TOPRIGHT", 12, 0)
    local detailsPanel = CreatePanel(frame, 428, 404)
    detailsPanel:SetPoint("TOPLEFT", recipesPanel, "TOPRIGHT", 12, 0)

    local professionHeader = CreateLabel(professionPanel, "Profesiones", "GameFontNormalLarge",
        "TOPLEFT", professionPanel, "TOPLEFT", 16, -14)
    professionHeader:SetTextColor(GOLD[1], GOLD[2], GOLD[3])

    local primaryHeader = CreateLabel(professionPanel, "PROFESIONES PRIMARIAS", "GameFontNormal",
        "TOPLEFT", professionPanel, "TOPLEFT", 16, -50)
    primaryHeader:SetTextColor(GOLD[1], GOLD[2], GOLD[3])
    local primaryRule = professionPanel:CreateTexture(nil, "ARTWORK")
    primaryRule:SetTexture("Interface\\Buttons\\WHITE8X8")
    primaryRule:SetVertexColor(0.50, 0.34, 0.12, 0.9)
    primaryRule:SetPoint("TOPLEFT", professionPanel, "TOPLEFT", 16, -72)
    primaryRule:SetSize(286, 1)

    local secondaryHeader = CreateLabel(professionPanel, "PROFESIONES SECUNDARIAS", "GameFontNormal",
        "TOPLEFT", professionPanel, "TOPLEFT", 16, -190)
    secondaryHeader:SetTextColor(GOLD[1], GOLD[2], GOLD[3])
    local secondaryRule = professionPanel:CreateTexture(nil, "ARTWORK")
    secondaryRule:SetTexture("Interface\\Buttons\\WHITE8X8")
    secondaryRule:SetVertexColor(0.50, 0.34, 0.12, 0.9)
    secondaryRule:SetPoint("TOPLEFT", professionPanel, "TOPLEFT", 16, -212)
    secondaryRule:SetSize(286, 1)

    local primaryEmpty = CreateLabel(professionPanel, "No hay profesiones aprendidas.",
        "GameFontHighlight", "TOPLEFT", professionPanel, "TOPLEFT", 22, -91, 280)
    primaryEmpty:SetTextColor(MUTED[1], MUTED[2], MUTED[3])
    local secondaryEmpty = CreateLabel(professionPanel, "No hay profesiones aprendidas.",
        "GameFontHighlight", "TOPLEFT", professionPanel, "TOPLEFT", 22, -231, 280)
    secondaryEmpty:SetTextColor(MUTED[1], MUTED[2], MUTED[3])

    local professionButtons = {}
    local function CreateProfessionButton(profession)
        local button = CreateFrame("Button", nil, professionPanel)
        button:SetSize(288, 48)
        button:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8X8",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 10,
            insets = { left = 3, right = 3, top = 3, bottom = 3 }
        })
        button:SetBackdropColor(0.035, 0.030, 0.025, 0.98)
        button:SetBackdropBorderColor(0.43, 0.35, 0.21, 1)
        button.icon = button:CreateTexture(nil, "ARTWORK")
        button.icon:SetSize(38, 38)
        button.icon:SetPoint("LEFT", button, "LEFT", 7, 0)
        button.icon:SetTexture(PROFESSION_ICONS[profession.id] or "Interface\\Icons\\INV_Misc_QuestionMark")
        button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        button.name = CreateLabel(button, profession.name, "GameFontNormal",
            "LEFT", button.icon, "RIGHT", 8, 0, 168)
        button.rank = CreateLabel(button, "", "GameFontHighlight",
            "RIGHT", button, "RIGHT", -10, 0, 70)
        button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
        button:SetScript("OnClick", function() frame:SelectProfession(profession.id) end)
        button:Hide()
        professionButtons[profession.id] = button
    end
    for _, profession in ipairs(PA_ProfessionCatalog or {}) do CreateProfessionButton(profession) end

    local recipesHeader = CreateLabel(recipesPanel, "Recetas", "GameFontNormalLarge",
        "TOPLEFT", recipesPanel, "TOPLEFT", 16, -14)
    recipesHeader:SetTextColor(GOLD[1], GOLD[2], GOLD[3])
    local recipeCountText = CreateLabel(recipesPanel, "", "GameFontHighlightSmall",
        "TOPRIGHT", recipesPanel, "TOPRIGHT", -14, -19, 120)
    recipeCountText:SetJustifyH("RIGHT")
    recipeCountText:SetTextColor(MUTED[1], MUTED[2], MUTED[3])

    local search = CreateFrame("EditBox", nil, recipesPanel, "InputBoxTemplate")
    search:SetSize(276, 24)
    search:SetPoint("TOPLEFT", recipesPanel, "TOPLEFT", 18, -47)
    search:SetAutoFocus(false)
    search:SetText("")
    search:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    search:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)

    local scroll = CreateFrame("ScrollFrame", "ProfessionAssistantRecipeScroll", recipesPanel, "FauxScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", recipesPanel, "TOPLEFT", 14, -80)
    scroll:SetPoint("BOTTOMRIGHT", recipesPanel, "BOTTOMRIGHT", -30, 14)

    local rows = {}
    for i = 1, VISIBLE_ROWS do
        local row = CreateFrame("Button", nil, recipesPanel)
        row:SetHeight(ROW_HEIGHT)
        row:SetPoint("TOPLEFT", scroll, "TOPLEFT", 0, -((i - 1) * ROW_HEIGHT))
        row:SetPoint("TOPRIGHT", scroll, "TOPRIGHT", 0, -((i - 1) * ROW_HEIGHT))
        row.background = row:CreateTexture(nil, "BACKGROUND")
        row.background:SetAllPoints(row)
        row.background:SetTexture("Interface\\Buttons\\WHITE8X8")
        row.background:SetVertexColor(0.025, 0.022, 0.018, 0.72)
        row.selectedBackground = row:CreateTexture(nil, "BORDER")
        row.selectedBackground:SetAllPoints(row)
    row.selectedBackground:SetTexture("Interface\\Buttons\\UI-Listbox-Highlight2")
    row.selectedBackground:SetVertexColor(1, 0.82, 0.22, 0.78)
        row.selectedBackground:Hide()
        row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
        row.marker = row:CreateTexture(nil, "ARTWORK")
        row.marker:SetSize(18, 18)
        row.marker:SetPoint("LEFT", row, "LEFT", 5, 0)
        row.marker:SetTexture("Interface\\Buttons\\WHITE8X8")
        row.text = CreateLabel(row, "", "GameFontHighlight", "LEFT", row.marker, "RIGHT", 7, 0, 250)
        row.recipeIndex = nil
        row:SetScript("OnClick", function(self)
            if self.recipeIndex then
                frame:ShowRecipeDetails(self.recipeIndex)
                frame:RefreshRecipes()
            end
        end)
        rows[i] = row
    end

    local detailsHeader = CreateLabel(detailsPanel, "Detalles de receta", "GameFontNormalLarge",
        "TOPLEFT", detailsPanel, "TOPLEFT", 16, -14)
    detailsHeader:SetTextColor(GOLD[1], GOLD[2], GOLD[3])

    local resultIconFrame = CreatePanel(detailsPanel, 92, 92)
    resultIconFrame:SetPoint("TOPLEFT", detailsPanel, "TOPLEFT", 16, -48)
    resultIconFrame:SetBackdropBorderColor(0.98, 0.72, 0.24, 1)
    local resultIcon = resultIconFrame:CreateTexture(nil, "ARTWORK")
    resultIcon:SetSize(72, 72)
    resultIcon:SetPoint("CENTER", resultIconFrame, "CENTER")
    resultIcon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
    resultIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    local recipeName = CreateLabel(detailsPanel, "Selecciona una receta", "GameFontNormalLarge",
        "TOPLEFT", resultIconFrame, "TOPRIGHT", 12, -7, 292)
    recipeName:SetTextColor(GOLD[1], GOLD[2], GOLD[3])
    local recipeResult = CreateLabel(detailsPanel, "", "GameFontHighlight",
        "TOPLEFT", recipeName, "BOTTOMLEFT", 0, -7, 292)
    local recipeSkill = CreateLabel(detailsPanel, "", "GameFontHighlightSmall",
        "TOPLEFT", recipeResult, "BOTTOMLEFT", 0, -7, 292)
    recipeSkill:SetTextColor(MUTED[1], MUTED[2], MUTED[3])
    local materialsTitle = CreateLabel(detailsPanel, "MATERIALES", "GameFontNormal",
        "TOPLEFT", resultIconFrame, "BOTTOMLEFT", 0, -10)
    materialsTitle:SetTextColor(GOLD[1], GOLD[2], GOLD[3])

    local materialsScroll = CreateFrame("ScrollFrame", "ProfessionAssistantMaterialsScroll", detailsPanel, "FauxScrollFrameTemplate")
    materialsScroll:SetPoint("TOPLEFT", materialsTitle, "BOTTOMLEFT", 0, -8)
    materialsScroll:SetPoint("BOTTOMRIGHT", detailsPanel, "BOTTOMRIGHT", -30, 122)

    local materialCards = {}
    local function CreateMaterialCard(parent, index)
        local card = CreatePanel(parent, 180, 56)
        card.icon = card:CreateTexture(nil, "ARTWORK")
        card.icon:SetSize(38, 38)
        card.icon:SetPoint("LEFT", card, "LEFT", 5, 0)
        card.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        card.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        card.name = CreateLabel(card, "", "GameFontHighlightSmall",
            "TOPLEFT", card.icon, "TOPRIGHT", 5, -2, 126)
        card.count = CreateLabel(card, "", "GameFontNormal",
            "BOTTOMLEFT", card.icon, "BOTTOMRIGHT", 5, 1, 126)
        materialCards[index] = card
        return card
    end
    for i = 1, VISIBLE_MATERIAL_ROWS * 2 do
        local card = CreateMaterialCard(detailsPanel, i)
        local col = (i - 1) % 2
        local row = math.floor((i - 1) / 2)
        card:SetPoint("TOPLEFT", materialsScroll, "TOPLEFT", col * 184, -row * MATERIAL_ROW_HEIGHT)
    end

    local infoPanel = CreatePanel(detailsPanel)
    infoPanel:SetPoint("BOTTOMLEFT", detailsPanel, "BOTTOMLEFT", 14, 12)
    infoPanel:SetPoint("BOTTOMRIGHT", detailsPanel, "BOTTOMRIGHT", -14, 12)
    infoPanel:SetHeight(102)
    local infoText = CreateLabel(infoPanel, "Fabricables: —", "GameFontHighlightSmall",
        "TOPLEFT", infoPanel, "TOPLEFT", 10, -10, 356)

    local quantityLabel = CreateLabel(infoPanel, "Cant.", "GameFontHighlightSmall",
        "BOTTOMLEFT", infoPanel, "BOTTOMLEFT", 10, 14, 34)
    local quantityDown = CreateFrame("Button", nil, infoPanel)
    quantityDown:SetSize(22, 22)
    quantityDown:SetPoint("LEFT", quantityLabel, "RIGHT", 3, 0)
    quantityDown:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
    quantityDown:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down")
    quantityDown:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Disabled")
    quantityDown:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
    local quantityInput = CreateFrame("EditBox", nil, infoPanel, "InputBoxTemplate")
    quantityInput:SetSize(38, 24)
    quantityInput:SetPoint("LEFT", quantityDown, "RIGHT", 4, 0)
    quantityInput:SetAutoFocus(false)
    quantityInput:SetNumeric(true)
    quantityInput:SetJustifyH("CENTER")
    quantityInput:SetText("1")
    quantityInput:SetCursorPosition(0)
    quantityInput:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    quantityInput:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
    local quantityUp = CreateFrame("Button", nil, infoPanel)
    quantityUp:SetSize(22, 22)
    quantityUp:SetPoint("LEFT", quantityInput, "RIGHT", 4, 0)
    quantityUp:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
    quantityUp:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down")
    quantityUp:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Disabled")
    quantityUp:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")

    local craftButton = CreateFrame("Button", nil, infoPanel, "UIPanelButtonTemplate")
    craftButton:SetSize(104, 28)
    craftButton:SetPoint("BOTTOMRIGHT", infoPanel, "BOTTOMRIGHT", -8, 10)
    craftButton:SetText("Fabricar")

    local filtersPanel = CreatePanel(frame, 1092, 58)
    filtersPanel:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 24, 78)
    local filtersTitle = CreateLabel(filtersPanel, "FILTROS", "GameFontNormalLarge",
        "LEFT", filtersPanel, "LEFT", 14, 0)
    filtersTitle:SetTextColor(GOLD[1], GOLD[2], GOLD[3])

    local craftableOnly = false
    local craftableButton = CreateFrame("Button", nil, filtersPanel)
    craftableButton:SetSize(210, 34)
    craftableButton:SetPoint("LEFT", filtersTitle, "RIGHT", 18, 0)
    craftableButton.box = CreatePanel(craftableButton, 24, 24)
    craftableButton.box:SetPoint("LEFT", craftableButton, "LEFT", 0, 0)
    craftableButton.check = craftableButton.box:CreateTexture(nil, "ARTWORK")
    craftableButton.check:SetAllPoints(craftableButton.box)
    craftableButton.check:SetTexture("Interface\\Buttons\\WHITE8X8")
    craftableButton.check:SetVertexColor(0.15, 0.85, 0.12, 1)
    craftableButton.check:Hide()
    craftableButton.label = CreateLabel(craftableButton, "Solo fabricables", "GameFontHighlight",
        "LEFT", craftableButton.box, "RIGHT", 8, 0, 160)
    craftableButton:SetScript("OnClick", function()
        craftableOnly = not craftableOnly
        if craftableOnly then craftableButton.check:Show() else craftableButton.check:Hide() end
        frame:RefreshRecipes()
    end)

    local statusPanel = CreatePanel(frame)
    statusPanel:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 24, 18)
    statusPanel:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -166, 18)
    statusPanel:SetHeight(48)
    local statusIcon = statusPanel:CreateTexture(nil, "ARTWORK")
    statusIcon:SetSize(28, 28)
    statusIcon:SetPoint("LEFT", statusPanel, "LEFT", 12, 0)
    statusIcon:SetTexture("Interface\\Icons\\INV_Misc_Note_01")
    local statusText = CreateLabel(statusPanel, "Listo",
        "GameFontNormal", "LEFT", statusIcon, "RIGHT", 10, 0, 850)
    statusText:SetTextColor(PALE[1], PALE[2], PALE[3])

    local closeButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    closeButton:SetSize(138, 38)
    closeButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -28, 22)
    closeButton:SetText("Cerrar")
    closeButton:SetScript("OnClick", function() frame:Hide() end)

    frame.professionID = nil
    frame.filteredRecipes = {}
    frame.knownProfessions = {}
    frame.selectedRecipeKey = nil
    frame.selectedRecipe = nil
    frame.lastSearch = ""
    frame.materialCards = materialCards
    frame.craftButton = craftButton

    local function GetCraftQuantity()
        local quantity = tonumber(quantityInput:GetText()) or 1
        quantity = math.floor(quantity)
        if quantity < 1 then quantity = 1 end
        if quantity > 100 then quantity = 100 end
        return quantity
    end

    local function NormalizeQuantityInput()
        quantityInput:SetText(tostring(GetCraftQuantity()))
    end

    function frame:GetCraftContext()
        local recipe = self.selectedRecipe
        if not recipe or not self.professionID or not GetTradeSkillLine or not GetTradeSkillInfo
            or not GetNumTradeSkills or not DoTradeSkill then
            return nil
        end
        if TradeSkillFrame and TradeSkillFrame.IsShown and not TradeSkillFrame:IsShown() then
            return nil
        end
        if IsTradeSkillLinked and IsTradeSkillLinked() then return nil end
        if (PartialPlayTime and PartialPlayTime()) or (NoPlayTime and NoPlayTime()) then return nil end

        local skillLine = GetTradeSkillLine()
        local openProfession = PA:FindProfessionBySkillName(skillLine)
        if not openProfession or openProfession.id ~= self.professionID then return nil end

        local function MatchesRecipe(index)
            local name, skillType = GetTradeSkillInfo(index)
            if not name or skillType == "header" or skillType == "subheader" then return false end
            local link = GetTradeSkillItemLink and GetTradeSkillItemLink(index)
            if recipe.resultLink and link then return recipe.resultLink == link end
            return PA:NormalizeSkillName(name) == PA:NormalizeSkillName(recipe.name or "")
        end

        local index = tonumber(recipe.tradeSkillIndex)
        local entryCount = GetNumTradeSkills() or 0
        if index and index >= 1 and index <= entryCount and MatchesRecipe(index) then
            local _, _, available = GetTradeSkillInfo(index)
            return recipe, index, tonumber(available) or 0
        end
        for candidate = 1, entryCount do
            if MatchesRecipe(candidate) then
                local _, _, available = GetTradeSkillInfo(candidate)
                return recipe, candidate, tonumber(available) or 0
            end
        end
        return nil
    end

    function frame:RefreshCraftControls()
        local recipe, index, available = self:GetCraftContext()
        local selected = self.selectedRecipe ~= nil
        quantityDown:SetEnabled(selected)
        quantityUp:SetEnabled(selected)
        if selected then
            local maximum = available or tonumber(self.selectedRecipe.craftableCount) or 0
            infoText:SetText("Fabricables: " .. tostring(maximum))
            if maximum > 0 then
                infoText:SetTextColor(GREEN[1], GREEN[2], GREEN[3])
            else
                infoText:SetTextColor(RED[1], RED[2], RED[3])
            end
        else
            infoText:SetText("Fabricables: —")
            infoText:SetTextColor(MUTED[1], MUTED[2], MUTED[3])
        end

        local canCraft = recipe and index and available and GetCraftQuantity() <= available
        if canCraft then craftButton:Enable() else craftButton:Disable() end
    end

    local function ChangeCraftQuantity(delta)
        local value = GetCraftQuantity() + delta
        if value < 1 then value = 1 end
        if value > 100 then value = 100 end
        quantityInput:SetText(tostring(value))
        if frame.selectedRecipe then
            local index
            for i, recipe in ipairs(frame.filteredRecipes) do
                if (recipe.key or recipe.name) == frame.selectedRecipeKey then index = i break end
            end
            if index then frame:ShowRecipeDetails(index) end
        end
        frame:RefreshCraftControls()
    end

    quantityDown:SetScript("OnClick", function() ChangeCraftQuantity(-1) end)
    quantityUp:SetScript("OnClick", function() ChangeCraftQuantity(1) end)
    quantityInput:SetScript("OnTextChanged", function()
        if frame.selectedRecipe then
            local index
            for i, recipe in ipairs(frame.filteredRecipes) do
                if (recipe.key or recipe.name) == frame.selectedRecipeKey then index = i break end
            end
            if index then frame:ShowRecipeDetails(index) end
        end
        frame:RefreshCraftControls()
    end)
    quantityInput:SetScript("OnEditFocusLost", NormalizeQuantityInput)
    craftButton:SetScript("OnClick", function()
        local recipe, index, available = frame:GetCraftContext()
        local quantity = GetCraftQuantity()
        if not recipe or not index or quantity > (available or 0) then
            frame:RefreshCraftControls()
            return
        end
        quantityInput:ClearFocus()
        DoTradeSkill(index, quantity)
    end)

    function frame:SetRecipeStatus(message)
        statusText:SetText(message or "")
        local recipes = PA.TradeSkillRecipes and PA.TradeSkillRecipes[self.professionID]
        if recipes then
            nextStepText:SetText("Recetas: " .. tostring(table.getn(recipes)))
        elseif self.professionID then
            nextStepText:SetText("Sin recetas")
        else
            nextStepText:SetText("Selecciona una profesión aprendida")
        end
    end

    function frame:RefreshProfessionSelection()
        self.knownProfessions = {}
        local skillLineCount = GetNumSkillLines and GetNumSkillLines() or 0
        for skillIndex = 1, skillLineCount do
            local skillName, _, _, skillRank, _, _, skillMaxRank = GetSkillLineInfo(skillIndex)
            local profession = PA:FindProfessionBySkillName(skillName)
            if profession then
                self.knownProfessions[profession.id] = {
                    rank = tonumber(skillRank) or 0,
                    maxRank = tonumber(skillMaxRank) or 0
                }
            end
        end

        local primaryIndex, secondaryIndex = 0, 0
        for _, profession in ipairs(PA_ProfessionCatalog or {}) do
            local button = professionButtons[profession.id]
            button:Hide()
            local skill = self.knownProfessions[profession.id]
            if skill then
                button.rank:SetText("(" .. tostring(skill.rank) .. "/" .. tostring(skill.maxRank) .. ")")
                if profession.category == "PRIMARY" then
                    button:ClearAllPoints()
                    button:SetPoint("TOPLEFT", professionPanel, "TOPLEFT", 16, -80 - primaryIndex * 52)
                    primaryIndex = primaryIndex + 1
                else
                    button:ClearAllPoints()
                    button:SetPoint("TOPLEFT", professionPanel, "TOPLEFT", 16, -220 - secondaryIndex * 52)
                    secondaryIndex = secondaryIndex + 1
                end
                local active = profession.id == self.professionID
                button:SetBackdropColor(active and 0.30 or 0.035, active and 0.20 or 0.030, active and 0.055 or 0.025, 0.98)
                button:SetBackdropBorderColor(active and 1 or 0.43, active and 0.72 or 0.35, active and 0.16 or 0.21, 1)
                button.name:SetTextColor(active and GOLD[1] or PALE[1], active and GOLD[2] or PALE[2], active and GOLD[3] or PALE[3])
                button:Show()
            end
        end

        if primaryIndex == 0 then primaryEmpty:Show() else primaryEmpty:Hide() end
        if secondaryIndex == 0 then secondaryEmpty:Show() else secondaryEmpty:Hide() end

        if self.professionID and not self.knownProfessions[self.professionID] then
            self.professionID = nil
            self.selectedRecipeKey = nil
            self:RefreshRecipes()
        elseif self.professionID and self.knownProfessions[self.professionID] then
            local profession = GetProfessionByID(self.professionID)
            local skill = self.knownProfessions[self.professionID]
            professionText:SetText(profession and profession.name or "Profesiones")
            skillLevelText:SetText("Nivel actual: " .. tostring(skill.rank) .. " / " .. tostring(skill.maxRank))
            skillBar:SetMinMaxValues(0, skill.maxRank > 0 and skill.maxRank or 1)
            skillBar:SetValue(skill.rank)
        end
    end

    function frame:SelectProfession(id)
        local selected = GetProfessionByID(id)
        if not selected or not self.knownProfessions[id] then return end
        self.professionID = id
        self.selectedRecipeKey = nil
        local skill = self.knownProfessions[id]
        professionText:SetText(selected.name)
        brandIcon:SetTexture(PROFESSION_ICONS[id] or "Interface\\Icons\\INV_Misc_Book_09")
        skillLevelText:SetText("Nivel actual: " .. tostring(skill.rank) .. " / " .. tostring(skill.maxRank))
        skillBar:SetMinMaxValues(0, skill.maxRank > 0 and skill.maxRank or 1)
        skillBar:SetValue(skill.rank)
        search:SetText("")
        self.lastSearch = ""
        self:RefreshProfessionSelection()
        local recipes = PA.TradeSkillRecipes and PA.TradeSkillRecipes[id]
        self:SetRecipeStatus(recipes and table.getn(recipes) > 0
            and (tostring(table.getn(recipes)) .. " recetas")
            or "Sin recetas")
        self:RefreshRecipes()
    end

    function frame:ShowRecipeDetails(index)
        local recipe = self.filteredRecipes[index]
        if not recipe then return end
        local recipeKey = recipe.key or recipe.name
        if recipeKey ~= self.selectedRecipeKey then
            self.selectedRecipeKey = recipeKey
            quantityInput:SetText("1")
        end
        self.selectedRecipe = recipe
        recipeName:SetText(recipe.name or "Receta sin nombre")
        recipeResult:SetText("Resultado: " .. tostring(recipe.result or recipe.name or "No indicado"))
        local skillLine = "Dificultad: " .. GetDifficultyName(recipe)
        if recipe.requiredSkill then skillLine = skillLine .. "  |  Requiere: " .. tostring(recipe.requiredSkill) end
        recipeSkill:SetText(skillLine)
        resultIcon:SetTexture(recipe.resultTexture or "Interface\\Icons\\INV_Misc_QuestionMark")

        local materials = recipe.materials or {}
        local count = table.getn(materials)
        materialsTitle:SetText(count > 0 and "MATERIALES NECESARIOS" or "MATERIALES NO DISPONIBLES")
        FauxScrollFrame_Update(materialsScroll, math.ceil(count / 2), VISIBLE_MATERIAL_ROWS, MATERIAL_ROW_HEIGHT)
        local offset = FauxScrollFrame_GetOffset(materialsScroll)
        for i = 1, VISIBLE_MATERIAL_ROWS * 2 do
            local card = materialCards[i]
            local materialIndex = offset * 2 + i
            local material = materials[materialIndex]
            if material then
                card.icon:SetTexture(material.texture or "Interface\\Icons\\INV_Misc_QuestionMark")
                card.name:SetText(material.name or "Material")
                local perCraft = tonumber(material.count or material.quantity) or 1
                local needed = perCraft * GetCraftQuantity()
                local owned = tonumber(material.owned)
                if owned then
                    card.count:SetText(tostring(owned) .. " / " .. tostring(needed))
                    if owned >= needed then
                        card.count:SetTextColor(GREEN[1], GREEN[2], GREEN[3])
                    else
                        card.count:SetTextColor(RED[1], RED[2], RED[3])
                    end
                else
                    card.count:SetText(tostring(needed) .. " necesarios")
                    card.count:SetTextColor(PALE[1], PALE[2], PALE[3])
                end
                card:Show()
            else
                card:Hide()
            end
        end

        self:RefreshCraftControls()
    end

    function frame:RefreshRecipes()
        local profession = PA:GetProfession(self.professionID)
        local imported = PA.TradeSkillRecipes and PA.TradeSkillRecipes[self.professionID]
        local recipes = imported and table.getn(imported) > 0 and imported or ((profession and profession.recipes) or {})
        local query = PA:NormalizeSkillName(search:GetText() or "")
        self.filteredRecipes = {}

        for _, recipe in ipairs(recipes) do
            local normalized = PA:NormalizeSkillName(recipe.name or "")
            local matchesText = query == "" or string.find(normalized, query, 1, true)
            local matchesCraftable = not craftableOnly or (tonumber(recipe.craftableCount) or 0) > 0
            if matchesText and matchesCraftable then table.insert(self.filteredRecipes, recipe) end
        end

        local total = table.getn(self.filteredRecipes)
        recipeCountText:SetText(tostring(total) .. " conocidas")
        FauxScrollFrame_Update(scroll, total, VISIBLE_ROWS, ROW_HEIGHT)
        local offset = FauxScrollFrame_GetOffset(scroll)
        for i = 1, VISIBLE_ROWS do
            local recipeIndex = i + offset
            local row = rows[i]
            local recipe = self.filteredRecipes[recipeIndex]
            if recipe then
                local r, g, b = GetDifficultyColor(recipe)
                row.recipeIndex = recipeIndex
                row.marker:SetVertexColor(r, g, b, 1)
                row.text:SetText(recipe.name or "Receta sin nombre")
                if (recipe.key or recipe.name) == self.selectedRecipeKey then
                    row.selectedBackground:Show()
                    row.text:SetTextColor(GOLD[1], GOLD[2], GOLD[3])
                else
                    row.selectedBackground:Hide()
                    row.text:SetTextColor(r, g, b)
                end
                row:Show()
            else
                row.recipeIndex = nil
                row:Hide()
            end
        end

        local selectedIndex
        if self.selectedRecipeKey then
            for index, recipe in ipairs(self.filteredRecipes) do
                if (recipe.key or recipe.name) == self.selectedRecipeKey then selectedIndex = index break end
            end
        end

        if selectedIndex then
            self:ShowRecipeDetails(selectedIndex)
        else
            self.selectedRecipeKey = nil
            recipeName:SetText(total > 0 and "Selecciona una receta" or "Aún no hay recetas")
            recipeResult:SetText("")
            recipeSkill:SetText("")
            resultIcon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
            materialsTitle:SetText("MATERIALES NECESARIOS")
            for i = 1, table.getn(materialCards) do materialCards[i]:Hide() end
            infoText:SetText(total > 0 and "Selecciona una receta." or "Sin recetas.")
            self.selectedRecipe = nil
            quantityInput:SetText("1")
            self:RefreshCraftControls()
        end
    end

    search:SetScript("OnTextChanged", function()
        if search:GetText() ~= frame.lastSearch then
            frame.lastSearch = search:GetText()
            scroll.offset = 0
            if FauxScrollFrame_SetOffset then FauxScrollFrame_SetOffset(scroll, 0) end
            frame.selectedRecipeKey = nil
        end
        frame:RefreshRecipes()
    end)

    scroll:SetScript("OnVerticalScroll", function(self, offset)
        FauxScrollFrame_OnVerticalScroll(self, offset, ROW_HEIGHT, function() frame:RefreshRecipes() end)
    end)
    materialsScroll:SetScript("OnVerticalScroll", function(self, offset)
        FauxScrollFrame_OnVerticalScroll(self, offset, MATERIAL_ROW_HEIGHT, function()
            if frame.selectedRecipeKey then
                local index
                for i, recipe in ipairs(frame.filteredRecipes) do
                    if (recipe.key or recipe.name) == frame.selectedRecipeKey then index = i break end
                end
                if index then frame:ShowRecipeDetails(index) end
            end
        end)
    end)

    function frame:Refresh()
        self:RefreshProfessionSelection()
        self:RefreshRecipes()
    end

    self.frame = frame
    frame:RefreshProfessionSelection()
    frame:RefreshRecipes()
    return frame
end


