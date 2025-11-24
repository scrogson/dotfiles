#!/usr/bin/env bash
# Claude Code status line with theme-aware colors

# Get current theme mode
THEME_MODE=$($HOME/.dotfiles/scripts/theme-mode.sh)

# ANSI color codes based on theme
if [ "$THEME_MODE" = "dark" ]; then
    # GitHub Dark Dimmed colors
    BG_COLOR="\033[48;2;34;39;46m"      # Background: #22272e
    FG_COLOR="\033[38;2;173;186;199m"   # Foreground: #adbac7
    ACCENT_COLOR="\033[38;2;83;155;245m" # Blue: #539bf5
    SUCCESS_COLOR="\033[38;2;87;171;90m" # Green: #57ab5a
    WARNING_COLOR="\033[38;2;198;144;38m" # Yellow: #c69026
    SUBTLE_COLOR="\033[38;2;110;118;129m" # Gray: #6e7681
else
    # GitHub Light colors
    BG_COLOR="\033[48;2;255;255;255m"   # Background: #ffffff
    FG_COLOR="\033[38;2;36;41;47m"      # Foreground: #24292f
    ACCENT_COLOR="\033[38;2;9;105;218m" # Blue: #0969da
    SUCCESS_COLOR="\033[38;2;17;99;41m" # Green: #116329
    WARNING_COLOR="\033[38;2;152;87;0m" # Orange: #985700
    SUBTLE_COLOR="\033[38;2;110;119;129m" # Gray: #6e7781
fi

RESET="\033[0m"
BOLD="\033[1m"

# Get git info if in a git repository
GIT_BRANCH=""
GIT_STATUS=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    GIT_BRANCH=$(git branch --show-current 2>/dev/null)
    if [ -n "$GIT_BRANCH" ]; then
        # Check if there are uncommitted changes
        if ! git diff-index --quiet HEAD -- 2>/dev/null; then
            GIT_STATUS="${WARNING_COLOR}●${RESET}"
        else
            GIT_STATUS="${SUCCESS_COLOR}✓${RESET}"
        fi
        GIT_BRANCH=" ${ACCENT_COLOR}${GIT_BRANCH}${RESET} ${GIT_STATUS}"
    fi
fi

# Get current directory (shortened)
CURRENT_DIR=$(pwd | sed "s|^$HOME|~|")

# Build status line
STATUS_LINE="${BG_COLOR}${FG_COLOR}"
STATUS_LINE+=" ${BOLD}${CURRENT_DIR}${RESET}${BG_COLOR}${FG_COLOR}"
if [ -n "$GIT_BRANCH" ]; then
    STATUS_LINE+="${GIT_BRANCH}${BG_COLOR}${FG_COLOR}"
fi
STATUS_LINE+=" ${RESET}"

# Output the status line
echo -e "$STATUS_LINE"
