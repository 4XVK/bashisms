function dsocks {

    # private help text function
    function _help {
        echo "Start a double SSH SOCKS proxy from one remote host through another"
        echo ""
        echo "Usage: $(basename ${0}) <-a|--host-a \$arg> <-p|--host-port-a \$arg> <-b|--host-b \$arg> <-o|--host-port-b \$arg> <-s|--socks-port \$arg>"
        echo ""
        echo "-h|--help\t\tdisplay help text and exit"
        echo "-a|--host-a\t\tfirst remote host to connect to"
        echo "-p|--host-port-a\tfirst remote host ssh port"
        echo "-b|--host-b\t\tsecond remote host to connect to"
        echo "-o|--host-port-b\tsecond remote host ssh port"
        echo "-s|--socks-port\t\tlocal socks port to expose"
    }

    # process arguments
    while (( $# )); do
        case "$1" in
            -h|--help) # help text
            _help; return 0
            ;;
            -a|--host-a) # host a
            HOST_A=$2
            shift 2
            ;;
            -p|--host-port-a) # host a ssh port
            HOST_PORT_A=$2
            shift 2
            ;;
            -b|--host-b) # host b
            HOST_B=$2
            shift 2
            ;;
            -o|--host-port-b) # host b ssh port
            HOST_PORT_B=$2
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
    if [ -z "$HOST_A" ] || [ -z "$HOST_PORT_A" ] || [ -z "$HOST_B" ] || [ -z "$HOST_PORT_B" ] || [ -z "$SOCKS_PORT" ]; then _help 1>&2; return 1; fi

    # start a double ssh socks proxy
    ssh -f -q -C -p $HOST_PORT_A -L $SOCKS_PORT:localhost:$SOCKS_PORT $HOST_A -t ssh -q -C -N -D $SOCKS_PORT -p $HOST_PORT_B $HOST_B
    # echo the corresponding information
    echo "Double SSH SOCKS proxy started to $HOST_A:$HOST_PORT_A through $HOST_B:$HOST_PORT_B on port $SOCKS_PORT with PID $!"
}