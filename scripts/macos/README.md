# macOS settings migration

Capture user-level macOS preferences on an old Mac and re-apply them on a new one.

## On the OLD Mac
```bash
cd scripts/macos
./capture.sh
```
This writes:
- `snapshot/*.plist` — full domain exports (backup/reference)
- `restore.sh` — a generated, reviewable script of `defaults write` lines
  populated with your current values, plus keyboard-shortcut imports.

`snapshot/` and `restore.sh` are gitignored (machine-specific). Copy the whole
`scripts/macos/` folder to the new Mac (e.g. AirDrop, USB, scp).

## On the NEW Mac
```bash
cd scripts/macos
less restore.sh   # review first
./restore.sh
```
Restore is cautious: user-level defaults only, no sudo, idempotent, prints every
change, and restarts Dock/Finder/SystemUIServer to apply.

## Not transferable via defaults (do by hand)
Touch ID, Apple ID/iCloud, Wi-Fi/keychain, FileVault, and anything locked by an
MDM/IT configuration profile.

## Which settings are captured
Edit `settings.sh` to add/remove scalar keys or snapshot domains, then re-run
`capture.sh`.
