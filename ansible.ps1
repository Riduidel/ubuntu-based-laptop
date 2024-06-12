$defaultKeepass = "$env:USERPROFILE\Cozy Drive\personnel.kdbx"
if (!($keepassDatabase = Read-Host "Quelle base Keepass utiliser? [$defaultKeepass]")) { $keepassDatabase = $defaultKeepass }

$securedMasterPassword = Read-Host -AsSecureString "Quel est le mot de passe?"

$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securedMasterPassword)
$masterPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)

# then free up the unmanged memory afterwards (thank to dimizuno)
[Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)

# Now build the KPScript commands
$readQnapPassword = "KPScript.exe `"$keepassDatabase`" -pw:`"$masterPassword`" -c:GetEntryString -Field:Password -ref-Title:`"QNAP`" -ref-UserName:admin"
$readRaspPassword = "KPScript.exe `"$keepassDatabase`" -pw:`"$masterPassword`" -c:GetEntryString -Field:Password -ref-Title:`"Raspberry`" -ref-UserName:pi"
$readNextCloudDBPassword = "KPScript.exe `"$keepassDatabase`" -pw:`"$masterPassword`" -c:GetEntryString -Field:Password -ref-Title:`"NextCloud MySQL DB`" -ref-UserName:nextcloud"

$qnapResult = Invoke-Expression $readQnapPassword
$raspResult = Invoke-Expression $readRaspPassword
$nextCloudDBResult = Invoke-Expression $readNextCloudDBPassword

$qnap = $qnapResult.Split([Environment]::NewLine) | Select -First 1
$rasp = $raspResult.Split([Environment]::NewLine) | Select -First 1
$nextCloudDB = $nextCloudDBResult.Split([Environment]::NewLine) | Select -First 1

$currentFolder = Get-Location
# Finally start the docker image!
$docker = "docker run --rm --name ansible -t -i -e QNAP_PASSWORD=`"$qnap`" -e RASPBIAN_PASSWORD=`"$rasp`" -e NEXTCLOUD_DB_PASSWORD=`"$nextCloudDB`" -v $currentFolder/ansible:/ansible willhallonline/ansible:2.13-ubuntu-22.04 /bin/bash"

Invoke-Expression $docker