# Profession Assistant

Addon para clientes de World of Warcraft 3.3.5a (Interface 30300). Detecta las profesiones que el personaje aprendió, las separa en primarias y secundarias y lee recetas del libro nativo del cliente.

## Versión 0.8.0

- Arranque en `PLAYER_LOGIN`, sin depender del nombre que el cliente reporte en `ADDON_LOADED`.
- Mensaje visible al cargar para confirmar que el addon se inicializó.
- Comandos `/pa`, `/pa debug` y `/pa scan`.
- Comparación de profesiones más tolerante a acentos y variantes de nombres en español.
- Detalles de receta con resultado, ingredientes, cantidades disponibles y dificultad del libro abierto.
- Búsqueda que ignora acentos, restablece la posición de la lista y limpia detalles desactualizados.
- La ventana mantiene la selección vacía al abrir; solo permite elegir profesiones aprendidas.

## Lo que lee y lo que falta

El addon lee **recetas que el personaje ya conoce y que aparecen en el libro nativo**. No contiene todavía el catálogo de recetas no aprendidas, dónde conseguirlas ni una ruta de subida del 1 al 450. Los datos leídos provienen del cliente en ejecución, así que respetan la fase y las modificaciones que ese cliente muestre.

## Instalación

1. Descarga el ZIP de GitHub y extráelo.
2. Renombra la carpeta extraída a `ProfessionAssistant`.
3. Coloca esa carpeta directamente en `Interface/AddOns/`.
4. Comprueba que el archivo quede en `Interface/AddOns/ProfessionAssistant/ProfessionAssistant.toc`, junto a `Core.lua`, `Data/` y `UI/`.
5. Cierra completamente el juego antes de copiar archivos; vuelve a abrir el cliente desde la misma instalación.
6. En la pantalla de personajes, abre **Accesorios**, activa Profession Assistant y, si aparece, activa **Cargar accesorios desactualizados**.
7. Entra al personaje y escribe `/pa`. Abre luego el libro nativo de una profesión aprendida para cargar las recetas.

## Diagnóstico dentro del juego

- `/pa debug`: confirma versión, cliente, profesiones detectadas y última línea de profesión leída.
- `/pa scan`: vuelve a leer la profesión cuyo libro está abierto.
- Al entrar al mundo debe aparecer el mensaje `v0.8.0 cargado`. Si no aparece y el addon tampoco figura en **Accesorios**, el cliente no está leyendo esa carpeta de AddOns.

## Compatibilidad

La interfaz está dirigida al cliente 3.3.5a. No afirmamos haber probado cada cliente personalizado de cada servidor: la confirmación final requiere que el addon aparezca en **Accesorios** y que la ventana abra en el cliente concreto. En servidores progresivos o personalizados, las recetas leídas son las que el libro del propio personaje entrega.

## Próximas etapas

1. Probar en el cliente de WoW Perú y corregir cualquier error real que reporte el juego.
2. Incorporar el catálogo de recetas no aprendidas, con su origen y fase de disponibilidad.
3. Añadir recomendaciones de subida según habilidad, color de dificultad y materiales.
4. Expandir los datos de todas las profesiones sin dar prioridad a ninguna.
