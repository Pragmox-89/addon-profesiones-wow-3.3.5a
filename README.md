# Profession Assistant

Add-on modular para World of Warcraft 3.3.5a (Interface 30300), pensado para reunir todas las profesiones en una sola herramienta.

## Estado actual

- Base de carga del add-on y comando `/pa`.
- Ventana inicial redimensionada para mostrar lista de recetas y panel de detalles.
- Módulo de datos independiente para Peletería.
- Las recetas todavía no están cargadas: se incorporarán después de verificar la versión de datos del servidor privado.

## Instalación

1. Descarga o clona este repositorio.
2. Copia los archivos a una carpeta llamada `ProfessionAssistant` dentro de `World of Warcraft/Interface/AddOns/`.
3. Comprueba que `ProfessionAssistant.toc` quede directamente dentro de esa carpeta.
4. Inicia el juego y activa el add-on en la pantalla de selección de personaje.
5. Entra al juego y escribe `/pa` para abrir o cerrar la ventana.

## Próximos pasos

1. Probar que el add-on cargue en el cliente 3.3.5a.
2. Identificar el servidor y validar recetas, rangos y materiales de Peletería.
3. Implementar búsqueda, filtros por color de habilidad y recomendación de fabricación.
4. Incorporar las demás profesiones mediante módulos de datos separados.
