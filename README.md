# ubuntu-based-laptop

Mon script Ansible pour initialiser mon portable basé sur Ubuntu (actuellement Zorin)

## Prérequis

Le raspberry doit avoir

* Une version d'une dérivée d'Ubuntu récente
* Le compte `nicolas-delsaux` configuré
* Le serveur SSH configuré

## Lancer avec Windows

Il faut d'abord installer Docker.
Dans le dossier `ubuntu-based-server`, lancer la commande **dans PowerShell**

    ansible.ps1

Entrer le mot de passe maître de Keepass

    ssh nicolas-delsaux@192.168.1.157
    ansible-galaxy install -r requirements.yml
    ansible-playbook -i hosts bootstrap.yml --extra-vars="ansible_password=\"$SESSION_PASSWORD\" ansible_become_password=\"$SESSION_PASSWORD\" ansible_ssh_password=\"$SESSION_PASSWORD\"" --ask-vault-pass

Le mot de passe vault est en fait inutile, mais sans ça Ansible demande un fichier vault qui n'existe pas.
Donc quand ANsible le demande, tu peux taper n'importe quelle lettre.

## Lancer avec Linux

Il faut d'abord installer Docker.
Dans le dossier `ubuntu-based-server`, lancer la commande **dans un terminal externe** (parce que VSCode sandboxe les appels à sudo)

    ansible.sh

Entrer le mot de passe maître de Keepass

    mkdir /root/.ssh && ssh-keyscan -t ED25519 192.168.0.14 >> /root/.ssh/known_hosts
    ansible-galaxy install -r requirements.yml
    ansible-playbook -i hosts bootstrap.yml --ask-vault-pass --extra-vars="ansible_password=\"$SESSION_PASSWORD\" ansible_become_password=\"$SESSION_PASSWORD\" ansible_ssh_password=\"$SESSION_PASSWORD\""

## Tracabilité

`ubuntu-based-laptop` est une simplification de https://github.com/rhietala/raspberry-ansible/

`raspbian_bootstrap`-role is heavily based on
[debian_boostrap](https://github.com/HanXHX/ansible-debian-bootstrap) by
[Emilien Mantel](https://twitter.com/hanxhx_) with minor modifications to
suit Raspbian.

## License

GPLv2
