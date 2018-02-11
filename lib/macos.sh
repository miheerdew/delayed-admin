function gexists { dseditgroup -o read "$1" &>/dev/null; }
function gdel { dseditgroup -o delete "$1"; }
function gadd { dseditgroup -o create "$1"; }
function add_user_to_group { dseditgroup -o edit -a "$1" -t user "$2"; }
function remove_user_from_group { dseditgroup -o edit -d "$1" -t user "$2"; }
readonly ADMIN_GROUP="admin"

function check_atd_is_running { launchctl list | grep -q com.apple.atrun; }
function start_atd { launchctl load -w /System/Library/LaunchDaemons/com.apple.atrun.plist; }
