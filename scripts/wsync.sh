function wsync {

    # process arguments
    while (( $# )); do
        case "$1" in
            -h|--help) # help text
            echo "Watch for changes and sync a local folder to a remote desination"
            echo ""
            echo "Usage: ${FUNCNAME[0]} <folder> <remote>"
            echo ""
            echo "-h|--help\tdisplay help text and exit"
            echo "<folder>\local folder to sync"
            echo "<remote>\tremote destination leveraging rsync format"
            return 0
            ;;
        esac
    done

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
        while inotifywait -r -m $1 | while read $f; do
            echo "Changes detected, resyncing"
            /usr/bin/rsync -qaz $1 $2 --delete --no-motd
        done
    fi
}