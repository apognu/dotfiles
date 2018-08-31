#!/bin/sh

set -e

GUID=$"$(uuidgen -r | tee sb-guid)"

for KID in PK KEK DB; do
  openssl req -new -x509 \
    -newkey rsa:2048 --days 3650 -nodes -sha256 \
    -subj "/CN=Secure Boot ${KID}/CN=Antoine POPINEAU/O=AppScho/" \
    -keyout ${KID}.key -out ${KID}.pem
  
  openssl x509 -in ${KID}.pem -out ${KID}.cer -outform DER

  cert-to-efi-sig-list -g $GUID ${KID}.crt ${KID}.esl
done

sign-efi-sig-list -t "$(date --date='1 second' +'%Y-%m-%d %H:%M:%S')" -k PK.key -c PK.pem PK PK.esl PK.auth
sign-efi-sig-list -t "$(date --date='1 second' +'%Y-%m-%d %H:%M:%S')" -k PK.key -c PK.pem KEK KEK.esl KEK.auth
sign-efi-sig-list -t "$(date --date='1 second' +'%Y-%m-%d %H:%M:%S')" -k KEK.key -c KEK.pem DB DB.esl DB.auth

sign-efi-sig-list -t "$(date --date='1 second' +'%Y-%m-%d %H:%M:%S')" -k PK.key -c PK.pem PK /dev/null empty.auth

chmod 0400 *.key
