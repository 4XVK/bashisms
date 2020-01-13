# Version: v0.2.0
function wsync {

    # function base name
    BASENAME=$(basename ${0})

    # private help text function
    function _help {
        echo "Watch for changes and sync a location to a remote desination"
        echo ""
        echo "Usage: $BASENAME [-h|--help] [-n|--no-delete] <-l|--location \$arg> <-r|--remote \$arg>"
        echo ""
        echo "-h|--help\tdisplay help text and exit"
        echo "-n|--no-delete\tdo not delete mismatching content"
        echo "-l|--location\tfile or folder to sync"
        echo "-r|--remote\tremote destination leveraging rsync format"
    }

    # initial arguments
    NODELETE=false

    # process arguments
    while (( $# )); do
        case "$1" in
            -h|--help) # help text
            _help; return 0
            ;;
            -n|--no-delete) # no delete
            NODELETE=true
            ;;
            -l|--location) # location
            LOCATION=$2
            shift 2
            ;;
            -r|--remote) # remote
            REMOTE=$2
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
    if [ -z "$LOCATION" ] || [ -z "$REMOTE" ]; then _help 1>&2; return 1; fi

    # sync helper function
    function _sync {
        if [ "${NODELETE}" = true ]; then
            echo "Syncing changes from $1 to $2 without deletion"
            /usr/bin/rsync -qaz $LOCATION $REMOTE --no-motd
        else
            echo "Syncing changes from $1 to $2 with deletion"
            /usr/bin/rsync -qaz $LOCATION $REMOTE --delete --no-motd
        fi
    }

    # initial sync
    _sync

    # rules for macos systems
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # watch for changes and continually sync
        fswatch -o $1 | while read; do
            echo "Changes detected on $1"
            _sync
        done
    # rules for all other systems
    else
        # watch for changes and continually sync
        inotifywait -r -m $1 | while read; do
            echo "Changes detected on $1"
            _sync
        done
    fi
}