#!/bin/bash

. lib/utils.sh
. tests/tools.sh

setUp() {
  with_sudo add_user_to_group "$USER" delayed-admin
}

tearDown() {
  if check_access_is_revoked; then
      with_delayed add_user_to_group "$USER" "$ADMIN_GROUP"
  fi
}

testing_delayed_admin() {

  with_sudo remove_user_from_group "$USER" "$ADMIN_GROUP" || fail "Couldn't remove $USER from $ADMIN_GROUP"

  check_access_is_revoked || fail "Sudo access is not revoked"

  check_delay add_user_to_group "$USER" "$ADMIN_GROUP" || fail "Couldn't regain sudo access"

  assertTrue 'Delay did not work' '[ $ELAPSED -ge "$(cat /etc/delayed-admin.conf)" ]'
}


check_delay(){
  local start=$SECONDS
  case $1 in
   *[!0-9]* | '')
	  #First argument is not a number.
	  #No timeout provided.
	  with_delayed $@
	  ;;
   * )    with_time_out_delayed $@
	  ;;
  esac
  local ret=$?
  ELAPSED=$((SECONDS - start))
  return $ret
}

testing_a_gibberish_delay() {

  [ -z "$TIMEOUT" ] && startSkipping

  echo "A0-12" | sudo tee /etc/delayed-admin.conf >/dev/null

  check_delay 10 true || fail "delayed did not work"

  assertTrue 'Gibberish delay took more than 10s' '[ $ELAPSED -lt 10 ]'

  echo "30" | sudo tee /etc/delayed-admin.conf >/dev/null

  testing_delayed_admin
}

oneTimeSetUp(){
  sudo ./setup.sh install || fail "Installation failed"
  assertTrue 'delayed executable not copied' '[ -x /usr/local/bin/delayed ]'
  assertFalse 'Config file is writable by regular user' '[ -w /etc/delayed-admin.conf ]'
  sudo visudo -scqf /etc/sudoers.d/delayed-admin || fail 'Error in the sudoers file'
  gexists delayed-admin || fail 'delayed-admin group has not been created'
}

oneTimeTearDown() {
 sudo ./setup.sh uninstall || fail "Un-installation failed"
 [ -x /usr/local/bin/delayed ] && fail "Failed to remove delayed binary"
 [ -f /etc/sudoers.d/delayed-admin.sudoers ] && fail "Failed to remove sudoers"
 [ -f /etc/delayed-admin.conf ] && fail "Failed to remove config file"
 gexists delayed-admin && fail "Failed to remove the delayed-admin group"
}

start_test
