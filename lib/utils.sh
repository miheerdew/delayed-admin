function log {
   local err="${2-$?}"
   local msg="$1"
   if [ $err -gt 0 ]; then
     echo -e "[\xE2\x9D\x8C] $msg" 1>&2
     exit $err
   else
     echo -e "[\xE2\x9C\x94] $msg"
   fi
}

function die {
    echo "$1" >&2
    exit "${2:-1}"  ## Return a code specified by $2 or 1 by default.
}

case $OSTYPE in
    darwin*) . ./lib/macos.sh
             ;;
    linux*) . ./lib/linux.sh
            ;;
    *) die "Unknown OS."
esac

is_user_in_group() {
  # Can't use grep -w since groups can contain hyphens
  groups "$1" | grep -qE "(\s|^)$2(\s|\$)"
}

function with_sudo {
  #Only works when func doesn't call other functions
  local func_name=$1
  shift
  sudo bash <<_EOF
`declare -f $func_name`
$func_name $@
_EOF
}

function with_delayed {
  #Only works when func doesn't call other functions
  local func_name=$1
  shift
  sudo /usr/local/bin/delayed <<_EOF
`declare -f $func_name`
$func_name $@
_EOF
}
