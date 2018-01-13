#!/bin/bash

set -e

function log {
   local msg="$1"
   if [ $? -gt 0 ]; then
     echo -e "[\xE2\x9D\x8C] $msg" 1>&2
   else
     echo -e "[\xE2\x9C\x94] $msg"
   fi
}

case $OSTYPE in
    darwin*) . ./lib/macos.sh
             ;;
    linux*) . ./lib/linux.sh
            ;;
    *) echo "Unknown OS."
       exit 1;
esac

readonly GROUP_NAME="delayed-admin"
readonly SUDOERS_FILE="/etc/sudoers.d/delayed-admin"
readonly DELAYED="/usr/local/bin/delayed" # Must be the same as specified in sudoers file
readonly CONFIG_FILE="/etc/delayed-admin.conf" # Must be the same as specified in delayed.sh

function install {
    create_group "$GROUP_NAME"
    cp delayed.sh "$DELAYED"
    cp delayed-admin.conf "$CONFIG_FILE"
    log "Copied $DELAYED and $CONFIG_FILE"
    EDITOR="tee" visudo -f "$SUDOERS_FILE" <delayed-admin.sudoers
    log "Copied above to sudoers file $SUDOERS_FILE"
}

function uninstall {
    rm -f "$DELAYED" "$CONFIG_FILE"
    log "Deleted $DELAYED $CONFIG_FILE"
    rm "$SUDOERS_FILE"
    log "Deleted sudoers file: $SUDOERS_FILE"
    delete_group "$GROUP_NAME"
}

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

case $1 in
    install)
        install
        log "Install successful"
        ;;
    uninstall)
        uninstall
        log "Uninstall successful"
        ;;
    *)
        echo "Usage: sudo $0 (install|uninstall)"
        exit
        ;;
esac
