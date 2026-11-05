#!/bin/bash
# Prueba de interfaz en Linux: pantalla virtual (Xvfb), clics con xdotool y capturas en shots/.
# Sin gestor de ventanas, la ventana (800x600) queda en la esquina superior izquierda.
#   linux-ui.sh               producto base
#   linux-ui.sh Prioridades   producto con el trait Prioridades
set -u
VARIANT=${1:-base}
OUT=shots/$VARIANT
mkdir -p "$OUT"
export DISPLAY=:99 GDK_BACKEND=x11 GSK_RENDERER=cairo LANG=C.UTF-8 LC_ALL=C.UTF-8
pgrep -x Xvfb >/dev/null || { Xvfb :99 -screen 0 1280x800x24 2>/dev/null & sleep 2; }

TRAITS=()
[ "$VARIANT" != base ] && TRAITS=(--traits "$VARIANT")
swift build --product TaskApp "${TRAITS[@]}" || exit 1
"$(swift build --product TaskApp "${TRAITS[@]}" --show-bin-path)/TaskApp" > "$OUT/app.log" 2>&1 &
APP=$!
sleep 5

shot()  { import -window root "$OUT/$1.png"; echo "captura: $OUT/$1.png"; }
click() { xdotool mousemove "$1" "$2" click 1; sleep 1; }
alive() { kill -0 $APP 2>/dev/null || { echo "La app se ha cerrado"; cat "$OUT/app.log"; exit 1; }; }

alive; shot 1-inicio
# Barra de GTK: botones de la barra a la derecha y filas de la lista debajo.
if [ "$VARIANT" = base ]; then
    xdotool mousemove 300 173 click 3; sleep 1          # menú contextual de «Publicar materiales»
    click 300 207; shot 2-tercera-borrada               # Eliminar tarea
    click 300 124; shot 3-detalle                       # abre «Revisar prácticas»
    xdotool type --delay 30 "Revisar prácticas de LPS"  # el título está seleccionado
    click 33 125;  shot 4-detalle-editado               # Completada
    click 42 26;   shot 5-lista-tras-volver             # Back
    click 605 26;  shot 6-anadida                       # Añadir tarea
    click 488 26;  shot 7-sin-fechas                    # Fechas
else
    click 478 26;  shot 2-sin-prioridades
    click 478 26;  shot 3-con-prioridades
    click 34 82;   shot 4-primera-completada
    click 300 67;  shot 5-detalle-primera
    click 42 26;   shot 6-lista-tras-volver
fi
alive
kill $APP
