testDelayed() {
  sudo ./setup.sh install || fail "Installation failed"

  . lib/utils.sh || fail "Loading failed"

  with_sudo add_user_to_group "$USER" delayed-admin || fail "Couldn't add $USER to delayed-admin group"

  with_sudo remove_user_from_group "$USER" "$ADMIN_GROUP" || fail "Couldn't remove $USER from $ADMIN_GROUP"

  check_access_is_revoked || fail "Sudo access is not revoked"

  with_delayed add_user_to_group "$USER" "$ADMIN_GROUP" || fail "Couldn't regain sudo access"

  sudo ./setup.sh uninstall || fail "Uninstall not successful"
}

. tests/tools.sh
. tests/shunit2
