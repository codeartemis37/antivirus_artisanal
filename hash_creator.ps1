cd ".\analyse\"
dir
$fichier = Read-Host "Enter the file path"
$hashtotal = (Get-FileHash -Algorithm SHA256 $fichier).Hash
Write-Host sha256>>$hashtotal
pause
