
function dsocks {

    # process arguments
    while (( "$#" )); do
        case "$1" in
            -h|--help) # help text
            echo "Start a double SSH SOCKS proxy from one remote host through another"
            echo ""
            echo "Usage: $(basename $0) <host1> <host1_ssh_port> <host2> <host2_ssh_port> <socks_port>"
            echo ""
            echo "-h|--help\tdisplay help text and exit"
            echo "<host1>\first remote host to connect to"
            echo "<host1_ssh_port>\first remote host ssh port"
            echo "<host2>\second remote host to connect to"
            echo "<host2_ssh_port>\second remote host ssh port"
            echo "<socks_port>\local socks port to expose"
            exit 0
            ;;
        esac
    done

    # start a double ssh socks proxy
    ssh -f -q -C -p ${2} -L ${5}:localhost:${5} ${1} -t ssh -q -C -N -D ${5} -p ${4} ${3}
    # echo the corresponding information
    echo "Double SSH SOCKS proxy started to $1:$2 through $3:$4 on port $5 with PID $!"
}