PA = PA or {}

local ROW_HEIGHT = 26
local VISIBLE_ROWS = 11

local function GetDifficultyColor(recipe)
    local difficulty = recipe.difficulty
    if difficulty == "orange" then return 1, 0.35, 0.15 end
    if difficulty == "yellow" then return 1, 0.85, 0.2 end
    if difficulty == "green" then return 0.25, 1, 0.25 end
    if difficulty == "gray" or difficulty == "grey" then return 0.65, 0.65, 0.65 end
    return 1, 1, 1
end

local function CreateLabel(parent, text, font, point, relative, relativePoint, x, y, width)
    local label = parent:CreateFontString(nil, "OVERLAY", font or "GameFontHighlightSmall")
    label:SetPoint(point, relative, relativePoint, x, y)
    if width then label:SetWidth(width) end
    label:SetJustifyH("LEFT")
    label:SetText(text or "")
    return label
end

function PA:CreateProfessionFrame()
    if self.frame then return self.frame end

    local frame = CreateFrame("Frame", "ProfessionAssistantFrame", UIParent)
    frame:SetWidth(760)
    frame:SetHeight(500)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("DIALOG")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    frame:Hide()
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    frame:SetBackdropColor(0, 0, 0, 1)

    local title = CreateLabel(frame, "Profession Assistant  |cffaaaaaa3.3.5a|r", "GameFontNormalLarge", "TOP", frame, "TOP", 0, -20)
    title:SetJustifyH("CENTER")

    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -6, -6)

    local professionText = CreateLabel(frame, "Selecciona una profesión", "GameFontNormal", "TOPLEFT", frame, "TOPLEFT", 28, -55)
    local changeProfession = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    changeProfession:SetSize(150, 24)
    changeProfession:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -42, -49)
    changeProfession:SetText("Cambiar profesión")

    local left = CreateFrame("Frame", nil, frame)
    left:SetPoint("TOPLEFT", frame, "TOPLEFT", 24, -82)
    left:SetWidth(330)
    left:SetHeight(385)
    left:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    left:SetBackdropColor(0.04, 0.04, 0.04, 0.8)

    CreateLabel(left, "Recetas", "GameFontNormal", "TOPLEFT", left, "TOPLEFT", 12, -10)

    local search = CreateFrame("EditBox", nil, left, "InputBoxTemplate")
    search:SetSize(190, 20)
    search:SetPoint("TOPRIGHT", left, "TOPRIGHT", -14, -7)
    search:SetAutoFocus(false)
    search:SetText("")
    search:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)

    local searchHint = CreateLabel(left, "Buscar:", "GameFontDisableSmall", "RIGHT", search, "LEFT", -8, 0)

    local scroll = CreateFrame("ScrollFrame", "ProfessionAssistantRecipeScroll", left, "FauxScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", left, "TOPLEFT", 8, -38)
    scroll:SetPoint("BOTTOMRIGHT", left, "BOTTOMRIGHT", -28, 10)

    local rows = {}
    for i = 1, VISIBLE_ROWS do
        local row = CreateFrame("Button", nil, left)
        row:SetHeight(ROW_HEIGHT)
        row:SetPoint("TOPLEFT", scroll, "TOPLEFT", 0, -((i - 1) * ROW_HEIGHT))
        row:SetPoint("TOPRIGHT", scroll, "TOPRIGHT", 0, -((i - 1) * ROW_HEIGHT))
        row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
        row.text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        row.text:SetPoint("LEFT", row, "LEFT", 7, 0)
        row.text:SetJustifyH("LEFT")
        row.text:SetWidth(270)
        row.recipeIndex = nil
        row:SetScript("OnClick", function(self)
            if self.recipeIndex then
                frame:ShowRecipeDetails(self.recipeIndex)
            end
        end)
        rows[i] = row
    end

    local right = CreateFrame("Frame", nil, frame)
    right:SetPoint("TOPLEFT", left, "TOPRIGHT", 14, 0)
    right:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -24, 115)
    right:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    right:SetBackdropColor(0.04, 0.04, 0.04, 0.8)

    CreateLabel(right, "Detalles de receta", "GameFontNormal", "TOPLEFT", right, "TOPLEFT", 14, -12)
    right.recipeName = CreateLabel(right, "Selecciona una receta", "GameFontNormalLarge", "TOPLEFT", right, "TOPLEFT", 14, -40, 340)
    right.skill = CreateLabel(right, "", "GameFontHighlightSmall", "TOPLEFT", right.recipeName, "BOTTOMLEFT", 0, -8, 340)
    right.description = CreateLabel(right, "Los materiales y requisitos aparecerán aquí.", "GameFontHighlightSmall", "TOPLEFT", right.skill, "BOTTOMLEFT", 0, -14, 340)
    right.materialsTitle = CreateLabel(right, "", "GameFontNormal", "TOPLEFT", right.description, "BOTTOMLEFT", 0, -18)
    right.materials = CreateLabel(right, "", "GameFontHighlightSmall", "TOPLEFT", right.materialsTitle, "BOTTOMLEFT", 0, -8, 340)

    local recommendation = CreateFrame("Frame", nil, frame)
    recommendation:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 24, 25)
    recommendation:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -24, 25)
    recommendation:SetHeight(72)
    recommendation:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    recommendation:SetBackdropColor(0.08, 0.06, 0.02, 0.85)
    CreateLabel(recommendation, "Recomendación", "GameFontNormal", "TOPLEFT", recommendation, "TOPLEFT", 12, -9)
    recommendation.text = CreateLabel(recommendation, "La recomendación aparecerá cuando carguemos recetas y habilidad.", "GameFontHighlightSmall", "TOPLEFT", recommendation, "TOPLEFT", 12, -30, 680)

    local selectionPanel = CreateFrame("Frame", nil, frame)
    selectionPanel:SetPoint("TOPLEFT", frame, "TOPLEFT", 24, -82)
    selectionPanel:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -24, 24)

    local primaryPanel = CreateFrame("Frame", nil, selectionPanel)
    primaryPanel:SetPoint("TOPLEFT", selectionPanel, "TOPLEFT", 0, 0)
    primaryPanel:SetPoint("BOTTOMLEFT", selectionPanel, "BOTTOMLEFT", 0, 0)
    primaryPanel:SetWidth(450)
    primaryPanel:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    primaryPanel:SetBackdropColor(0.04, 0.04, 0.04, 0.8)
    CreateLabel(primaryPanel, "Profesiones primarias", "GameFontNormal", "TOPLEFT", primaryPanel, "TOPLEFT", 16, -14)

    local secondaryPanel = CreateFrame("Frame", nil, selectionPanel)
    secondaryPanel:SetPoint("TOPLEFT", primaryPanel, "TOPRIGHT", 14, 0)
    secondaryPanel:SetPoint("BOTTOMRIGHT", selectionPanel, "BOTTOMRIGHT", 0, 0)
    secondaryPanel:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    secondaryPanel:SetBackdropColor(0.04, 0.04, 0.04, 0.8)
    CreateLabel(secondaryPanel, "Profesiones secundarias", "GameFontNormal", "TOPLEFT", secondaryPanel, "TOPLEFT", 14, -14)

    local professionButtons = {}
    local primaryEmpty = CreateLabel(primaryPanel, "No hay profesiones aprendidas.", "GameFontHighlightSmall", "TOPLEFT", primaryPanel, "TOPLEFT", 18, -48)
    local secondaryEmpty = CreateLabel(secondaryPanel, "No hay profesiones aprendidas.", "GameFontHighlightSmall", "TOPLEFT", secondaryPanel, "TOPLEFT", 14, -48)

    local function CreateProfessionButton(profession)
        local parent = profession.category == "PRIMARY" and primaryPanel or secondaryPanel
        local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
        button:SetSize(190, 32)
        button:SetText(profession.name)
        button:SetScript("OnClick", function()
            frame:SelectProfession(profession.id)
        end)
        button:Hide()
        professionButtons[profession.id] = button
    end

    for _, profession in ipairs(PA_ProfessionCatalog) do
        CreateProfessionButton(profession)
    end

    CreateLabel(selectionPanel, "Solo aparecen las profesiones que tu personaje ha aprendido.", "GameFontHighlightSmall", "BOTTOMLEFT", selectionPanel, "BOTTOMLEFT", 4, -8, 700)

    frame.professionID = nil
    frame.filteredRecipes = {}
    frame.allRecipes = {}
    frame.knownProfessions = {}

    function frame:RefreshProfessionSelection()
        self.knownProfessions = {}
        local skillLineCount = GetNumSkillLines and GetNumSkillLines() or 0
        for skillIndex = 1, skillLineCount do
            local skillName = GetSkillLineInfo(skillIndex)
            local normalizedName = string.lower(string.gsub(skillName or "", "%s+", ""))
            for _, profession in ipairs(PA_ProfessionCatalog) do
                for _, alias in ipairs(profession.skillNames or {}) do
                    local normalizedAlias = string.lower(string.gsub(alias, "%s+", ""))
                    if normalizedName == normalizedAlias then
                        self.knownProfessions[profession.id] = true
                    end
                end
            end
        end

        local primaryIndex, secondaryIndex = 0, 0
        for _, profession in ipairs(PA_ProfessionCatalog) do
            local button = professionButtons[profession.id]
            button:Hide()
            if self.knownProfessions[profession.id] then
                if profession.category == "PRIMARY" then
                    button:ClearAllPoints()
                    button:SetPoint("TOPLEFT", primaryPanel, "TOPLEFT", 18 + (primaryIndex % 2) * 205, -42 - math.floor(primaryIndex / 2) * 52)
                    primaryIndex = primaryIndex + 1
                else
                    button:ClearAllPoints()
                    button:SetPoint("TOPLEFT", secondaryPanel, "TOPLEFT", 18, -42 - secondaryIndex * 52)
                    secondaryIndex = secondaryIndex + 1
                end
                button:Show()
            end
        end

        if primaryIndex == 0 then primaryEmpty:Show() else primaryEmpty:Hide() end
        if secondaryIndex == 0 then secondaryEmpty:Show() else secondaryEmpty:Hide() end
    end

    function frame:ShowProfessionSelection()
        self:RefreshProfessionSelection()
        selectionPanel:Show()
        professionText:Hide()
        changeProfession:Hide()
        left:Hide()
        right:Hide()
        recommendation:Hide()
    end

    function frame:SelectProfession(id)
        local selected
        for _, profession in ipairs(PA_ProfessionCatalog) do
            if profession.id == id then
                selected = profession
                break
            end
        end
        if not selected or not self.knownProfessions[selected.id] then return end

        self.professionID = selected.id
        professionText:SetText("Profesión: " .. selected.name)
        selectionPanel:Hide()
        professionText:Show()
        changeProfession:Show()
        left:Show()
        right:Show()
        recommendation:Show()

        search:SetText("")
        self:RefreshRecipes()
    end

    changeProfession:SetScript("OnClick", function()
        frame:ShowProfessionSelection()
    end)


    function frame:ShowRecipeDetails(index)
        local recipe = self.filteredRecipes[index]
        if not recipe then return end
        right.recipeName:SetText(recipe.name or "Receta sin nombre")
        local skillText = ""
        if recipe.skill then skillText = "Habilidad: " .. tostring(recipe.skill) end
        if recipe.requiredSkill then
            if skillText ~= "" then skillText = skillText .. "  |  " end
            skillText = skillText .. "Requiere: " .. tostring(recipe.requiredSkill)
        end
        right.skill:SetText(skillText)
        right.description:SetText(recipe.description or "")
        right.materialsTitle:SetText("Materiales necesarios")
        local lines = {}
        if recipe.materials then
            for _, material in ipairs(recipe.materials) do
                local amount = material.count or material.quantity or 1
                table.insert(lines, tostring(amount) .. " x " .. tostring(material.name or "Material"))
            end
        end
        if table.getn(lines) == 0 then
            right.materials:SetText("No hay materiales registrados para esta receta.")
        else
            right.materials:SetText(table.concat(lines, "\n"))
        end
    end

    function frame:RefreshRecipes()
        local profession = PA:GetProfession(self.professionID)
        local recipes = profession and profession.recipes or {}
        local query = string.lower(search:GetText() or "")
        self.filteredRecipes = {}
        for _, recipe in ipairs(recipes) do
            local name = string.lower(recipe.name or "")
            if query == "" or string.find(name, query, 1, true) then
                table.insert(self.filteredRecipes, recipe)
            end
        end

        local total = table.getn(self.filteredRecipes)
        FauxScrollFrame_Update(scroll, total, VISIBLE_ROWS, ROW_HEIGHT)
        local offset = FauxScrollFrame_GetOffset(scroll)
        for i = 1, VISIBLE_ROWS do
            local recipeIndex = i + offset
            local row = rows[i]
            local recipe = self.filteredRecipes[recipeIndex]
            if recipe then
                row.recipeIndex = recipeIndex
                row.text:SetText(recipe.name or "Receta sin nombre")
                row.text:SetTextColor(GetDifficultyColor(recipe))
                row:Show()
            else
                row.recipeIndex = nil
                row:Hide()
            end
        end

        if total == 0 then
            right.recipeName:SetText("Aún no hay recetas")
            right.skill:SetText("")
            right.description:SetText("La profesión seleccionada todavía no tiene recetas registradas.")
            right.materialsTitle:SetText("")
            right.materials:SetText("Cuando incorporemos sus datos, podrás consultar aquí recetas, materiales y requisitos.")
        end
    end

    search:SetScript("OnTextChanged", function() frame:RefreshRecipes() end)
    scroll:SetScript("OnVerticalScroll", function(self, offset)
        FauxScrollFrame_OnVerticalScroll(self, offset, ROW_HEIGHT, function() frame:RefreshRecipes() end)
    end)

    frame:ShowProfessionSelection()
    self.frame = frame
    return frame
end
