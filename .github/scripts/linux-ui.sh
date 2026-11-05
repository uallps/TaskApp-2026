#!/bin/bash
# Prueba de interfaz en Linux: pantalla virtual (Xvfb), clics con xdotool y capturas en shots/.
# Sin gestor de ventanas, la ventana (800x600) queda en la esquina superior izquierda.
set -u
mkdir -p shots
export DISPLAY=:99 GDK_BACKEND=x11 GSK_RENDERER=cairo LANG=C.UTF-8 LC_ALL=C.UTF-8
Xvfb :99 -screen 0 1280x800x24 2>/dev/null &
sleep 2
"$(swift build --product TaskApp --show-bin-path)/TaskApp" > shots/app.log 2>&1 &
APP=$!
sleep 5

shot()  { import -window root "shots/$1.png"; echo "captura: shots/$1.png"; }
click() { xdotool mousemove "$1" "$2" click 1; sleep 1; }
alive() { kill -0 $APP 2>/dev/null || { echo "La app se ha cerrado"; cat shots/app.log; exit 1; }; }

alive; shot 1-inicio

# Sesión 3: marcar la primera tarea, añadir dos y marcar la tercera.
click 29 24;   shot 2-primera-marcada
click 400 575; click 400 575; shot 3-dos-anadidas
click 29 122;  shot 4-tercera-marcada
click 29 122;  shot 5-tercera-desmarcada

alive
kill $APP
