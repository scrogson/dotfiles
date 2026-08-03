#!/usr/bin/env bash
set -euo pipefail

# Back up ~/.claude to an external volume.
#
# The target is FAT32, which drives most of the flag choices below:
#   -L               FAT32 can't store symlinks (skills/ has ~40 into ~/.agents),
#                    so follow them and copy the real content.
#   --modify-window=1  FAT32 timestamps have 2s granularity. Without this every
#                    file looks modified and the whole tree re-copies each run.
#   no -p/-o/-g      FAT32 has no permission or ownership bits (so no -a).

# First arg is the volume; anything after is passed through to rsync
# (e.g. --dry-run, --delete-excluded).
#
# WARNING: macOS ships openrsync, which only prints "deleting" lines when -v is
# passed. A --delete dry-run without -v reports nothing and looks safe. Always
# preview deletions with: ... --delete --dry-run -v
# Note also that --delete-excluded is a no-op unless --delete is given too.
DEST_VOLUME="${1:-/Volumes/ENIGMA}"
if [ $# -gt 0 ]; then shift; fi

SRC="$HOME/.claude"
DEST="$DEST_VOLUME/.claude"

# Regenerable or machine-local — no point burning space or write cycles.
# Leading '/' anchors to the backup root; an unanchored 'cache/' would also
# match plugins/cache and anything else named cache at any depth.
EXCLUDES=(
  '/security/agent-sdk-venv/'  # ~430M python venv, rebuilt on demand
  '/plugins/cache/'            # ~220M, re-fetched by the plugin loader
  '/file-history/'             # editor undo history
  '/image-cache/'
  '/paste-cache/'
  '/cache/'
  '/session-env/'
  '/shell-snapshots/'
  '/debug/'
  '*.lock'
  '.DS_Store'
  '._*'
)

if [ ! -d "$DEST_VOLUME" ]; then
  echo "error: $DEST_VOLUME is not mounted" >&2
  exit 1
fi

rsync_args=(-rtL --modify-window=1 --stats)
for pattern in "${EXCLUDES[@]}"; do
  rsync_args+=(--exclude "$pattern")
done

echo "==> Backing up $SRC -> $DEST"
rsync "${rsync_args[@]}" "$@" "$SRC/" "$DEST/"

# macOS writes an AppleDouble ._file alongside anything carrying extended
# attributes, because FAT32 can't store xattrs natively. The rsync --exclude
# only stops us copying them; it can't stop the OS creating them on write, so
# they come back every run (~3.3k / 94M last time). Sweep after the transfer.
# Slow on FAT32 -- it's thousands of tiny unlinks.
case " $* " in
  *" --dry-run "*|*" -n "*) ;;
  *)
    echo "==> Clearing AppleDouble files"
    removed=$(find "$DEST" -name '._*' -type f -print -delete 2>/dev/null | wc -l | tr -d ' ')
    echo "    removed $removed"
    ;;
esac

echo "==> Done"
