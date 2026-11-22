PA_ProfessionCatalog = {
    { id = "ALCHEMY", name = "Alquimia", module = nil },
    { id = "BLACKSMITHING", name = "Herrería", module = nil },
    { id = "ENCHANTING", name = "Encantamiento", module = nil },
    { id = "ENGINEERING", name = "Ingeniería", module = nil },
    { id = "HERBALISM", name = "Herboristería", module = nil },
    { id = "INSCRIPTION", name = "Inscripción", module = nil },
    { id = "JEWELCRAFTING", name = "Joyería", module = nil },
    { id = "LEATHERWORKING", name = "Peletería", module = "PA_Leatherworking" },
    { id = "MINING", name = "Minería", module = nil },
    { id = "SKINNING", name = "Desuello", module = nil },
    { id = "TAILORING", name = "Sastrería", module = nil },
    { id = "COOKING", name = "Cocina", module = nil },
    { id = "FIRST_AID", name = "Primeros auxilios", module = nil },
    { id = "FISHING", name = "Pesca", module = nil }
}

PA = PA or {}
PA.Professions = PA.Professions or {}

function PA:RegisterProfession(id, data)
    self.Professions[id] = data
end

function PA:GetProfession(id)
    return self.Professions[id]
end
