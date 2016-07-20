# re: http://unix.stackexchange.com/a/20977

# process arguments "$1", "$2", ... (i.e. "$@")
while getopts "rcsq:" opt; do
    case $opt in
    r) aflag=true ;; # Handle -a
    c) barg=$OPTARG ;; # Handle -b argument
    \?) ;; # Handle error: unknown option or missing required argumentS.
    esac
done

# OR; re http://stackoverflow.com/a/29754866/1397555 :


# Usage:
 # getopt optstring parameters
 # getopt [options] [--] optstring parameters
 # getopt [options] -o|--options optstring [options] [--] parameters

# Options:
 # -a, --alternative            Allow long options starting with single -
 # -h, --help                   This small usage guide
 # -l, --longoptions <longopts> Long options to be recognized
 # -n, --name <progname>        The name under which errors are reported
 # -o, --options <optstring>    Short options to be recognized
 # -q, --quiet                  Disable error reporting by getopt(3)
 # -Q, --quiet-output           No normal output
 # -s, --shell <shell>          Set shell quoting conventions
 # -T, --test                   Test for getopt(1) version
 # -u, --unquoted               Do not quote the output
 # -V, --version                Output version information
