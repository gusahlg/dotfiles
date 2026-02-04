# ~/.config/fish/config.fish

# Make sure user binaries are found
fish_add_path -g $HOME/.local/bin

set -g fish_greeting
fish_vi_key_bindings

alias ll="ls -lah"
alias gs="git status"
alias gl="git log --oneline --graph --decorate --all"
alias v="nvim"

export EDITOR=nvim
