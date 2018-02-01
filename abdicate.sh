#!/bin/bash

set -e

. lib/utils.sh

readonly TIME="$1"
readonly USER="$SUDO_USER"

function usage {
  cat <<_EOF
Usage: sudo $0 TIME

Explaination

  TIME: The time in seconds to steal (i.e pause) admin access.

_EOF
}


if [ "$EUID" -ne 0 ] || [ -z "$USER" ]; then
    echo "Please run using sudo"
    usage
    exit -1
fi

case $TIME in
    ''|*[!0-9]*) echo "TIME is not an integer"
	         usage
		 exit -1
esac

add_user_to_group "$USER" delayed-admin
log "Added $USER to the group delayed-admin"

remove_user_from_group "$USER" "$ADMIN_GROUP"
log "Removed $USER from group $ADMIN_GROUP"

echo "Sleeping for $TIME seconds starting from $(date '+%D %T')"
sleep "$TIME"

add_user_to_group "$USER" "$ADMIN_GROUP"
log "Added $USER to the $ADMIN_GROUP"
