-- Lee las recetas que el cliente 3.3.5a muestra en el libro abierto.
-- No inventa un catálogo ni supone que todas las fases del servidor estén habilitadas.
PA = PA or {}
ProfessionAssistantDB = ProfessionAssistantDB or {}
ProfessionAssistantDB.recipes = ProfessionAssistantDB.recipes or {}
PA.TradeSkillRecipes = PA.TradeSkillRecipes or ProfessionAssistantDB.recipes

local function GetDifficulty(skillType)
    if skillType == "optimal" then return "orange" end
    if skillType == "medium" then return "yellow" end
    if skillType == "easy" then return "green" end
    if skillType == "trivial" then return "gray" end
    return nil
end

local function GetLinkName(itemLink)
    if not itemLink then return nil end
    return string.match(itemLink, "%[(.-)%]")
end

local function GetLinkItemID(itemLink)
    if not itemLink then return nil end
    return tonumber(string.match(itemLink, "item:(%d+)"))
end

function PA:ScanTradeSkill()
    if not GetTradeSkillLine or not GetNumTradeSkills or not GetTradeSkillInfo then
        self.LastScanError = "El cliente no expone la API del libro de profesiones."
        return false
    end

    local skillLine = GetTradeSkillLine()
    self.LastTradeSkillLine = skillLine
    local profession = self:FindProfessionBySkillName(skillLine)
    if not profession then
        self.LastScanError = "No pude identificar la profesión abierta: " .. tostring(skillLine)
        return false
    end

    local recipes = {}
    local entryCount = GetNumTradeSkills() or 0
    for index = 1, entryCount do
        local name, skillType, craftableCount = GetTradeSkillInfo(index)
        if name and skillType ~= "header" and skillType ~= "subheader" then
            local resultLink = GetTradeSkillItemLink and GetTradeSkillItemLink(index)
            local resultName, resultTexture
            if resultLink and GetItemInfo then
                local itemInfo = { GetItemInfo(resultLink) }
                resultName = itemInfo[1]
                resultTexture = itemInfo[10]
            end
            local recipe = {
                key = resultLink or (name .. ":" .. tostring(index)),
                name = name,
                result = resultName or GetLinkName(resultLink) or name,
                resultLink = resultLink,
                resultTexture = resultTexture,
                difficulty = GetDifficulty(skillType),
                craftableCount = tonumber(craftableCount),
                tradeSkillIndex = index,
                materials = {}
            }

            if GetTradeSkillNumReagents and GetTradeSkillReagentInfo then
                local reagentCount = GetTradeSkillNumReagents(index) or 0
                for reagentIndex = 1, reagentCount do
                    local reagentName, reagentTexture, quantity, owned = GetTradeSkillReagentInfo(index, reagentIndex)
                    local reagentLink = GetTradeSkillReagentItemLink and GetTradeSkillReagentItemLink(index, reagentIndex)
                    local reagentItemID = GetLinkItemID(reagentLink)
                    local reagentQuality
                    if reagentLink then
                        local reagentInfo = GetItemInfo and { GetItemInfo(reagentLink) } or nil
                        reagentName = reagentName or GetLinkName(reagentLink) or (reagentInfo and reagentInfo[1])
                        reagentTexture = reagentTexture or (reagentInfo and reagentInfo[10])
                        reagentQuality = reagentInfo and tonumber(reagentInfo[3])
                    end
                    if reagentName then
                        table.insert(recipe.materials, {
                            name = reagentName,
                            texture = reagentTexture,
                            count = tonumber(quantity) or 1,
                            owned = tonumber(owned) or 0,
                            itemID = reagentItemID,
                            itemLink = reagentLink,
                            quality = reagentQuality
                        })
                    end
                end
            end

            table.insert(recipes, recipe)
        end
    end

    local cachedRecipes = self.TradeSkillRecipes[profession.id]
    if table.getn(recipes) == 0 and cachedRecipes and table.getn(cachedRecipes) > 0 then
        recipes = cachedRecipes
    else
        self.TradeSkillRecipes[profession.id] = recipes
    end
    if table.getn(recipes) > 0 then
        ProfessionAssistantDB.recipes[profession.id] = recipes
    end
    self.LastScanError = nil
    self.LastScanProfession = profession.id
    self.LastScanCount = table.getn(recipes)

    if self.frame then
        self.frame:RefreshRecipes()
        if self.frame.recommendationPopup and self.frame.recommendationPopup:IsShown()
            and self.frame.RefreshRecommendationPopup then
            self.frame:RefreshRecommendationPopup()
        end
        if self.frame.professionID == profession.id then
            local message
            if table.getn(recipes) > 0 then
                message = tostring(table.getn(recipes)) .. " recetas"
            else
                message = "Sin recetas"
            end
            self.frame:SetRecipeStatus(message)
        end
    end

    return true, table.getn(recipes)
end


