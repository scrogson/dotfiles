#!/usr/bin/env bash
set -euo pipefail

# Remap Caps Lock -> Left Control.
#
# hidutil rather than the System Settings > Modifier Keys route, because that
# one writes com.apple.keyboard.modifiermapping.<vendorID>-<productID>-0 --
# keyed to specific hardware, so it doesn't survive a move to a new machine or
# apply to a keyboard you plug in later. hidutil applies to all keyboards.
#
# The mapping is session-scoped and resets on logout/reboot, which is why this
# runs from a launch agent with RunAtLoad rather than being set once by hand.
#
# Usage codes are HID page 0x07: 0x39 Caps Lock, 0xE0 Left Control.

hidutil property --set '{"UserKeyMapping":[
  {"HIDKeyboardModifierMappingSrc":0x700000039,
   "HIDKeyboardModifierMappingDst":0x7000000E0}
]}' >/dev/null

echo "Caps Lock -> Left Control"
