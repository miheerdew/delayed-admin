#!/bin/bash
set -e

CONFIG_FILE='/etc/delayed-admin.conf'

# use integer variable to ensure that delay is always an integer regardless of the contents of the CONFIG_FILE.
declare -i delay="$(cat '$CONFIG_FILE')"

CMD=${@:-/bin/bash}

echo "Sleeping for $delay seconds starting from $(date '+%D %T')"
sleep $delay
echo "Running command '$CMD'"

$CMD
