function config --description 'Manage dotfiles with the bare Git repository' --wraps git
    command /usr/bin/git --git-dir="$HOME/.cfg" --work-tree="$HOME" $argv
end
