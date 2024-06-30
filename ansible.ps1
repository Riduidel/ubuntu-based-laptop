$defaultKeepass = "$env:USERPROFILE\kDrive\personnel.kdbx"
if (!($keepassDatabase = Read-Host "Quelle base Keepass utiliser? [$defaultKeepass]")) { $keepassDatabase = $defaultKeepass }

$securedMasterPassword = Read-Host -AsSecureString "Quel est le mot de passe?"

$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securedMasterPassword)
$masterPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)

# then free up the unmanged memory afterwards (thank to dimizuno)
[Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)

# Now build the KPScript commands
$readZorinPassword = "KPScript.exe `"$keepassDatabase`" -pw:`"$masterPassword`" -c:GetEntryString -Field:Password -ref-Title:`"Portable Dell`""
$zorinPasswordResult = Invoke-Expression $readZorinPassword
$zorinPassword = $zorinPasswordResult.Split([Environment]::NewLine) | Select -First 1

$readkDrivePassword = "KPScript.exe `"$keepassDatabase`" -pw:`"$masterPassword`" -c:GetEntryString -Field:Password -ref-Title:`"Infomaniak`" -ref-UserName:nicolas.delsaux@etik.com"
$kDrivePasswordResult = Invoke-Expression $readkDrivePassword
$kDrivePassword = $kDrivePasswordResult.Split([Environment]::NewLine) | Select -First 1

$currentFolder = Get-Location
# Finally start the docker image!
$docker = "docker run --rm --name ansible -t -i -e ZORIN_PASSWORD=`"$zorinPassword`" -e KDRIVE_PASSWORD=`"$kdrivePassword`" -v $currentFolder/ansible:/ansible:ro willhallonline/ansible:2.16.4-bookworm-slim /bin/bash"

Invoke-Expression $docker