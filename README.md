# Workstation ![Linters](https://github.com/guillaumededrie/workstation/actions/workflows/linters.yml/badge.svg)

All I need for my workstation.


## Todolist

* [ ] Take a look at [Security - ArchWiki](https://wiki.archlinux.org/index.php/Security)


## Installation

### Install Archlinux Base

Disk partitioning and preparation:
```shell
$ pacman -S --needed gdisk
$ lsblk
$ export DISK=/dev/sda
$ sgdisk --zap-all $DISK
$ sgdisk --clear $DISK
$ sgdisk --mbrtogpt $DISK
$ sgdisk --new=1:2048:+512M --typecode=1:ef02 $DISK # /boot - BIOS Boot
$ sgdisk --new=2:0:0 --typecode=2:8309 $DISK # / - Linux LUKS
$ sgdisk --print $DISK
$ sgdisk --verify $DISK

$ cryptsetup open --type plain ${DISK}2 container --key-file /dev/random
$ dd if=/dev/zero of=/dev/mapper/container bs=1M status=progress
$ cryptsetup close container

$ cryptsetup --verify-passphrase --verbose luksFormat ${DISK}2
$ cryptsetup open ${DISK}2 root

$ mkfs.ext4 ${DISK}1
$ mkfs.ext4 /dev/mapper/root

$ mount /dev/mapper/root /mnt
$ mount --mkdir ${DISK}1 /mnt/boot

$ pacman -S reflector
$ reflector --verbose --latest 5 --sort rate --country France --protocol https --save /mnt/etc/pacman.d/mirrorlist
$ pacstrap -K /mnt base linux linux-firmware vim
$ genfstab -U -p /mnt >> /mnt/etc/fstab
```

Follow [Installation guide - ArchWiki#Configure the
system](https://wiki.archlinux.org/title/Installation_guide#Configure_the_system)
and perform the following changes:
  * Use `LANG=en_US.UTF-8` as locale.
  * Add in `/etc/hosts`:
    ```shell
    127.0.1.1 <HOSTNAME>
    127.0.0.1 localhost
    127.0.0.1 localhost.localdomain
    127.0.0.1 local
    255.255.255.255 broadcasthost
    ::1 localhost
    ::1 ip6-localhost
    ::1 ip6-loopback
    fe80::1%lo0 localhost
    ff00::0 ip6-localnet
    ff00::0 ip6-mcastprefix
    ff02::1 ip6-allnodes
    ff02::2 ip6-allrouters
    ff02::3 ip6-allhosts
    0.0.0.0 0.0.0.0
    ```
  * Configure initramfs:
    1. Remove `fallback` from presets (`/etc/mkinitcpio.d/linux.preset`):
      Modify `PRESETS=('default' 'fallback')` into `PRESETS=('default')`
    1. `rm /boot/*-fallback.img`
    1. Use the followings Hooks (`/etc/mkinitcpio.conf`):
      `HOOKS=(base systemd autodetect keyboard sd-vconsole modconf block sd-encrypt filesystems fsck)`
    1. `mkinitcpio -P`
  * Install the appropriate [Microcode](https://wiki.archlinux.org/title/Microcode)
  * Install and configure [SystemD-boot](https://wiki.archlinux.org/title/systemd-boot):
    1. Don't forget to add the [Microcode configuration for Systemd-boot](https://wiki.archlinux.org/title/Microcode#systemd-boot).
  * Install [NetworkManager](https://wiki.archlinux.org/title/NetworkManager): `pacman -S --needed networkmanager`
  * Configure user `me`:
    ```shell
    $ useradd -m -d /home/me -s /bin/bash -G adm,log,wheel me
    $ passwd me
    $ pacman -S sudo
    $ (umask 337 && echo "me ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/10-user-me)
    ```
  * [Installation Guide - ArchWiki#Reboot](https://wiki.archlinux.org/title/Installation_guide#Reboot)
  * Debug…
  * Deactivate `root` authentication:
    Replace `root:<password_hashed>:…` by `root:!:…` in `/etc/shadow`.


### Install and configure environment

```bash
  # Install tools for Ansible installation
$ sudo pacman -S python python-uv
$ uv sync --locked --dev
$ uv run ansible-galaxy collection install -r ansible-galaxy-requirements.yml
$ uv run ./setup.yml

  # To get the list of available tags
$ uv run ./setup.yml --list-tags

  # To launch only a specific tag
$ uv run ./setup.yml --tags <TAG>
```


### Screen

In order to use `autorandr` to automatically load appropriate display settings:

1. First, use `arandr` to configure the display
2. Save the configuration, e.g.: `autorandr --save docked`


### Yubikey

In order for gpg to work with my Yubikey, I need to download my public key
first: `gpg --recv-keys 0x1e85134124cf4a6f`

Then, check the status with `gpg --card-status`


#### PAM Support with U2F

To authenticate with the Yubikey (with PIN and without touching it)

```bash
$ ykman fido access change-pin # To add a pin
$ export YUBICO_CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
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
+ auth       sufficient                  pam_u2f.so           userpresence=0
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

### Update

### Firmwares

```bash
$ fwupdmgr get-devices
$ fwupdmgr refresh
$ fwupdmgr get-updates
$ fwupdmgr update
```

Restart if needed!

### System

> :warning: Take a look at https://www.archlinux.org/ for any important
> information regarding updates. :warning:

```bash
# Preparation
$ sudo reflector --country France --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
$ sudo pacman -Syy
  # NOTE: Update `archlinux-keyring` first as new keys can be required by the
  # full system update.
$ sudo pacman -S archlinux-keyring

# Update
$ sudo pacman -Su
$ paru -Sua
$ vim +PlugUpgrade +PlugUpdate

# Cleanups
$ sudo pacdiff
  # Remove orphan packages.
$ sudo pacman -Rns $(pacman -Qtdq)
$ sudo journalctl --vacuum-time=8d
```

Restart!


## Resources

* [User:Altercation/Bullet Proof Arch Install](https://wiki.archlinux.org/index.php/User:Altercation/Bullet_Proof_Arch_Install)
