function add_ssh_key_with_keychain
    set key_path ~/.ssh/id_ed25519
    set fingerprint (ssh-keygen -lf $key_path | awk '{print $2}')
    if not ssh-add -l | rg --quiet --fixed-strings $fingerprint
        ssh-add --apple-use-keychain $key_path
    end
end
