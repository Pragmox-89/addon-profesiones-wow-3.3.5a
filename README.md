# Profession Assistant

Add-on modular para World of Warcraft 3.3.5a (Interface 30300), diseñado para reunir las profesiones aprendidas y sus recetas en una ventana con estilo clásico de WoW.

## Estado actual — versión 0.7.0

- Cargador del add-on y comando `/pa`.
- Selector de profesiones aprendidas, separado en profesiones primarias y secundarias; no elige una profesión automáticamente.
- Ventana con marco clásico de WoW, rango real de habilidad, lista de recetas, buscador y panel de detalles.
- Al abrir el libro nativo de una profesión, importa las recetas que el personaje ya conoce, su dificultad y los materiales que requiere.
- Los datos importados proceden del cliente del juego. Esto ayuda a que nombres y materiales coincidan con el servidor sin fijar una profesión favorita ni una lista de recetas de un servidor concreto.
- Peletería sigue registrada como módulo de profesión y el sistema puede ampliarse con datos estáticos más adelante.

## Límite de esta versión

Esta versión muestra las recetas que ya aparecen en el libro de profesión del personaje. Aún no incluye el catálogo completo de recetas que el personaje no ha aprendido, las fuentes para conseguirlas ni una ruta automática para subir del 1 al 450. Esos datos se incorporarán y comprobarán en una etapa posterior.

## Instalación

1. Descarga el ZIP del repositorio.
2. Coloca la carpeta `ProfessionAssistant` dentro de `World of Warcraft/Interface/AddOns/`.
3. Verifica que `ProfessionAssistant.toc` esté directamente dentro de esa carpeta.
4. Activa el add-on en la pantalla de selección de personaje.
5. Entra al juego y escribe `/pa` para abrir o cerrar la ventana.
6. Abre la ventana nativa de una profesión que hayas aprendido. El addon importará las recetas conocidas y los materiales que muestra el juego.

## Próximas etapas

1. Validar el comportamiento en el cliente 3.3.5a de NaerZone.
2. Incorporar un catálogo de recetas no aprendidas, sus requisitos y dónde conseguirlas.
3. Implementar recomendaciones de subida basadas en habilidad, dificultad y materiales.
4. Ampliar los datos para todas las profesiones primarias y secundarias.

Por ahora el addon no depende de datos particulares de NaerZone: lee del cliente las recetas conocidas del personaje. El catálogo completo se basará en WotLK 3.3.5a y se contrastará con el servidor cuando podamos probarlo dentro del juego.
