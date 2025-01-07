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


#═══════════════════════════════#
#                               #
#   🔐 1Password CLI Tools      #
#   Secret Management utils     #
#                               #
#   brew install 1password-cli  #
#                               # 
#═══════════════════════════════#


# Inject 1Password secrets as environment variables when running commands
# Environment variables should be defined in format: op://VAULT/item/key
#
# Usage:
#   openv npm run dev              # Uses default .env file
#   openv -f custom.env npm run dev # Uses custom env file
#
function openv {
  # Set default values
  local env_path=".env"

  # Parse command line arguments to override defaults if provided
  while getopts "d:e:" opt; do
    case $opt in
      f) env_path="$OPTARG" ;;
      *) return 1 ;;
    esac
  done
  shift $((OPTIND-1))

  # see if we are logged in, will return exit code > 0 if not
  op whoami

  # if we are logged skip if not ask for master password
  if [[ $? != 0 ]]; then 
    eval $(op signin)
  fi

  # this will inject the env vars we defined in our .env file
  op run --env-file="${env_path}" -- $@
}

# Pull secrets from 1Password and write them to a .env file
#
# Usage:
#   oppull item-name                  # Write secrets to default .env file
#   oppull -f custom.env item-name    # Write to custom env file
#   oppull -r item-name              # Write raw secret values (default)
#   oppull item-name                 # Write as op:// references
#
# Options:
#   -f <file>  Specify custom env file path (default: .env)
#   -r         Write raw secret values instead of op:// references
# 
function oppull {
  # Set default values
  local env_path=".env"
  local raw=false

  # Parse command line arguments to override defaults if provided
  while getopts "f:r" opt; do
    case $opt in
      f) env_path="$OPTARG" ;;
      r) raw=true ;;
      *) return 1 ;;
    esac
  done
  shift $((OPTIND-1))

  # Check if we have an argument
  if [ -z "$1" ]; then
    echo "Please provide an item name"
    return 1
  fi

  # see if we are logged in, will return exit code > 0 if not
  op whoami

  # if we are logged skip if not ask for master password
  if [[ $? != 0 ]]; then 
    eval $(op signin)
  fi

  # Get all secrets from the vault and combine them
  if [ "$raw" = true ]; then
    op item get "$1" --format json | jq -r '.fields[] | select(.value != null) | "\(.label)=\(.value)"' > "${env_path}"
  else
    op item get "$1" --format json | jq -r --arg item "$1" '.fields[] | select(.value != null) | "\(.label)=op://ENV/\($item)/\(.label)"' > "${env_path}"
  fi

  if [[ $? == 0 ]]; then
    echo "✨ Successfully wrote secrets to ${env_path}"
  else
    echo "❌ Failed to write secrets to ${env_path}"
  fi
}

# Save environment variables from a .env file to 1Password
#
# Usage:
#   oppush item-name              # Save secrets from default .env file
#   oppush -f custom.env item-name # Save secrets from custom env file
#
# Options:
#   -f <file>  Specify custom env file path (default: .env)
#
# The secrets will be saved to the ENV vault in 1Password.
# A backup of any existing item with the same name will be created before overwriting.
# 
function oppush {
  # Set default values
  local env_path=".env"

  # Parse command line arguments to override defaults if provided
  while getopts "f:" opt; do
    case $opt in
      f) env_path="$OPTARG" ;;
      *) return 1 ;;
    esac
  done
  shift $((OPTIND-1))

  # Check if we have an argument
  if [ -z "$1" ]; then
    echo "Please provide an item name"
    return 1
  fi

  # Check if env file exists
  if [ ! -f "${env_path}" ]; then
    echo "❌ Environment file ${env_path} not found"
    return 1
  fi

  # see if we are logged in, will return exit code > 0 if not
  op whoami

  # if we are not logged in, ask for master password
  if [[ $? != 0 ]]; then 
    eval $(op signin)
  fi

  # Create a backup of the current item if it exists
  if op item get "$1" --vault ENV &>/dev/null; then
    echo "⚠️  Item '$1' already exists. Creating backup..."
    op item get "$1" --vault ENV --format json > "${1}.backup.json"
  fi

  # Create a temporary JSON file for the new item
  echo '{"title":"'"$1"'","category":"LOGIN","fields":[]}' > temp_item.json

  # Read the env file and add each variable to the JSON
  while IFS='=' read -r key value || [ -n "$key" ]; do
    # Skip empty lines and comments
    [[ -z "$key" || "$key" == \#* ]] && continue
    
    # Remove any quotes from the value
    value=$(echo "$value" | sed -e 's/^["\x27]//' -e 's/["\x27]$//')
    
    # Add the field to the JSON as a password field
    tmp=$(jq --arg k "$key" --arg v "$value" '.fields += [{"id": $k, "label": $k, "value": $v, "type": "CONCEALED"}]' temp_item.json)
    echo "$tmp" > temp_item.json
  done < "${env_path}"

  # Create or update the item in 1Password
  if op item get "$1" --vault ENV &>/dev/null; then
    op item delete "$1" --vault ENV --archive
    op item create --vault ENV --template temp_item.json
  else
    op item create --vault ENV --template temp_item.json
  fi

  # Clean up
  rm temp_item.json

  if [[ $? == 0 ]]; then
    echo "✨ Successfully saved ${env_path} to 1Password vault 'ENV' as '$1'"
  else
    echo "❌ Failed to save ${env_path} to 1Password"
    if [ -f "${1}.backup.json" ]; then
      echo "🔄 Restoring from backup..."
      op item delete "$1" --vault ENV --archive
      op item create --vault ENV --template "${1}.backup.json"
      rm "${1}.backup.json"
    fi
  fi
}