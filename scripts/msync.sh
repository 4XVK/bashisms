# Version: v0.1.0
function msync {

    # private help text function
    function _help {
            echo "Extract maven artifacts and sync them to a remote destination"
            echo ""
            echo "Usage: $(basename ${0}) [-h|--help] [-d|--delete] <-p|--pom \$arg> ... [-r|--remote \$arg] ..."
            echo ""
            echo "-h|--help\tdisplay help text and exit"
            echo "-f|--delete\tdelete artifact directory upon completion"
            echo "-p|--pom\tpom file or directory containing a pom.xml"
            echo "-r|--remote\tremote destination leveraging rsync format"
    }

    POMS=()
    REMOTES=()
    DELETE=false

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
        echo "Generating artifacts for ${pom}"
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