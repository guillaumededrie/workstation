# Workstation [![Build Status](https://travis-ci.org/guillaumededrie/workstation.svg?branch=master)](https://travis-ci.org/guillaumededrie/workstation)

All I need for my workstation.


## Todolist

* [ ] Explain, command by command, how I install my workstation
* [ ] Take a look at [Security - ArchWiki](https://wiki.archlinux.org/index.php/Security)


## Installation

### Install Archlinux Base

TO BE COMPLETED.

Add your user to the following [User groups](https://wiki.archlinux.org/title/users_and_groups#User_groups):
  - `log`
  - `wheel`


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


#### PAM Support with U2F

To authenticate with the Yubikey (with PIN and without touching it)

```bash
$ ykman fido access change-pin # To add a pin
$ export $YUBICO_CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
$ mkdir "$YUBICO_CONF_DIR/Yubico/"
$ pamu2fcfg --pin-verification --no-user-presence > "$YUBICO_CONF_DIR/u2f_keys"
```

Then modify `/etc/pam.d/system-auth`:
```diff
  #%PAM-1.0

  auth       required                    pam_faillock.so      preauth
  # Optionally use requisite above if you do not want to prompt for the password
  # on locked accounts.
  -auth      [success=2 default=ignore]  pam_systemd_home.so
+ auth sufficient pam_u2f.so nouserok userpresence=0
  auth       [success=1 default=bad]     pam_unix.so          try_first_pass nullok
  auth       [default=die]               pam_faillock.so      authfail
  auth       optional                    pam_permit.so
  auth       required                    pam_env.so
  auth       required                    pam_faillock.so      authsucc
  # If you drop the above call to pam_faillock.so the lock will be done also
  # on non-consecutive authentication failures.

  -account   [success=1 default=ignore]  pam_systemd_home.so
  account    required                    pam_unix.so
  account    optional                    pam_permit.so
  account    required                    pam_time.so

  -password  [success=1 default=ignore]  pam_systemd_home.so
  password   required                    pam_unix.so          try_first_pass nullok shadow sha512
  password   optional                    pam_permit.so

  -session   optional                    pam_systemd_home.so
  session    required                    pam_limits.so
  session    required                    pam_unix.so
  session    optional                    pam_permit.so
```

See:
  - [pam-u2f](https://developers.yubico.com/pam-u2f/)
  - [Linux user authentication with PAM](https://wiki.archlinux.org/title/YubiKey#Linux_user_authentication_with_PAM)


## Resources

* [User:Altercation/Bullet Proof Arch Install](https://wiki.archlinux.org/index.php/User:Altercation/Bullet_Proof_Arch_Install)
