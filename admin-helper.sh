#!/bin/bash

cmd="$1"
. lib/utils.sh

lock_status() {
  if is_user_in_group "$USER" "$ADMIN_GROUP"; then
      echo "Admin access is unlocked."
  elif is_user_in_group "$USER" "delayed-admin"; then
      echo "Admin access is locked."
  else
      die "$USER is not authorized to use delayed-admin."
  fi
}

lock() {
   if is_user_in_group "$USER" delayed-admin; then
       log "$USER is already in delayed-admin group. Doing nothing."
   else
       with_sudo add_user_to_group "$USER" "delayed-admin"
       log "Added $USER to delayed-admin"
   fi
   with_sudo remove_user_from_group "$USER" "$ADMIN_GROUP"
   log "Removed $USER from $ADMIN_GROUP"
}

unlock() {
   with_delayed add_user_to_group "$USER" "$ADMIN_GROUP"
   log "Added $USER to $ADMIN_GROUP"
}

case "$cmd" in
    lock)
        if is_user_in_group "$USER" "$ADMIN_GROUP"; then
            lock
            log "Lock successful"
        else
            die "$USER is not in $ADMIN_GROUP group. Perhaps you are already locked?"
        fi
        ;;
    unlock)
        if is_user_in_group "$USER" "delayed-admin"; then
            unlock
            log "Unlock successful"
        else
            die "$USER is not authorized to use delayed-admin"
        fi
        ;;
    status)
        lock_status
        ;;
    *)
        echo "Usage: $0 (lock|unlock|status)"
        exit
        ;;
esac

