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
