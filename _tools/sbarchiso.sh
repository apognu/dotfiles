#!/bin/sh
# This script repackages ArchLinux's ISO to be signed with specific
# Secure Boot keys

set -e

fatal() {
  echo "$1" 2>&1
  exit 1
}

for ELF in bsdtar genisoimage xorriso; do
  if ! which $ELF > /dev/null 2>&1; then
    fatal "ERROR: '${ELF}' should be available on this system."
  fi
done

if [ $# -ne 3 ]; then
  fatal "Usage: $0 <ISO> <DB_CERT> <DB_KEY>"
fi

for FILE in "$1" "$2" "$3"; do
  if ! [ -r "$FILE" ]; then
    fatal "ERROR: could not read '${FILE}'."
  fi
done

OUTDIR="$(pwd)"

ISO="$1"
SB_CERT="$2"
SB_KEY="$3"

VOLID="$(isoinfo -i ${ISO} -d 2> /dev/null | grep 'Volume id:' | awk '{print $3}')"
TMPISO="$(mktemp -d)"
TMPFAT="$(mktemp -d)"

cd $TMPISO
bsdtar -C . -xf "$ISO"

for FILE in $(find . -name '*.efi'); do sbsign --key "$SB_KEY" --cert "$SB_CERT" --output $FILE $FILE; done

mount EFI/archiso/efiboot.img $TMPFAT
cd $TMPFAT
for FILE in $(find . -name '*.efi'); do sbsign --key "$SB_KEY" --cert "$SB_CERT" --output $FILE $FILE; done

cd $TMPISO
umount $TMPFAT

genisoimage -l -r -J \
  -V "$VOLID" \
  -b isolinux/isolinux.bin \
  -no-emul-boot -boot-load-size 4 -boot-info-table -c isolinux/boot.cat \
  -o "${OUTDIR}/archlinux-sb.iso" \
  ./

xorriso -as mkisofs \
  -iso-level 3 -full-iso9660-filenames \
  -volid "$VOLID" \
  -eltorito-boot isolinux/isolinux.bin -eltorito-catalog isolinux/boot.cat \
  -no-emul-boot -boot-load-size 4 -boot-info-table -isohybrid-mbr isolinux/isohdpfx.bin -eltorito-alt-boot \
  -e EFI/archiso/efiboot.img \
  -no-emul-boot -isohybrid-gpt-basdat -output "${OUTDIR}/archlinux-sb.iso" $TMPISO

cd /

rm -rf $TMPISO
rm -rf $TMPFAT
