if status is-interactive
    # Commands to run in interactive sessions can go here
    # Set en-US
    set -x LANG "en_US.UTF-8"
    set -x LC_ALL "en_US.UTF-8"
    starship init fish | source
    zoxide init fish | source
    direnv hook fish | source
    enable_transience
    alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
    set fish_greeting ''
    set -g fish_color_autosuggestion 928374
    fish_vi_key_bindings
    add_abbr
end
