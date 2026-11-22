PA_ProfessionCatalog = {
    { id = "ALCHEMY", name = "Alquimia", category = "PRIMARY", module = nil },
    { id = "BLACKSMITHING", name = "Herrería", category = "PRIMARY", module = nil },
    { id = "ENCHANTING", name = "Encantamiento", category = "PRIMARY", module = nil },
    { id = "ENGINEERING", name = "Ingeniería", category = "PRIMARY", module = nil },
    { id = "HERBALISM", name = "Herboristería", category = "PRIMARY", module = nil },
    { id = "INSCRIPTION", name = "Inscripción", category = "PRIMARY", module = nil },
    { id = "JEWELCRAFTING", name = "Joyería", category = "PRIMARY", module = nil },
    { id = "LEATHERWORKING", name = "Peletería", category = "PRIMARY", module = "PA_Leatherworking" },
    { id = "MINING", name = "Minería", category = "PRIMARY", module = nil },
    { id = "SKINNING", name = "Desuello", category = "PRIMARY", module = nil },
    { id = "TAILORING", name = "Sastrería", category = "PRIMARY", module = nil },
    { id = "COOKING", name = "Cocina", category = "SECONDARY", module = nil },
    { id = "FIRST_AID", name = "Primeros auxilios", category = "SECONDARY", module = nil },
    { id = "FISHING", name = "Pesca", category = "SECONDARY", module = nil }
}

PA = PA or {}
PA.Professions = PA.Professions or {}

function PA:RegisterProfession(id, data)
    self.Professions[id] = data
end

function PA:GetProfession(id)
    return self.Professions[id]
end
