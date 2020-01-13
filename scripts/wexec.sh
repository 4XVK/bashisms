# Version: v0.1.0
function wexec {

    # function base name
    BASENAME=$(basename ${0})

    # private help text function
    function _help {
        echo "Watch for changes on a location and optionally execute commands"
        echo ""
        echo "Usage: $BASENAME [-h|--help] <-l|--location \$arg> [\$command] ..."
        echo ""
        echo "-h|--help\tdisplay help text and exit"
        echo "-l|--location\tfile or folder to watch"
        echo "command\t\tseries of commands to execute"
    }

    # positional arguments
    POSARGS=()

    # process arguments
    while (( $# )); do
        case "$1" in
            -h|--help) # help text
            _help; return 0
            ;;
            -l|--location) # folder
            LOCATION=$2
            shift 2
            ;;
            *) # preserve positional arguments
            POSARGS+=( "$1" )
            shift
            ;;
        esac
    done

    # check for all required arguments
    if [ "${#POSARGS[@]}" -lt 1 ]; then _help 1>&2; return 1; fi

    # optionally execute initially
    if [ "${#POSARGS[@]}" -gt 0 ]; then echo "Running initial execution"; eval ${POSARGS[@]}; fi

    # rules for macos systems
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # watch for changes and optionally execute
        fswatch -o $LOCATION | while read; do
            echo "Changes detected on $LOCATION"
            if [ "${#POSARGS[@]}" -gt 0 ]; then eval ${POSARGS[@]}; fi
        done
    # rules for all other systems
    else
        # watch for changes and optionally execute
        inotifywait -r -m $LOCATION | while read; do
            echo "Changes detected on $LOCATION"
            if [ "${#POSARGS[@]}" -gt 0 ]; then eval ${POSARGS[@]}; fi
        done
    fi
}