#!/bin/sh

defaultKeepass=$HOME/kDrive/personnel.kdbx
read -p  "Quelle base Keepass utiliser? [$defaultKeepass]" keepass
keepass="${keepass:-$defaultKeepass}"

stty -echo
read -p "Quel est le mot de passe de '$keepass'?: " password
stty echo
printf '\n'


DEFAULT_SYSTEM_USER="nicolas-delsaux"
read -p  "Quel est l'utilisateur Linux? [$DEFAULT_SYSTEM_USER]" systemUser
systemUser="${systemUser:-$defaultKeepass}"

# Now read values from keepassxc database
# keepassxc command-line is obviously slightly different

sessionPassword=$(echo "$password" | keepassxc-cli show $keepass "Portable perso" --show-protected --quiet --attributes "password")
kdrivePassword=$(echo "$password" | keepassxc-cli show $keepass "Infomaniak" --show-protected --quiet --attributes "password")

currentFolder=${PWD}
# Finally start the docker image!
# See https://stackoverflow.com/a/36648428 for the ssh socket madness
docker="sudo docker run --rm --name ansible-for-laptop --hostname ansible-for-laptop -t -i -e ANSIBLE_KEEPASS_PSW=\"$password\" --mount type=bind,source=$keepass,target=/keepass.kdbx --mount type=bind,source=$SSH_AUTH_SOCK,target=/ssh-agent --env SSH_AUTH_SOCK=/ssh-agent -e SESSION_PASSWORD=\"$sessionPassword\" -e KDRIVE_PASSWORD=\"$kdrivePassword\" -v $currentFolder/ansible:/ansible:ro willhallonline/ansible:2.18-bookworm-slim /bin/bash"

bash -c "$docker"
