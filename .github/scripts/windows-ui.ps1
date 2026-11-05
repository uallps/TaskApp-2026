# Prueba de interfaz en Windows: arranca la app, pulsa los controles y guarda
# capturas y la lista de controles en shots/.
# Los textos de las filas son controles Static (se buscan por texto); los botones
# con estilo los dibuja SwiftOpenUI (Direct2D). La ventana se coloca siempre en
# (0,0) con 900x700.
. "$PSScriptRoot/ui.ps1"
$bin = swift build --product TaskApp --show-bin-path
$app = Start-App "$bin\TaskApp.exe" "taskapp"
if ($app.HasExited) { throw "La app se ha cerrado al arrancar" }
$w = Get-AppWindow $app.Id
Snap $w "1-inicio"

function Count-Text([string]$text) { @(Get-Controls $w | Where-Object { $_.Text -eq $text }).Count }

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

# Marcar desde la fila no debe abrir el detalle.
Click-Toggle "Publicar materiales"; Snap $w "2-tercera-marcada"
if ((Count-Text "Publicar materiales") -ne 1) { throw "Al marcar la fila se ha salido de la lista" }

# Borrar con el menú contextual: clic derecho y primera opción.
if (-not (Click-Text $w "Publicar materiales" -Right)) { throw "No está la fila Publicar materiales" }
Snap $w "2b-menu"; Send-Text "{DOWN}{ENTER}"; Snap $w "2c-borrada"
if ((Count-Text "Publicar materiales") -ne 0) { throw "La tarea no se ha borrado" }

# Entrar en el detalle de «Revisar prácticas», cambiar el título y marcarla.
if (-not (Click-Text $w "Revisar prácticas")) { throw "No está la fila Revisar prácticas" }
Snap $w "3-detalle"
if (-not (Click-Class $w "Edit")) { throw "El detalle no tiene campo de título" }
Send-Text "^a"; Send-Text "Revisar prácticas de LPS"
if (-not (Click-Text $w "Completada")) { Write-Host "Completada no es un control con texto" }
Snap $w "4-detalle-editado"

# Volver y comprobar que la lista muestra el título nuevo.
if (-not (Click-Text $w "← Back")) { if (-not (Click-Text $w "Back")) { throw "No hay botón para volver" } }
Snap $w "5-lista-tras-volver"
if ((Count-Text "Revisar prácticas de LPS") -ne 1) { throw "La lista no muestra el título editado" }

if ($app.HasExited) { throw "La app se ha cerrado durante la prueba" }
Stop-Process -Id $app.Id -Force
Write-Host "Prueba de Windows superada"
