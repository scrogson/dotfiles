#!/bin/bash
# YubiKey (slot 2 HMAC-SHA1 challenge-response, touch required) for sudo,
# polkit dialogs (1Password, pkexec) and the scrogson.lock lock screen. The
# password keeps working everywhere as the fallback.
#
# Installs the PAM and systemd files only. Programming the key and creating
# the challenge files need the key and touches, so they are printed at the end.
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)

sudo pacman -S --needed --noconfirm yubikey-personalization yubico-pam

sudo install -m 644 "$here/pam.d/polkit-1" /etc/pam.d/polkit-1
sudo install -m 644 "$here/pam.d/omarchy-lock-yubikey" /etc/pam.d/omarchy-lock-yubikey
sudo install -D -m 644 "$here/systemd/polkit-agent-helper-yubikey.conf" \
  /etc/systemd/system/polkit-agent-helper@.service.d/yubikey.conf
sudo systemctl daemon-reload

line='auth		sufficient	pam_yubico.so mode=challenge-response chalresp_path=/var/yubico'
if ! grep -q pam_yubico /etc/pam.d/sudo; then
  sudo cp -a /etc/pam.d/sudo "/etc/pam.d/sudo.bak.$(date +%s)"
  sudo sed -i "0,/^auth/s//${line//\//\\/}\nauth/" /etc/pam.d/sudo
fi
sudo install -d -m 700 /var/yubico

cat <<'STEPS'

PAM and systemd files installed. Finish with the key plugged in:

  # Only if slot 2 is not already set up -- this erases slot 2:
  ykpersonalize -2 -ochal-resp -ochal-hmac -ohmac-lt64 -ochal-btn-trig -oserial-api-visible

  # Touch the key when it blinks (each command needs one touch):
  ykpamcfg -2                                   # ~/.yubico, for the lock screen
  sudo install -m 600 ~/.yubico/challenge-$(ykinfo -sq) /var/yubico/$USER-$(ykinfo -sq)   # sudo + polkit

Each check needs two touches (pam_yubico verifies, then stores the next challenge).
STEPS
