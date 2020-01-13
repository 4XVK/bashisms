# Version: v0.2.0
function wsync {

    # function base name
    BASENAME=$(basename ${0})

    # private help text function
    function _help {
        echo "Watch for changes and sync a local folder to a remote desination"
        echo ""
        echo "Usage: $BASENAME <-f|--folder \$arg> <-r|--remote \$arg>"
        echo ""
        echo "-h|--help\tdisplay help text and exit"
        echo "-f|--folder\tlocal folder to sync"
        echo "-r|--remote\tremote destination leveraging rsync format"
    }

    # process arguments
    while (( $# )); do
        case "$1" in
            -h|--help) # help text
            _help; return 0
            ;;
            -f|--folder) # folder
            FOLDER=$2
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
    if [ -z "$FOLDER" ] || [ -z "$REMOTE" ]; then _help 1>&2; return 1; fi

    # initial sync
    echo "Syncing changes from $1 to $2"
    /usr/bin/rsync -qaz $1 $2 --delete --no-motd

    # rules for macos systems
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # watch for changes and continually sync
        fswatch -o $1 | while read; do
            echo "Changes detected, resyncing"
            /usr/bin/rsync -qaz $1 $2 --delete --no-motd
        done
    # rules for all other systems
    else
        # watch for changes and continually sync
        inotifywait -r -m $1 | while read; do
            echo "Changes detected, resyncing"
            /usr/bin/rsync -qaz $1 $2 --delete --no-motd
        done
    fi
}