# Sesión 3 — Modelado de características de TaskApp Pro

El núcleo obligatorio de la línea de productos es **título** y
**estado completada/pendiente**. La fecha de vencimiento y la prioridad son
opcionales, por lo que el tipo `Task` emplea `Date?` y `Priority?`.

El diagrama [FEATURE_MODEL.puml](FEATURE_MODEL.puml) muestra además:
- *Recordatorios* como opción que requiere fecha de vencimiento;
- *Persistencia* como decisión obligatoria con alternativas JSON y Core Data /
  SwiftData (ejemplo histórico de XOR).

En esta versión solo se **modelan** las features; ni los recordatorios ni
la persistencia alternativa están implementados. No confundimos campos
opcionales de Swift con activar/desactivar una feature completa: eso
se trabajará en la **sesión 4**.

La vista de saludo de la sesión 2 sigue compilando. En la sesión 4 la
reemplazaremos por la lista de tareas.
