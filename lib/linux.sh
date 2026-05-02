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
  local id
  id=$(distro_id)
  case $id in
    ubuntu|kubuntu|debian|linuxmint|pop|neon|elementary|zorin)
      echo "sudo"
      ;;
    centos|fedora|rhel|arch|manjaro|endeavouros|opensuse*|sles)
      echo "wheel"
      ;;
    *)
      # Fallback: use ID_LIKE from /etc/os-release
      local id_like
      id_like=$(grep '^ID_LIKE=' /etc/os-release 2>/dev/null | cut -d= -f2- | tr -d '"')
      case "$id_like" in
        *ubuntu*|*debian*)
          echo "sudo"
          ;;
        *rhel*|*fedora*|*centos*|*suse*)
          echo "wheel"
          ;;
        *)
          # Last resort: check which admin group actually exists on this system.
          # If neither exists, admin_group() returns empty and the check below will abort.
          if getent group sudo > /dev/null 2>&1; then
            echo "sudo"
          elif getent group wheel > /dev/null 2>&1; then
            echo "wheel"
          fi
          ;;
      esac
      ;;
  esac
}
readonly ADMIN_GROUP=$(admin_group)
if [ -z "$ADMIN_GROUP" ]; then
  die "Could not determine the admin group for this OS (ID=$(distro_id)). Please file a bug report."
fi
#TODO Implement these
function check_atd_is_running { true; }
function start_atd { true; }
