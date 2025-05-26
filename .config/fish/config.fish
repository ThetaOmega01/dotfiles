if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
    zoxide init fish | source
    alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
    set fish_greeting ''
    fish_vi_key_bindings
    add_ssh_key_with_keychain
    add_abbr
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
