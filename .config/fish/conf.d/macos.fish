if test (uname) = Darwin
    source ~/.orbstack/shell/init2.fish 2>/dev/null || :

    set -gx PNPM_HOME "$HOME/Library/pnpm"
    fish_add_path --path "$PNPM_HOME/bin"
end
