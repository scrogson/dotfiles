#!/usr/bin/env bash
set -euo pipefail

# Restore ~/.claude from an external volume. Counterpart to backup-claude.sh.
#
# This is NOT just the backup with the arguments swapped. Going FAT32 -> APFS
# has to undo what FAT32 did to the data on the way out:
#
#   permissions  FAT32 has no mode bits; it reports whatever the mount says
#                (everything looks 0700). Restored files would come back with
#                the wrong modes, so we fix them explicitly afterwards.
#                openrsync's --chmod is no help: it rejects F644-style modes
#                and silently ignores the symbolic ones it does accept.
#   symlinks     backup-claude.sh dereferences them (-L), so skills/ is real
#                directories on the volume, not links into ~/.agents. See below.
#
# Never passes --delete: a restore should not be able to destroy local data.

DEST_VOLUME="${1:-/Volumes/ENIGMA}"
if [ $# -gt 0 ]; then shift; fi

SRC="$DEST_VOLUME/.claude"
DEST="$HOME/.claude"

if [ ! -d "$SRC" ]; then
  echo "error: no backup at $SRC" >&2
  exit 1
fi

# Restoring underneath a live session invites half-written state.
if pgrep -qx claude 2>/dev/null; then
  echo "warning: Claude Code appears to be running." >&2
  echo "         Quit it first, or files may be overwritten mid-write." >&2
  echo "         Continuing in 5s -- ^C to abort." >&2
  sleep 5
fi

rsync_args=(-rt --modify-window=1 --stats --exclude '.DS_Store' --exclude '._*')

# skills/ on the volume are dereferenced copies. If this machine already has
# the symlink farm, restoring would replace live links with stale copies --
# so leave it alone and let ~/.agents keep owning them.
if [ -d "$DEST/skills" ]; then
  echo "==> skills/ exists locally; leaving it untouched (backup holds copies,"
  echo "    not the ~/.agents symlinks). Delete it first to restore from backup."
  rsync_args+=(--exclude '/skills/')
fi

echo "==> Restoring $SRC -> $DEST"
rsync "${rsync_args[@]}" "$@" "$SRC/" "$DEST/"

# Undo FAT32's flat permissions. Skipped on a dry run, which writes nothing.
case " $* " in
  *" --dry-run "*|*" -n "*) ;;
  *)
    echo "==> Fixing permissions"
    find "$DEST" -type d -exec chmod 755 {} +
    find "$DEST" -type f -exec chmod 644 {} +
    find "$DEST" -type f -name '*.sh' -exec chmod 755 {} +
    [ -f "$DEST/settings.json" ] && chmod 600 "$DEST/settings.json"
    ;;
esac

echo "==> Done"
echo
echo "Not in the backup (regenerated on demand): agent-sdk-venv, plugin cache,"
echo "file-history, image/paste caches. Plugins re-fetch on first run."
