#!/bin/bash
# YubiKey touch (pam_u2f / FIDO U2F) for sudo, polkit dialogs (1Password's
# "Unlock using system authentication", pkexec) and the scrogson.lock lock
# screen. The password keeps working everywhere as the fallback.
#
# Safe to re-run: it skips keys and PAM lines that are already in place.
# Any FIDO U2F/FIDO2 key works (YubiKey 4, 5, Bio, Security Key).
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
keys="$HOME/.config/Yubico/u2f_keys"
u2f='auth       sufficient   pam_u2f.so cue'

echo "==> Installing pam-u2f"
# pam-u2f also ships a polkit-agent-helper drop-in that lets polkit reach the key.
sudo pacman -S --needed --noconfirm pam-u2f libfido2

echo "==> Registering keys in $keys"
mkdir -p "$(dirname "$keys")"
chmod 700 "$(dirname "$keys")"
if [[ -s $keys ]]; then
  echo "    $(awk -F: '{print NF-1}' "$keys") key(s) already registered."
fi
# pamu2fcfg can't pick a key, so register them one at a time.
while true; do
  read -rp "    Plug in ONE key to register (unplug the others) and press Enter, or type q to finish: " answer
  [[ $answer == q* ]] && break
  if [[ $(fido2-token -L | wc -l) -ne 1 ]]; then
    echo "    Found $(fido2-token -L | wc -l) keys; plug in exactly one."
    continue
  fi
  echo "    Touch the key when it blinks."
  if [[ -s $keys ]]; then
    cred=$(pamu2fcfg -n) || { echo "    Registration failed; try again."; continue; }
    line="$(tr -d '\n' < "$keys")$cred"
  else
    line=$(pamu2fcfg) || { echo "    Registration failed; try again."; continue; }
  fi
  printf '%s\n' "$line" > "$keys.tmp"
  chmod 600 "$keys.tmp"
  mv "$keys.tmp" "$keys"
  echo "    Registered. $(awk -F: '{print NF-1}' "$keys") key(s) total."
done
if [[ ! -s $keys ]]; then
  echo "No keys registered; stopping before changing PAM." >&2
  exit 1
fi

echo "==> sudo"
if ! sudo grep -q pam_u2f /etc/pam.d/sudo; then
  sudo cp -a /etc/pam.d/sudo "/etc/pam.d/sudo.bak.$(date +%s)"
  sudo sed -i "/^#%PAM-1.0/a $u2f" /etc/pam.d/sudo
fi

echo "==> polkit (1Password system unlock, pkexec)"
sudo install -m 644 "$here/pam.d/polkit-1" /etc/pam.d/polkit-1

echo "==> Lock screen (scrogson.lock touch-to-unlock)"
# The plugin loops on this PAM service while a YubiKey is plugged in. Omarchy
# never rewrites it, so it survives updates.
sudo install -m 644 "$here/pam.d/omarchy-lock-yubikey" /etc/pam.d/omarchy-lock-yubikey
# Keep the password field password-only so it doesn't compete with the loop.
if [[ -f /etc/pam.d/omarchy-lock-password ]]; then
  sudo sed -i '/pam_u2f/d' /etc/pam.d/omarchy-lock-password
fi

# Clean up the old pam_yubico (challenge-response) setup if it is present.
if sudo grep -q pam_yubico /etc/pam.d/sudo; then
  sudo sed -i '/pam_yubico/d' /etc/pam.d/sudo
fi
if [[ -f /etc/systemd/system/polkit-agent-helper@.service.d/yubikey.conf ]]; then
  sudo rm /etc/systemd/system/polkit-agent-helper@.service.d/yubikey.conf
  sudo rmdir --ignore-fail-on-non-empty /etc/systemd/system/polkit-agent-helper@.service.d
  sudo systemctl daemon-reload
fi

cat <<'DONE'

Done. Test in a NEW terminal (keep this one open until it works):
  sudo -k && sudo true        # "Please touch the device."
Then lock the screen and touch the key.

1Password: Settings > Security > "Unlock using system authentication".

With several keys plugged in at once, pam_u2f only asks the first one listed
in ~/.config/Yubico/u2f_keys.
DONE
