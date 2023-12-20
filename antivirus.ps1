$datescanfile = Get-Date -Format "dd-MM-yyyy_HH-mm";
$datescanfile = ".\log\log_" + $datescanfile + ".txt";
$directory = ".\analyse";

# Vérifier si le répertoire existe
if (Test-Path $directory -PathType Container) {
    $files = Get-ChildItem -Path $directory -File;
	. .\hashlist.ps1
    function Write-ProgressBar {
        param(
            [int]$Progress,
            [int]$Total
        );
        $Percentage = ($Progress / $Total) * 100;
        Write-Host ("╔" + "═" * $Total + "╗");
        Write-Host ("║" + "#" * $Progress + " " * ($Total - $Progress) + "║ $Percentage%");
        Write-Host ("╚" + "═" * $Total + "╝") -NoNewline;
    };

    Write-Host "╔═════════════════════════╗";
    Write-Host "║                         ║";
    Write-Host "║ antivirus maison ultime ║";
    Write-Host "║                         ║";
    Write-Host "╚═════════════════════════╝";
    Write-Host "appuyez sur entrer pour lancer le scan";
    pause;
    clear;

    $TotalFiles = $files.Count;
    $Progress = 0;

    foreach ($file in $files) {
        $Progress++;
        Write-ProgressBar -Progress $Progress -Total $TotalFiles;
        Write-Host "";
        $hashtest = Get-FileHash -Algorithm SHA512 $file.FullName;
        if ($hashlist.ContainsKey($hashtest.Hash)) {
            Write-Host "$($hashlist[$hashtest.Hash]) detecté dans $($file.Name)";
            Add-Content -Path $datescanfile -Value "hash $($hashtest.Hash) $($hashlist[$hashtest.Hash]) detecté dans $($file.Name)";
        } else {
            Write-Host "virus non détecté dans $($file.Name)";
            Add-Content -Path $datescanfile -Value "hash $($hashtest.Hash) virus non détecté dans $($file.Name)";
        };
        Start-Sleep -Milliseconds 500;
        clear;
    };
} else {
    Write-Host "Le répertoire spécifié n'existe pas.";
};
Write-Host ('nombre de hash de la bdd :'+$hashlist.Count);
Write-Host ('');
type $datescanfile;
pause;
