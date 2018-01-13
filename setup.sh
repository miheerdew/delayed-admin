#!/bin/bash -e

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
    EDITOR="tee" visudo -f "$SUDOERS_FILE" <delayed-admin.sudoers
    cp delayed.sh "$DELAYED"
    cp delayed-admin.conf "$CONFIG_FILE"
}

function uninstall {
    delete_group "$GROUP_NAME"
    rm -f "$SUDOERS_FILE" "$DELAYED" "$CONFIG_FILE"
}

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

case $1 in
    install)
        echo "Installing delayed-admin"
        install
        ;;
    uninstall)
        echo "Uninstalling delayed-admin"
        uninstall
        ;;
    *)
        echo "Usage: sudo $0 (install|uninstall)"
        exit
        ;;
esac
