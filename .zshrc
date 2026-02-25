# =============================================================================
# Keybindings
# =============================================================================
bindkey -e  # Emacs mode (Ctrl+A/E for line start/end, Ctrl+K to kill, etc.)
bindkey '^p' history-search-backward
bindkey '^p' history-search-forward


# =============================================================================
# History Configuration
# =============================================================================
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history

setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first
setopt HIST_IGNORE_DUPS          # Don't record duplicates
setopt HIST_IGNORE_ALL_DUPS      # Delete old duplicate entry
setopt HIST_FIND_NO_DUPS         # Don't display duplicates when searching
setopt HIST_IGNORE_SPACE         # Don't record entries starting with space
setopt HIST_SAVE_NO_DUPS         # Don't write duplicates to history file
setopt SHARE_HISTORY             # Share history between sessions
setopt EXTENDED_HISTORY          # Add timestamps to history

# =============================================================================
# Environment Variables
# =============================================================================
export EDITOR='nvim'

# PATH additions (consolidated)
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export PATH="$HOME/.opencode/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# =============================================================================
# Lazy-loaded Tools (faster startup)
# =============================================================================

# Lazy load pyenv - only initialize when needed
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

pyenv() {
    unfunction pyenv
    eval "$(command pyenv init -)"
    pyenv "$@"
}

# fnm (Node version manager) - eager load since node/npx used frequently
eval "$(fnm env --use-on-cd --shell zsh)"

# Add ~/.local/bin AFTER fnm so it takes precedence over npm global installs
export PATH="$HOME/.local/bin:$PATH"

# =============================================================================
# Tool Initializations
# =============================================================================
# Disable zoxide in Claude Code (causes issues with cd)
[[ -z "$CLAUDECODE" ]] && eval "$(zoxide init --cmd cd zsh)"

export BAT_THEME="ansi"

# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --style minimal
  --tmux 80%
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
source <(fzf --zsh)

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# =============================================================================
# Aliases
# =============================================================================
alias c='clear'
alias cc='claude'
alias cds='claude --dangerously-skip-permissions'
alias p='pnpm'
alias b='bun'
alias sb='pnpx supabase'
alias cu='cursor'
alias cuu='cursor .'
alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias vim='nvim'
alias v='nvim'

alias ez='eza --group-directories-first --icons -l -a --git'

# Git aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gd='git diff'
alias gds='git diff --staged'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gl='git pull'
alias glr='git pull --rebase'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias glog='git log --oneline --graph --decorate -10'
alias gla='git log --oneline --graph --decorate --all'
alias gst='git stash'
alias gstp='git stash pop'
alias gm='git merge'
alias grb='git rebase'
alias grbi='git rebase -i'
alias grs='git restore'
alias grss='git restore --staged'

alias ien='~/.config/tmux/three-pane-layout.sh'
alias cien='~/.config/tmux/three-pane-layout.sh "claude --dangerously-skip-permissions"'

# =============================================================================
# Load Secrets (if exists)
# =============================================================================
[ -f ~/.secrets ] && source ~/.secrets

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit cdreplay -q

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

zinit ice blockf
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

zinit snippet OMZP::git
zinit snippet OMZP::bun
zinit snippet OMZP::gh
zinit snippet OMZP::z

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

### End of Zinit's installer chunk

eval "$(oh-my-posh init zsh --config $HOME/.config/omp/config.toml)"

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}


# Added by Hades
export PATH="$PATH:$HOME/.hades/bin"
export FPATH="~/.dotfiles/.config/eza/completions/zsh:$FPATH"
