#!/usr/bin/env sh
set -eu

cmd="/usr/bin/tmux-up"

# hypr session - config editing windows
$cmd -f --cwd ~/.config/hypr  hypr hyprland-inspect 'nvim .'
$cmd -f --cwd ~/.config/river hypr river-inspect    'nvim .'
$cmd -f --cwd ~               hypr tmux-conf        'nvim ~/.tmux.conf'
$cmd -f --cwd ~               hypr nvim-conf        'nvim ~/.config/nvim/init.lua'

# repos session - development windows
$cmd -f repos main
$cmd -f repos nvim 'nvim .'
