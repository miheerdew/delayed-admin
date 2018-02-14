. tests/tools.sh

testAbdicate(){
  sudo ./setup.sh install || fail "Delayed-admin installation failed"
  sudo ./abdicate.sh "now+1min" || fail "Abdicate failed"
  check_access_is_revoked || fail "Sudo access is not revoked"
  sleep 100
  check_access_is_restored || fail "Sudo access is not restored"
  sudo ./setup.sh uninstall || fail "Uninstallation failed"
}

. tests/shunit2
