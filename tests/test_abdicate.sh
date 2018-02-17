. tests/tools.sh

testAbdicate(){
  sudo ./setup.sh install || fail "Installation failed"
  sudo ./abdicate.sh "now+1min" || fail "Abdicate failed"
  check_access_is_revoked || fail "Sudo access is not revoked"
  sleep 100
  check_access_is_restored || fail "Sudo access is not restored"
  sudo ./setup.sh uninstall || fail "Uninstall failed"
}

testAbdicateWithoutDelayedAdmin() {
  sudo ./abdicate.sh "now+1min" && fail "Abdicate did not err without Delayed Admin"
  check_access_is_restored || fail "Sudo access is not restored"
}
. tests/shunit2
