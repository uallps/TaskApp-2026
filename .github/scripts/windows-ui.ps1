# Prueba de interfaz en Windows: arranca la app, pulsa los controles y guarda
# capturas y la lista de controles en shots/.
# Los textos de las filas son controles Static (se buscan por texto); los botones
# con estilo los dibuja SwiftOpenUI (Direct2D) y se pulsan por posición: la ventana
# se coloca siempre en (0,0) con 900x700.
. "$PSScriptRoot/ui.ps1"
$bin = swift build --product TaskApp --show-bin-path
$app = Start-App "$bin\TaskApp.exe" "taskapp"
if ($app.HasExited) { throw "La app se ha cerrado al arrancar" }
$w = Get-AppWindow $app.Id
Snap $w "1-inicio"

function Count-Text([string]$text) { @(Get-Controls $w | Where-Object { $_.Text -eq $text }).Count }
function Count-Like([string]$pattern) { @(Get-Controls $w | Where-Object { $_.Text -like $pattern }).Count }

# Clic en el botón de marcar de una fila: el botón es el control a la izquierda del título.
function Click-Toggle([string]$title) {
    $c = Get-Controls $w | Where-Object { $_.Text -eq $title } | Select-Object -First 1
    if (-not $c) { throw "No hay una fila '$title'" }
    # El botón de marcar es pequeño (24 px); la fila entera también es un botón (el enlace).
    $b = Get-Controls $w | Where-Object { $_.Class -eq "SwiftUICustomButton" -and $_.W -le 32 -and $_.X -lt $c.X } |
        Sort-Object { [math]::Abs(($_.Y + $_.H / 2) - ($c.Y + $c.H / 2)) } | Select-Object -First 1
    if (-not $b) { throw "No hay botón de marcar junto a '$title'" }
    Click-At ($b.X + [int]($b.W / 2)) ($b.Y + [int]($b.H / 2))
}

# Marcar la primera tarea y añadir dos.
Click-Toggle "Preparar clase"; Snap $w "2-primera-marcada"
Click-At 450 667; Click-At 450 667; Snap $w "3-dos-anadidas"   # Añadir tarea
$added = Count-Text "Tarea de ejemplo"
Write-Host "Filas 'Tarea de ejemplo': $added"
if ($added -ne 2) { throw "Se esperaban 2 tareas añadidas y hay $added" }

# Sesión 4: el flag de fechas oculta y vuelve a mostrar la fecha de vencimiento.
if ((Count-Like "Vence:*") -ne 1) { throw "Al empezar debería verse una fecha" }
Click-At 450 55; Snap $w "4-sin-fechas"                         # Fechas: Sí
if ((Count-Like "Vence:*") -ne 0) { throw "Con el flag apagado no debería verse ninguna fecha" }
Click-At 450 55; Snap $w "5-con-fechas"                         # Fechas: No
if ((Count-Like "Vence:*") -ne 1) { throw "Al volver a encender el flag debería verse la fecha" }

if ($app.HasExited) { throw "La app se ha cerrado durante la prueba" }
Stop-Process -Id $app.Id -Force
Write-Host "Prueba de Windows superada"
