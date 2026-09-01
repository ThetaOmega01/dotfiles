set --global --export LANG en_US.UTF-8

if status is-interactive
    set --global fish_greeting
    set --global fish_color_autosuggestion 928374
    set --global fish_key_bindings fish_vi_key_bindings

    if command --query starship
        starship init fish | source
        enable_transience
    end

    if command --query zoxide
        zoxide init fish | source
    end

    if command --query direnv
        direnv hook fish | source
    end

    abbr --add nv nvim
    abbr --add v nvim
    abbr --add c clear
    abbr --add e eza
    abbr --add ea eza -a
    abbr --add eal eza -al
    abbr --add el eza -l
    abbr --add et eza -T
    abbr --add e1 eza -1
    abbr --add etg eza -T --git-ignore
end
