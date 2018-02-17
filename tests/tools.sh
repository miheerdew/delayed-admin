function with_sudo {
  local func_name=$1
  shift
  sudo bash <<_EOF
`declare -f $func_name`
$func_name $@
_EOF
}

function with_delayed {
  local func_name=$1
  shift
  sudo /usr/local/bin/delayed <<_EOF
`declare -f $func_name`
$func_name $@
_EOF
}

function check_access_is_revoked {
 #Check if we can execute the true command (under a new login if required)
 ! ( sudo -n true && sudo -n su $USER -c "sudo -n true" )
}

function check_access_is_restored {
  sudo su $USER -c "sudo true"
}

function start_test {

if [ $EUID -eq 0 ]; then
	  cat >&2 <<_EOF
	Don't run this script as root. You will be asked to provide your sudo credentials later.
_EOF
	  exit 1
	fi

cat >&2 <<_EOF
################################################################################
Attention! This script can mess up your sudo privileges if something goes wrong.
################################################################################

Either run this script as a new sudo user or keep a root shell running.
If you lose sudo access because of this script, add yourself back to
$ADMIN_GROUP group using the root shell

`declare -f add_user_to_group`
add_user_to_group $USER $ADMIN_GROUP
===============================================================================
_EOF

#Reset the sudo timeout so that the commands don't run accidentally.
sudo -K

. tests/shunit2
}


TIMEOUT=""
if type gtimeout; then
  TIMEOUT=gtimeout
fi
if type timeout; then
  TIMEOUT=timeout
fi

function with_time_out_delayed {
  if [ -z "$TIMEOUT" ]; then
    echo "timeout/gtimeout not found" >&2
		return 1
	fi
  local delay=$1
	shift
  local func_name=$1
  shift
  sudo "$TIMEOUT" "$delay" /usr/local/bin/delayed <<_EOF
`declare -f $func_name`
$func_name $@
_EOF
}

