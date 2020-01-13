# Version: v0.2.0
function msync {

    # function base name
    BASENAME=$(basename ${0})

    # private help text function
    function _help {
            echo "Extract maven artifacts and sync them to a remote destination"
            echo ""
            echo "Usage: $BASENAME [-h|--help] [-d|--delete] [-n|--no-clean] <-p|--pom \$arg> ... [-r|--remote \$arg] ..."
            echo ""
            echo "-h|--help\tdisplay help text and exit"
            echo "-d|--delete\tdelete artifact directory upon completion"
            echo "-n|--no-clean\tdo not clean maven artifact target directories"
            echo "-p|--pom\tpom file or directory containing a pom.xml"
            echo "-r|--remote\tremote destination leveraging rsync format"
    }

    # starting variables
    POMS=()
    REMOTES=()
    DELETE=false
    NOCLEAN=false

    # process arguments
    while (( $# )); do
        case "$1" in
            -h|--help) # help text
            _help; return 0
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
            -n|--no-clean) # maven no clean flag
            NOCLEAN=true
            shift 1
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
    if [ ${#POMS[@]} -eq 0 ]; then _help 1>&2; return 1; fi

    # creat the artifact directory
    tmpdir=$(mktemp -d)
    echo "Creating artifact directory ${tmpdir}"

    for pom in ${POMS[@]}; do
        # set pom to ${pom}/pom.xml if folder was passed
        test -f "${pom}/pom.xml" && { pom="${pom}/pom.xml"; }
        test -f ${pom} || { echo "Error: Unable to find POM file ${pom}" >&2; continue; }
        # optional maven artifact cleaning flag
        if [ "${NOCLEAN}" = true ]; then
            # generate maven artifacts based on current pom file without cleaning
            echo "Generating artifacts for ${pom} without target cleaning"
            artifacts=($(mvn -f "${pom}" package | grep --line-buffered Wrote: | awk '{print $3}' | tr "\n" "\n"))
        else
            # generate maven artifacts based on current pom file
            echo "Generating artifacts for ${pom} with target cleaning"
            artifacts=($(mvn -f "${pom}" clean package | grep --line-buffered Wrote: | awk '{print $3}' | tr "\n" "\n"))
        fi
        for artifact in $artifacts; do
            # copy generated artifacts to artifact directory
            echo "Generated artifact ${artifact##*/}"
            cp $artifact $tmpdir
        done
    done

    for remote in ${REMOTES[@]}; do
        # sync artifact directory with remote destinations
        echo "Syncing artifact directory with ${remote}"
        rsync -qaz $tmpdir/ $remote
    done

    if [ "${DELETE}" = true ]; then
        # optionally delete the artifact directory
        echo "Deleting artifact directory"
        rm -rf ${tmpdir}
    fi

}