# remove initial welcome message
set fish_greeting
set -g fish_key_bindings fish_user_key_bindings
# starship init command
# starship init fish | source

# load_nvm
set PATH ~/.pyenv/versions/2.7.18/bin $PATH
set PATH ~/.nvm/nvm.sh $PATH

# Bun
# set -Ux BUN_INSTALL "/Users/griffinjohnson/.bun"
# set -px --path PATH "/Users/griffinjohnson/.bun/bin"


set -gx PNPM_HOME "/Users/griffinjohnson/Library/pnpm"
set -gx PATH "$PNPM_HOME" $PATH



# Get gpg to work ...
export GPG_TTY=$(tty)
set -x GPG_TTY (tty)

# Add config scripts to the path
set -U fish_user_paths $fish_user_paths $HOME/.config/scripts


source /Users/gjohnson/.docker/init-fish.sh || true # Added by Docker Desktop


# pnpm
set -gx PNPM_HOME "/Users/gjohnson/Library/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
# pnpm end

#zk setup
export ZK_NOTEBOOK_DIR="$HOME/vaults/Palace"

export XDG_CONFIG_HOME="$HOME/.config"
zoxide init fish | source
