# Profession Assistant

Add-on modular para World of Warcraft 3.3.5a (Interface 30300), diseñado para reunir todas las profesiones en una sola herramienta.

## Estado actual — versión 0.3.0

- Cargador del add-on y comando `/pa`.
- Ventana ampliada con buscador de recetas, lista seleccionable y panel de detalles.
- Catálogo central con las profesiones de WoW 3.3.5a.
- Peletería registrada como primer módulo de profesión.
- Estructura preparada para añadir módulos de datos independientes.
- Interfaz preparada para mostrar recetas, dificultad, habilidad, requisitos y materiales. La base de recetas de Peletería aún debe cargarse y validarse en el servidor.

## Instalación

1. Descarga el repositorio.
2. Coloca la carpeta `ProfessionAssistant` dentro de `World of Warcraft/Interface/AddOns/`.
3. Verifica que `ProfessionAssistant.toc` esté directamente dentro de esa carpeta.
4. Activa el add-on en la pantalla de selección de personaje.
5. Entra al juego y escribe `/pa` para abrir o cerrar la ventana.

## Próximas etapas

1. Probar la carga en el cliente 3.3.5a y corregir cualquier error de Lua o interfaz.
2. Conectar la ventana con las profesiones y recetas conocidas por el personaje.
3. Incorporar datos de recetas de Peletería y comprobar los rangos de habilidad.
4. Implementar búsqueda, filtros por color y recomendación según habilidad/materiales.
5. Añadir el resto de profesiones usando el mismo sistema modular.

El proyecto no depende por ahora de un servidor concreto. Las diferencias de recetas y datos se ajustarán después de la primera prueba.
