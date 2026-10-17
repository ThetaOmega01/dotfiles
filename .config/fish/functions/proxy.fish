function proxy --description 'Switch shell proxy variables on or off'
    set --local vars http_proxy https_proxy all_proxy socks_proxy no_proxy
    set --local upper (string upper $vars)

    switch "$argv[1]"
        case on
            # Clash Verge Rev mixed port serves HTTP and SOCKS5.
            set --local addr 127.0.0.1:7897
            if set --query argv[2]
                set addr $argv[2]
            end
            set --local no_proxy_list localhost,127.0.0.1,::1,.local,100.64.0.0/10,.ts.net

            for v in http_proxy https_proxy HTTP_PROXY HTTPS_PROXY
                set --global --export $v http://$addr
            end
            for v in all_proxy socks_proxy ALL_PROXY SOCKS_PROXY
                set --global --export $v socks5h://$addr
            end
            set --global --export no_proxy $no_proxy_list
            set --global --export NO_PROXY $no_proxy_list
            proxy status
        case off
            set --erase --global $vars $upper
            proxy status
        case status ''
            for v in $vars
                if set --query $v
                    printf '%s=%s\n' $v $$v
                else
                    printf '%s unset\n' $v
                end
            end
        case '*'
            echo 'Usage: proxy on [host:port] | off | status' >&2
            return 1
    end
end
