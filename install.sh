#!/bin/bash -e

#TODO: take username and delay times as parameters, so that user doesn't have to edit file
sudo mkdir -p /private/etc/sudoers.d/
EDITOR="cp delayed-admin.sudoers" sudo visudo -f /private/etc/sudoers.d/delayed-admin
sudo cp admin-helper /usr/local/bin/admin-helper
