# Workstation [![Build Status](https://travis-ci.org/guillaumededrie/workstation.svg?branch=master)](https://travis-ci.org/guillaumededrie/workstation)

All I need for my workstation.


## Todolist

* [ ] Explain, command by command, how I install my workstation
* [ ] Take a look at [Security - ArchWiki](https://wiki.archlinux.org/index.php/Security)


## Installation

### Install Archlinux Base

TO BE COMPLETED.


### Install and configure environment

```bash
  # Install tools for Ansible installation
$ sudo pacman -S python-pipenv
$ pipenv install --dev
$ pipenv run ansible-galaxy collection install -r ansible-galaxy-requirements.yml
$ pipenv run ./setup.yml

  # To get the list of available tags
$ pipenv run ./setup.yml --list-tags

  # To launch only a specific tag
$ pipenv run ./setup.yml --tags <TAG>
```


### Yubikey

In order for gpg to work with my Yubikey, I need to download my public key
first: `gpg --recv-keys 0x1e85134124cf4a6f`

Then, check the status with `gpg --card-status`


## Resources

* [User:Altercation/Bullet Proof Arch Install](https://wiki.archlinux.org/index.php/User:Altercation/Bullet_Proof_Arch_Install)
