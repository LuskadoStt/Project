$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$saida = Join-Path $repo 'qa-artifacts'
$extraido = Join-Path $saida 'jogo'
New-Item -ItemType Directory -Force -Path $saida | Out-Null
Expand-Archive -LiteralPath (Join-Path $repo 'Museu-Marco-Zero-Windows.zip') -DestinationPath $extraido -Force
$exe = Get-ChildItem -LiteralPath $extraido -Recurse -Filter 'new_blank.exe' | Select-Object -First 1
if ($null -eq $exe) { $exe = Get-ChildItem -LiteralPath $extraido -Recurse -Filter '*.exe' | Select-Object -First 1 }
if ($null -eq $exe) { throw 'O pacote Windows não contém executável para o teste.' }
# O argumento opt-in inicia o roteiro automatizado, sem alterar saves de uma sessão normal.
$processo = Start-Process -FilePath $exe.FullName -ArgumentList '--qa-cutscene' -WorkingDirectory $exe.DirectoryName -PassThru
$terminou = $processo.WaitForExit(150000)
if (-not $terminou) {
    # Captura o desktop do runner para diagnosticar eventuais diálogos de erro.
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    $tela = [System.Windows.Forms.SystemInformation]::VirtualScreen
    $bitmap = New-Object System.Drawing.Bitmap($tela.Width, $tela.Height)
    $grafico = [System.Drawing.Graphics]::FromImage($bitmap)
    $grafico.CopyFromScreen($tela.Location, [System.Drawing.Point]::Empty, $tela.Size)
    $bitmap.Save((Join-Path $saida 'timeout-desktop.png'))
    $grafico.Dispose()
    $bitmap.Dispose()
    Stop-Process -Id $processo.Id -Force
    throw 'Timeout: o jogo não finalizou o teste em 150 segundos. Consulte a captura do runner.'
}
# O sandbox GameMaker grava o relatório na área de dados do jogo.
$pastas = @($extraido, $env:LOCALAPPDATA, $env:APPDATA, $env:TEMP)
$relatorio = $null
foreach ($pasta in $pastas) {
    if (Test-Path -LiteralPath $pasta) {
        $relatorio = Get-ChildItem -LiteralPath $pasta -Recurse -Filter 'qa_resultado_etapa2.json' -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($null -ne $relatorio) { break }
    }
}
if ($null -eq $relatorio) { throw "O executável terminou (exit code $($processo.ExitCode)), mas não produziu o relatório de QA." }
Copy-Item -LiteralPath $relatorio.FullName -Destination (Join-Path $saida 'qa_resultado_etapa2.json')
foreach ($foto in @('qa_museu_etapa2.png', 'qa_praca_etapa2.png')) {
    $arquivo = Join-Path $relatorio.DirectoryName $foto
    if (Test-Path -LiteralPath $arquivo) { Copy-Item -LiteralPath $arquivo -Destination (Join-Path $saida $foto) }
}
$resultado = Get-Content -LiteralPath $relatorio.FullName -Raw | ConvertFrom-Json
Write-Output ($resultado | ConvertTo-Json -Depth 10)
if ($resultado.aprovado -ne $true) { throw 'O relatório do jogo contém falhas. Consulte qa_resultado_etapa2.json.' }
if ($processo.ExitCode -ne 0) { throw "O jogo terminou com exit code $($processo.ExitCode)." }
# A pasta do jogo extraído não é necessária como evidência; o pacote compilado é outro artifact.
Remove-Item -LiteralPath $extraido -Recurse -Force
