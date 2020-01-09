#
# Extract maven artifacts and sync them to a remote destination
#
function msync {

    POMS=()
    REMOTES=()
    DELETE=false

    # process arguments
    while (( "$#" )); do
        case "$1" in
            -h|--help) # help text
            echo "Extract maven artifacts and sync them to a remote destination"
            echo ""
            echo "Usage: $(basename $0) [-h|--help] [-d|--delete] [-p|--pom <arg>] ... [-r|--remote <arg>] ..."
            echo ""
            echo "-h|--help\tdisplay help text and exit"
            echo "-f|--delete\tdelete artifact directory upon completion"
            echo "-p|--pom\tpom file or directory containing a pom.xml"
            echo "-r|--remote\tremote destination leveraging rsync format"
            exit 0
            ;;
            -p|--pom) # pom files
            POMS+=( "$2" )
            shift 2
            ;;
            -r|--remote) # remote destinations
            REMOTES+=( "$2" )
            shift 2
            ;;
            -d|--delete) # delete artifact directory
            DELETE=true
            shift 1
            ;;
            --) # end argument parsing
            shift
            break
            ;;
            -*|--*=) # unsupported flags
            echo "Error: Unsupported flag $1" >&2
            exit 1
            ;;
            *) # preserve positional arguments
            shift
            ;;
        esac
    done

    # creat the artifact directory
    tmpdir=$(mktemp -d)
    echo "Creating artifact directory ${tmpdir}"

    for pom in ${POMS[@]}; do
        # set pom to ${pom}/pom.xml if folder was passed
        test -f "${pom}/pom.xml" && { pom="${pom}/pom.xml"; }
        test -f ${pom} || { echo "Error: Unable to find POM file ${pom}" >&2; continue; }
        echo "Using POM file ${pom}"
        # generate maven artifacts based on current pom file
        artifacts=($(mvn -f "${pom}" clean package | grep --line-buffered Wrote: | awk '{print $3}' | tr "\n" "\n"))
        for artifact in $artifacts; do
            # copy generated artifacts to artifact directory
            echo "Generated artifact ${artifact##*/}"
            cp $artifact $tmpdir
        done
    done

    for remote in ${REMOTES[@]}; do
        # sync artifact directory with remote destinations
        echo "Syncing artifact directory with ${remote}"
        rsync -a $tmpdir/ $remote
    done

    if [ "${DELETE}" = true ]; then
        # optionally delete the artifact directory
        echo "Deleting artifact directory"
        rm -rf ${tmpdir}
    fi

}

# call the function
msync $@

# example output

# ./msync.sh -p ~/Documents/workspace/example1 -p ~/Documents/workspace/example2/test.xml -r /tmp/foo -r user@server:/tmp/baz -d
# Creating artifact directory /var/folders/f8/qf2kgv9d68v6qr2ktd4ffqn80000gp/T/tmp.ctxS22PV
# Using POM file ~/Documents/workspace/example1/pom.xml
# Generated artifact example1-1.2.3-SNAPSHOT20200109065014.noarch.rpm
# Using POM file ~/Documents/workspace/example2/test.xml
# Generated artifact example2-1.2.3-SNAPSHOT20200109065017.noarch.rpm
# Syncing artifact directory with /tmp/foo
# Syncing artifact directory with user@server:/tmp/baz
# Deleting artifact directory