# Prueba de interfaz en Windows: arranca la app, pulsa los controles y guarda
# capturas y la lista de controles en shots/.
# Los textos son controles Static (se buscan por texto); los botones con estilo
# los dibuja SwiftOpenUI (Direct2D). La ventana se coloca siempre en (0,0) con 900x700.
. "$PSScriptRoot/ui.ps1"
$bin = swift build --product TaskApp --show-bin-path

function Count-Text([string]$text) { @(Get-Controls $w | Where-Object { $_.Text -eq $text }).Count }
function Count-Like([string]$pattern) { @(Get-Controls $w | Where-Object { $_.Text -like $pattern }).Count }

# Clic en el botón de marcar de una fila: el botón pequeño (24 px) a la izquierda del título.
function Click-Toggle([string]$title) {
    $c = Get-Controls $w | Where-Object { $_.Text -eq $title } | Select-Object -First 1
    if (-not $c) { throw "No hay una fila '$title'" }
    $b = Get-Controls $w | Where-Object { $_.Class -eq "SwiftUICustomButton" -and $_.W -le 32 -and $_.X -lt $c.X } |
        Sort-Object { [math]::Abs(($_.Y + $_.H / 2) - ($c.Y + $c.H / 2)) } | Select-Object -First 1
    if (-not $b) { throw "No hay botón de marcar junto a '$title'" }
    Click-At ($b.X + [int]($b.W / 2)) ($b.Y + [int]($b.H / 2))
}

# Clic en una opción de la barra lateral: el texto más a la izquierda con ese nombre
# (el título de la pantalla también puede llamarse igual).
function Click-Sidebar([string]$text) {
    $c = Get-Controls $w | Where-Object { $_.Text -eq $text -or $_.Text -like "* $text" } |
        Sort-Object X | Select-Object -First 1
    if (-not $c) { return $false }
    Click-At ($c.X + [int]($c.W / 2)) ($c.Y + [int]($c.H / 2))
    return $true
}

$app = Start-App "$bin\TaskApp.exe" "taskapp"
if ($app.HasExited) { throw "La app se ha cerrado al arrancar" }
$w = Get-AppWindow $app.Id
Snap $w "1-inicio"
if ((Count-Text "Preparar clase") -ne 1) { throw "No se ve la lista de tareas" }

# Marcar desde la fila no abre el detalle.
Click-Toggle "Publicar materiales"; Snap $w "2-tercera-marcada"
if ((Count-Text "Publicar materiales") -ne 1) { throw "Al marcar la fila se ha salido de la lista" }

# Detalle: escribir no debe volver a la lista (fallo de SwiftOpenUI con @Observable, ya arreglado).
if (-not (Click-Text $w "Revisar prácticas")) { throw "No está la fila Revisar prácticas" }
Snap $w "3-detalle"
if (-not (Click-Class $w "Edit")) { throw "El detalle no tiene campo de título" }
Send-Text "{END} hoy"; Snap $w "4-detalle-editado"
if (-not (Click-Class $w "Edit")) { throw "Al escribir se ha salido del detalle" }
if (-not (Click-Text $w "← Back")) { if (-not (Click-Text $w "Back")) { throw "No hay botón para volver" } }
Snap $w "5-lista-tras-volver"
if ((Count-Text "Revisar prácticas hoy") -ne 1) { throw "La lista no muestra el título editado" }

# Ajustes: apagar las fechas y comprobarlo en la lista.
if ((Count-Like "Vence:*") -ne 1) { throw "Al empezar debería verse una fecha" }
if (-not (Click-Sidebar "Ajustes")) { throw "No está Ajustes en la barra lateral" }
Snap $w "6-ajustes"
if (-not (Click-Text $w "Mostrar fechas de vencimiento")) { throw "No está el ajuste de fechas" }
Snap $w "7-sin-fechas"
if (-not (Click-Sidebar "Tareas")) { throw "No está Tareas en la barra lateral" }
Snap $w "8-tareas-sin-fechas"
if ((Count-Like "Vence:*") -ne 0) { throw "Con el ajuste apagado no debería verse ninguna fecha" }

# Al volver a abrir se conservan las tareas y los ajustes.
Stop-Process -Id $app.Id -Force; Start-Sleep -Seconds 2
$app = Start-App "$bin\TaskApp.exe" "taskapp2"
if ($app.HasExited) { throw "La app se ha cerrado al volver a abrirla" }
$w = Get-AppWindow $app.Id
Snap $w "9-tras-reiniciar"
if ((Count-Text "Revisar prácticas hoy") -ne 1) { throw "No se ha conservado el título editado" }
if ((Count-Like "Vence:*") -ne 0) { throw "No se ha conservado el ajuste de fechas" }

Stop-Process -Id $app.Id -Force
Write-Host "Prueba de Windows superada"
