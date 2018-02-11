testDelayed() {
  sudo ./setup.sh install || fail "Installation failed"

  . lib/utils.sh || fail "Loading failed"

  with_sudo add_user_to_group "$USER" delayed-admin || fail "Couldn't add $USER to delayed-admin group"

  with_sudo remove_user_from_group "$USER" "$ADMIN_GROUP" || fail "Couldn't remove $USER from $ADMIN_GROUP"

  sudo true && fail "Can use sudo"
  sudo delayed true || fail "Can't use delayed"

  with_delayed add_user_to_group "$USER" "$ADMIN_GROUP" || fail "Couldn't regain sudo access"

  sudo ./setup.sh uninstall || fail "Uninstall not successful"
}

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
  sudo delayed <<_EOF
`declare -f $func_name`
$func_name $@
_EOF
}

. tests/shunit2
