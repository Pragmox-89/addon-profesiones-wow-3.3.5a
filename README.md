# Profession Assistant

Addon para World of Warcraft 3.3.5a (Interface 30300). Detecta las profesiones aprendidas, separa primarias y secundarias, y lee las recetas que conoce el personaje.

## Versión 0.8.4

- Selector de cantidad con botones de incremento y decremento.
- Botón **Fabricar** conectado a la fabricación nativa del cliente.
- Los ingredientes muestran el total necesario según la cantidad elegida.
- El botón se activa únicamente cuando está abierto el libro de la profesión correspondiente y hay materiales suficientes.
- Ventana compacta con elementos de interfaz clásica de WoW.
- Búsqueda de recetas y filtro de recetas fabricables.

## Lo que lee y lo que falta

El addon muestra las recetas que el personaje ya conoce y que aparecen en el libro nativo. No contiene todavía el catálogo de recetas no aprendidas, dónde conseguirlas ni una ruta de subida del 1 al 450. Los datos respetan las recetas que el cliente y el servidor muestran al personaje.

## Instalación

1. Descarga el ZIP y extráelo.
2. Coloca la carpeta `ProfessionAssistant` directamente en `Interface/AddOns/`.
3. Comprueba que `ProfessionAssistant.toc` quede en `Interface/AddOns/ProfessionAssistant/`, junto a `Core.lua`, `Data/` y `UI/`.
4. En la pantalla de personajes, activa Profession Assistant en **Accesorios** y, si aparece, **Cargar accesorios desactualizados**.
5. Entra al personaje, escribe `/pa` y abre una profesión aprendida para cargar sus recetas.

## Comandos

- `/pa`: abre o cierra la ventana.
- `/pa debug`: muestra el estado de carga y las profesiones detectadas.
- `/pa scan`: vuelve a leer el libro de profesión abierto.

## Compatibilidad

Diseñado para clientes 3.3.5a. Las recetas disponibles pueden variar entre servidores; la lista procede del libro abierto en el cliente.

