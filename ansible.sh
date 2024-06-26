#!/bin/sh

defaultKeepass=$HOME/kDrive/personnel.kdbx
read -p  "Quelle base Keepass utiliser? [$defaultKeepass]" keepass
keepass={keepass:-$defaultKeepass}

stty -echo
read -p "Keepass master password: " password
stty echo
printf '\n'


defaultZorinUser="nicolas-delsaux"
read -p  "Quel est l'utilisateur Linux? [$defaultZorinUser]" zorinUser
zorinUser={zorinUser:-$defaultKeepass}

# Now read values from keepassxc database
# keepassxc command-line is obviously slightly different

zorinPassword=$(echo $password | keepassxc-cli show $keepass "Portable Dell" --show-protected --quiet --attributes password)
kdrivePassword=$(echo $password | keepassxc-cli show $keepass "Infomaniak" --show-protected --quiet --attributes password)

currentFolder=${PWD}
# Finally start the docker image!
docker="docker run --rm --name ansible -t -i -e ZORIN_PASSWORD=\"$zorinPassword\" -e KDRIVE_PASSWORD=\"$kdrivePassword\" -v $currentFolder/ansible:/ansible:ro willhallonline/ansible:2.16.4-bookworm-slim /bin/bash"

sudo bash -c "$docker"
