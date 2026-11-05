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
if [ "$VARIANT" = base ]; then
    click 29 66;   shot 2-primera-completada
    click 400 25;  shot 3-sin-fechas
    click 400 575; shot 4-anadida
else
    click 453 25;  shot 2-sin-prioridades
    click 453 25;  shot 3-con-prioridades
    click 29 73;   shot 4-primera-completada
fi
alive
kill $APP
