function gexists { getent group "$1" > /dev/null; }
function gdel { groupdel "$1"; }
function gadd { groupadd "$1"; }
function add_user_to_group { usermod -a -G "$2" "$1"; }
function remove_user_from_group { gpasswd -d "$1" "$2"; }
function distro_id() {
  source /etc/os-release
  echo $ID
}
function admin_group() {
  case $(distro_id) in
    ubuntu|debian)
      echo "sudo"
      ;;
    centos|fedora|rhel)
      echo "wheel"
      ;;
  esac
}
readonly ADMIN_GROUP=$(admin_group)
#TODO Implement these
function check_atd_is_running { true; }
function start_atd { true; }
