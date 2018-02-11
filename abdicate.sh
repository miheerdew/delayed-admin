#!/bin/bash

. lib/utils.sh

readonly TIME="$@"
readonly USER="$SUDO_USER"

function usage {
  cat <<_EOF
Usage: sudo $0 TIME

Explaination

  TIME: Steal (i.e pause) admin access till TIME.
        TIME should be in a format recongnizable by the at command.

This script will schedule an at command to restore admin access at time TIME.
After this it will add user to the delayed-admin group and remove
user from the $ADMIN_GROUP group.
_EOF
}


if [ "$EUID" -ne 0 ] || [ -z "$USER" ]; then
    echo "Please run using sudo."
    usage
    exit -1
fi

if check_atd_is_running; then
   log "atd is already running."
else
   start_atd
   log "Starting atd."
fi

at $TIME <<_EOF
`declare -f add_user_to_group`
add_user_to_group '$USER' '$ADMIN_GROUP'
_EOF
log "Scheduled: Add $USER to $ADMIN_GROUP group at $TIME"

add_user_to_group "$USER" delayed-admin
log "Added $USER to the delayed-admin group"

remove_user_from_group "$USER" "$ADMIN_GROUP"
log "Removed $USER from $ADMIN_GROUP group"

echo "You may need to log out for changes to take effect."
