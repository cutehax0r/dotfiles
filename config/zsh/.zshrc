export PATH="$PATH:$HOME/.lmstudio/bin:$HOME/.local/bin"
export HISTFILE="$HOME/.local/share/zsh/zsh_history"
export ZCOMPDUMP="$HOME/.local/share/zsh/zcompdump"
export HISTSIZE="10000"
export SAVEHIST="10000"
export EDITOR="/usr/bin/vim"
export PROMPT='%F{%(?.green.red)}${SHORT_PWD}❯%f '

setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt IGNORE_EOF
setopt PROMPT_SUBST

unsetopt AUTOCD
unsetopt EXTENDED_HISTORY

# Homebrew specific config
if test -r "/opt/homebrew/bin/brew"
then
  export HOMEBREW_NO_ANALYTICS=1
  export HOMEBREW_NO_ENV_HINTS=1
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export EDITOR="/opt/homebrew/bin/nvim"
  export EZA_CONFIG_DIR="$HOME/.config/eza"
  export GOPATH="$HOME/.local/share/go"
  alias cat="/opt/homebrew/bin/bat --paging=never"
  alias ls="/opt/homebrew/bin/eza --group-directories-first --hyperlink --icons -F -x"
  alias la="/opt/homebrew/bin/eza --group-directories-first --hyperlink --icons -F -x -a"
  alias ll="/opt/homebrew/bin/eza --group-directories-first --hyperlink --icons -F -x -a -l"
  alias lr="/opt/homebrew/bin/eza --group-directories-first --hyperlink --icons -F -x -a -R"
  alias lt="/opt/homebrew/bin/eza --group-directories-first --hyperlink --icons -F -a -x --tree"
fi
alias src="cd ~/Documents/src/github.com/cutehax0r"

alias vi="$EDITOR"
alias vim="$EDITOR"
alias vimdiff="$EDITOR -d"

typeset -aU path
path=(
  $path
  $HOME/.local/share/go/bin
  $HOME/Documents/src/github.com/cutehax0r/scripts
)
typeset -aU cdpath
cdpath=(
  $HOME/Documents/src/github.com/cutehax0r
)

autoload -U compinit
() {
if [[ $# -gt 0 ]]; then
  compinit -i -d $ZCOMPDUMP
  touch $ZCOMPDUMP
else
  compinit -C -d $ZCOMPDUMP
fi
} $ZCOMPDUMP(N.mh+24)

autoload -Uz colors && colors

autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line
bindkey -v

function expand_dots() {
  [[ $LBUFFER = *.. ]] && LBUFFER+=/.. || LBUFFER+=.
}
zle -N expand_dots
bindkey . expand_dots

autoload -Uz add-zsh-hook
function compute_short_pwd() {
  local shortened_path full_path part current_path_part first_part
  local -a split
  split=(${(s:/:)${(Q)${(D)1:-$PWD}}})
  if [[ $split == "" ]]; then
    SHORT_PWD=/
    return 0
  fi
  if [[ $split[1] = \~* ]]; then
    first_part=$split[1]
    full_path=$~split[1]
    shift split
  fi
  if (( $#split > 0 )); then
    part=/
  fi
  for current_path_part ($split[1,-2]) {
    while {
      part+=$current_path_part[1]
      current_path_part=$cur[2,-1]
      local -a glob
      glob=( $full_path/$part*(-/N) )
      (( $#glob > 1 )) || [[ $part == (.|..) ]] && (( $#current_path_part > 0 ))
    } { }
    full_path+=$part$current_path_part
    shortened_path+=$part
    part=/
  }
  SHORT_PWD=$first_part$shortened_path$part$split[-1]
  return 0
}
compute_short_pwd
add-zsh-hook -Uz chpwd compute_short_pwd


if test -r "$HOMEBREW_PREFIX/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
then
  source "$HOMEBREW_PREFIX/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
  export FAST_HIGHLIGHT[chroma-man]='' # This is a workaround for an annoying 'pause' when typing commands like `man`  https://github.com/zdharma-continuum/fast-syntax-highlighting/issues/27#issuecomment-1267278072
fi

if test -r "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
then
  source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  bindkey '^ ' autosuggest-execute
  bindkey '^[[Z' autosuggest-accept
  export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
fi

if test -r "$HOMEBREW_PREFIX/opt/chruby/share/chruby/chruby.sh"
then
  source "$HOMEBREW_PREFIX/opt/chruby/share/chruby/chruby.sh"
  # ruby-build 3.4.6 ~/.local/share/ruby/3.4.6
  RUBIES+=(
    "$HOME/.local/share/ruby/3.4.6"
    "$HOME/.local/share/ruby/4.0.0"
  )
  chruby 4.0.0
fi

if test -r "$HOMEBREW_PREFIX/bin/fnm"
then
  # fnm install v24.9.0
  eval "$($HOMEBREW_PREFIX/bin/fnm env --use-on-cd --shell zsh)"  && eval "$($HOMEBREW_PREFIX/bin/fnm env --use-on-cd --shell zsh)"
fi

export FZF_DEFAULT_OPTS=" \
--color=bg+:#363A4F,bg:#24273A,spinner:#F4DBD6,hl:#ED8796 \
--color=fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6 \
--color=marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796 \
--color=selected-bg:#494D64 \
--color=border:#6E738D,label:#CAD3F5"
if test -r "$HOMEBREW_PREFIX/bin/fzf"
then
  source <($HOMEBREW_PREFIX/bin/fzf --zsh)
fi

# need ls_colors set for cattpuscin to make this consistent
# git clone https://github.com/Aloxaf/fzf-tab ~/.local/share/fzf/tab-complete
if test -r "$HOME/.local/share/fzf/tab-complete/fzf-tab.plugin.zsh"
then
  zstyle ':completion:*:git-checkout:*' sort false
  zstyle ':completion:*:descriptions' format '[%d]'
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
  zstyle ':completion:*' menu no
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
  zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind='tab:down,shift-tab:up,ctrl-space:accept,enter:accept,esc:abort'
  zstyle ':fzf-tab:*' use-fzf-default-opts yes
  zstyle ':fzf-tab:*' switch-group '<' '>'
  zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
  source "$HOME/.local/share/fzf/tab-complete/fzf-tab.plugin.zsh"
fi

# Retrieve keychain items by keychain name.
# To add keys to Keychain using the command line:
#   security add-generic-password -l "ENV: some label" -a "username" -s "server" -w "your-key-here"
# Test them with:
#   security find-generic-password -l "ENV: some label" -w
# To retrieve:
#   get_keychain_item "ENV: some label" "account"   # returns account name
#   get_keychain_item "ENV: some label" "server"    # returns server/service
#   get_keychain_item "ENV: some label" "password"  # returns password
function get_keychain_item() {
  local keychain_name="$1"
  local item_type="$2"
  local result
  
  if [[ -z "$keychain_name" || -z "$item_type" ]]; then
    return 1
  fi
  
  case "$item_type" in
    account)
      result=$(security find-generic-password -l "$keychain_name" 2>/dev/null | awk '/"acct"<blob>/ { val=$0; sub(/.*=/,"",val); gsub(/"/,"",val); print val }')
      ;;
    server)
      result=$(security find-generic-password -l "$keychain_name" 2>/dev/null | awk '/"svce"<blob>/ { val=$0; sub(/.*=/,"",val); gsub(/"/,"",val); print val }')
      ;;
    password)
      result=$(security find-generic-password -l "$keychain_name" -w 2>/dev/null)
      ;;
    *)
      return 1
      ;;
  esac
  echo "${result%%}"
}
# This is a hack to make the slow fetching of environment variables from keychain less noticable.
# It's still slow, not-async, and blocking, but it's less noticeable if we delay it until after the
# prompt is show.
#
# We register a command `_zsh_slow_init_handler` to run precmd - before every prompt is displayed.
# We use `ZSH_SLOW_INIT_DONE` to ensure that it only runs once. When it runs it opens a file
# descriptor for reading /dev/null and registers a callback for when that becomes readable. This
# should happen instantly BUT by doing this as a callback the prompt will render after the zle call.
#
# Once the prompt is done that file descriptor callback will fire. At this point the UI is blocking
# but you probably aren't trying to type for a few milliseconds so you don't notice. The callback
# unregisters itself and closes the /dev/null file descriptor. Then it kicks off all those slow
# calls out to `get_keychain_item()` and exports the environment variables.
#
# This would be a good place to add other slow things that might block prompt rendering.
# compinit regeneration maybe?
autoload -Uz add-zsh-hook
typeset -gi ZSH_SLOW_INIT_FD
function _slow_init_handler() {
  if [[ -n $ZSH_SLOW_INIT_DONE ]]; then
    return
  fi
  ZSH_SLOW_INIT_DONE=1
  exec {ZSH_SLOW_INIT_FD}</dev/null
  zle -F $ZSH_SLOW_INIT_FD _slow_init
}
function _slow_init() {
  zle -F $ZSH_SLOW_INIT_FD
  exec {ZSH_SLOW_INIT_FD}<&-
  export BW_PASSWORD=$(get_keychain_item "ENV: Bitwarden Session" "password")
  export GEMINI_API_KEY=$(get_keychain_item "ENV: Google AI Studio API Key" "password")
  export ANTHROPIC_API_KEY=$(get_keychain_item "ENV: Anthropic Claude Code API Key" "password")
  export GITHUB_COPILOT_TOKEN=$(get_keychain_item "ENV: Github Copilot token" "password")
  export GH_TOKEN=$(get_keychain_item "ENV: Github gh CLI token" "password")
}
add-zsh-hook precmd _slow_init_handler
