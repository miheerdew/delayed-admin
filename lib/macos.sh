function gexists { dseditgroup -o read "$1" &>/dev/null; }
function gdel { dseditgroup -o delete "$1"; }
function gadd { dseditgroup -o create "$1"; }
