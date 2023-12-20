$datescanfiles = Get-Date -Format "dd-MM-yyyy_HH-mm"
$datescanfile = ".\log\" + $datescanfiles + ".log"
$detectedatescanfile = ".\log\infecte_" + $datescanfiles + ".log"
$directory = ".\analyse"

# Vérifier si le répertoire existe
if (Test-Path $directory -PathType Container) {
    $files = Get-ChildItem -Path $directory -File
    function Write-ProgressBar {
        param(
            [int]$Progress,
            [int]$Total
        )
        $Percentage = ($Progress / $Total) * 100
        Write-Host ("╔" + "═" * $Total + "╗")
        Write-Host ("║" + "#" * $Progress + " " * ($Total - $Progress) + "║ $Percentage%")
        Write-Host ("╚" + "═" * $Total + "╝") -NoNewline
    }

    Write-Host "╔═════════════════════════╗"
    Write-Host "║                         ║"
    Write-Host "║ antivirus maison ultime ║"
    Write-Host "║                         ║"
    Write-Host "╚═════════════════════════╝"
    Write-Host "appuyez sur entrer pour lancer le scan"
    pause
    clear

    $TotalFiles = $files.Count
    $Progress = 0

    $hashlist = Get-Content "VirusHash.bdd" -ErrorAction SilentlyContinue

    foreach ($file in $files) {
        $Progress++
        Write-ProgressBar -Progress $Progress -Total $TotalFiles
        Write-Host ""
        $hashtest = Get-FileHash -Algorithm SHA256 -Path $file.FullName
        $detected = $false
        foreach ($hash in $hashlist) {
            $hashValue, $threat = $hash -split ":", 2
            if ($hashtest.Hash -eq $hashValue) {
                Write-Host "$($hashtest.Hash) detecté comme $threat dans $($file.Name)"
                Add-Content -Path $datescanfile -Value "$($hashtest.Hash) detecté comme $threat dans $($file.Name)"
				Add-Content -Path $detectedatescanfile -Value "$($hashtest.Hash) detecté comme $threat dans $($file.Name)"
                $detected = $true
                break
            }
        }
        if (-not $detected) {
            Write-Host "$($hashtest.Hash) Aucune menace détectée dans $($file.Name)"
            Add-Content -Path $datescanfile -Value "$($hashtest.Hash) Aucune menace détectée dans $($file.Name)"
        }
        Start-Sleep -Milliseconds 500
        clear
    }
} else {
    Write-Host "Le répertoire spécifié n'existe pas."
}
Write-Host ('nombre de menaces dans la liste :'+$hashlist.Count)
Write-Host ('')
type $datescanfile
pause