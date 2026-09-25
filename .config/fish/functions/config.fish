function config --description 'Manage dotfiles with the bare Git repository' --wraps git
    command git --git-dir="$HOME/.cfg" --work-tree="$HOME" $argv
end
