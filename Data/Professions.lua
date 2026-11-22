PA_ProfessionCatalog = {
    { id = "ALCHEMY", name = "Alquimia", category = "PRIMARY", skillNames = { "Alquimia", "Alchemy" }, module = nil },
    { id = "BLACKSMITHING", name = "Herrería", category = "PRIMARY", skillNames = { "Herrería", "Blacksmithing" }, module = nil },
    { id = "ENCHANTING", name = "Encantamiento", category = "PRIMARY", skillNames = { "Encantamiento", "Enchanting" }, module = nil },
    { id = "ENGINEERING", name = "Ingeniería", category = "PRIMARY", skillNames = { "Ingeniería", "Engineering" }, module = nil },
    { id = "HERBALISM", name = "Herboristería", category = "PRIMARY", skillNames = { "Herboristería", "Herbalism" }, module = nil },
    { id = "INSCRIPTION", name = "Inscripción", category = "PRIMARY", skillNames = { "Inscripción", "Inscription" }, module = nil },
    { id = "JEWELCRAFTING", name = "Joyería", category = "PRIMARY", skillNames = { "Joyería", "Jewelcrafting" }, module = nil },
    { id = "LEATHERWORKING", name = "Peletería", category = "PRIMARY", skillNames = { "Peletería", "Leatherworking" }, module = "PA_Leatherworking" },
    { id = "MINING", name = "Minería", category = "PRIMARY", skillNames = { "Minería", "Mining" }, module = nil },
    { id = "SKINNING", name = "Desuello", category = "PRIMARY", skillNames = { "Desuello", "Skinning" }, module = nil },
    { id = "TAILORING", name = "Sastrería", category = "PRIMARY", skillNames = { "Sastrería", "Tailoring" }, module = nil },
    { id = "COOKING", name = "Cocina", category = "SECONDARY", skillNames = { "Cocina", "Cooking" }, module = nil },
    { id = "FIRST_AID", name = "Primeros auxilios", category = "SECONDARY", skillNames = { "Primeros auxilios", "First Aid" }, module = nil },
    { id = "FISHING", name = "Pesca", category = "SECONDARY", skillNames = { "Pesca", "Fishing" }, module = nil }
}

PA = PA or {}
PA.Professions = PA.Professions or {}

function PA:RegisterProfession(id, data)
    self.Professions[id] = data
end

function PA:GetProfession(id)
    return self.Professions[id]
end
