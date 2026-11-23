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

    local frame = CreateFrame("Frame", "ProfessionAssistantFrame", UIParent, "UIPanelDialogTemplate")
    frame:SetWidth(960)
    frame:SetHeight(620)
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
        tile = true, tileSize = 32,
        insets = { left = 18, right = 18, top = 18, bottom = 18 }
    })
    frame:SetBackdropColor(0.48, 0.43, 0.34, 0.98)

    local title = CreateLabel(frame, "Profession Assistant  |cffaaaaaa" .. tostring(PA.VERSION or "0.8.1") .. "|r", "GameFontNormalLarge", "TOP", frame, "TOP", 0, -20)
    title:SetJustifyH("CENTER")

    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -6, -6)

    local brandIcon = frame:CreateTexture(nil, "ARTWORK")
    brandIcon:SetSize(52, 52)
    brandIcon:SetPoint("TOPLEFT", frame, "TOPLEFT", 25, -30)
    brandIcon:SetTexture("Interface\\Icons\\INV_Misc_Book_09")

    local professionText = CreateLabel(frame, "Selecciona una profesión", "GameFontNormal", "TOPLEFT", frame, "TOPLEFT", 104, -61)
    local skillLevelText = CreateLabel(frame, "Nivel actual: - / -", "GameFontNormal", "TOPLEFT", frame, "TOPLEFT", 330, -61)
    local skillBar = CreateFrame("StatusBar", nil, frame)
    skillBar:SetSize(315, 14)
    skillBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 330, -82)
    skillBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    skillBar:SetStatusBarColor(0.1, 0.8, 0.12)
    skillBar:SetMinMaxValues(0, 1)
    skillBar:SetValue(0)
    local skillBarBackground = skillBar:CreateTexture(nil, "BACKGROUND")
    skillBarBackground:SetAllPoints(skillBar)
    skillBarBackground:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
    skillBarBackground:SetVertexColor(0.08, 0.08, 0.08, 0.9)

    local nextStepText = CreateLabel(frame, "Abre el libro de profesión para cargar recetas", "GameFontNormal", "TOPRIGHT", frame, "TOPRIGHT", -52, -61)

    local left = CreateFrame("Frame", nil, frame)
    left:SetPoint("TOPLEFT", frame, "TOPLEFT", 270, -122)
    left:SetWidth(290)
    left:SetHeight(390)
    left:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    left:SetBackdropColor(0.04, 0.04, 0.04, 0.8)

    CreateLabel(left, "Recetas", "GameFontNormal", "TOPLEFT", left, "TOPLEFT", 12, -10)

    local search = CreateFrame("EditBox", nil, left, "InputBoxTemplate")
    search:SetSize(150, 20)
    search:SetPoint("TOPRIGHT", left, "TOPRIGHT", -14, -7)
    search:SetAutoFocus(false)
    search:SetText("")
    search:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
    search:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)

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
                frame:RefreshRecipes()
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
    right.recipeResult = CreateLabel(right, "", "GameFontHighlightSmall", "TOPLEFT", right.recipeName, "BOTTOMLEFT", 0, -6, 340)
    right.skill = CreateLabel(right, "", "GameFontHighlightSmall", "TOPLEFT", right.recipeResult, "BOTTOMLEFT", 0, -6, 340)
    right.description = CreateLabel(right, "Los materiales y requisitos aparecerán aquí.", "GameFontHighlightSmall", "TOPLEFT", right.skill, "BOTTOMLEFT", 0, -12, 340)
    right.materialsTitle = CreateLabel(right, "", "GameFontNormal", "TOPLEFT", right.description, "BOTTOMLEFT", 0, -18)
    right.materials = CreateLabel(right, "", "GameFontHighlightSmall", "TOPLEFT", right.materialsTitle, "BOTTOMLEFT", 0, -8, 340)

    local recommendation = CreateFrame("Frame", nil, frame)
    recommendation:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 30, 25)
    recommendation:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -155, 25)
    recommendation:SetHeight(60)
    recommendation:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    recommendation:SetBackdropColor(0.08, 0.06, 0.02, 0.85)
    CreateLabel(recommendation, "Recomendación", "GameFontNormal", "TOPLEFT", recommendation, "TOPLEFT", 12, -9)
    recommendation.text = CreateLabel(recommendation, "Las recetas conocidas se cargarán al abrir su libro de profesión.", "GameFontHighlightSmall", "TOPLEFT", recommendation, "TOPLEFT", 12, -30, 700)

    local selectionPanel = CreateFrame("Frame", nil, frame)
    selectionPanel:SetPoint("TOPLEFT", frame, "TOPLEFT", 30, -122)
    selectionPanel:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 30, 90)
    selectionPanel:SetWidth(210)

    local primaryPanel = CreateFrame("Frame", nil, selectionPanel)
    primaryPanel:SetPoint("TOPLEFT", selectionPanel, "TOPLEFT", 0, 0)
    primaryPanel:SetWidth(210)
    primaryPanel:SetHeight(180)
    primaryPanel:SetBackdrop({
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    primaryPanel:SetBackdropColor(0.04, 0.04, 0.04, 0.8)
    CreateLabel(primaryPanel, "Profesiones primarias", "GameFontNormal", "TOPLEFT", primaryPanel, "TOPLEFT", 16, -14)

    local secondaryPanel = CreateFrame("Frame", nil, selectionPanel)
    secondaryPanel:SetPoint("TOPLEFT", primaryPanel, "BOTTOMLEFT", 0, -8)
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
        button:SetSize(174, 28)
        button:SetText(profession.name)
        button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
        button:SetScript("OnClick", function()
            frame:SelectProfession(profession.id)
        end)
        button:Hide()
        professionButtons[profession.id] = button
    end

    for _, profession in ipairs(PA_ProfessionCatalog) do
        CreateProfessionButton(profession)
    end


    frame.professionID = nil
    frame.filteredRecipes = {}
    frame.allRecipes = {}
    frame.knownProfessions = {}
    frame.selectedRecipeKey = nil
    frame.lastSearch = ""

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
        for _, profession in ipairs(PA_ProfessionCatalog) do
            local button = professionButtons[profession.id]
            button:Hide()
            if self.knownProfessions[profession.id] then
                local skill = self.knownProfessions[profession.id]
                button:SetText(profession.name .. "  (" .. tostring(skill.rank) .. "/" .. tostring(skill.maxRank) .. ")")
                local fontString = button:GetFontString()
                if fontString then
                    if profession.id == self.professionID then
                        fontString:SetTextColor(1, 0.82, 0.1)
                    else
                        fontString:SetTextColor(0.92, 0.92, 0.92)
                    end
                end
                if profession.category == "PRIMARY" then
                    button:ClearAllPoints()
                    button:SetPoint("TOPLEFT", primaryPanel, "TOPLEFT", 18, -42 - primaryIndex * 32)
                    primaryIndex = primaryIndex + 1
                else
                    button:ClearAllPoints()
                    button:SetPoint("TOPLEFT", secondaryPanel, "TOPLEFT", 18, -42 - secondaryIndex * 32)
                    secondaryIndex = secondaryIndex + 1
                end
                button:Show()
            end
        end

        if primaryIndex == 0 then primaryEmpty:Show() else primaryEmpty:Hide() end
        if secondaryIndex == 0 then secondaryEmpty:Show() else secondaryEmpty:Hide() end

        if self.professionID and not self.knownProfessions[self.professionID] then
            self.professionID = nil
            self.selectedRecipeKey = nil
            professionText:SetText("Selecciona una profesión")
            skillLevelText:SetText("Nivel actual: - / -")
            skillBar:SetMinMaxValues(0, 1)
            skillBar:SetValue(0)
            self:SetRecipeStatus("Selecciona una profesión aprendida.")
            self:RefreshRecipes()
        elseif self.professionID and self.knownProfessions[self.professionID] then
            local skill = self.knownProfessions[self.professionID]
            skillLevelText:SetText("Nivel actual: " .. tostring(skill.rank) .. " / " .. tostring(skill.maxRank))
            skillBar:SetMinMaxValues(0, skill.maxRank > 0 and skill.maxRank or 1)
            skillBar:SetValue(skill.rank)
        end
    end

    function frame:ShowProfessionSelection()
        self:RefreshProfessionSelection()
        selectionPanel:Show()
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
        self.selectedRecipeKey = nil
        local skill = self.knownProfessions[selected.id]
        professionText:SetText(selected.name)
        skillLevelText:SetText("Nivel actual: " .. tostring(skill.rank) .. " / " .. tostring(skill.maxRank))
        skillBar:SetMinMaxValues(0, skill.maxRank > 0 and skill.maxRank or 1)
        skillBar:SetValue(skill.rank)
        local knownRecipes = PA.TradeSkillRecipes and PA.TradeSkillRecipes[selected.id]
        local recipeCount = knownRecipes and table.getn(knownRecipes) or 0
        self:SetRecipeStatus(recipeCount > 0 and ("Recetas conocidas cargadas: " .. tostring(recipeCount)) or "Abre el libro de profesión para importar tus recetas conocidas.")
        for professionID, button in pairs(professionButtons) do
            local fontString = button:GetFontString()
            if fontString then
                if professionID == selected.id then fontString:SetTextColor(1, 0.82, 0.1) else fontString:SetTextColor(0.92, 0.92, 0.92) end
            end
        end
        search:SetText("")
        self:RefreshRecipes()
    end

    function frame:SetRecipeStatus(message)
        recommendation.text:SetText(message or "")
        local recipes = PA.TradeSkillRecipes and PA.TradeSkillRecipes[self.professionID]
        if recipes then
            nextStepText:SetText("Recetas: " .. tostring(table.getn(recipes)))
        elseif self.professionID then
            nextStepText:SetText("Abre el libro para cargar recetas")
        else
            nextStepText:SetText("Selecciona una profesión")
        end
    end

    function frame:ShowRecipeDetails(index)
        local recipe = self.filteredRecipes[index]
        if not recipe then return end
        self.selectedRecipeKey = recipe.key or recipe.name
        right.recipeName:SetText(recipe.name or "Receta sin nombre")
        right.recipeResult:SetText("Resultado: " .. tostring(recipe.result or recipe.name or "No indicado"))
        local skillText = ""
        if recipe.skill then skillText = "Habilidad: " .. tostring(recipe.skill) end
        if recipe.requiredSkill then
            if skillText ~= "" then skillText = skillText .. "  |  " end
            skillText = skillText .. "Requiere: " .. tostring(recipe.requiredSkill)
        end
        if recipe.craftableCount ~= nil then
            if skillText ~= "" then skillText = skillText .. "  |  " end
            skillText = skillText .. "Fabricables ahora: " .. tostring(recipe.craftableCount)
        end
        right.skill:SetText(skillText)
        right.description:SetText(recipe.description or "")
        right.materialsTitle:SetText("Materiales necesarios")
        local lines = {}
        if recipe.materials then
            for _, material in ipairs(recipe.materials) do
                local amount = material.count or material.quantity or 1
                local owned = material.owned
                local ownedText = owned ~= nil and ("  (" .. tostring(owned) .. " disponibles)") or ""
                table.insert(lines, tostring(amount) .. " x " .. tostring(material.name or "Material") .. ownedText)
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
        local imported = PA.TradeSkillRecipes and PA.TradeSkillRecipes[self.professionID]
        local recipes
        if imported and table.getn(imported) > 0 then
            recipes = imported
        else
            recipes = (profession and profession.recipes) or {}
        end

        local query = PA:NormalizeSkillName(search:GetText() or "")
        self.filteredRecipes = {}
        for _, recipe in ipairs(recipes) do
            local normalizedName = PA:NormalizeSkillName(recipe.name or "")
            if query == "" or string.find(normalizedName, query, 1, true) then
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
                local recipeKey = recipe.key or recipe.name
                local recipeName = recipe.name or "Receta sin nombre"
                if recipeKey == self.selectedRecipeKey then
                    row.text:SetText("» " .. recipeName)
                    row.text:SetTextColor(1, 0.82, 0.1)
                else
                    row.text:SetText(recipeName)
                    row.text:SetTextColor(GetDifficultyColor(recipe))
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
                if (recipe.key or recipe.name) == self.selectedRecipeKey then
                    selectedIndex = index
                    break
                end
            end
        end

        if selectedIndex then
            self:ShowRecipeDetails(selectedIndex)
        else
            self.selectedRecipeKey = nil
            right.recipeName:SetText(total > 0 and "Selecciona una receta" or (self.professionID and "Aún no hay recetas" or "Selecciona una profesión"))
            right.recipeResult:SetText("")
            right.skill:SetText("")
            right.description:SetText(total > 0 and "Elige una receta para ver su resultado y materiales." or (self.professionID and "Abre el libro nativo de esta profesión para leer las recetas conocidas del personaje." or "Elige una profesión aprendida en el panel de la izquierda."))
            right.materialsTitle:SetText("")
            right.materials:SetText("")
        end
    end
    search:SetScript("OnTextChanged", function()
        if search:GetText() ~= frame.lastSearch then
            frame.lastSearch = search:GetText()
            scroll.offset = 0
            if FauxScrollFrame_SetOffset then FauxScrollFrame_SetOffset(scroll, 0) end
        end
        frame:RefreshRecipes()
    end)
    scroll:SetScript("OnVerticalScroll", function(self, offset)
        FauxScrollFrame_OnVerticalScroll(self, offset, ROW_HEIGHT, function() frame:RefreshRecipes() end)
    end)

    frame:ShowProfessionSelection()
    frame:RefreshRecipes()
    local closeAction = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    closeAction:SetSize(112, 28)
    closeAction:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -34, 27)
    closeAction:SetText("Cerrar")
    closeAction:SetScript("OnClick", function() frame:Hide() end)
    self.frame = frame
    return frame
end
