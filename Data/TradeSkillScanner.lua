-- Imports the recipes visible in the native 3.3.5 profession window.
-- This reads the player's client data, so the names and reagents match the server.
PA = PA or {}
PA.TradeSkillRecipes = PA.TradeSkillRecipes or {}

local function Normalize(value)
    return string.lower(string.gsub(value or "", "%s+", ""))
end

local function FindProfession(skillLine)
    local normalizedLine = Normalize(skillLine)
    for _, profession in ipairs(PA_ProfessionCatalog or {}) do
        for _, alias in ipairs(profession.skillNames or {}) do
            if normalizedLine == Normalize(alias) then
                return profession
            end
        end
    end
end

local function GetDifficulty(skillType)
    if skillType == "optimal" then return "orange" end
    if skillType == "medium" then return "yellow" end
    if skillType == "easy" then return "green" end
    if skillType == "trivial" then return "gray" end
    return nil
end

function PA:ScanTradeSkill()
    if not GetTradeSkillLine or not GetNumTradeSkills or not GetTradeSkillInfo then return end

    local skillLine = GetTradeSkillLine()
    local profession = FindProfession(skillLine)
    if not profession then return end

    local recipes = {}
    local count = GetNumTradeSkills() or 0
    for index = 1, count do
        local name, skillType = GetTradeSkillInfo(index)
        if name and skillType ~= "header" and skillType ~= "subheader" then
            local recipe = {
                name = name,
                difficulty = GetDifficulty(skillType),
                description = "Receta aprendida que aparece en el libro de profesión.",
                materials = {}
            }

            if GetTradeSkillNumReagents and GetTradeSkillReagentInfo then
                local reagentCount = GetTradeSkillNumReagents(index) or 0
                for reagentIndex = 1, reagentCount do
                    local reagentName, _, quantity, owned = GetTradeSkillReagentInfo(index, reagentIndex)
                    if reagentName then
                        table.insert(recipe.materials, {
                            name = reagentName,
                            count = quantity or 1,
                            owned = owned or 0
                        })
                    end
                end
            end

            table.insert(recipes, recipe)
        end
    end

    self.TradeSkillRecipes[profession.id] = recipes
    if self.frame then
        self.frame:RefreshRecipes()
        if self.frame.professionID == profession.id then
            local message = #recipes > 0
                and ("Recetas conocidas cargadas: " .. tostring(#recipes))
                or "No se encontraron recetas en el libro abierto."
            self.frame:SetRecipeStatus(message)
        end
    end
end
