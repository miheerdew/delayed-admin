#!/bin/bash

. lib/utils.sh

testing_the_delay() {
  check_install

  with_sudo add_user_to_group "$USER" delayed-admin || fail "Couldn't add $USER to delayed-admin group"

  with_sudo remove_user_from_group "$USER" "$ADMIN_GROUP" || fail "Couldn't remove $USER from $ADMIN_GROUP"

  check_access_is_revoked || fail "Sudo access is not revoked"

  with_delayed add_user_to_group "$USER" "$ADMIN_GROUP" || fail "Couldn't regain sudo access"

  check_uninstall
}

check_install(){
  sudo ./setup.sh install || fail "Installation failed"
  assertTrue 'delayed executable not copied' '[ -x /usr/local/bin/delayed ]'
  assertFalse 'Config file is writable by regular user' '[ -w /etc/delayed-admin.conf ]'
  sudo visudo -scqf /etc/sudoers.d/delayed-admin || fail 'Error in the sudoers file'
  gexists delayed-admin || fail 'delayed-admin group has not been created'
}

check_uninstall() {
 sudo ./setup.sh uninstall || fail "Un-installation failed"
 [ -x /usr/local/bin/delayed ] && fail "Failed to remove delayed binary"
 [ -f /etc/sudoers.d/delayed-admin.sudoers ] && fail "Failed to remove sudoers"
 [ -f /etc/delayed-admin.conf ] && fail "Failed to remove config file"
 gexists delayed-admin && fail "Failed to remove the delayed-admin group"
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
  sudo /usr/local/bin/delayed <<_EOF
`declare -f $func_name`
$func_name $@
_EOF
}

function check_access_is_revoked {
 #Check if we can execute the true command (under a new login if required)
 ! ( sudo -n true && sudo -n su $USER -c "sudo -n /bin/true" )
}


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
$ADMIN group using the root shell

`declare -f add_user_to_group`
add_user_to_group $USER $ADMIN_GROUP
===============================================================================
_EOF

sudo -K

. tests/shunit2
