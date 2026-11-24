# Cambios

## 0.8.5

- Actualiza recetas al elegir una profesión desde el addon, sin abrir manualmente el libro nativo.
- Guarda por personaje las recetas descubiertas para que la lista siga disponible después de recargar.
- Oculta el libro nativo durante la lectura; respeta si ya estaba abierto por el jugador.
- Cierra el libro nativo al cerrar el addon cuando fue abierto por el asistente.
- Corrige un error de compatibilidad de botones que impedía crear la ventana tras recargar la interfaz.

## 0.8.4

- Añade selector de cantidad y botón **Fabricar**, conectado a la creación nativa del cliente 3.3.5a.
- Actualiza el total de ingredientes al cambiar la cantidad.
- Solo permite fabricar con la profesión correcta abierta, materiales suficientes y sin restricciones de descanso.
- Compacta la ventana y usa resaltados, botones de cantidad y texturas de interfaz clásica de WoW.
- Retira mensajes redundantes sobre el origen de las recetas.
- Mantiene las tarjetas de ingredientes dentro del panel de detalles, incluso en recetas con varios materiales.

## 0.8.3

- Reduce la ventana a un tamaño moderado y devuelve la tipografía a escala habitual de WoW.
- Corrige la capa de las tarjetas para mostrar los materiales reales de cada receta.
- Mejora el fondo y los bordes con paneles opacos y marcos dorados.
- Añade lectura alternativa del enlace del ingrediente para recuperar su nombre e icono.

## 0.8.2

- Rediseña la ventana con marco y paneles en tonos dorados, iconos de profesión y una escala legible en el cliente.
- Añade iconos de resultado y materiales, cantidades disponibles y filtro de recetas fabricables.

## 0.8.1

- Normaliza las rutas de los archivos Lua del `.toc` con separadores `\\`, como usa el cliente 3.3.5a.
- Actualiza la versión visible a 0.8.1.

## 0.8.0

- El arranque usa `PLAYER_LOGIN` para evitar depender del nombre del addon informado durante la carga.
- Añade confirmación de carga y diagnóstico con `/pa debug`.
- Mejora la detección de profesiones en español con y sin tildes.
- Muestra resultado, materiales y cantidad fabricable reportada por el libro de profesión.
- Corrige la búsqueda con acentos, el reinicio de scroll y los detalles de receta obsoletos.
- Actualiza las instrucciones de instalación y diagnóstico para el cliente 3.3.5a.

## 0.7.0

- Importa las recetas conocidas que aparecen en el libro nativo del cliente 3.3.5a.
- Divide profesiones primarias y secundarias sin selección automática.

