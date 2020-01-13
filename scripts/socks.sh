# Version: v0.2.0
function socks {

    BASENAME=$(basename ${0})

    # private help text function
    function _help {
        echo "Start an SSH SOCKS proxy to a remote desination"
        echo ""
        echo "Usage: $BASENAME [-h|--help] <-r|--remote \$arg> <-p|--ssh-port \$arg> <-s|--socks-port \$arg>"
        echo ""
        echo "-h|--help\tdisplay help text and exit"
        echo "-r|--remote\tremote host to connect to"
        echo "-p|--ssh-port\tremote host ssh port"
        echo "-s|--socks-port\tlocal socks port to expose"
    }

    # process arguments
    while (( $# )); do
        case "$1" in
            -h|--help) # help text
            _help; return 0
            ;;
            -r|--remote) # remote host
            REMOTE=$2
            shift 2
            ;;
            -p|--ssh-port) # ssh port
            SSH_PORT=$2
            shift 2
            ;;
            -s|--socks-port) # socks port
            SOCKS_PORT=$2
            shift 2
            ;;
            --) # end argument parsing
            shift
            break
            ;;
            -*|--*=) # unsupported flags
            echo "Error: Unsupported flag $1" >&2
            return 1
            ;;
            *) # preserve positional arguments
            shift
            ;;
        esac
    done

    # check for all required arguments
    if [ -z "$REMOTE" ] || [ -z "$SSH_PORT" ] || [ -z "$SOCKS_PORT" ]; then _help 1>&2; return 1; fi

    # start an ssh socks proxy
    ssh -p $SSH_PORT -D $SOCKS_PORT -f -C -q -N $REMOTE
    # echo the corresponding information
    echo "SSH SOCKS proxy started to $REMOTE:$SSH_PORT on port $SOCKS_PORT with PID $!"
}