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
$ sudo pacman -S python python-pipenv
$ pipenv install
$ ansible-playbook -K setup.py
```


### Yubikey

In order for gpg to work with my Yubikey, I need to download my public key
first: `gpg --recv-keys 0x1e85134124cf4a6f`


## Resources

* [User:Altercation/Bullet Proof Arch Install](https://wiki.archlinux.org/index.php/User:Altercation/Bullet_Proof_Arch_Install)
