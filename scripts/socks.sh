function socks {

    # process arguments
    while (( $# )); do
        case "$1" in
            -h|--help) # help text
            echo "Start an SSH SOCKS proxy to a remote desination"
            echo ""
            echo "Usage: ${FUNCNAME[0]} <host> <host_ssh_port> <socks_port>"
            echo ""
            echo "-h|--help\tdisplay help text and exit"
            echo "<host>\t\tremote host to connect to"
            echo "<host_ssh_port>\tremote host ssh port"
            echo "<socks_port>\tlocal socks port to expose"
            return 0
            ;;
        esac
    done

    # start an ssh socks proxy
    ssh -p $2 -D $3 -f -C -q -N $1
    # echo the corresponding information
    echo "SSH SOCKS proxy started to $1:$2 on port $3 with PID $!"
}