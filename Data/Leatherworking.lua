-- Módulo base de Peletería. Las recetas conocidas se importan del libro del juego.
PA = PA or {}

PA_Leatherworking = {
    id = "LEATHERWORKING",
    name = "Peletería",
    recipes = PA_LeatherworkingRecipes or {}
}

PA:RegisterProfession("LEATHERWORKING", PA_Leatherworking)
