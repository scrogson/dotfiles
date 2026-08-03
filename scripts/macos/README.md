# macOS settings migration

Capture user-level macOS preferences on an old Mac and re-apply them on a new one.

## On the OLD Mac
```bash
cd scripts/macos
./capture.sh
```
This writes:
- `restore.sh` — a generated, reviewable script of `defaults write` lines
  populated with your current values, plus keyboard-shortcut imports.
- `snapshot/*.plist` — full domain exports, as XML.

Then commit the result — **git is the transport**:
```bash
git add scripts/macos/restore.sh scripts/macos/snapshot
git commit -m "Recapture macOS settings"
```

`restore.sh` is generated but committed on purpose: it's the only record of the
captured values, and committing it means a new Mac gets them from `git clone`
alone. Of the snapshot exports only `com.apple.symbolichotkeys.plist` is
tracked — it's the one `restore.sh` reads back for keyboard shortcuts. The rest
are bulky backups already covered by `restore.sh`, so they stay local.

Re-run `capture.sh` and commit whenever you change a setting you care about;
the diff shows exactly what moved.

## On the NEW Mac
Already there after `install.sh` (or any `git clone`):
```bash
cd ~/.dotfiles/scripts/macos
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
