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
BIN="$(swift build --product TaskApp "${TRAITS[@]}" --show-bin-path)/TaskApp"

# Empezar sin datos guardados: tareas (JSON) y ajustes (UserDefaults).
rm -f ~/Documents/tasks.json ~/.config/TaskApp.plist

start() { "$BIN" > "$OUT/app.log" 2>&1 & APP=$!; sleep 5; }
shot()  { import -window root "$OUT/$1.png"; echo "captura: $OUT/$1.png"; }
click() { xdotool mousemove "$1" "$2" click 1; sleep 1; }
alive() { kill -0 $APP 2>/dev/null || { echo "La app se ha cerrado"; cat "$OUT/app.log"; exit 1; }; }

# Barra lateral (Tareas / Ajustes) a la izquierda; la lista, a la derecha.
if [ "$VARIANT" = base ]; then FILA3=173; TITULO2=124; else FILA3=188; TITULO2=131; fi

start; alive; shot 1-inicio
click 285 $FILA3;   shot 2-tercera-marcada
click 360 $TITULO2; shot 3-detalle                      # abre «Revisar prácticas»
xdotool key End; xdotool type --delay 60 " hoy"; sleep 1
shot 4-detalle-editado                                  # sigue en el detalle
click 42 26;        shot 5-lista-tras-volver            # Back
click 77 106;       shot 6-ajustes                      # Ajustes
click 284 100;      shot 7-sin-fechas                   # Mostrar fechas: no
click 77 74;        shot 8-tareas-sin-fechas            # Tareas
alive
kill $APP; sleep 1

# Al volver a abrir se conservan las tareas y los ajustes.
start; alive; shot 9-tras-reiniciar
kill $APP
