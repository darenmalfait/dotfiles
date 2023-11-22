#!/bin/bash

export TERM=xterm-256color
export CLICOLOR=1
export LSCOLORS=Fafacxdxbxegedabagacad

# PROMPT STUFF
GREEN=$(tput setaf 2);
YELLOW=$(tput setaf 3);
RESET=$(tput sgr0);

function git_branch {
  # Shows the current branch if in a git repository
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \(\1\)/';
}

function random_element {
  declare -a array=("$@")
  r=$((RANDOM % ${#array[@]}))
  printf "%s\n" "${array[$r]}"
}

# Default Prompt
setEmoji () {
  EMOJI="$*"
  DISPLAY_DIR='$(dirs)'
  DISPLAY_BRANCH='$(git_branch)'
  PROMPT="${YELLOW}${DISPLAY_DIR}${GREEN}${DISPLAY_BRANCH}${RESET} ${EMOJI}"$'\n'"$ ";
}

newRandomEmoji () {
  setEmoji "$(random_element 😅 👽 🔥 🚀 👻 ⛄ 👾 🍔 😄 🍰 🐑 😎 🏎 🤖 😇 😼 💪 🦄 🥓 🌮 🎉 💯 ⚛️ 🐠 🐳 🐿 🥳 🤩 🤯 🤠 👨‍💻 🦸‍ 🧝‍ 🧞‍ 🧙‍ 👨‍🚀 👨‍🔬 🕺 🦁 🐶 🐵 🐻 🦊 🐙 🦎 🦖 🦕 🦍 🦈 🐊 🦂 🐍 🐢 🐘 🐉 🦚 ✨ ☄️ ⚡️ 💥 💫 🧬 🔮 ⚗️ 🎊 🔭 ⚪️ 🔱)"
}

newRandomEmoji

alias jestify="PS1=\"🃏\"$'\n'\"$ \"";
alias testinglibify="PS1=\"🐙\"$'\n'\"$ \"";
alias cypressify="PS1=\"🌀\"$'\n'\"$ \"";
alias staticify="PS1=\"🚀\"$'\n'\"$ \"";
alias nodeify="PS1=\"💥\"$'\n'\"$ \"";
alias reactify="PS1=\"⚛️\"$'\n'\"$ \"";
alias harryify="PS1=\"🧙‍\"$'\n'\"$ \"";

# allow substitution in PS1
setopt promptsubst

# history size
HISTSIZE=5000
HISTFILESIZE=10000

SAVEHIST=5000
setopt EXTENDED_HISTORY
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
# share history across multiple zsh sessions
setopt SHARE_HISTORY
# append to history
setopt APPEND_HISTORY
# adds commands as they are typed, not at shell exit
setopt INC_APPEND_HISTORY
# do not store duplications
setopt HIST_IGNORE_DUPS

# PATH ALTERATIONS
## Node
PATH="/usr/local/bin:$PATH:./node_modules/.bin";

## Yarn
PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
# alias yarn="echo update the PATH in ~/.zshrc"

# Custom bins
PATH="$PATH:$HOME/.bin";
# dotfile bins
PATH="$PATH:$HOME/.my_bin";

# CDPATH ALTERATIONS
CDPATH=.:$HOME:$HOME/code:$HOME/code/epic-react:$HOME/code/testingjavascript:$HOME/Desktop
# CDPATH=($HOME $HOME/code $HOME/Desktop)

# disable https://scarf.sh/
SCARF_ANALYTICS=false

# Custom Aliases
alias code="\"/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code\""
function c { code ${@:-.} }
alias ll="ls -1a";
alias ..="cd ../";
alias ..l="cd ../ && ll";
alias pg="echo 'Pinging Google' && ping www.google.com";
alias cz="code ~/.zshrc";
alias de="cd ~/Desktop";
alias d="cd ~/code";
alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
alias deleteDSFiles="find . -name '.DS_Store' -type f -delete"

alias npm-update="npx npm-check-updates --dep prod --dep dev --upgrade";
alias yarn-update="yarn upgrade-interactive --latest";
alias flushdns="sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder"
alias dont_index_node_modules='find . -type d -name "node_modules" -exec touch "{}/.metadata_never_index" \;';

## git aliases
function gc { git commit -m "$@"; }

## use hub for git
alias git=hub

# Custom functions
killport() { lsof -i tcp:"$*" | awk 'NR!=1 {print $2}' | xargs kill -9 ;}

autoload -Uz compinit && compinit

export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

export DOTENVOP_VAULT=
export DOTENVOP_ACCOUNT=
export DOTENVOP_EMAIL=

# This loads nvm without restarting the shell
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# pnpm
export PNPM_HOME="/Users/darenmalfait/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end
# bun completions
[ -s "/Users/darenmalfait/.bun/_bun" ] && source "/Users/darenmalfait/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
