#!/usr/bin/env bash
# settings.sh — curated data sourced by capture.sh.
# Declares which domains to snapshot in full, and which scalar keys to
# regenerate as readable `defaults write` lines. Grouped by area.
# Type is one of: bool | int | float | string.

# Domains exported in full to snapshot/ (backup + reference).
SNAPSHOT_DOMAINS=(
  com.apple.dock
  com.apple.finder
  com.apple.screencapture
  com.apple.AppleMultitouchTrackpad
  com.apple.driver.AppleBluetoothMultitouch.trackpad
  com.apple.menuextra.clock
  com.apple.screensaver
  com.apple.symbolichotkeys
  NSGlobalDomain
)

# Curated scalar settings: domain|key|type
SETTINGS=(
  # --- Dock ---
  "com.apple.dock|autohide|bool"
  "com.apple.dock|autohide-time-modifier|float"
  "com.apple.dock|autohide-delay|float"
  "com.apple.dock|tilesize|int"
  "com.apple.dock|magnification|bool"
  "com.apple.dock|largesize|int"
  "com.apple.dock|mineffect|string"
  "com.apple.dock|show-recents|bool"
  "com.apple.dock|orientation|string"
  "com.apple.dock|show-process-indicators|bool"
  "com.apple.dock|launchanim|bool"
  "com.apple.dock|mru-spaces|bool"
  # --- Dock: hot corners (action + modifier per corner) ---
  "com.apple.dock|wvous-tl-corner|int"
  "com.apple.dock|wvous-tl-modifier|int"
  "com.apple.dock|wvous-tr-corner|int"
  "com.apple.dock|wvous-tr-modifier|int"
  "com.apple.dock|wvous-bl-corner|int"
  "com.apple.dock|wvous-bl-modifier|int"
  "com.apple.dock|wvous-br-corner|int"
  "com.apple.dock|wvous-br-modifier|int"
  # --- Finder ---
  "com.apple.finder|ShowPathbar|bool"
  "com.apple.finder|ShowStatusBar|bool"
  "com.apple.finder|FXPreferredViewStyle|string"
  "com.apple.finder|_FXShowPosixPathInTitle|bool"
  "com.apple.finder|FXDefaultSearchScope|string"
  "com.apple.finder|_FXSortFoldersFirst|bool"
  "com.apple.finder|ShowHardDrivesOnDesktop|bool"
  "com.apple.finder|ShowExternalHardDrivesOnDesktop|bool"
  "com.apple.finder|ShowRemovableMediaOnDesktop|bool"
  "com.apple.finder|ShowMountedServersOnDesktop|bool"
  "com.apple.finder|FXRemoveOldTrashItems|bool"
  # --- Global (keyboard, text, UI) ---
  "NSGlobalDomain|AppleShowAllExtensions|bool"
  "NSGlobalDomain|KeyRepeat|int"
  "NSGlobalDomain|InitialKeyRepeat|int"
  "NSGlobalDomain|ApplePressAndHoldEnabled|bool"
  "NSGlobalDomain|AppleKeyboardUIMode|int"
  "NSGlobalDomain|NSAutomaticSpellingCorrectionEnabled|bool"
  "NSGlobalDomain|NSAutomaticCapitalizationEnabled|bool"
  "NSGlobalDomain|NSAutomaticDashSubstitutionEnabled|bool"
  "NSGlobalDomain|NSAutomaticPeriodSubstitutionEnabled|bool"
  "NSGlobalDomain|NSAutomaticQuoteSubstitutionEnabled|bool"
  "NSGlobalDomain|AppleShowScrollBars|string"
  "NSGlobalDomain|AppleInterfaceStyle|string"
  "NSGlobalDomain|NSNavPanelExpandedStateForSaveMode|bool"
  "NSGlobalDomain|PMPrintingExpandedStateForPrint|bool"
  "NSGlobalDomain|AppleICUForce24HourTime|bool"
  "NSGlobalDomain|com.apple.swipescrolldirection|bool"
  "NSGlobalDomain|com.apple.sound.beep.feedback|int"
  "NSGlobalDomain|com.apple.mouse.tapBehavior|int"
  "NSGlobalDomain|com.apple.trackpad.scaling|float"
  # --- Trackpad ---
  "com.apple.AppleMultitouchTrackpad|Clicking|bool"
  "com.apple.AppleMultitouchTrackpad|TrackpadThreeFingerDrag|bool"
  "com.apple.driver.AppleBluetoothMultitouch.trackpad|Clicking|bool"
  "com.apple.driver.AppleBluetoothMultitouch.trackpad|TrackpadThreeFingerDrag|bool"
  # --- Screenshots ---
  "com.apple.screencapture|location|string"
  "com.apple.screencapture|type|string"
  "com.apple.screencapture|disable-shadow|bool"
  "com.apple.screencapture|show-thumbnail|bool"
  "com.apple.screencapture|include-date|bool"
  # --- Menu bar clock ---
  "com.apple.menuextra.clock|ShowSeconds|bool"
  "com.apple.menuextra.clock|ShowDayOfWeek|bool"
  "com.apple.menuextra.clock|ShowDate|int"
  "com.apple.menuextra.clock|Show24Hour|bool"
  # --- Screensaver / lock ---
  "com.apple.screensaver|askForPassword|int"
  "com.apple.screensaver|askForPasswordDelay|int"
)

# Filename used for the extracted NSUserKeyEquivalents value (see capture.sh).
NSGLOBAL_KEYEQUIV_FILE="NSGlobalDomain-NSUserKeyEquivalents.plist"
