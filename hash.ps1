cd "D:\hash_ps1\analyse\"
dir
$fichier = Read-Host "Enter the file path"
$hash = (Get-FileHash -Algorithm SHA256 "LOIC-1.0.8-binary.zip").Hash
$hash = (Get-FileHash -Algorithm SHA512 $fichier).Hash
$hashtotal = (Get-FileHash -Algorithm SHA256 $fichier).Hash
Write-Host sha512>>$hash
Write-Host sha256>>$hashtotal
#Start-Process "https://www.virustotal.com/gui/file/$hashtotal"
pause