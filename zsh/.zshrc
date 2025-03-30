############################# ZSH CONFIGURATION #############################
: '
Welcome to my ZSH configuration file!

This file is used to configure ZSH with the following tools:
- Oh My Posh (Theme Manager)
- Zinit (Plugin Manager)
- Dependencies:
  - fzf
  - zoxide
  - eza
- ZSH Plugins:
  - zsh-syntax-highlighting
  - zsh-completions
  - zsh-autosuggestions
  - fzf-tab

This file is divided into the following sections:
  1. Exports
  2. Oh My Posh
  3. Dependencies
  4. Settings
  5. ZINIT (Plugin Manager)
  6. Aliases & Functions
  7. Source local zshrc

Enjoy your ZSH configuration! 🚀
'
#############################################################################

############################## PERSONAL NOTES ###############################
: '
To profile zsh startup time, add the following commands to the start and end of this file respectively:
  - zmodload zsh/zprof
  - zprof
'
#############################################################################


#### Exports ####
# so that executables can be found and installed
export PATH=$PATH:/home/ahmedgado/.local/bin

# make neovim default editor
export EDITOR="nv"
export VISUAL="nv"


#### Oh My Posh ####
if ! command -v oh-my-posh &> /dev/null; then
  curl -s https://ohmyposh.dev/install.sh | bash -s
fi

eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/base.toml)"


#### Dependencies ####
## Zinit (Plugin Manager)
# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone --depth 1  https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source Zinit
[[ -r "$ZINIT_HOME/zinit.zsh" ]] && source "$ZINIT_HOME/zinit.zsh"

## FZF
# Set the directory we want to store fzf
FZF_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/fzf"

# Check if fzf is installed
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
elif ! command -v fzf &> /dev/null; then
  git clone --depth 1 https://github.com/junegunn/fzf.git "$FZF_HOME"
  "$FZF_HOME/install" --all
  source ~/.fzf.zsh
fi

## Zoxide
# Check if zoxide is installed
if ! command -v zoxide &> /dev/null; then
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# Source zoxide
eval "$(zoxide init --cmd c zsh)"

## Eza
# Check if eza is installed
if ! command -v eza &> /dev/null; then
  wget -c https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz -O - | tar xz
  sudo chmod +x eza
  sudo chown root:root eza
  sudo mv eza /usr/local/bin/eza
fi


#### Settings ####

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt inc_append_history
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt hist_verify

# vim mode
bindkey -v

# Load completions
autoload -Uz compinit && compinit -d ~/.zcompdump

#### ZINIT (Plugin Manager) ####
## Load Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

## Zinit snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

## Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:c:*' fzf-preview 'eza --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --color=always $realpath'

## Zinit completion stuff
zinit cdreplay -q


#### Aliases & Functions ####
# shell stuff
alias ..='cd ..'

# ls stuff
alias ls='eza'
alias l='eza -l'
alias la='eza -la'

# make tmux colorful
alias tmux='TERM=xterm-256color tmux'

# python
alias py='python3'
alias pip='py -m pip'
function activ {
  if [[ -z "$1" ]]; then
    source venv/bin/activate
  else
    source $1/bin/activate
  fi
}

# c/cpp
alias gccrn='() {gcc $1.c -o $1 && ./$1}'
alias g++rn='() {g++ $1.cpp -o $1 && ./$1}'


#### Source local zshrc ####
# source the startup file if it exists
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
