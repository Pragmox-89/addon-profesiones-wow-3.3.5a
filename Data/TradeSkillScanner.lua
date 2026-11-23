-- Lee las recetas que el cliente 3.3.5a muestra en el libro abierto.
-- No inventa un catálogo ni supone que todas las fases del servidor estén habilitadas.
PA = PA or {}
PA.TradeSkillRecipes = PA.TradeSkillRecipes or {}

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
                resultTexture = resultTexture,
                difficulty = GetDifficulty(skillType),
                craftableCount = tonumber(craftableCount),
                description = "Dato leído del libro de profesión de este personaje.",
                materials = {}
            }

            if GetTradeSkillNumReagents and GetTradeSkillReagentInfo then
                local reagentCount = GetTradeSkillNumReagents(index) or 0
                for reagentIndex = 1, reagentCount do
                    local reagentName, reagentTexture, quantity, owned = GetTradeSkillReagentInfo(index, reagentIndex)
                    if reagentName then
                        table.insert(recipe.materials, {
                            name = reagentName,
                            texture = reagentTexture,
                            count = tonumber(quantity) or 1,
                            owned = tonumber(owned) or 0
                        })
                    end
                end
            end

            table.insert(recipes, recipe)
        end
    end

    self.TradeSkillRecipes[profession.id] = recipes
    self.LastScanError = nil
    self.LastScanProfession = profession.id
    self.LastScanCount = table.getn(recipes)

    if self.frame then
        self.frame:RefreshRecipes()
        if self.frame.professionID == profession.id then
            local message
            if table.getn(recipes) > 0 then
                message = "Recetas conocidas leídas del libro: " .. tostring(table.getn(recipes))
            else
                message = "El libro de esta profesión está vacío o no entregó recetas."
            end
            self.frame:SetRecipeStatus(message)
        end
    end

    return true, table.getn(recipes)
end
