#!/bin/bash

set -e

. lib/utils.sh

readonly GROUP_NAME="delayed-admin"
readonly SUDOERS_FILE="/etc/sudoers.d/delayed-admin"
readonly DELAYED="/usr/local/bin/delayed" # Must be the same as specified in sudoers file
readonly CONFIG_FILE="/etc/delayed-admin.conf" # Must be the same as specified in delayed.sh


function create_group {
    local grp="$1"
    if gexists "$grp"; then
	log "Group $grp already exists"
    else
        gadd "$grp"
	log "Created group $grp"
    fi
}

function delete_group {
    local grp="$1"
    if gexists "$grp"; then
	gdel "$grp"
	log "Deleted group $grp"
    else
	log "Group $grp does not exist. Doing nothing."
    fi
}


function install {
    create_group "$GROUP_NAME"
    cp delayed.sh "$DELAYED"
    log "Copied $DELAYED"
    cp delayed-admin.conf "$CONFIG_FILE"
    log "Copied $CONFIG_FILE"
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
    die "Please run as root"
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
        die "Usage: sudo $0 (install|uninstall)"
        ;;
esac
