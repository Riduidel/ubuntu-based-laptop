# ubuntu-based-laptop

Mon script Ansible pour initialiser mon portable basé sur Ubuntu (actuellement Zorin)

## Prérequis

Le raspberry doit avoir

* Une version d'une dérivée d'Ubuntu récente
* Le compte `nicolas` configuré
* Le serveur SSH configuré

## Lancer avec Windows

Il faut d'abord installer Docker.
Dans le dossier `ubuntu-based-server`, lancer la commande **dans PowerShell**

    ansible.ps1

Entrer le mot de passe maître de Keepass

    cd /ansible
    ansible-playbook -i hosts bootstrap.yml --extra-vars="TODO"

## Tracabilité

`raspbian-bootstrap` est une simplification de https://github.com/rhietala/raspberry-ansible/

`raspbian_bootstrap`-role is heavily based on
[debian_boostrap](https://github.com/HanXHX/ansible-debian-bootstrap) by
[Emilien Mantel](https://twitter.com/hanxhx_) with minor modifications to
suit Raspbian.

## License

GPLv2
