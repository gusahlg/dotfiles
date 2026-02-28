# ~/.config/fish/config.fish

# Make sure user binaries are found
fish_add_path -g $HOME/.local/bin

set -g fish_greeting
fish_vi_key_bindings

# Abbreviations (expand inline, editable before running)
abbr -a ll  'ls -lah'
abbr -a gs  'git status'
abbr -a gl  'git log --oneline --graph --decorate --all'
abbr -a v   'nvim'

# Git
abbr -a ga  'git add'
abbr -a gap 'git add -p'
abbr -a gc  'git commit'
abbr -a gco 'git checkout'
abbr -a gd  'git diff'
abbr -a gds 'git diff --staged'
abbr -a gp  'git push'
abbr -a gpl 'git pull'
abbr -a gb  'git branch'

# Cargo
abbr -a cb  'cargo build'
abbr -a cr  'cargo run'
abbr -a ct  'cargo test'
abbr -a cc  'cargo check'

# Navigation
abbr -a ..  'cd ..'
abbr -a ... 'cd ../..'

export EDITOR=nvim
