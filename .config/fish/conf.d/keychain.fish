if status is-login
    and status is-interactive
    keychain --eval --quiet -Q ~/.ssh/id_ed25519 | source
end
