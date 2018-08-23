#!/usr/bin/sh
# This script installs ArchLinux to my taste.

set -e

trap abort INT

abort() {
  exit 1
}

fatal() {
  echo "$1" >&2
  exit 1
}

if [ $# -ne 2 ]; then
  fatal "Usage: ${0} <HOSTNAME> <BLOCK_DEVICE>"
fi

if [ "$(hostname)" != 'archiso' ]; then
  fatal "ERROR: this script is meant to be run on ArchLinux Live ISO"
fi

if ! ls /sys/firmware/efi > /dev/null 2>&1; then
  fatal "ERROR: this script only works on EFI-booted systems"
fi

BLOCK_DEVICE="$1"

if ! blkid "$BLOCK_DEVICE" > /dev/null 2>&1; then
  fatal "ERROR: could not find given block device '${BLOCK_DEVICE}'"
fi

BLOCK_DEVICE_PREFIX="${BLOCK_DEVICE}"

if [ "${BLOCK_DEVICE:0:9}" == '/dev/nvme' ]; then
  BLOCK_DEVICE_PREFIX="${BLOCK_DEVICE}p"
fi

echo 'Preparing installation.'

loadkeys fr

timedatectl set-timezone Europe/Paris
timedatectl set-ntp true

echo 'Partitioning disks.'

parted -sa opt "$BLOCK_DEVICE" \
  mklabel GPT \
  mkpart primary 0% 512M \
  set 1 boot on \
  mkpart primary 512M 100%

echo 'Creating filesystems.'

mkfs.vfat "${BLOCK_DEVICE}1"

cryptsetup --type luks2 luksFormat -q -h sha512 -c aes-xts-plain64 -s 512 "${BLOCK_DEVICE}2"
cryptsetup open "${BLOCK_DEVICE}2" root
mkfs.btrfs /dev/mapper/root

echo 'Creating btrfs subvolumes.'

mount /dev/mapper/root /mnt
mkdir /mnt/{@live,@transient}

btrfs subvolume create /mnt/@live/@rootfs
btrfs subvolume create /mnt/@live/home
btrfs subvolume create /mnt/@live/var.lib
btrfs subvolume create /mnt/@live/srv

umount /mnt

echo 'Mouting rootfs.'

mount -o compress=zstd,subvol=@live/@rootfs /dev/mapper/root /mnt

mkdir -p /mnt/{boot,home,var/lib,srv}
mount "${BLOCK_DEVICE}1" /mnt/boot
mount -o compress=zstd,subvol=@live/home /dev/mapper/root /mnt/home
mount -o compress=zstd,subvol=@live/var.lib /dev/mapper/root /mnt/var/lib
mount -o compress=zstd,subvol=@live/srv /dev/mapper/root /mnt/srv

echo 'Installing base system.'

pacstrap /mnt base base-devel

genfstab -U /mnt > /mnt/etc/fstab

function acr() {
  arch-chroot /mnt $@
}

echo 'Configuring system.'

acr ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
acr hwclock --systohc

echo 'en_US.UTF-8 UTF-8' > /mnt/etc/locale.gen
echo 'LANG=en_US.UTF-8' > /mnt/etc/locale.conf
echo 'KEYMAP=fr' > /mnt/etc/vconsole.conf

acr locale-gen

echo "$HOSTNAME" > /mnt/etc/hostname

cat > /mnt/etc/hosts <<-EOF
127.0.0.1 localhost.localdomain localhost
::1       localhost.localdomain localhost

127.0.1.1 $HOSTNAME
EOF

acr pacman -Sq --noconfirm sudo iwd vim stow

cat > /mnt/etc/sudoers <<-EOF
Defaults passprompt = "%p>%U: "
Defaults env_reset
Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

Defaults env_keep += "SSH_AGENT_PID"
Defaults env_keep += "SSH_AUTH_SOCK"

root    ALL=(ALL) ALL

%wheel ALL=(ALL) NOPASSWD: ALL

#includedir /etc/sudoers.d
EOF

acr mv /root /home/root
acr ln -s /home/root /root

acr passwd root

echo 'Configuring kernel and initramfs.'

acr pacman -Sq --noconfirm btrfs-progs

cat > /mnt/etc/mkinitcpio.conf <<-EOF
MODULES=""
BINARIES=""
FILES=""
HOOKS="base udev autodetect modconf block encrypt filesystems keyboard btrfs"
EOF

acr mkinitcpio -p linux

echo 'Configuring bootloader'

acr bootctl install

cat > /mnt/boot/loader/entries/archlinux.conf <<-EOF
title ArchLinux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options cryptdevice="${BLOCK_DEVICE}2:root" root=/dev/mapper/root rootflags=compress=zstd,subvol=@live/@rootfs add_efi_memmap
EOF

umount -R /mnt
