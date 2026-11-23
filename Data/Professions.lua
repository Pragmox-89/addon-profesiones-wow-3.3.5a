PA = PA or {}
PA.VERSION = "0.8.0"

PA_ProfessionCatalog = {
    { id = "ALCHEMY", name = "Alquimia", category = "PRIMARY", skillNames = { "Alquimia", "Alchemy" }, module = nil },
    { id = "BLACKSMITHING", name = "Herrería", category = "PRIMARY", skillNames = { "Herrería", "Herreria", "Blacksmithing" }, module = nil },
    { id = "ENCHANTING", name = "Encantamiento", category = "PRIMARY", skillNames = { "Encantamiento", "Enchanting" }, module = nil },
    { id = "ENGINEERING", name = "Ingeniería", category = "PRIMARY", skillNames = { "Ingeniería", "Ingenieria", "Engineering" }, module = nil },
    { id = "HERBALISM", name = "Herboristería", category = "PRIMARY", skillNames = { "Herboristería", "Herboristeria", "Herbalism" }, module = nil },
    { id = "INSCRIPTION", name = "Inscripción", category = "PRIMARY", skillNames = { "Inscripción", "Inscripcion", "Inscription" }, module = nil },
    { id = "JEWELCRAFTING", name = "Joyería", category = "PRIMARY", skillNames = { "Joyería", "Joyeria", "Jewelcrafting" }, module = nil },
    { id = "LEATHERWORKING", name = "Peletería", category = "PRIMARY", skillNames = { "Peletería", "Peleteria", "Leatherworking" }, module = "PA_Leatherworking" },
    { id = "MINING", name = "Minería", category = "PRIMARY", skillNames = { "Minería", "Mineria", "Mining" }, module = nil },
    { id = "SKINNING", name = "Desuello", category = "PRIMARY", skillNames = { "Desuello", "Skinning" }, module = nil },
    { id = "TAILORING", name = "Sastrería", category = "PRIMARY", skillNames = { "Sastrería", "Sastreria", "Tailoring" }, module = nil },
    { id = "COOKING", name = "Cocina", category = "SECONDARY", skillNames = { "Cocina", "Cooking" }, module = nil },
    { id = "FIRST_AID", name = "Primeros auxilios", category = "SECONDARY", skillNames = { "Primeros auxilios", "First Aid" }, module = nil },
    { id = "FISHING", name = "Pesca", category = "SECONDARY", skillNames = { "Pesca", "Fishing" }, module = nil }
}

PA.Professions = PA.Professions or {}

function PA:NormalizeSkillName(value)
    value = string.lower(value or "")
    local replacements = {
        { "á", "a" }, { "é", "e" }, { "í", "i" }, { "ó", "o" }, { "ú", "u" }, { "ü", "u" }, { "ñ", "n" },
        { "Á", "a" }, { "É", "e" }, { "Í", "i" }, { "Ó", "o" }, { "Ú", "u" }, { "Ü", "u" }, { "Ñ", "n" }
    }
    for _, pair in ipairs(replacements) do
        value = string.gsub(value, pair[1], pair[2])
    end
    value = string.gsub(value, "%s+", "")
    return value
end

function PA:FindProfessionBySkillName(skillName)
    local normalizedName = self:NormalizeSkillName(skillName)
    if normalizedName == "" then return nil end
    for _, profession in ipairs(PA_ProfessionCatalog) do
        for _, alias in ipairs(profession.skillNames or {}) do
            if normalizedName == self:NormalizeSkillName(alias) then
                return profession
            end
        end
    end
end

function PA:RegisterProfession(id, data)
    self.Professions[id] = data
end

function PA:GetProfession(id)
    if not id then return nil end
    return self.Professions[id]
end
