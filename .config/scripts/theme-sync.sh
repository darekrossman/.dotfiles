#!/bin/bash
# Theme sync script - synchronizes Catppuccin theme with macOS appearance
# Used by dark-notify, tmux, and Neovim

# Full path to tmux (needed when running from LaunchAgent)
TMUX_BIN="/opt/homebrew/bin/tmux"
TMUX_SOCKET="/private/tmp/tmux-501/default"

# Detect macOS appearance
# Returns "Dark" in dark mode, errors/empty in light mode
if defaults read -g AppleInterfaceStyle &>/dev/null; then
    APPEARANCE="dark"
    CATPPUCCIN_FLAVOR="mocha"
else
    APPEARANCE="light"
    CATPPUCCIN_FLAVOR="latte"
fi

# Export for other scripts to source
export APPEARANCE
export CATPPUCCIN_FLAVOR

# If called with --query, just output the values
if [[ "$1" == "--query" ]]; then
    echo "$APPEARANCE"
    exit 0
fi

if [[ "$1" == "--flavor" ]]; then
    echo "$CATPPUCCIN_FLAVOR"
    exit 0
fi

# Update tmux if running
if [[ -S "$TMUX_SOCKET" ]] && "$TMUX_BIN" -S "$TMUX_SOCKET" info &>/dev/null; then
    # Unset all Catppuccin theme variables (they use -o flag which won't override)
    "$TMUX_BIN" -S "$TMUX_SOCKET" set -gu @thm_bg
    "$TMUX_BIN" -S "$TMUX_SOCKET" set -gu @thm_fg
    "$TMUX_BIN" -S "$TMUX_SOCKET" set -gu @thm_rosewater
    "$TMUX_BIN" -S "$TMUX_SOCKET" set -gu @thm_flamingo
    "$TMUX_BIN" -S "$TMUX_SOCKET" set -gu @thm_pink
    "$TMUX_BIN" -S "$TMUX_SOCKET" set -gu @thm_mauve
    "$TMUX_BIN" -S "$TMUX_SOCKET" set -gu @thm_red
    "$TMUX_BIN" -S "$TMUX_SOCKET" set -gu @thm_maroon
    "$TMUX_BIN" -S "$TMUX_SOCKET" set -gu @thm_peach
    "$TMUX_BIN" -S "$TMUX_SOCKET" set -gu @thm_yellow
    "$TMUX_BIN" -S "$TMUX_SOCKET" set -gu @thm_green
    "$TMUX_BIN" -S "$TMUX_SOCKET" set -gu @thm_teal
    "$TMUX_BIN" -S "$TMUX_SOCKET" set -gu @thm_sky
    "$TMUX_BIN" -S "$TMUX_SOCKET" set -gu @thm_sapphire
    "$TMUX_BIN" -S "$TMUX_SOCKET" set -gu @thm_blue
    "$TMUX_BIN" -S "$TMUX_SOCKET" set -gu @thm_lavender
    "$TMUX_BIN" -S "$TMUX_SOCKET" set -gu @thm_text
    "$TMUX_BIN" -S "$TMUX_SOCKET" set -gu @thm_subtext_1
    "$TMUX_BIN" -S "$TMUX_SOCKET" set -gu @thm_subtext_0
    "$TMUX_BIN" -S "$TMUX_SOCKET" set -gu @thm_overlay_2
    "$TMUX_BIN" -S "$TMUX_SOCKET" set -gu @thm_overlay_1
    "$TMUX_BIN" -S "$TMUX_SOCKET" set -gu @thm_overlay_0
    "$TMUX_BIN" -S "$TMUX_SOCKET" set -gu @thm_surface_2
    "$TMUX_BIN" -S "$TMUX_SOCKET" set -gu @thm_surface_1
    "$TMUX_BIN" -S "$TMUX_SOCKET" set -gu @thm_surface_0
    "$TMUX_BIN" -S "$TMUX_SOCKET" set -gu @thm_mantle
    "$TMUX_BIN" -S "$TMUX_SOCKET" set -gu @thm_crust

    # Set new flavor and reload config
    "$TMUX_BIN" -S "$TMUX_SOCKET" set -g @catppuccin_flavor "$CATPPUCCIN_FLAVOR"
    "$TMUX_BIN" -S "$TMUX_SOCKET" source-file ~/.tmux.conf 2>/dev/null || true
fi

# Signal all Neovim instances to update their theme
# Neovim should have an autocmd listening for SIGUSR1
for pid in $(pgrep -x nvim); do
    kill -SIGUSR1 "$pid" 2>/dev/null || true
done

# Update Yazi theme symlink (requires restart to take effect)
YAZI_CONFIG="$HOME/.config/yazi"
if [[ -d "$YAZI_CONFIG" ]]; then
    rm -f "$YAZI_CONFIG/theme.toml"
    ln -s "$YAZI_CONFIG/theme-$CATPPUCCIN_FLAVOR.toml" "$YAZI_CONFIG/theme.toml"
fi

# Update Claude Code theme (new sessions will use this theme)
CLAUDE_CONFIG="$HOME/.claude.json"
JQ_BIN="/opt/homebrew/bin/jq"
if [[ -f "$CLAUDE_CONFIG" ]] && [[ -x "$JQ_BIN" ]]; then
    "$JQ_BIN" --arg theme "$APPEARANCE" '.theme = $theme' "$CLAUDE_CONFIG" > /tmp/claude.json.tmp && \
    mv /tmp/claude.json.tmp "$CLAUDE_CONFIG"
fi

echo "Theme synced to: $APPEARANCE ($CATPPUCCIN_FLAVOR)"
