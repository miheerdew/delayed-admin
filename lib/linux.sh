function gexists { gentent group "$1" &> /dev/null; }
function gdel { groupdel "$1"; }
function gadd { groupadd "$1"; }
function add_user_to_group { usermod -a -G "$2" "$1"; }
function remove_user_from_group { gpasswd -d "$1" "$2"; }
readonly ADMIN_GROUP="sudo"

#TODO Implement these
function check_atd_is_running { true; }
function start_atd { true; }
