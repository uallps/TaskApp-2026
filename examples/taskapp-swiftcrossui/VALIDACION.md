# Validación de TaskApp SwiftUI / SwiftCrossUI

Fecha de ejecución: 22 de octubre de 2026.

## Qué se ha probado

Se usan exactamente los mismos modelos y reglas del paquete Core para las dos interfaces. El escenario de paridad añade una tarea, marca una como completada, elimina otra y desactiva los flags de fechas y prioridades.

### macOS (Apple Silicon)

- Swift 6.3.3, Xcode 26.6.
- Core: 5 pruebas XCTest superadas.
- SwiftUI: compilación correcta y proceso gráfico vivo durante 4 segundos.
- SwiftCrossUI 0.9.0, backend AppKit: compilación correcta y proceso gráfico vivo durante 4 segundos.
- SHA-256 del JSON del escenario: 20f6de48fa2bebcab167f80663954b813883a1247dc4221a29766140dfcbe4a4.

### Linux x86_64 (Debian 13)

- Swift 6.2.1.
- Core: 5 pruebas XCTest superadas.
- SHA-256 del mismo JSON: 20f6de48fa2bebcab167f80663954b813883a1247dc4221a29766140dfcbe4a4.
- La interfaz SwiftCrossUI no se compiló en este contenedor: faltaba GTK4 y este entorno no tenía resolución DNS.

### Linux ARM64 (Docker sobre el Mac)

- Imagen swift:6.2-jammy, Swift 6.2.4, GTK 4.6.9.
- Core: 5 pruebas XCTest superadas.
- SHA-256 del JSON: 20f6de48fa2bebcab167f80663954b813883a1247dc4221a29766140dfcbe4a4.
- SwiftCrossUI + GtkBackend: compilación correcta usando SwiftPM con la opción --disable-index-store y directorio de compilación separado .build-linux.
- Prueba gráfica de arranque: xvfb-run con X11 y timeout de 9 segundos; el proceso permaneció en ejecución hasta terminarlo intencionadamente (código 124). No hubo salida de error.
- Se ha capturado la ventana real GTK4 dentro de Xvfb con Openbox, ampliada a 1030 x 650 para hacer visibles las tres tareas y sus botones.
- Se instaló GTK4 en un contenedor de prueba; no se cambió la instalación del host.

## Qué significa y qué no significa

El hash idéntico prueba que el escenario de operaciones del núcleo devuelve exactamente la misma información en macOS y Linux (tanto x86_64 como ARM64).

La compilación y el arranque de SwiftUI y SwiftCrossUI prueban que las aplicaciones se pueden construir y lanzar con esos entornos. No constituyen una prueba automatizada completa de pulsación de botones, accesibilidad o igualdad visual de las ventanas. Tampoco se espera igualdad píxel a píxel: los backends son distintos (SwiftUI/AppKit frente a GTK4).

Las tres capturas reales se encuentran en `screenshots/` y están enlazadas desde el README: SwiftUI/macOS, SwiftCrossUI/AppKit y SwiftCrossUI/GTK4. Son evidencias visuales de las mismas tareas, estados, fechas, prioridades y controles en el arranque; no equivalen a una prueba de interacción.

Para terminar una comparación funcional de ventanas conviene interactuar manualmente con ambas siguiendo el checklist del README: añadir, completar, borrar y alternar los dos flags.

## Alcance exacto

Este ejemplo demuestra el subconjunto inicial de TaskApp (lista de tareas + operaciones básicas + dos flags). No es una migración completa del proyecto histórico TaskApp Pro: quedan fuera plugins, navegación avanzada y persistencia.
