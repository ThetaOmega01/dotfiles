if status --is-interactive
    keychain --eval --quiet -Q ~/.ssh/id_ed25519 | source
    set -xg SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -xg SSH_AGENT_PID $SSH_AGENT_PID
end
