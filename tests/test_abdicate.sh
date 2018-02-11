testAbdicate(){
  sudo ./setup.sh install || fail "Delayed-admin installation failed"
  sudo ./abdicate.sh "now+1min" || fail "Abdicate failed"
  sudo true && fail "Sudo access is not revoked"
  sleep 100
  sudo true || fail "Sudo access is not restored"
}

. tests/shunit2
